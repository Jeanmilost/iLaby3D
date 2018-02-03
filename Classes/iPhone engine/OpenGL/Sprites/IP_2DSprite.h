/*****************************************************************************
 * ==> IP_2DSprite ----------------------------------------------------------*
 * ***************************************************************************
 * Description : Special sprite that always in 2D coordinates system         *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "IP_SpriteBase.h"

/**
* Contains the 2D object data for displaying
*@author Jean-Milost Reymond
*/
struct IP_2DObject
{
	static const GLfloat m_Vertices[];
	static const GLfloat m_TextureCoords[];
};

/**
* 2D sprite, always displayed on the screen, even if the camera moves in the 3D
* world
*@author Jean-Milost Reymond
*/
@interface IP_2DSprite : IP_SpriteBase <IP_SpriteProtocol>
{
    @private
        E_Vector2D m_Position;
        float      m_Deep;
}

@property (readonly,  nonatomic, assign) E_Vector2D m_Position;
@property (readwrite, nonatomic, assign) float      m_Deep;

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
* Creates sprite
*@param width - sprite width
*@param height - sprite height
*/
- (void)Create :(const float&)width :(const float&)height;

/**
* Sets sprite position and rotation
*@param position - sprite position
*@param rotation - sprite rotation axis
*@param angle - sprite angle of rotation
*@throws E_Exception
*/
- (void)Set :(const E_Vector2D&)position :(const E_Vector3D&)rotation :(const float&)angle;

/**
* Renders sprite on screen
*@throws E_Exception
*/
- (void)Render;

@end
