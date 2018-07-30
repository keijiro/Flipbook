// Flip book effect example
// https://github.com/keijiro/FlipBook

using UnityEngine;
using UnityEngine.Rendering;
using System.Collections.Generic;

namespace Flipbook
{
    public sealed class FlipbookRenderer : MonoBehaviour
    {
        #region Editable variables

        [SerializeField] Camera _source;
        [SerializeField] Vector2Int _resolution = new Vector2Int(1280, 720);
        [SerializeField, Range(0.02f, 0.2f)] float _interval = 0.1f;
        [SerializeField, Range(0.2f, 5)] float _speed = 0.3f;
        [SerializeField, Range(0, 5)] float _curvature = 1;
        [SerializeField, ColorUsage(false)] Color _backColor = Color.white;

        [SerializeField, HideInInspector] Mesh _mesh;
        [SerializeField, HideInInspector] Shader _shader;

        #endregion

        #region Page resource queue

        class Page
        {
            public RenderTexture RT;
            public float Param;
            public float PrevParam;

            public Page(Vector2Int resolution)
            {
                RT = new RenderTexture(resolution.x, resolution.y, 24);
            }

            public void Release()
            {
                Destroy(RT);
            }

            public void Reset()
            {
                Param = PrevParam = 0;
            }
        }

        Queue<Page> _activePages = new Queue<Page>();
        Queue<Page> _freePages = new Queue<Page>();
        Page _lastPage;

        #endregion

        #region Private members

        static class ShaderID
        {
            public static readonly int MainTex = Shader.PropertyToID("_MainTex");
            public static readonly int BackColor = Shader.PropertyToID("_BackColor");
            public static readonly int Curvature = Shader.PropertyToID("_Curvature");
            public static readonly int Param = Shader.PropertyToID("_Param");
            public static readonly int PrevParam = Shader.PropertyToID("_PrevParam");
        }

        Material _material;
        MaterialPropertyBlock _propertyBlock;
        CommandBuffer _commandBuffer;
        float _time;

        Page AllocatePage()
        {
            if (_freePages.Count > 0) return _freePages.Dequeue();
            return new Page(_resolution);
        }

        void DrawPage(Page page)
        {
            _propertyBlock.SetTexture(ShaderID.MainTex, page.RT);
            _propertyBlock.SetFloat(ShaderID.Param, page.Param);

            Graphics.DrawMesh(
                _mesh, transform.localToWorldMatrix,
                _material, gameObject.layer, null, 0, _propertyBlock
            );
        }

        void DrawPageMovec(Page page)
        {
            _propertyBlock.SetFloat(ShaderID.PrevParam, page.PrevParam);
            _propertyBlock.SetFloat(ShaderID.Param, page.Param);

            _commandBuffer.DrawMesh(
                _mesh, transform.localToWorldMatrix,
                _material, 0, 0, _propertyBlock
            );
        }

        #endregion

        #region MonoBehaviour implementation

        void OnValidate()
        {
            _resolution = Vector2Int.Max(_resolution, Vector2Int.one * 32);
            _interval = Mathf.Max(_interval, 1.0f / 60);
        }

        void Start()
        {
            _material = new Material(_shader);
            _propertyBlock = new MaterialPropertyBlock();
            _commandBuffer = new CommandBuffer();
        }

        void OnDestroy()
        {
            Destroy(_material);
            _commandBuffer.Dispose();

            while (_activePages.Count > 0) _activePages.Dequeue().Release();
            while (_freePages.Count > 0) _freePages.Dequeue().Release();
            if (_lastPage != null) _lastPage.Release();
        }

        void Update()
        {
            // Add delta to the active pages and the last one.
            var delta = Time.deltaTime * _speed / _interval;

            foreach (var page in _activePages)
            {
                page.PrevParam = page.Param;
                page.Param += delta;
            }

            if (_lastPage != null) _lastPage.PrevParam = _lastPage.Param;

            // Send the page to _lastPage when Param goes over 1.0.
            while (_activePages.Count > 0 && _activePages.Peek().Param >= 1)
            {
                if (_lastPage != null) _freePages.Enqueue(_lastPage);
                _lastPage = _activePages.Dequeue();
                _lastPage.Param = 1;
            }

            // Time increment
            _time += Time.deltaTime;
        }

        void LateUpdate()
        {
            // The interval was over?
            if (_time > _interval)
            {
                // Allocate a page, grab a render and send to the page queue.
                var page = AllocatePage();
                page.Reset();

                var currentRT = _source.targetTexture;
                _source.targetTexture = page.RT;
                _source.Render();
                _source.targetTexture = currentRT;

                _activePages.Enqueue(page);

                // Calculate the next interval.
                _time %= _interval;
            }

            // Material common properties.
            _material.SetColor(ShaderID.BackColor, _backColor);
            _material.SetFloat(ShaderID.Curvature, _curvature);

            // Draw the active pages and the last one.
            foreach (var page in _activePages) DrawPage(page);
            if (_lastPage != null) DrawPage(_lastPage);
        }

        void OnRenderObject()
        {
            var cam = Camera.current;

            // Do nothing if the movion vector buffer is not ready to use.
            if ((cam.depthTextureMode & DepthTextureMode.MotionVectors) == 0) return;

            // View-Projection matrix
            _material.SetMatrix(
                "_NonJitteredVP",
                cam.nonJitteredProjectionMatrix * cam.worldToCameraMatrix
            );

            // Reset the command buffer.
            _commandBuffer.Clear();
            _commandBuffer.SetRenderTarget(
                BuiltinRenderTextureType.MotionVectors,
                BuiltinRenderTextureType.CameraTarget
            );

            // Generate motion vectors with the active pages and the last one.
            foreach (var page in _activePages) DrawPageMovec(page);
            if (_lastPage != null) DrawPageMovec(_lastPage);

            // Execute the command buffer immediately.
            Graphics.ExecuteCommandBuffer(_commandBuffer);
        }

        #endregion
    }
}
