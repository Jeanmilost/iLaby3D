/*****************************************************************************
 * ==> IP_Camera ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Camera or point of view                                     *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <OpenGLES/ES1/gl.h>
#import "E_Maths.h"

/**
* Camera class
*@author Jean-Milost Reymond
*/
@interface IP_Camera : NSObject
{
    @private
        float m_WindowsWidth;  // display windows width
        float m_WindowsHeight; // display windows height
        float m_Near;          // near visibility distance (projection only)
        float m_Far;           // far visibility distance (projection only)
        float m_Deep;          // display deep (ortho only)
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
* Initializes the camera (orthogonal mode)
*@param width - display window width
*@param height - display windows height
*@param deep - deep for visibility
*@note if the orientation of the window changes, the class must be initialized again
*/
- (void)Initialize :(const float&)width
                   :(const float&)height
                   :(const float&)deep;

/**
* Initializes the camera (projection mode)
*@param width - display window width
*@param height - display windows height
*@param near - minimum (near) distance for visibility
*@param far - maximum (far) distance for visibility
*@note if the orientation of the window changes, the class must be initialized again
*/
- (void)Initialize :(const float&)width
                   :(const float&)height
                   :(const float&)near
                   :(const float&)far;

/**
* Sets the camera in the 3D world (orthogonal mode)
*/
- (void)SetCamera;

/**
* Sets the camera in the 3D world (projection mode)
*@param translation - translation vector
*@param rotation - rotation vector
*@param angle - rotation angle
*/
- (void)SetCamera :(const E_Vector3D&)translation
                  :(const E_Vector3D&)rotation
                  :(const float&)angle;

/**
* Creates an orthogonal view matrix
*/
- (void)CreateOrtho;

/**
* Creates a projection view matrix
*/
- (void)CreateProjection;

@end
