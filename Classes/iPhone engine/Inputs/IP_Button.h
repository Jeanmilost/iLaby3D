/*****************************************************************************
 * ==> IP_Button ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Button class                                                *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "IP_Texture.h"
#import "IP_2DSprite.h"

@interface IP_Button : NSObject
{
    @private
        IP_2DSprite* m_pSprite;
        IP_Texture*  m_pTexture;
        float        m_X;
        float        m_Y;
}

@property (nonatomic, assign) float m_X;
@property (nonatomic, assign) float m_Y;

/**
* Initializes class
*@param pTextureName - button texture file name in resources
*@param pTextureExt - button texture file extension in resources
*@returns self object
*/
- (id)init :(NSString*)pTextureName :(NSString*)pTextureExt;

/**
* Deletes all resources
*/
- (void)dealloc;

/**
* Check if button is clicked
*@param position - finger position
*@returns on clicked, otherwise false
*/
- (bool)IsClicked :(const CGPoint&)position;

/**
* Renders user control on screen
*@throws E_Exception
*/
- (void)Render;

@end
