/*****************************************************************************
 * ==> E_Polygon ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Polygon class                                               *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Polygon.h"

//------------------------------------------------------------------------------
// Class E_Polygon - c++ class
//------------------------------------------------------------------------------
E_Polygon::E_Polygon()
{}
//------------------------------------------------------------------------------
E_Polygon::E_Polygon(const E_Vector3D& vertex1,
                     const E_Vector3D& vertex2,
                     const E_Vector3D& vertex3)
{
    m_Vertex[0] = vertex1;
    m_Vertex[1] = vertex2;
    m_Vertex[2] = vertex3;
}
//------------------------------------------------------------------------------
E_Polygon::~E_Polygon()
{}
//------------------------------------------------------------------------------
const E_Vector3D& E_Polygon::GetVertex(int index) const
{
    // we apply a binary mask of 3 (binary value 0011), to ensure that the user
    // can never exceed the bounds of the array of vertices. This is what we
    // call a circular array
    return m_Vertex[index & 3];
}
//------------------------------------------------------------------------------
void E_Polygon::SetVertex(int index, const E_Vector3D& vertex)
{
    // we apply a binary mask of 3 (binary value 0011), to ensure that the user
    // can never exceed the bounds of the array of vertices. This is what we
    // call a circular array
    m_Vertex[index & 3] = vertex;
}
//------------------------------------------------------------------------------
const E_Vector3D& E_Polygon::GetVertex1() const
{
    return m_Vertex[0];
}
//------------------------------------------------------------------------------
void E_Polygon::SetVertex1(const E_Vector3D& value)
{
    m_Vertex[0] = value;
}
//------------------------------------------------------------------------------
const E_Vector3D& E_Polygon::GetVertex2() const
{
    return m_Vertex[1];
}
//------------------------------------------------------------------------------
void E_Polygon::SetVertex2(const E_Vector3D& value)
{
    m_Vertex[1] = value;
}
//------------------------------------------------------------------------------
const E_Vector3D& E_Polygon::GetVertex3() const
{
    return m_Vertex[2];
}
//------------------------------------------------------------------------------
void E_Polygon::SetVertex3(const E_Vector3D& value)
{
    m_Vertex[2] = value;
}
//------------------------------------------------------------------------------
E_Plane E_Polygon::GetPlane() const
{
    // calculates the plane from the values of the 3 vertices of the polygon
    return E_Maths::PlaneFromPoints(m_Vertex[0], m_Vertex[1], m_Vertex[2]);
}
//------------------------------------------------------------------------------
E_Vector3D E_Polygon::GetCenter() const
{
    // calculates then returns the value of the midpoint of the polygon
    return E_Vector3D
            (((m_Vertex[0].m_X + m_Vertex[1].m_X + m_Vertex[2].m_X) / 3.0f),
             ((m_Vertex[0].m_Y + m_Vertex[1].m_Y + m_Vertex[2].m_Y) / 3.0f),
             ((m_Vertex[0].m_Z + m_Vertex[1].m_Z + m_Vertex[2].m_Z) / 3.0f));
}
//------------------------------------------------------------------------------
E_Polygon E_Polygon::GetClone() const
{
    // copies the polygon, then returns the copy
    return E_Polygon(m_Vertex[0], m_Vertex[1], m_Vertex[2]);
}
//------------------------------------------------------------------------------
E_Polygon E_Polygon::ApplyMatrix(const E_Matrix16& matrix) const
{
    // build a new polygon transforming all vertices of the polygon using
    // given matrix, and return new builded polygon
    return E_Polygon(E_Maths::Vec3TransformCoord(m_Vertex[0], matrix),
                     E_Maths::Vec3TransformCoord(m_Vertex[1], matrix),
                     E_Maths::Vec3TransformCoord(m_Vertex[2], matrix));
}
//------------------------------------------------------------------------------
