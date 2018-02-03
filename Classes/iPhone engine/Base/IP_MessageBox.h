/*****************************************************************************
 * ==> IP_MessageBox --------------------------------------------------------*
 * ***************************************************************************
 * Description : Some tools to display message to user                       *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>

/**
* Some tools to display message to user
*@author Jean-Milost Reymond
*/
@interface IP_MessageBox : NSObject
{}

/**
* Displays a message box to the user
*@param pTitle - title of the box
*@param pMessage - message to display to user
*/
+ (void)DisplayError :(NSString*)pTitle :(NSString*)pMessage;

@end
