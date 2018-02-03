/*****************************************************************************
 * ==> E_Polygon ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Polygon class                                               *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_POLYGON_H
#define E_POLYGON_H

#include "E_Maths.h"

/*
* Class representing a polygon
*@author Jean-Milost Reymond
*/
class E_Polygon
{
    public:
        /**
        * Constructor
        */
        E_Polygon();

        /**
        * Constructor
        *@param vertex1 - first vertex of the polygon
        *@param vertex2 - second vertex of the polygon
        *@param vertex3 - thrid vertex of the polygon
        */
        E_Polygon(const E_Vector3D& vertex1,
                  const E_Vector3D& vertex2,
                  const E_Vector3D& vertex3);

        /**
        * Destructor
        */
        ~E_Polygon();

        /**
        * Gets vertex at the given index
        *@param index - index of the vertex
        *@returns corresponding vertex
        */
        const E_Vector3D& GetVertex(int index) const;

        /**
        * Sets vertex
        *@param index - index of the vertex to set
        *@param vertex - value of the vertex
        */
        void SetVertex(int index, const E_Vector3D& vertex);

        /**
        * Gets first vertex of the polygon
        *@returns first vertex of the polygon
        */
        const E_Vector3D& GetVertex1() const;

        /**
        * Sets first vertex of the polygon
        *@param value - value of the first vertex of the polygon
        */
        void SetVertex1(const E_Vector3D& value);

        /**
        * Gets second vertex of the polygon
        *@returns second vertex of the polygon
        */
        const E_Vector3D& GetVertex2() const;

        /**
        * Sets second vertex of the polygon
        *@param value - value of the second vertex of the polygon
        */
        void SetVertex2(const E_Vector3D& value);

        /**
        * Gets thrid vertex of the polygon
        *@returns thrid vertex of the polygon
        */
        const E_Vector3D& GetVertex3() const;

        /**
        * Sets thrid vertex of the polygon
        *@param value - value of the thrid vertex of the polygon
        */
        void SetVertex3(const E_Vector3D& value);

        /**
        * Gets the plane of the polygon
        *@returns the plane of the polygon
        */
        E_Plane GetPlane() const;

        /**
        * Calculates and returns the center point of the polygon
        *@returns the center point of the polygon
        */
        E_Vector3D GetCenter() const;

        /**
        * Creates and returns a clone of the polygon
        *@returns a clone of the polygon
        */
        E_Polygon GetClone() const;

        /**
        * Applies the given matrix to the polygon
        *@param matrix - matrix to apply
        *@returns transformed polygon
        */
        E_Polygon ApplyMatrix(const E_Matrix16& matrix) const;

    private:
        E_Vector3D m_Vertex[3]; // array of vertices of the polygon
};

#endif // E_POLYGON_H
