/*****************************************************************************
 * ==> E_Collisions ---------------------------------------------------------*
 * ***************************************************************************
 * Description : Toolbox for collision detection                             *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Collisions.h"
#include <math.h>

//------------------------------------------------------------------------------
bool E_Collisions::GetTriSphereCollision(const E_Vector3D& position,
                                         const float&      radius,
                                         const E_Polygon&  polygon,
                                         E_Plane&          slidingPlane)
{
    // create a plane using the 3 vertices of the polygon
    E_Plane polygonPlane = polygon.GetPlane();

    // calculate the distance between the center of the sphere and the plane
    float testPoint1 = GetDistanceToPlane(polygonPlane, position);

    E_Vector3D sphereNormal;

    // calculate the normal of the distance sphere-plan using the positive or
    // negative value of the calculated distance between plane and position
    if (testPoint1 < 0.0f)
        sphereNormal = E_Vector3D(polygonPlane.m_A,
                                  polygonPlane.m_B,
                                  polygonPlane.m_C);
    else
        sphereNormal = E_Vector3D(-polygonPlane.m_A,
                                  -polygonPlane.m_B,
                                  -polygonPlane.m_C);

    // calculate the point who the segment from center of sphere in the
    // direction of the plane will cross the border of the sphere
    E_Vector3D pointOnSphere = 
            E_Vector3D(position.m_X + (radius * sphereNormal.m_X),
                       position.m_Y + (radius * sphereNormal.m_Y),
                       position.m_Z + (radius * sphereNormal.m_Z));

    // calculate the distance between the border of the sphere and the plane
    float testPoint2 = GetDistanceToPlane(polygonPlane, pointOnSphere);

    // if the test points are on each side of the plane, then the sphere cross
    // the plane. We assume that the segment from the center of the sphere to
    // the direction of the plane can never be co-planar
    if ((testPoint1 <= 0.0f && testPoint2 >= 0.0f) ||
        (testPoint2 <= 0.0f && testPoint1 >= 0.0f))
    {
        E_Vector3D pointOnPlane;
        bool       coplanar;

        // calculate who the segment cross the plane
        if (testPoint1 == 0.0f)
            // if testPoint1 is equal to 0, the center of the sphere cross the
            // plane
            pointOnPlane = position;
        else
        if (testPoint2 == 0.0f)
            // if testPoint2 is equal to 0, the border of the sphere cross the
            // plane
            pointOnPlane = pointOnSphere;
        else
            // calculate the intersection point
            pointOnPlane = E_Maths::PlaneIntersectLine(polygonPlane,
                                                       position,
                                                       pointOnSphere,
                                                       coplanar);

        // check if calculated point is inside the polygon
        if (IsPointInTriangle(pointOnPlane, polygon) == true)
        {
            // if yes, the sphere collide the polygon. In this case, we copy
            // the plane and we returns true
            slidingPlane = polygonPlane;
            return true;
        }
        else
        {
            // otherwise check if the sphere collide the border of the polygon.
            // First we calculate the test point on the border of the polygon
            E_Vector3D pointOnTriangle = ClosestPointOnTriangle(pointOnPlane,
                                                                polygon);

            // check if calculated point is inside the sphere
            if (IsPointInSphere(pointOnTriangle,
                                position,
                                radius) == true)
            {
                // if yes, the sphere collide the polygon. In this case, we
                // copy the plane and we returns true
                slidingPlane = polygonPlane;
                return true;
            }
        }
    }

    // no collision was found
    return false;
}
//------------------------------------------------------------------------------
E_Vector3D E_Collisions::GetSlidingPoint(const E_Plane&   slidingPlane,
                                         const E_Vector3D position,
                                         const float&     radius)
{
    E_Plane plane = slidingPlane;

    // calculate the distance between the center of the sphere and the plane
    float distanceToPlane = GetDistanceToPlane(plane, position);

    // check if value is negative
    if (distanceToPlane < 0.0f)
    {
        // invert the plane
        plane.m_A = -plane.m_A;
        plane.m_B = -plane.m_B;
        plane.m_C = -plane.m_C;
        plane.m_D = -plane.m_D;
    }

    // calculate the direction of the segment position - plane
    E_Vector3D planeRatio(radius * plane.m_A,
                          radius * plane.m_B,
                          radius * plane.m_C);

    // calculate who the segment perpendicular to the plane, from the center
    // of the sphere, cross the collision sphere. Normally this point is beyond
    // the plane
    E_Vector3D pointBeyondPlane(position.m_X - planeRatio.m_X,
                                position.m_Y - planeRatio.m_Y,
                                position.m_Z - planeRatio.m_Z);

    bool coplanar;

    // calculate the point who the segment "center of the sphere - point beyond
    // the plane" cross the collision plane
    E_Vector3D pointOnPlane = E_Maths::PlaneIntersectLine(slidingPlane,
                                                          position,
                                                          pointBeyondPlane,
                                                          coplanar);

    // from point calculated below, we add the radius of the sphere, and we
    // returns the value
    return E_Vector3D(pointOnPlane.m_X + planeRatio.m_X,
                      pointOnPlane.m_Y + planeRatio.m_Y,
                      pointOnPlane.m_Z + planeRatio.m_Z);
}
//------------------------------------------------------------------------------
bool E_Collisions::IsPointInSphere(const E_Vector3D& point,
                                   const E_Vector3D& sphereOrigin,
                                   const float&      sphereRadius)
{
    // calculate the distance between test point and the center of the sphere
    E_Vector3D length   = point - sphereOrigin;
    float      distance = E_Maths::Vec3Length(length);

    // check if distance is shorter than the radius of the sphere and return
    // result
    return (distance <= sphereRadius);
}
//------------------------------------------------------------------------------
bool E_Collisions::IsPointInTriangle(const E_Vector3D& point,
                                     const E_Polygon&  polygon)
{
    // here we check if the point P is inside the polygon
    //
    //              Collision                 No collision
    //                  V1                         V1
    //                  /\                         /\
    //                 /  \                       /  \
    //                / *P \                  *P /    \
    //               /      \                   /      \
    //            V2 -------- V3             V2 -------- V3
    //
    // calculate the segments between the P point and each vertices of the
    // polygon and we normalize this segment. For that we uses the following
    // algorithms
    // PToV1 = Polygon.Vertex1 - Point;
    // PToV2 = Polygon.Vertex2 - Point;
    // PToV3 = Polygon.Vertex3 - Point;
    E_Vector3D nPToV1 = E_Maths::Vec3Normalize(polygon.GetVertex1() - point);
    E_Vector3D nPToV2 = E_Maths::Vec3Normalize(polygon.GetVertex2() - point);
    E_Vector3D nPToV3 = E_Maths::Vec3Normalize(polygon.GetVertex3() - point);

    // calculate the angles using the scalar product of each vectors. We use
    // the following algorythms:
    // A1 = NPToV1.x * NPToV2.x + NPToV1.y * NPToV2.y + NPToV1.z * NPToV2.z
    // A2 = NPToV2.x * NPToV3.x + NPToV2.y * NPToV3.y + NPToV2.z * NPToV3.z
    // A3 = NPToV3.x * NPToV1.x + NPToV3.y * NPToV1.y + NPToV3.z * NPToV1.z
    float a1 = E_Maths::Vec3Dot(nPToV1, nPToV2);
    float a2 = E_Maths::Vec3Dot(nPToV2, nPToV3);
    float a3 = E_Maths::Vec3Dot(nPToV3, nPToV1);

    // calculate the sum of all angles
    float angleResult = (float)acosf(a1) + (float)acosf(a2) + (float)acosf(a3);

    // if the sum is equal to 360, then P is inside the polygon
    return (angleResult >= 6.28f);
}
//------------------------------------------------------------------------------
E_Vector3D E_Collisions::ClosestPointOnLine(const E_Vector3D& segStart,
                                            const E_Vector3D& segEnd,
                                            const E_Vector3D& point)
{
    // calculate the distance between the test point and the segment 
    E_Vector3D PToStart  = point  - segStart;
    E_Vector3D length    = segEnd - segStart;
    float      segLength = E_Maths::Vec3Length(length);

    // calculate the direction of the segment
    E_Vector3D normalizedLength = E_Maths::Vec3Normalize(length);

    // calculate the projection of the point on the segment
    float angle = E_Maths::Vec3Dot(normalizedLength, PToStart);

    // check if projection is before the segment
    if (angle < 0.0f)
        return segStart;
    else
    // check if projection is after the segment
    if (angle > segLength)
        return segEnd;
    else
    {
        // calculate the position of the projection on the segment
        E_Vector3D p(normalizedLength.m_X * angle,
                     normalizedLength.m_Y * angle,
                     normalizedLength.m_Z * angle);

        // calculate and returns the point coordinate on the segment
        return (segStart + p);
    }
}
//------------------------------------------------------------------------------
E_Vector3D E_Collisions::ClosestPointOnTriangle(const E_Vector3D& point,
                                                const E_Polygon&  polygon)
{
    // calculate the projections points on each edge of the triangle
    E_Vector3D rab = ClosestPointOnLine(polygon.GetVertex1(),
                                        polygon.GetVertex2(),
                                        point);
    E_Vector3D rbc = ClosestPointOnLine(polygon.GetVertex2(),
                                        polygon.GetVertex3(),
                                        point);
    E_Vector3D rca = ClosestPointOnLine(polygon.GetVertex3(),
                                        polygon.GetVertex1(),
                                        point);

    // calculate the distances between points below and test point
    E_Vector3D vAB = point - rab;
    E_Vector3D vBC = point - rbc;
    E_Vector3D vCA = point - rca;

    // calculate the length of each segments
    float dAB = E_Maths::Vec3Length(vAB);
    float dBC = E_Maths::Vec3Length(vBC);
    float dCA = E_Maths::Vec3Length(vCA);

    // calculate the shortest distance
    float min = dAB;

    E_Vector3D result = rab;

    // check if dBC is shortest
    if (dBC < min)
    {
        min    = dBC;
        result = rbc;
    }

    // check if dCA is shortest
    if (dCA < min)
        result = rca;

    return result;
}
//------------------------------------------------------------------------------
float E_Collisions::GetDistanceToPlane(const E_Plane&    plane,
                                       const E_Vector3D& point)
{
    // get the normal of the plane
    E_Vector3D n(plane.m_A, plane.m_B, plane.m_C);

    // calculate the distance between the plane and the point
    return E_Maths::Vec3Dot(n, point) + plane.m_D;
}
//------------------------------------------------------------------------------
