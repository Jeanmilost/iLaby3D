/*****************************************************************************
 * ==> E_Player -------------------------------------------------------------*
 * ***************************************************************************
 * Description : Player data class                                           *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Player.h"
#include "E_Exception.h"
#include "E_MemoryTools.h"
#include "E_Collisions.h"
#include <memory>

E_Player g_Player;

//------------------------------------------------------------------------------
// Struct E_Player
//------------------------------------------------------------------------------
E_Player::E_Player()
{
    m_Position    = E_Vector3D(-5.0f, 0.0f, -5.0f);
    m_Rotation    = E_Vector3D(0.0f, 0.0f, 0.0f);
    m_Direction   = E_Vector3D(0.0f, 0.0f, 1.0f);
    m_Angle       = 0.0f;
    m_Radius      = 2.0f;
    m_PosVelocity = 4.5f;
    m_DirVelocity = 8.0f;
}
//------------------------------------------------------------------------------
void E_Player::ValidateNextPosition(const E_Vector3D& nextPosition,
                                    E_PolygonList*    pPolygonList,
                                    const E_Matrix16& worldMatrix,
                                    bool&             collision,
                                    bool&             multipleCollisions,
                                    E_Plane&          slidingPlane)
{
    M_Assert(pPolygonList);

    collision          = false;
    multipleCollisions = false;

    E_PolygonContainer* pCurrentPolygon = pPolygonList->GetFirst();	
    bool                firstCollision  = true;

    // iterate through all polygons contined in the sprite
    while (pCurrentPolygon != NULL)
    {
        E_Plane collisionPlane;

        E_Polygon* pPolygon = pCurrentPolygon->GetPolygon();
        M_Assert(pPolygon);

        E_Polygon testPolygon = pPolygon->ApplyMatrix(worldMatrix);

        // check if the current polygon is in collision with player position
        if (E_Collisions::GetTriSphereCollision(-nextPosition,
                                                m_Radius,
                                                testPolygon,
                                                collisionPlane))
        {
            // if it's not the first collision and if current plane is not the same as the previous plane, there is more than one collision
            if ((slidingPlane != collisionPlane) && (slidingPlane != -collisionPlane) && !firstCollision)
            {
                multipleCollisions = true;
                return;
            }

            collision      = true;
            firstCollision = false;
            slidingPlane   = collisionPlane;
        }

        // go to next polygon
        pCurrentPolygon = pCurrentPolygon->GetNext();
    }
}
//------------------------------------------------------------------------------
