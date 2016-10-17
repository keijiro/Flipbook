using UnityEngine;

public class PageFlippingAnimation : MonoBehaviour
{
    [SerializeField] Texture _texture;
    [SerializeField] float _interval = 0.15f;
    [SerializeField] float _delay = 0.0f;

    MaterialPropertyBlock _props;
    Vector3 _position;
    float _lastTime;

    void Start()
    {
        _props = new MaterialPropertyBlock();
        _props.SetTexture("_MainTex", _texture);

        _position = transform.position;
    }

    void Update()
    {
        var time = ((Time.time - _delay) / _interval) % 2;

        _props.SetFloat("_Progress", time);
        _props.SetFloat("_PreviousProgress", _lastTime);
        GetComponent<Renderer>().SetPropertyBlock(_props);

        transform.position = _position + Vector3.forward * time * 0.01f;

        _lastTime = time;
    }
}
