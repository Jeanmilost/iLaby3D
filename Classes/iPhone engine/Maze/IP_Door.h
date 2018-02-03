/*****************************************************************************
 * ==> IP_Door --------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a door                                           *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "IP_Texture.h"
#import "IP_Sprite.h"

#define M_Nb_Objects  3

@interface IP_Door : NSObject
{
    @private
        IP_Texture* m_pTexture[M_Nb_Objects];
        IP_Sprite*  m_pSprite[M_Nb_Objects];
        E_Vector3D  m_Position[M_Nb_Objects];
        float       m_Height;
        bool        m_Open;
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
* Gets enter door position
*@returns enter door position
*/
- (const E_Vector3D&)GetEnterPosition;

/**
* Sets enter door position
*@param position - enter door position
*/
- (void)SetEnterPosition :(const E_Vector3D&)position;

/**
* Gets exit door position
*@returns exit door position
*/
- (const E_Vector3D&)GetExitPosition;

/**
* Sets exit door position
*@param position - exit door position
*/
- (void)SetExitPosition :(const E_Vector3D&)position;

/**
* Checks if exit was opened
*@returns true if exit was opened, otherwise false
*/
- (bool)IsOpen;

/**
* Sets whether exit is open or not
*@param value - whether or not exit is open
*/
- (void)SetOpen :(bool)value;

/**
* Renders the door
*/
- (bool)RenderDoor;

@end
