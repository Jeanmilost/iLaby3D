/*****************************************************************************
 * ==> IP_SpriteBase --------------------------------------------------------*
 * ***************************************************************************
 * Description : Basic sprite class and protocol                             *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#include "E_Polygonlist.h"
#include "E_Player.h"
#import "IP_Texture.h"

/**
* Sprite protocol
*@author Jean-Milost Reymond
*/
@protocol IP_SpriteProtocol
    @required
        /**
        * Creates sprite
        *@param width - sprite width
        *@param height - sprite height
        */
        - (void)Create :(const float&)width :(const float&)height;

        /**
        * Renders sprite on screen
        */
        - (void)Render;
@end

/**
* Basic sprite class
*@author Jean-Milost Reymond
*/
@interface IP_SpriteBase : NSObject
{
    @protected
        GLfloat*       m_pSpriteData;
        E_PolygonList* m_pPolygonList;
        IP_Texture*    m_pTexture;
		E_Vector3D     m_Rotation;
        float          m_Angle;
}

@property (readonly,  nonatomic, assign) E_Vector3D     m_Rotation;
@property (readonly,  nonatomic, assign) float          m_Angle;
@property (readonly,  nonatomic, assign) E_Matrix16     m_WorldMatrix;
@property (readonly,  nonatomic, assign) E_PolygonList* m_pPolygonList;
@property (readwrite, nonatomic, retain) IP_Texture*    m_pTexture;

/**
* Initializes class
*@returns self object
*/
- (id)init;

/**
* Deletes all resources
*/
- (void)dealloc;

@end
