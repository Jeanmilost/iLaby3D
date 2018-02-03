/*****************************************************************************
 * ==> E_Collisions ---------------------------------------------------------*
 * ***************************************************************************
 * Description : Toolbox for collision detection                             *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_COLLISIONS_H
#define E_COLLISIONS_H

#include "E_Polygon.h"

/**
* Collisions detections toolbox
*@author Jean-Milost Reymond
*/
class E_Collisions
{
    public:
        /**
        * Calculates collision between a sphere and a polygon
        *@param position - player position
        *@param radius - sphere radius
        *@param polygon - polygon to check
        *@param[out] slidingPlane - sliding plane
        *@returns true if objects are in collision, otherwise false
        */
        static bool GetTriSphereCollision(const E_Vector3D& position,
                                          const float&      radius,
                                          const E_Polygon&  polygon,
                                          E_Plane&          slidingPlane);

        /**
        * Gets sliding point (correction of the player position using a plane)
        *@param slidingPlane - sliding plane
        *@param position - current player position
        *@param radius - sphere radius
        *@returns sliding point
        */
        static E_Vector3D GetSlidingPoint(const E_Plane&   slidingPlane,
                                          const E_Vector3D position,
                                          const float&     radius);

        /**
        * Checks if a given point is contained in a given sphere
        *@param point - point to check
        *@param sphereOrigin - origin of the sphere
        *@param sphereRadius - radius of the sphere
        *@returns true if point is in the sphere, otherwise false
        */
        static bool IsPointInSphere(const E_Vector3D& point,
                                    const E_Vector3D& sphereOrigin,
                                    const float&      sphereRadius);

        /**
        * Checks if a given point is on a given polygon
        *@param point - point to check
        *@param polygon - polygon to check
        *@returns true if given point is on the given polygon, otherwise false
        */
        static bool IsPointInTriangle(const E_Vector3D& point,
                                      const E_Polygon&  polygon);

        /**
        * Calculates and gets the projection of a given point on a given segment
        *@param segStart - segment start
        *@param segEnd - segment end
        *@param point - point for which projection must be calculated
        *@returns the calculated point
        */
        static E_Vector3D ClosestPointOnLine(const E_Vector3D& segStart,
                                             const E_Vector3D& segEnd,
                                             const E_Vector3D& point);

        /**
        * Calculates and gets the projection of a given point on a given polygon
        *@param point - point for which projection must be calculated
        *@param polygon - polygon
        *@returns the calculated point
        */
        static E_Vector3D ClosestPointOnTriangle(const E_Vector3D& point,
                                                 const E_Polygon&  polygon);

        /**
        * Gets distance to plane
        *@param plane - plane for which the distance must be calculated
        *@param point - point for which the distance must be calculated
        *@returns distance to plane
        */
        static float GetDistanceToPlane(const E_Plane&    plane,
                                        const E_Vector3D& point);

    private:
        /**
        * Constructor
        */
        E_Collisions();

        /**
        * Destructor
        */
        ~E_Collisions();
};

#endif // E_COLLISIONS_H
