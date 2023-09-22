using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode()]
public class EasyImageEffect : MonoBehaviour
{
    public Material material;
    // Start is called before the first frame update
    void Start()
    {
        if(material == null || SystemInfo.supportsImageEffects == false || material.shader == null || material.shader.isSupported == false)
        {
            enabled = false;
            return;
        }
    }

    // OnRenderImage is called every frame. Only effective under camera component.
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material, 0);
    }
}
