/*****************************************************************************
 * ==> Class E_PolygonList --------------------------------------------------*
 * ***************************************************************************
 * Description : List of polygons                                            *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_POLYGONLIST_H
#define E_POLYGONLIST_H

#include "E_Polygon.h"

/**
* Node for polygon list
*@author Jean-Milost Reymond
*/
class E_PolygonContainer
{
    public:
        /**
        * Constructor
        */
        E_PolygonContainer();

        /**
        * Destructor
        */
        ~E_PolygonContainer();

        /**
        * Gets polygon
        *@returns pointer to the polygon
        */
        E_Polygon* GetPolygon();

        /**
        * Sets polygon
        *@param - polygon to set
        */
        void SetPolygon(E_Polygon* pPolygon);

        /**
        * Gets next node
        *@returns next node
        */
        E_PolygonContainer* GetNext();

        /**
        * Sets next node
        *@param next - next node to add in the chain list
        */
        void SetNext(E_PolygonContainer* pNext);

    private:
        E_Polygon*          m_pPolygon; // pointer to the polygon
        E_PolygonContainer* m_pNext;    // pointer to the next node
};

/**
* Polygons chained list
*@author Jean-Milost Reymond
*/
class E_PolygonList
{
    public:
        /**
        * Constructor
        */
        E_PolygonList();

        /**
        * Destructor
        */
        ~E_PolygonList();

        /**
        * Adds a polygon in the list
        *@param pPolygon - polygon to add
        *@returns true if operation success, otherwise false
        *@note The value is managed and will be destroyed internally
        */
        bool AddPolygon(E_Polygon* Polygon);

        /**
        * Adds a polygon in the list
        *@param v1 - first vertex of the polygon
        *@param v2 - second vertex of the polygon
        *@param v3 - thrid vertex of the polygon
        *@returns true if operation success, otherwise false
        */
        bool AddPolygon(const E_Vector3D& v1,
                        const E_Vector3D& v2,
                        const E_Vector3D& v3);

        /**
        * Gets number of polygons in the list
        *@returns number of polygons in the list
        */
        int GetCount();

        /**
        * Gets first polygon of the list
        *@returns first polygon of the list
        */
        E_PolygonContainer* GetFirst();

    private:
        E_PolygonContainer* m_pFirst;       // first polygon of the list
        E_PolygonContainer* m_pCurrent;     // current polygon
        int                 m_PolygonCount; // numbers of polygons in the list
};

#endif // E_POLYGONLIST_H
