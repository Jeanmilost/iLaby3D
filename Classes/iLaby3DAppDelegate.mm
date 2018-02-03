/*****************************************************************************
 * ==> iLaby3DAppDelegate ---------------------------------------------------*
 * ***************************************************************************
 * Description : Application delegate                                        *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "iLaby3DAppDelegate.h"
#import "EAGLView.h"
#import "IP_CatchMacros.h"

//------------------------------------------------------------------------------
@implementation iLaby3DAppDelegate
//------------------------------------------------------------------------------
@synthesize m_pWindow;
@synthesize m_pGLView;
//------------------------------------------------------------------------------
- (void)dealloc
{
    #ifdef Show_Advertisements
        if (m_pADView)
        {
            [m_pADView removeFromSuperview];
            [m_pADView release];
        }
    #endif

    if (m_pGLView)
        [m_pGLView release];

    if (m_pWindow)
        [m_pWindow release];

	[super dealloc];
}
//------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching :(UIApplication*)pApplication
{
    #ifdef Show_Advertisements
        m_pADView = nil;
    #endif

    if (m_pGLView)
    {
        #ifdef Show_Advertisements
            M_Try
            {
                m_pADView                                = [[ADBannerView alloc]initWithFrame:CGRectZero];
                m_pADView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
                m_pADView.currentContentSizeIdentifier   = ADBannerContentSizeIdentifierPortrait;
                m_pADView.frame                          = CGRectMake(0, 425, 320, 475);
                [m_pADView setDelegate:self];
                [m_pWindow addSubview:m_pADView];
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
- (void)applicationDidEnterBackground :(UIApplication*)pApplication
{
    if (m_pGLView)
        [m_pGLView OnAppEnterBackground];
}
//------------------------------------------------------------------------------
- (void)applicationWillEnterForeground :(UIApplication*)pApplication
{
    if (m_pGLView)
        [m_pGLView OnAppEnterForeground];
}
//------------------------------------------------------------------------------
#ifdef Show_Advertisements
    - (void)bannerViewDidLoadAd :(ADBannerView*)banner
    {
        [UIView beginAnimations:@"runtimeAnimate" context:nil];

        if (m_pADView)
            [m_pADView setHidden:NO];

        //[UIView commitAnimations];
    }
#endif
//------------------------------------------------------------------------------
#ifdef Show_Advertisements
    - (void)bannerView :(ADBannerView*)banner didFailToReceiveAdWithError:(NSError*)error
    {
        [UIView beginAnimations:@"errorAnimate" context:nil];

        if (m_pADView)
            [m_pADView setHidden:YES];

        //[UIView commitAnimations];
    }
#endif
//------------------------------------------------------------------------------
#ifdef Show_Advertisements
    - (BOOL)bannerViewActionShouldBegin :(ADBannerView*)banner willLeaveApplication:(BOOL)willLeave
    {
        return TRUE;
    }
#endif
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
