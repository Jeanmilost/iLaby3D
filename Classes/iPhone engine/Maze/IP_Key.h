/*****************************************************************************
 * ==> IP_Key ---------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents the key of the maze                              *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "IP_Texture.h"
#import "IP_Sprite.h"
#import "IP_2DSprite.h"

@interface IP_Key : NSObject
{
    @private
        IP_Texture*  m_pTexture;
        IP_Sprite*   m_pKey;
        IP_2DSprite* m_pMiniKey;
        E_Vector3D   m_Position;
        float        m_Height;
        bool         m_KeyFound;
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
* Gets key position
*@returns key position
*/
- (const E_Vector3D&)GetPosition;

/**
* Sets key position
*@param position - key position
*/
- (void)SetPosition :(const E_Vector3D&)position;

/**
* Checks if key was found
*@returns true if key was found, otherwise false
*/
- (bool)IsKeyFound;

/**
* Set whether key was found or not
*@param value - whteher or not key was found
*/
- (void)SetKeyFound :(bool)value;

/**
* Renders the key
*/
- (bool)RenderKey;

@end
