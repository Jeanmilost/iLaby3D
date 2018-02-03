/*****************************************************************************
 * ==> E_Maths --------------------------------------------------------------*
 * ***************************************************************************
 * Description : Basic mathematics for 3D engine                             *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_MATHS_H
#define E_MATHS_H

/**
* Vector 2D
*@author Jean-Milost Reymond
*/
class E_Vector2D
{
    public:
        float m_X; // x coordinate for the 3D vector
        float m_Y; // y coordinate for the 3D vector

        /**
		* Constructor
		*/
        E_Vector2D();

        /**
		* Constructor
		*@param x - vector x value
		*@param y - vector y value
		*/
        E_Vector2D(float x, float y);

        /**
		* Operator +
		*@param other - other vector to add
		*@returns resulting added vector
		*/
        E_Vector2D operator + (const E_Vector2D& other) const;

        /**
        * Operator -
        *@returns inverted vector
        */
        E_Vector2D operator - () const;

        /**
		* Operator -
		*@param other - other vector to substract
		*@returns resulting substracted vector
		*/
        E_Vector2D operator - (const E_Vector2D& other) const;

        /**
		* Operator +=
		*@param other - other vector to add
		*@returns resulting added vector
		*/
        const E_Vector2D& operator += (const E_Vector2D& other);

        /**
		* Operator -=
		*@param other - other vector to substract
		*@returns resulting substracted vector
		*/
        const E_Vector2D& operator -= (const E_Vector2D& other);

        /**
		* Operator ==
		*@param other - other vector to compare
		*@returns true if vectors are identical, otherwise false
		*/
        bool operator == (const E_Vector2D& other) const;

        /**
		* Operator !=
		*@param other - other vector to compare
		*@returns true if vectors are not identical, otherwise false
		*/
        bool operator != (const E_Vector2D& other) const;
};

/**
* Vector 3D
*@author Jean-Milost Reymond
*/
class E_Vector3D
{
    public:
        float m_X; // x coordinate for the 3D vector
        float m_Y; // y coordinate for the 3D vector
        float m_Z; // z coordinate for the 3D vector

        /**
        * Constructor
        */
        E_Vector3D();

        /**
        * Constructor
        *@param x - vector x value
        *@param y - vector y value
        *@param z - vector z value
        */
        E_Vector3D(float x, float y, float z);

        /**
        * Operator +
        *@param other - other vector to add
        *@returns resulting added vector
        */
        E_Vector3D operator + (const E_Vector3D& other) const;

        /**
        * Operator -
        *@returns inverted vector
        */
        E_Vector3D operator - () const;

        /**
        * Operator -
        *@param other - other vector to substract
        *@returns resulting substracted vector
        */
        E_Vector3D operator - (const E_Vector3D& other) const;

        /**
        * Operator +=
        *@param other - other vector to add
        *@returns resulting added vector
        */
        const E_Vector3D& operator += (const E_Vector3D& other);

        /**
        * Operator -=
        *@param other - other vector to substract
        *@returns resulting substracted vector
        */
        const E_Vector3D& operator -= (const E_Vector3D& other);

        /**
        * Operator ==
        *@param other - other vector to compare
        *@returns true if vectors are identical, otherwise false
        */
        bool operator == (const E_Vector3D& other) const;

        /**
        * Operator !=
        *@param other - other vector to compare
        *@returns true if vectors are not identical, otherwise false
        */
        bool operator != (const E_Vector3D& other) const;
};

/**
* Plane
*@author Jean-Milost Reymond
*/
class E_Plane
{
    public:
        float m_A; // a coordinate for the plane
        float m_B; // b coordinate for the plane
        float m_C; // c coordinate for the plane
        float m_D; // d coordinate for the plane

        /**
        * Constructor
        */
        E_Plane();

        /**
        * Constructor
        *@param a - a coordinate
        *@param b - b coordinate
        *@param c - c coordinate
        *@param d - d coordinate
        */
        E_Plane(float a, float b, float c, float d);

        /**
        * Operator -
        *@returns inverted plane
        */
        E_Plane operator - () const;

        /**
        * Operator ==
        *@param other - other plane to compare
        *@returns true if planes are identical, otherwise false
        */
        bool operator == (const E_Plane& other) const;

        /**
        * Operator !=
        *@param other - other plane to compare
        *@returns true if planes are not identical, otherwise false
        */
        bool operator != (const E_Plane& other) const;
};

/**
* 4x4 matrix
*@author Jean-Milost Reymond
*/
class E_Matrix16
{
    public:
        float m_Table[4][4]; // 4x4 matrix array

        /**
        * Constructor
        */
        E_Matrix16();

        /**
        * Constructor
        *@param _11 - matrix value
        *@param _12 - matrix value
        *@param _13 - matrix value
        *@param _14 - matrix value
        *@param _21 - matrix value
        *@param _22 - matrix value
        *@param _23 - matrix value
        *@param _24 - matrix value
        *@param _31 - matrix value
        *@param _32 - matrix value
        *@param _33 - matrix value
        *@param _34 - matrix value
        *@param _41 - matrix value
        *@param _42 - matrix value
        *@param _43 - matrix value
        *@param _44 - matrix value
        */
        E_Matrix16(float _11, float _12, float _13, float _14,
                   float _21, float _22, float _23, float _24,
                   float _31, float _32, float _33, float _34,
                   float _41, float _42, float _43, float _44);
};

/**
* Basic geometrical mathematics class
*@author Jean-Milost Reymond
*/
class E_Maths
{
    public:
        /**
        * Calculates the length of a vector
        *@param vector - vector for which the length must be calculated
        *@returns the length of the given vector
        */
        static float Vec3Length(const E_Vector3D& vector);

        /**
        * Normalizes a vector
        *@param vector - vector to normalize
        *@returns normalized vector
        */
        static E_Vector3D Vec3Normalize(const E_Vector3D& vector);

        /**
        * Calculates the cross product between 2 vectors
        *@param v1 - first vector for which cross product must be calculated
        *@param v2 - second vector for which cross product must be calculated
        *@returns cross product
        */
        static E_Vector3D Vec3Cross(const E_Vector3D& v1, const E_Vector3D& v2);

        /**
        * Calculates the dot product between 2 vectors
        *@param v1 - first vector for which dot product must be calculated
        *@param v2 - second vector for which dot product must be calculated
        *@returns dot product
        */
        static float Vec3Dot(const E_Vector3D& v1, const E_Vector3D& v2);

        /**
        * Calculates a plane using 3 vertex
        *@param v1 - value of the first vertex
        *@param v2 - value of the second vertex
        *@param v3 - value of the thrid vertex
        *@returns the builded plane
        */
        static E_Plane PlaneFromPoints(const E_Vector3D& v1,
                                       const E_Vector3D& v2,
                                       const E_Vector3D& v3);

        /**
        * Calculates a plane using a point and a normal
        *@param point - a point belongs to the plane
        *@param normal - normal of the plane
        *@returns the builded plane
        */
        static E_Plane PlaneFromPointNormal(const E_Vector3D& point,
                                            const E_Vector3D& normal);

        /**
        * Calculates the point who a given line intersect a given plane
        *@param plane - given plane
        *@param v1 - start of the segment
        *@param v2 - end of the segment
        *@param[out] coplanar - if true, the line is coplanar
        *@returns the calculated point
        */
        static E_Vector3D PlaneIntersectLine(const E_Plane&    plane,
                                             const E_Vector3D& v1,
                                             const E_Vector3D& v2,
                                             bool&             coplanar);

        /**
        * Applies a transformation matrix to a vector
        *@param vector - vector to transform
        *@param matrix - transformation matrix
        *@returns transformed vector
        */
        static E_Vector3D Vec3TransformCoord(const E_Vector3D& vector,
                                             const E_Matrix16& matrix);

        /**
        * Compare the given planes using the given tolerance
        *@param p1 - first plane to compare
        *@param p2 - second plane to compare
        *@param tolerance - tolerance for comparison
        *@returns true if planes are equals in the limits of the given tolerance, otherwise false
        */
        static bool ComparePlanes(const E_Plane& p1,
                                  const E_Plane& p2,
                                  const float&   tolerance);
};

#endif
