/*****************************************************************************
 * ==> IP_Sprite ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a sprite, usable e.g. for billboarding           *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <OpenGLES/ES1/gl.h>
#import "IP_SpriteBase.h"

/**
* Contains the 3D object data for displaying
*@author Jean-Milost Reymond
*/
struct IP_3DObject
{
	static const GLfloat m_Vertices[];
	static const GLfloat m_TextureCoords[];
};

/**
* Sprite class
*@author Jean-Milost Reymond
*/
@interface IP_Sprite : IP_SpriteBase <IP_SpriteProtocol>
{
	@private
        E_Vector3D m_Position;
        E_Matrix16 m_WorldMatrix;
        bool       m_UseOrtho;
}

@property (readonly,  nonatomic, assign) E_Vector3D m_Position;
@property (readwrite, nonatomic, assign) bool       m_UseOrtho;
@property (readonly,  nonatomic, assign) E_Matrix16 m_WorldMatrix;

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
*@throws E_Exception
*/
- (void)Create :(const float&)width :(const float&)height;

/**
* Sets sprite position and rotation
*@param position - sprite position
*@param rotation - sprite rotation axis
*@param angle - sprite angle of rotation
*@throws E_Exception
*/
- (void)Set :(const E_Vector3D&)position :(const E_Vector3D&)rotation :(const float&)angle;

/**
* Renders sprite on screen
*@throws E_Exception
*/
- (void)Render;

@end
