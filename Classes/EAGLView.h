/*****************************************************************************
 * ==> EAGLView -------------------------------------------------------------*
 * ***************************************************************************
 * Description : OpenGL view class                                           *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "GM_Welcome.h"
#import "GM_GameCore.h"

/**
* This class wraps the CAEAGLLayer from CoreAnimation into a convenient UIView subclass.
* The view content is basically an EAGL surface you render your OpenGL scene into.
* Note that setting the view non-opaque will only work if the EAGL surface has an alpha channel.
*/
@interface EAGLView : UIView
{
    @private
        // The pixel dimensions of the backbuffer
        GLint             m_BackingWidth;
        GLint             m_BackingHeight;

        EAGLContext*      m_pContext;

	    // OpenGL names for the renderbuffer and framebuffers used to render to this view
        GLuint            m_ViewRenderbuffer;
        GLuint            m_ViewFramebuffer;

	    // OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
	    GLuint            m_DepthRenderbuffer;

	    NSTimer*          m_pAnimationTimer;
	    NSTimeInterval    m_AnimationInterval;

        GM_Welcome*       m_pWelcome;
        GM_GameCore*      m_pGame;

        bool              m_Ready;
        bool              m_HasWin;

        IBOutlet UILabel* m_pGameLabel;
        IBOutlet UILabel* m_pGameTimeLabel;
        IBOutlet UILabel* m_RunningTimeLabel;
}

@property NSTimeInterval m_AnimationInterval;

/**
* The GL view is stored in the nib file. When it's unarchived it's sent initWithCoder
*/
- (id)initWithCoder :(NSCoder*)pCoder;

/**
* Destructor
*/
- (void)dealloc;

/**
* Start animation
*/
- (void)startAnimation;

/**
* Stop animation
*/
- (void)stopAnimation;

/**
* Draw the view
*/
- (void)drawView;

/**
* Called when OnBeginGame (underground level) command was sent from game
*/
- (void)OnBeginGame_Underground;

/**
* Called when OnBeginGame (tree level) command was sent from game
*/
- (void)OnBeginGame_Trees;

/**
* Called when OnBeginGame (snow level) command was sent from game
*/
- (void)OnBeginGame_Snow;

/**
* Called when OnBeginGame (mars level) command was sent from game
*/
- (void)OnBeginGame_Mars;

/**
* Called when run command was sent from game
*/
- (void)OnRun;

/**
* Called when pause command was sent from game
*/
- (void)OnPause;

/**
* Called when quit command was sent from game
*/
- (void)OnQuit;

/**
* Called when really quit command was sent from game
*/
- (void)OnReallyQuit;

/**
* Called when exit command was sent from game
*/
- (void)OnExit;

/**
* Called when win command was sent from game
*/
- (void)OnWin;

/**
* Called when user press the screen a long time
* pSender - sender of the event
*/
- (void)OnLongPress :(UIGestureRecognizer*)pSender;

@end
