/*****************************************************************************
 * ==> IP_OpenGLHelper ------------------------------------------------------*
 * ***************************************************************************
 * Description : Some OpenGL tools                                           *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "E_Maths.h"

#define M_DegToRad(angle) ((angle * (M_PI * 2)) / 360.0f)

/**
* Structure representng an OpenGL matrix
*@author Jean-Milost Reymond
*/
struct IP_OpenGLMatrix
{
    public:
        float m_Table[16];
};

/**
* OpenGL tools class
*@author Jean-Milost Reymond
*/
@interface IP_OpenGLHelper : NSObject
{}

/**
* Converts an OpenGL matrix array to E_Matrix16
*@param openGLMatrix - openGL matrix to convert
*@returns converted E_Matrix16
*/
+ (E_Matrix16)OpenGLMatrixToEMatrix :(const IP_OpenGLMatrix&)openGLMatrix;

@end
