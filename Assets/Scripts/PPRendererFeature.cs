using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class PPRendererFeature : ScriptableRendererFeature
{
    
    public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingPostProcessing;
    public Material postMat;


    TestRenderPass m_ScriptavlePass;

    public override void Create()
    {
        #region 不清楚这个pass数量是什么
        //int passIndex = 1;
        //if (setting.postMat)
        //{
        //    passIndex = setting.postMat.passCount - 1;
        //}

        //setting.blitMaterialPassIndex = Mathf.Clamp(setting.blitMaterialPassIndex, -1, passIndex); 
        #endregion

        m_ScriptavlePass = new TestRenderPass(renderPassEvent);
        m_ScriptavlePass.material = postMat;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        //获取渲染出来的source和将被替换的destination
        RenderTargetIdentifier src = renderer.cameraColorTarget;
        RenderTargetHandle dest = RenderTargetHandle.CameraTarget;

        //赋值给ScriptableRenderPass
        m_ScriptavlePass.Setup(src, dest);

        //把该ScriptableRenderPass加入渲染队列
        renderer.EnqueuePass(m_ScriptavlePass);
    }
}
