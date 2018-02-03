/*****************************************************************************
 * ==> iLaby3DAppDelegate ---------------------------------------------------*
 * ***************************************************************************
 * Description : Application delegate                                        *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <UIKit/UIKit.h>

@class EAGLView;

@interface iLaby3DAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow* m_pWindow;
    EAGLView* m_pGLView;
}

@property (nonatomic, retain) IBOutlet UIWindow* m_pWindow;
@property (nonatomic, retain) IBOutlet EAGLView* m_pGLView;

- (void)applicationDidFinishLaunching :(UIApplication*)pApplication;
- (void)applicationWillResignActive :(UIApplication*)pApplication;
- (void)applicationDidBecomeActive :(UIApplication*)pApplication;
- (void)dealloc;

@end
