/*****************************************************************************
 * ==> iLaby3DAppDelegate ---------------------------------------------------*
 * ***************************************************************************
 * Description : Application delegate                                        *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "iLaby3DAppDelegate.h"
#import <iAd/iAd.h>
#import "EAGLView.h"
#import "IP_CatchMacros.h"

//------------------------------------------------------------------------------
@implementation iLaby3DAppDelegate
//------------------------------------------------------------------------------
@synthesize m_pWindow;
@synthesize m_pGLView;
//------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching :(UIApplication*)pApplication
{
    if (m_pGLView)
    {
        #ifdef Show_Advertisements
            M_Try
            {
                UIViewController* pADController = [[UIViewController alloc]init];
                pADController.view.frame = CGRectMake(0, 423, 320, 455);

                // from the official iAd programming guide
                ADBannerView* pADView = [[ADBannerView alloc]initWithFrame:CGRectZero];

                pADView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
                pADView.currentContentSizeIdentifier   = ADBannerContentSizeIdentifierPortrait;

                [pADController.view addSubview:pADView];
                [m_pGLView addSubview:pADController.view];
            }
            M_CatchSilent
        #endif

        m_pGLView.m_AnimationInterval = 1.0 / 60.0;
        [m_pGLView startAnimation];
    }
    else
        exit(0);
}
//------------------------------------------------------------------------------
- (void)applicationWillResignActive :(UIApplication*)pApplication
{
    if (m_pGLView)
        m_pGLView.m_AnimationInterval = 1.0 / 5.0;
}
//------------------------------------------------------------------------------
- (void)applicationDidBecomeActive :(UIApplication*)pApplication
{
    if (m_pGLView)
        m_pGLView.m_AnimationInterval = 1.0 / 60.0;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    if (m_pWindow)
        [m_pWindow release];

    if (m_pGLView)
        [m_pGLView release];

	[super dealloc];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
