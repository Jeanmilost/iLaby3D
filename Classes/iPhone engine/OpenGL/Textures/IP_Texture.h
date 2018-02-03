/*****************************************************************************
 * ==> IP_Texture -----------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a texture                                        *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGContext.h>
#import <OpenGLES/ES1/gl.h>

/**
* Texture class
*@author Jean-Milost Reymond
*/
@interface IP_Texture : NSObject
{
	@private
		GLuint m_Texture[1];
}

/**
* Initializes class
*@returns self pointer
*/
- (id)init;

/**
* Loads texture from resources
*@param pResourceName - the texture name in the resources
*@param pExtension - resource extension
*/
- (bool)Load :(NSString*)pResourceName :(NSString*)pExtension;

/**
* Configures texture for rendering
*/
- (void)Render;

@end
