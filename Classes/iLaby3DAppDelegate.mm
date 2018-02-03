/*****************************************************************************
 * ==> iLaby3DAppDelegate ---------------------------------------------------*
 * ***************************************************************************
 * Description : Application delegate                                        *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "iLaby3DAppDelegate.h"
#import "EAGLView.h"

//------------------------------------------------------------------------------
@implementation iLaby3DAppDelegate
//------------------------------------------------------------------------------
@synthesize m_pWindow;
@synthesize m_pGLView;
//------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching: (UIApplication*)pApplication
{
	m_pGLView.m_AnimationInterval = 1.0 / 60.0;
	[m_pGLView startAnimation];
}
//------------------------------------------------------------------------------
- (void)applicationWillResignActive: (UIApplication*)pApplication
{
	m_pGLView.m_AnimationInterval = 1.0 / 5.0;
}
//------------------------------------------------------------------------------
- (void)applicationDidBecomeActive: (UIApplication*)pApplication
{
	m_pGLView.m_AnimationInterval = 1.0 / 60.0;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
	[m_pWindow release];
	[m_pGLView release];
	[super dealloc];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
