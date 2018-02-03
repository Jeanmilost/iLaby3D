/*****************************************************************************
 * ==> IP_UserControl -------------------------------------------------------*
 * ***************************************************************************
 * Description : User control class                                          *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "IP_Texture.h"
#import "IP_2DSprite.h"

/**
* User control
*@author Jean-Milost Reymond
*/
@interface IP_UserControl : NSObject
{
    @private
        CGPoint      m_Cursor;
        float        m_Radius;
        float        m_DefaultX;
        float        m_DefaultY;
        IP_2DSprite* m_pSprite;
        IP_Texture*  m_pTexture;
        IP_2DSprite* m_pBgSprite;
        IP_Texture*  m_pBgTexture;
}

/**
* Initializes class
*@returns self object
*/
- (id)init;

/**
* Deletes all resources
*/
- (void)dealloc;

/**
* Resets position to default
*/
- (void)ResetPosition;

/**
* Sets current position
*@param position - position in iPhone view controller coordinate
*@note Position is automatically converted in OpenGL coordinate
*/
- (void)SetPosition :(const CGPoint&)position;

/**
* Updates position velocity
*@param velocity - velocity to update
*@returns updated velocity in foncton of control user position
*/
- (float)UpdatePosVelocity :(const float&)velocity;

/**
* Updates rotation velocity
*@param velocity - velocity to update
*@returns updated velocity in foncton of control user position
*/
- (float)UpdateDirVelocity :(const float&)velocity;

/**
* Renders user control on screen
*@throws E_Exception
*/
- (void)Render;

@end
