/*****************************************************************************
 * ==> E_Player -------------------------------------------------------------*
 * ***************************************************************************
 * Description : Player data class                                           *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_PLAYER_H
#define E_PLAYER_H

#include "E_Maths.h"
#include "E_Polygonlist.h"

/**
* Represents a player in the 3D world
*@author Jean-Milost Reymond
*/
struct E_Player
{
    E_Vector3D m_Position;
    E_Vector3D m_Direction;
    E_Vector3D m_Rotation;
    float      m_Angle;
    float      m_Radius;
    float      m_PosVelocity;
    float      m_DirVelocity;

    /**
    * Constructor
    */
    E_Player();

    /**
    * Validates the next player position
    *@param nextPosition - next position to check
    *@param pPolygonList - list of polygon to check against player
    *@param worldMatrix - world matrix
    *@param[out] collision - whether or not collision is detected
    *@param[out] multipleCollisions - whether or not multiple collisions are detected
    *@param[out] slidingPlane - resulting sliding plane (useless if multiple collisions are detected)
    *@throws E_Exception
    */
    void ValidateNextPosition(const E_Vector3D& nextPosition,
                              E_PolygonList*    pPolygonList,
                              const E_Matrix16& worldMatrix,
                              bool&             collision,
                              bool&             multipleCollisions,
                              E_Plane&          slidingPlane);
};

extern E_Player g_Player;

#endif // E_PLAYER_H
