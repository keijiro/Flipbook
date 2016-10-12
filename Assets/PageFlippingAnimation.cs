using UnityEngine;

public class PageFlippingAnimation : MonoBehaviour
{
    [SerializeField] Texture _texture;
    [SerializeField] float _duration = 0.5f;
    [SerializeField] float _delay = 0.0f;

    MaterialPropertyBlock _props;
    float _time;

    void Start()
    {
        _time = _delay / _duration;
        _props = new MaterialPropertyBlock();
        _props.SetTexture("_MainTex", _texture);
    }

    void Update()
    {
        _props.SetFloat("_PreviousProgress", Mathf.Clamp01(_time));

        _time = (_time + Time.deltaTime / _duration) % 2.0f;

        _props.SetFloat("_Progress", Mathf.Clamp01(_time));

        GetComponent<Renderer>().SetPropertyBlock(_props);
    }
}
