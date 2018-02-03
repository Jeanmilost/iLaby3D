/*****************************************************************************
 * ==> iLaby3DAppDelegate ---------------------------------------------------*
 * ***************************************************************************
 * Description : Application delegate                                        *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@class EAGLView;

@interface iLaby3DAppDelegate : NSObject <UIApplicationDelegate, ADBannerViewDelegate>
{
    UIWindow*         m_pWindow;
    EAGLView*         m_pGLView;

    #ifdef Show_Advertisements
        ADBannerView* m_pADView;
    #endif
}

@property (nonatomic, retain) IBOutlet UIWindow* m_pWindow;
@property (nonatomic, retain) IBOutlet EAGLView* m_pGLView;

- (void)dealloc;
- (void)applicationDidFinishLaunching :(UIApplication*)pApplication;
- (void)applicationWillResignActive :(UIApplication*)pApplication;
- (void)applicationDidBecomeActive :(UIApplication*)pApplication;
- (void)applicationDidEnterBackground :(UIApplication*)pApplication;
- (void)applicationWillEnterForeground :(UIApplication*)pApplication;

#ifdef Show_Advertisements
    - (void)bannerViewDidLoadAd :(ADBannerView*)banner;
    - (void)bannerView :(ADBannerView*)banner didFailToReceiveAdWithError:(NSError*)error;
    - (BOOL)bannerViewActionShouldBegin :(ADBannerView*)banner willLeaveApplication:(BOOL)willLeave;
#endif

@end
