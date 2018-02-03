/*****************************************************************************
 * ==> GM_Stage -------------------------------------------------------------*
 * ***************************************************************************
 * Description : Basic application stage class and protocol                  *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "GM_Stage.h"
#import <OpenGLES/EAGLDrawable.h>
#include "E_MemoryTools.h"
#import "IP_CatchMacros.h"

//------------------------------------------------------------------------------
// class GM_Stage - objective c
//------------------------------------------------------------------------------
@implementation GM_Stage
//------------------------------------------------------------------------------
@synthesize m_Red;
@synthesize m_Green;
@synthesize m_Blue;
@synthesize m_Alpha;
@synthesize m_HasFocus;
//------------------------------------------------------------------------------
- (id)init
{
    m_Red   = 0.0f;
    m_Green = 0.0f;
    m_Blue  = 0.0f;
    m_Alpha = 0.0f;

    if (self = [super init])
	{}

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [super dealloc];
}
//------------------------------------------------------------------------------
- (void)Run :(EAGLContext*)pContext :(GLuint)viewRenderBuffer :(GLint)backingWidth :(GLint)backingHeight
{
    M_Try
    {
        // if application stage does not have focus, simply quit
        if (!m_HasFocus)
            return;

        if (!m_Ready)
            return;

        [self OnDrawBegin];

        // begin the scene drawing
        if (![self BeginScene :pContext :viewRenderBuffer :backingWidth :backingHeight])
        {
            m_Ready = false;
            return;
        }

        [self OnDraw];

        // dispay the scene and close the drawing
        if (![self EndScene :pContext :viewRenderBuffer])
        {
            m_Ready = false;
            return;
        }

        [self OnDrawEnd];

        return;
    }
    M_CatchShow

    m_Ready = false;
}
//------------------------------------------------------------------------------
- (bool)BeginScene :(EAGLContext*)pContext :(GLuint)viewRenderBuffer :(GLint)backingWidth :(GLint)backingHeight
{
    M_Try
    {
        M_Assert(pContext);

        // clear the scene
        glClearColor(m_Red, m_Green, m_Blue, m_Alpha);
        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

        // begin the scene drawing
        [EAGLContext setCurrentContext:pContext];
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewRenderBuffer);
        glViewport(0, 0, backingWidth, backingHeight);

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (bool)EndScene :(EAGLContext*)pContext :(GLuint)viewRenderBuffer
{
    M_Try
    {
        M_Assert(pContext);

        // dispay the scene and close the drawing
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderBuffer);
        [pContext presentRenderbuffer:GL_RENDERBUFFER_OES];
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (void)OnDrawBegin
{}
//------------------------------------------------------------------------------
- (void)OnDraw
{}
//------------------------------------------------------------------------------
- (void)OnDrawEnd
{}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
