/*****************************************************************************
 * ==> GM_Stage -------------------------------------------------------------*
 * ***************************************************************************
 * Description : Basic application stage class and protocol                  *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

/**
* Stage protocol
*@author Jean-Milost Reymond
*/
@protocol GM_StageProtocol
    @required
        /**
        * Called before draw begins
        */
        - (void)OnDrawBegin;

        /**
        * Called when the scene should be drawn
        */
        - (void)OnDraw;

        /**
        * Called after draw ends
        */
        - (void)OnDrawEnd;
@end

/**
* Basic stage class
*@author Jean-Milost Reymond
*/
@interface GM_Stage : NSObject <GM_StageProtocol>
{
    @protected
        GLfloat m_Red;
        GLfloat m_Green;
        GLfloat m_Blue;
        GLfloat m_Alpha;
        bool    m_Ready;
        bool    m_HasFocus;
}

@property (readonly,  nonatomic, assign) GLfloat m_Red;
@property (readonly,  nonatomic, assign) GLfloat m_Green;
@property (readonly,  nonatomic, assign) GLfloat m_Blue;
@property (readonly,  nonatomic, assign) GLfloat m_Alpha;
@property (readwrite, nonatomic, assign) bool    m_HasFocus;

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
* Run application loop
*@param pContext - OpenGL drawing context
*@param viewRenderBuffer - view render buffer
*@param backingWidth - backing width
*@param backingHeight - backing height
*/
- (void)Run :(EAGLContext*)pContext :(GLuint)viewRenderBuffer :(GLint)backingWidth :(GLint)backingHeight;

/**
* Begin scene drawing
*@param pContext - OpenGL drawing context
*@param viewRenderBuffer - view render buffer
*@param backingWidth - backing width
*@param backingHeight - backing height
*@returns true on success, otherwise false
*/
- (bool)BeginScene :(EAGLContext*)pContext :(GLuint)viewRenderBuffer :(GLint)backingWidth :(GLint)backingHeight;

/**
* End scene drawing
*@param pContext - OpenGL drawing context
*@param renderBuffer - render buffer
*@returns true on success, otherwise false
*/
- (bool)EndScene :(EAGLContext*)pContext :(GLuint)viewRenderBuffer;

/**
* Called before draw begins
*/
- (void)OnDrawBegin;

/**
* Called when the scene should be drawn
*/
- (void)OnDraw;

/**
* Called after draw ends
*/
- (void)OnDrawEnd;

@end
