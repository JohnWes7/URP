using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class TestRenderPass : ScriptableRenderPass
{

    public Material material;

    public RenderTargetIdentifier source;
    public RenderTargetHandle destination;

    public TestRenderPass(RenderPassEvent renderPassEvent)
    {
        //设置渲染的顺序，这个只在after postprocessing之后会有效
        this.renderPassEvent = renderPassEvent;
    }

    /// <summary>
    /// 接收blit用的source和destination
    /// </summary>
    /// <param name="source">source</param>
    /// <param name="dest">destination</param>
    public void Setup(RenderTargetIdentifier source, RenderTargetHandle dest)
    {
        //接收blit用的source和destination
        this.source = source;
        this.destination = dest;
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        CommandBuffer cb = CommandBufferPool.Get("TestEffect");


        #region 两种情况，第二种是什么不清楚
        //RenderTextureDescriptor renderTextureDescriptor = renderingData.cameraData.cameraTargetDescriptor;
        //renderTextureDescriptor.depthBufferBits = 0;

        //if (destination == RenderTargetHandle.CameraTarget)
        //{
        //    cb.GetTemporaryRT(m_temp.id, renderTextureDescriptor);
        //    Blit(cb, source, m_temp.Identifier(), material);
        //    Blit(cb, m_temp.Identifier(), source);
        //}
        //else
        //{
        //    Blit(cb, source, destination.Identifier(), material);
        //} 
        #endregion

        //这个姑且理解就是老版的blit
        //可以用在after postprocess
        Blit(cb, source, destination.Identifier(), material);

        context.ExecuteCommandBuffer(cb);
        CommandBufferPool.Release(cb);
    }

    
}
