/*****************************************************************************
 * ==> IP_MessageBox --------------------------------------------------------*
 * ***************************************************************************
 * Description : Some tools to display message to user                       *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_MessageBox.h"

//------------------------------------------------------------------------------
// class IP_MessageBox - objective c
//------------------------------------------------------------------------------
@implementation IP_MessageBox
//------------------------------------------------------------------------------
+ (void)DisplayError :(NSString*)pTitle :(NSString*)pMessage
{
    UIAlertView* pError = [[UIAlertView alloc]initWithTitle:pTitle
                                              message:pMessage
                                              delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];

    [pError show];
    [pError release];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
