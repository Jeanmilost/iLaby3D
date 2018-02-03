/*****************************************************************************
 * ==> E_Maths --------------------------------------------------------------*
 * ***************************************************************************
 * Description : Basic mathematics for 3D engine                             *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Maths.h"
#include <math.h>
#include <memory>

//------------------------------------------------------------------------------
// Class E_Vector2D - c++ class
//------------------------------------------------------------------------------
E_Vector2D::E_Vector2D()
{
    // initialize memory
    std::memset(this, 0, sizeof(*this));
}
//------------------------------------------------------------------------------
E_Vector2D::E_Vector2D(float x, float y)
{
    m_X = x;
    m_Y = y;
}
//------------------------------------------------------------------------------
E_Vector2D E_Vector2D::operator + (const E_Vector2D& other) const
{
    return E_Vector2D(m_X + other.m_X, m_Y + other.m_Y);
}
//------------------------------------------------------------------------------
E_Vector2D E_Vector2D::operator - () const
{
    return E_Vector2D(-m_X, -m_Y);
}
//------------------------------------------------------------------------------
E_Vector2D E_Vector2D::operator - (const E_Vector2D& other) const
{
    return E_Vector2D(m_X - other.m_X, m_Y - other.m_Y);
}
//------------------------------------------------------------------------------
const E_Vector2D& E_Vector2D::operator += (const E_Vector2D& other)
{
    m_X += other.m_X;
    m_Y += other.m_Y;
	
    return *this;
}
//------------------------------------------------------------------------------
const E_Vector2D& E_Vector2D::operator -= (const E_Vector2D& other)
{
    m_X -= other.m_X;
    m_Y -= other.m_Y;
	
    return *this;
}
//------------------------------------------------------------------------------
bool E_Vector2D::operator == (const E_Vector2D& other) const
{
    return ((m_X == other.m_X) && (m_Y == other.m_Y));
}
//------------------------------------------------------------------------------
bool E_Vector2D::operator != (const E_Vector2D& other) const
{
    return ((m_X != other.m_X) || (m_Y != other.m_Y));
}
//------------------------------------------------------------------------------
// Class E_Vector3D - c++ class
//------------------------------------------------------------------------------
E_Vector3D::E_Vector3D()
{
    // initialize memory
    std::memset(this, 0, sizeof(*this));
}
//------------------------------------------------------------------------------
E_Vector3D::E_Vector3D(float x, float y, float z)
{
    m_X = x;
    m_Y = y;
    m_Z = z;
}
//------------------------------------------------------------------------------
E_Vector3D E_Vector3D::operator + (const E_Vector3D& other) const
{
    return E_Vector3D(m_X + other.m_X, m_Y + other.m_Y, m_Z + other.m_Z);
}
//------------------------------------------------------------------------------
E_Vector3D E_Vector3D::operator - () const
{
    return E_Vector3D(-m_X, -m_Y, -m_Z);
}
//------------------------------------------------------------------------------
E_Vector3D E_Vector3D::operator - (const E_Vector3D& other) const
{
    return E_Vector3D(m_X - other.m_X, m_Y - other.m_Y, m_Z - other.m_Z);
}
//------------------------------------------------------------------------------
const E_Vector3D& E_Vector3D::operator += (const E_Vector3D& other)
{
    m_X += other.m_X;
    m_Y += other.m_Y;
    m_Z += other.m_Z;

    return *this;
}
//------------------------------------------------------------------------------
const E_Vector3D& E_Vector3D::operator -= (const E_Vector3D& other)
{
    m_X -= other.m_X;
    m_Y -= other.m_Y;
    m_Z -= other.m_Z;

    return *this;
}
//------------------------------------------------------------------------------
bool E_Vector3D::operator == (const E_Vector3D& other) const
{
    return ((m_X == other.m_X) && (m_Y == other.m_Y) && (m_Z == other.m_Z));
}
//------------------------------------------------------------------------------
bool E_Vector3D::operator != (const E_Vector3D& other) const
{
    return ((m_X != other.m_X) || (m_Y != other.m_Y) || (m_Z != other.m_Z));
}
//------------------------------------------------------------------------------
// Class E_Plane - c++ class
//------------------------------------------------------------------------------
E_Plane::E_Plane()
{
    // initialize memory
    std::memset(this, 0, sizeof(*this));
}
//------------------------------------------------------------------------------
E_Plane::E_Plane(float a, float b, float c, float d)
{
    m_A = a;
    m_B = b;
    m_C = c;
    m_D = d;
}
//------------------------------------------------------------------------------
E_Plane E_Plane::operator - () const
{
    return E_Plane(-m_A, -m_B, -m_C, -m_D);
}
//------------------------------------------------------------------------------
bool E_Plane::operator == (const E_Plane& other) const
{
    return ((m_A == other.m_A) &&
            (m_B == other.m_B) &&
            (m_C == other.m_C) &&
            (m_D == other.m_D));
}
//------------------------------------------------------------------------------
bool E_Plane::operator != (const E_Plane& other) const
{
    return ((m_A != other.m_A) ||
            (m_B != other.m_B) ||
            (m_C != other.m_C) ||
            (m_D != other.m_D));
}
//------------------------------------------------------------------------------
// Class E_Matrix16 - c++ class
//------------------------------------------------------------------------------
E_Matrix16::E_Matrix16()
{
    // initialize memory
    std::memset(this, 0, sizeof(*this));
}
//------------------------------------------------------------------------------
E_Matrix16::E_Matrix16(float _11, float _12, float _13, float _14,
                       float _21, float _22, float _23, float _24,
                       float _31, float _32, float _33, float _34,
                       float _41, float _42, float _43, float _44)
{
    m_Table[0][0] = _11;
    m_Table[0][1] = _12;
    m_Table[0][2] = _13;
    m_Table[0][3] = _14;
    m_Table[1][0] = _21;
    m_Table[1][1] = _22;
    m_Table[1][2] = _23;
    m_Table[1][3] = _24;
    m_Table[2][0] = _31;
    m_Table[2][1] = _32;
    m_Table[2][2] = _33;
    m_Table[2][3] = _34;
    m_Table[3][0] = _41;
    m_Table[3][1] = _42;
    m_Table[3][2] = _43;
    m_Table[3][3] = _44;
}
//------------------------------------------------------------------------------
// Class E_Maths - c++ class
//------------------------------------------------------------------------------
float E_Maths::Vec3Length(const E_Vector3D& vector)
{
    return sqrt((vector.m_X * vector.m_X) +
                (vector.m_Y * vector.m_Y) +
                (vector.m_Z * vector.m_Z));
}
//------------------------------------------------------------------------------
E_Vector3D E_Maths::Vec3Normalize(const E_Vector3D& vector)
{
    float len = Vec3Length(vector);

    return E_Vector3D((vector.m_X / len),
                      (vector.m_Y / len),
                      (vector.m_Z / len));
}
//------------------------------------------------------------------------------
E_Vector3D E_Maths::Vec3Cross(const E_Vector3D& v1, const E_Vector3D& v2)
{
    return E_Vector3D((v1.m_Y * v2.m_Z) - (v2.m_Y * v1.m_Z),
                      (v1.m_Z * v2.m_X) - (v2.m_Z * v1.m_X),
                      (v1.m_X * v2.m_Y) - (v2.m_X * v1.m_Y));
}
//------------------------------------------------------------------------------
float E_Maths::Vec3Dot(const E_Vector3D& v1, const E_Vector3D& v2)
{
    return ((v1.m_X * v2.m_X) + (v1.m_Y * v2.m_Y) + (v1.m_Z * v2.m_Z));
}
//------------------------------------------------------------------------------
E_Plane E_Maths::PlaneFromPoints(const E_Vector3D& v1,
                                 const E_Vector3D& v2,
                                 const E_Vector3D& v3)
{
    // calculate edge vectors
    E_Vector3D e1 = v2 - v1;
    E_Vector3D e2 = v3 - v1;

    // calculate the normal of the plane
    E_Vector3D normal = Vec3Normalize(Vec3Cross(e1, e2));

    // calculate and return the plane
    return PlaneFromPointNormal(v1, normal);
}
//------------------------------------------------------------------------------
E_Plane E_Maths::PlaneFromPointNormal(const E_Vector3D& point,
                                      const E_Vector3D& normal)
{
    // the a, b, and c components are only the normal of the plane, and the D
    // component can be calculated using the aX + bY + cZ + d = 0 algorythm
    return E_Plane(normal.m_X,
                   normal.m_Y,
                   normal.m_Z,
                   -((normal.m_X * point.m_X) + (normal.m_Y * point.m_Y)
                           + (normal.m_Z * point.m_Z)));
}
//------------------------------------------------------------------------------
E_Vector3D E_Maths::PlaneIntersectLine(const E_Plane&    plane,
                                       const E_Vector3D& v1,
                                       const E_Vector3D& v2,
                                       bool&             coplanar)
{
    // gets the normal of the plane
    E_Vector3D normal(plane.m_A, plane.m_B, plane.m_C);

    // calculates the direction of the segment
    E_Vector3D direction(v2.m_X - v1.m_X,
                         v2.m_Y - v1.m_Y,
                         v2.m_Z - v1.m_Z);

    // calculates the angle between the segment and the normal
    float dot = E_Maths::Vec3Dot(normal, direction);

    // check if segment is coplanar and store result
    coplanar = !dot;

    if (coplanar)
        return E_Vector3D();
    else
    {
        float temp = (plane.m_D + E_Maths::Vec3Dot(normal, v1)) / dot;

        // calculate and returns the intersection point
        return E_Vector3D(v1.m_X - (temp * direction.m_X),
                          v1.m_Y - (temp * direction.m_Y),
                          v1.m_Z - (temp * direction.m_Z));
    }
}
//------------------------------------------------------------------------------
E_Vector3D E_Maths::Vec3TransformCoord(const E_Vector3D& vector,
                                       const E_Matrix16& matrix)
{
    // calculates x, y and z coordinates (don't use w component), and returns
    // transformed vector
    return E_Vector3D((vector.m_X * matrix.m_Table[0][0] +
                       vector.m_Y * matrix.m_Table[1][0] +
                       vector.m_Z * matrix.m_Table[2][0] +
                       matrix.m_Table[3][0]),
                      (vector.m_X * matrix.m_Table[0][1] +
                       vector.m_Y * matrix.m_Table[1][1] +
                       vector.m_Z * matrix.m_Table[2][1] +
                       matrix.m_Table[3][1]),
                      (vector.m_X * matrix.m_Table[0][2] +
                       vector.m_Y * matrix.m_Table[1][2] +
                       vector.m_Z * matrix.m_Table[2][2] +
                       matrix.m_Table[3][2]));
}
//------------------------------------------------------------------------------
bool E_Maths::ComparePlanes(const E_Plane& p1,
                            const E_Plane& p2,
                            const float&   tolerance)
{
    return (((p1.m_A >= (p2.m_A - tolerance))  &&
             (p1.m_A <= (p2.m_A + tolerance))) &&
            ((p1.m_B >= (p2.m_B - tolerance))  &&
             (p1.m_B <= (p2.m_B + tolerance))) &&
            ((p1.m_C >= (p2.m_C - tolerance))  &&
             (p1.m_C <= (p2.m_C + tolerance))) &&
            ((p1.m_D >= (p2.m_D - tolerance))  &&
             (p1.m_D <= (p2.m_D + tolerance))));
}
//------------------------------------------------------------------------------
