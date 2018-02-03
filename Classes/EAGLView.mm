/*****************************************************************************
 * ==> EAGLView -------------------------------------------------------------*
 * ***************************************************************************
 * Description : OpenGL view class                                           *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "EAGLView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#include <sstream>
#import "E_Exception.h"
#import "E_MemoryTools.h"
#import "E_Collisions.h"
#import "IP_OpenGLHelper.h"
#import "IP_CatchMacros.h"
#import "IP_StringTools.h"
#import "IP_MessageBox.h"

#define USE_DEPTH_BUFFER 1

//------------------------------------------------------------------------------
// EAGLView - class extension to declare private methods - objective c
//------------------------------------------------------------------------------
@interface EAGLView ()
//------------------------------------------------------------------------------
@property (nonatomic, retain) EAGLContext* m_pContext;
@property (nonatomic, assign) NSTimer*     m_pAnimationTimer;
//------------------------------------------------------------------------------
- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
// EAGLView - objective c
//------------------------------------------------------------------------------
@implementation EAGLView
//------------------------------------------------------------------------------
@synthesize m_pContext;
@synthesize m_pAnimationTimer;
@synthesize m_AnimationInterval;
//------------------------------------------------------------------------------
// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}
//------------------------------------------------------------------------------
- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:m_pContext];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}
//------------------------------------------------------------------------------
- (id)initWithCoder :(NSCoder*)pCoder
{
    m_pGame    = nil;
    m_pWelcome = nil;
    m_Ready    = false;
    m_HasWin   = false;

    if (self = [super initWithCoder:pCoder])
	{
        M_Try
        {
            // get the layer
            CAEAGLLayer* pEaglLayer = (CAEAGLLayer*)self.layer;

            pEaglLayer.opaque             = YES;
            pEaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],
                    kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

            m_pContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES1];

            if (!m_pContext || ![EAGLContext setCurrentContext:m_pContext])
            {
                [self release];
                return nil;
            }

            m_AnimationInterval = 1.0 / 60.0;

            // create long press gesture recognizer
            UILongPressGestureRecognizer* pGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                    action:@selector(OnLongPress:)];

            pGestureRecognizer.minimumPressDuration = 0;

            // add gesture recognizer to view
            [self addGestureRecognizer: pGestureRecognizer];

            // release local gesture recognizer object
            [pGestureRecognizer release];

            // create welcome object
            m_pWelcome = [[GM_Welcome alloc]init];
            [m_pWelcome SetOnBeginGame_Underground_Delegate:self :@selector(OnBeginGame_Underground)];
            [m_pWelcome SetOnBeginGame_Trees_Delegate:self :@selector(OnBeginGame_Trees)];
            [m_pWelcome SetOnBeginGame_Snow_Delegate:self :@selector(OnBeginGame_Snow)];
            [m_pWelcome SetOnBeginGame_Mars_Delegate:self :@selector(OnBeginGame_Mars)];
            [m_pWelcome SetOnExitDelegate:self :@selector(OnExit)];
            m_pWelcome.m_HasFocus = true;

            // create game core object
            m_pGame = [[GM_GameCore alloc]init];
            [m_pGame SetOnRunDelegate:self :@selector(OnRun)];
            [m_pGame SetOnPauseDelegate:self :@selector(OnPause)];
            [m_pGame SetOnQuitDelegate:self :@selector(OnQuit)];
            [m_pGame SetOnWinDelegate:self :@selector(OnWin)];

            return self;
        }
        M_CatchSilent

        [self release];
    }
    else
        NSLog(@"EAGLView init - self not initialized");

    exit(0);
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [self stopAnimation];
    
    if ([EAGLContext currentContext] == m_pContext)
        [EAGLContext setCurrentContext:nil];

    if (m_pGame)
        [m_pGame release];

    if (m_pWelcome)
        [m_pWelcome release];

	if (m_pContext)
        [m_pContext release];  

    [super dealloc];
}
//------------------------------------------------------------------------------
- (BOOL)createFramebuffer
{
    M_Try
    {
        glGenFramebuffersOES(1, &m_ViewFramebuffer);
        glGenRenderbuffersOES(1, &m_ViewRenderbuffer);

        glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_ViewFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_ViewRenderbuffer);

        [m_pContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];

        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, m_ViewRenderbuffer);
        glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &m_BackingWidth);
        glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &m_BackingHeight);

        if (USE_DEPTH_BUFFER)
        {
            glGenRenderbuffersOES(1, &m_DepthRenderbuffer);
            glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_DepthRenderbuffer);
            glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, m_BackingWidth, m_BackingHeight);
            glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, m_DepthRenderbuffer);

            glEnable(GL_DEPTH_TEST);
        }

        if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
        {
            NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
            return NO;
        }

        glEnable(GL_CULL_FACE);

        // initialize welcome object
        if (m_pWelcome)
            m_Ready = [m_pWelcome Open :m_BackingWidth :m_BackingHeight];

        return YES;
    }
    M_CatchShow

    return NO;
}
//------------------------------------------------------------------------------
- (void)destroyFramebuffer
{
    M_Try
    {
        glDeleteFramebuffersOES(1, &m_ViewFramebuffer);
        m_ViewFramebuffer = 0;

        glDeleteRenderbuffersOES(1, &m_ViewRenderbuffer);
        m_ViewRenderbuffer = 0;

        if (m_DepthRenderbuffer)
        {
            glDeleteRenderbuffersOES(1, &m_DepthRenderbuffer);
            m_DepthRenderbuffer = 0;
        }
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (void)setAnimationTimer: (NSTimer*)pNewTimer
{
    M_Try
    {
        [m_pAnimationTimer invalidate];
        m_pAnimationTimer = pNewTimer;
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (void)setAnimationInterval:(NSTimeInterval)interval
{
    M_Try
    {
        m_AnimationInterval = interval;

        if (m_pAnimationTimer)
        {
            [self stopAnimation];
            [self startAnimation];
        }
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (void)startAnimation
{
    M_Try
    {
        self.m_pAnimationTimer =
                [NSTimer scheduledTimerWithTimeInterval:m_AnimationInterval
                         target:self
                         selector:@selector(drawView)
                         userInfo:nil
                         repeats:YES];
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (void)stopAnimation
{
    M_Try
    {
        self.m_pAnimationTimer = nil;
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (void)drawView
{
    M_Try
    {
        if (!m_Ready)
            return;

        // welcome and game stages must be built at this point
        M_Assert(m_pWelcome);
        M_Assert(m_pGame);

        // if game is running, display elapsed time
        if (m_RunningTimeLabel && m_pGame.m_HasFocus && m_pGame.m_Play)
        {
            m_RunningTimeLabel.text = [IP_StringTools WStrToNSStr:[m_pGame FormatTime:[m_pGame GetElapsedTime]]];
            [m_RunningTimeLabel setHidden:NO];
        }

        // send run command to each stage
        [m_pWelcome Run :m_pContext :m_ViewRenderbuffer :m_BackingWidth :m_BackingHeight];
        [m_pGame Run :m_pContext :m_ViewRenderbuffer :m_BackingWidth :m_BackingHeight];

        return;
    }
    M_CatchShow

    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnBeginGame_Underground
{
    M_Try
    {
        // hide welcome object
        if (m_pWelcome)
            m_pWelcome.m_HasFocus = false;
        else
            M_THROW_EXCEPTION("Welcome object is NULL");

        // initialize main game object
        if (m_pGame && m_pWelcome)
        {
            m_Ready = [m_pGame Open :IE_Underground :[m_pWelcome GetMazeSize] :[m_pWelcome GetMazeSize] :m_BackingWidth :m_BackingHeight];
            [m_pGame SetVolume :[m_pWelcome GetSoundVolume]];
            m_pGame.m_HasFocus = true;
        }
        else
            M_THROW_EXCEPTION("Game object is NULL");

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnBeginGame_Trees
{
    M_Try
    {
        // hide welcome object
        if (m_pWelcome)
            m_pWelcome.m_HasFocus = false;
        else
            M_THROW_EXCEPTION("Welcome object is NULL");

        // initialize main game object
        if (m_pGame)
        {
            m_Ready = [m_pGame Open :IE_Trees :[m_pWelcome GetMazeSize] :[m_pWelcome GetMazeSize] :m_BackingWidth :m_BackingHeight];
            [m_pGame SetVolume :[m_pWelcome GetSoundVolume]];
            m_pGame.m_HasFocus = true;
        }
        else
            M_THROW_EXCEPTION("Game object is NULL");

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnBeginGame_Snow
{
    M_Try
    {
        // hide welcome object
        if (m_pWelcome)
            m_pWelcome.m_HasFocus = false;
        else
            M_THROW_EXCEPTION("Welcome object is NULL");

        // initialize main game object
        if (m_pGame)
        {
            m_Ready = [m_pGame Open :IE_Snow :[m_pWelcome GetMazeSize] :[m_pWelcome GetMazeSize] :m_BackingWidth :m_BackingHeight];
            [m_pGame SetVolume :[m_pWelcome GetSoundVolume]];
            m_pGame.m_HasFocus = true;
        }
        else
            M_THROW_EXCEPTION("Game object is NULL");

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnBeginGame_Mars
{
    M_Try
    {
        // hide welcome object
        if (m_pWelcome)
            m_pWelcome.m_HasFocus = false;
        else
            M_THROW_EXCEPTION("Welcome object is NULL");

        // initialize main game object
        if (m_pGame)
        {
            m_Ready = [m_pGame Open :IE_OnMars :[m_pWelcome GetMazeSize] :[m_pWelcome GetMazeSize] :m_BackingWidth :m_BackingHeight];
            [m_pGame SetVolume :[m_pWelcome GetSoundVolume]];
            m_pGame.m_HasFocus = true;
        }
        else
            M_THROW_EXCEPTION("Game object is NULL");

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnRun
{
    M_Try
    {
        if (m_pGameLabel)
            [m_pGameLabel setHidden:YES];
        else
            M_THROW_EXCEPTION("Game label is NULL");

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnPause
{
    M_Try
    {
        if (m_pGameLabel)
        {
            if (m_pGameLabel.text != @"Pause")
                m_pGameLabel.text = @"Pause";

            [m_pGameLabel setHidden:NO];
        }
        else
            M_THROW_EXCEPTION("Game label is NULL");

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnQuit
{
    M_Try
    {
        UIAlertView* pAlert = [[UIAlertView alloc] initWithTitle:@"iLaby3D"
                                                   message:@"Do you really want to quit?"
                                                   delegate:self
                                                   cancelButtonTitle:@"No"
                                                   otherButtonTitles:@"Yes", nil];
        [pAlert show];
        [pAlert release];

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnReallyQuit
{
    M_Try
    {
        if (m_pGameLabel)
            [m_pGameLabel setHidden:YES];
        else
            M_THROW_EXCEPTION("Game label is NULL");

        if (m_RunningTimeLabel)
            [m_RunningTimeLabel setHidden:YES];
        else
            M_THROW_EXCEPTION("Running time label is NULL");

        if (m_pWelcome)
            m_pWelcome.m_HasFocus = true;
        else
            M_THROW_EXCEPTION("Welcome object is NULL");

        if (m_pGame)
        {
            [m_pGame StopAllSounds];
            m_pGame.m_HasFocus = false;
        }
        else
            M_THROW_EXCEPTION("Game object is NULL");

        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnExit
{
    M_Try
    {
        [self dealloc];
        exit(0);
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (void)OnWin
{
    M_Try
    {
        if (m_pGameLabel && m_pGameLabel.text != @"Congratulations")
        {
            m_pGameLabel.text = @"Congratulations";
            [m_pGameLabel setHidden:NO];
        }
        else
        if (!m_pGameLabel)
            M_THROW_EXCEPTION("Game label is NULL");

        if (m_RunningTimeLabel)
            [m_RunningTimeLabel setHidden:YES];
        else
            M_THROW_EXCEPTION("Running time label is NULL");

        std::wstring message = L"Time elapsed " + [m_pGame FormatTime:[m_pGame GetElapsedTime]];

        if (m_pGameTimeLabel)
        {
            m_pGameTimeLabel.text = [IP_StringTools WStrToNSStr:message];
            [m_pGameTimeLabel setHidden:NO];
        }
        else
            M_THROW_EXCEPTION("Game time label is NULL");

        m_HasWin = true;
        return;
    }
    M_CatchShow
    
    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnLongPress :(UIGestureRecognizer*)pSender
{
    M_Try
    {
        if (m_pWelcome)
            [m_pWelcome OnControlMoves :[pSender locationInView :nil] :(pSender.state == UIGestureRecognizerStateEnded)];
        else
            M_THROW_EXCEPTION("Welcome object is NULL");

        if (m_pGame)
        {
            [m_pGame OnControlMoves :[pSender locationInView :nil] :(pSender.state == UIGestureRecognizerStateEnded)];

            if (m_HasWin && pSender.state == UIGestureRecognizerStateBegan)
            {
                m_HasWin = false;

                if (m_pGameLabel)
                    [m_pGameLabel setHidden:YES];

                if (m_pGameTimeLabel)
                    [m_pGameTimeLabel setHidden:YES];

                if (m_pGame)
                {
                    [m_pGame StopAllSounds];
                    m_pGame.m_HasFocus = false;
                }

                if (m_pWelcome)
                    m_pWelcome.m_HasFocus = true;
            }
        }
        else
            M_THROW_EXCEPTION("Game object is NULL");
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (void)alertView :(UIAlertView*)pAlertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
        [self OnReallyQuit];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
