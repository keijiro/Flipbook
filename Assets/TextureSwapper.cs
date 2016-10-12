using UnityEngine;

public class TextureSwapper : MonoBehaviour
{
    [SerializeField] RenderTexture[] _textures;
    [SerializeField] float _interval = 0.1f;

    void Update()
    {
        GetComponent<Camera>().targetTexture =
            _textures[(int)(Time.time / _interval) % _textures.Length];
    }
}
