/*****************************************************************************
 * ==> IP_Delegate ----------------------------------------------------------*
 * ***************************************************************************
 * Description : Basic delegate class                                        *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>

/**
* Delegate class
*@author Jean-Milost Reymond
*/
@interface IP_Delegate : NSObject
{
    @private
        id  m_pObject;
        SEL m_pDelegate;
}

/**
* Initializes the class
*@returns pointer to itself
*/
- (id)init;

/**
* Releases class resources
*/
- (void)dealloc;

/**
* Sets delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)Set :(id)pObject :(SEL)pDelegate;

/**
* Calls delegate
*/
- (void)Call;

@end
