/*****************************************************************************
 * ==> IP_Cell --------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a maze cell                                      *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "IP_Sprite.h"
#import "IP_Texture.h"
#include "E_Maths.h"
#include <vector>

/**
* Represents a maze cell
*@author Jean-Milost Reymond
*/
@interface IP_Cell : NSObject
{
    @public
        /**
        * Walls types enumeration
        */
        enum IType
        {
            IE_Soil,
            IE_Wall_Top,
            IE_Wall_Left,
            IE_Wall_Bottom,
            IE_Wall_Right,
            IE_Ceiling,
        };

    @private
        IP_Sprite*      m_pFloor;
        IP_Sprite*      m_pCeiling;
        NSMutableArray* m_pWall;
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
* Sets wall
*@param type - wall type
*@param x - x position of the cell (in maze coordinate)
*@param y - y position of the cell (in maze coordinate)
*@param pTexture - texture for the wall
*/
- (void)SetWall :(IType)type :(const float&)x :(const float&)y :(IP_Texture*)pTexture;

/**
* Checks if the payer is in collision with any wall of the cell
*@param nextPosition - position to check
*@param[out] planes - pointer to a vector of planes. If the planes vector containt at least 1 plane, then the player is in collision
*@returns true on success, otherwise false
*/
- (bool)CheckCollisions :(const E_Vector3D&)nextPosition :(std::vector<E_Plane>&)planes;

/**
* Checks if the given polygon list is clipped and should not be displayed
*@param clippingPlane - clipping plane
*@param worldMatrix - world matrix
*@param pPolygonList - polygon list
*@returns true if the polygon list can be displayed, otherwise false
*/
- (bool)IsClipped :(const E_Plane&)clippingPlane :(const E_Matrix16&)worldMatrix :(E_PolygonList*)pPolygonList;

/**
* Renders the cell
*/
- (bool)RenderCell;

/**
* Renders the cell
*@param nearClippingPlane - near clipping plane
*@param farClippingPlane - far clipping plane
*@param rightClippingPlane - right clipping plane
*@param leftClippingPlane - left clipping plane
*@returns true on success, otherwise false
*/
- (bool)RenderCell :(const E_Plane&)nearClippingPlane :(const E_Plane&)farClippingPlane :(const E_Plane&)rightClippingPlane
        :(const E_Plane&)leftClippingPlane;

@end
