/*****************************************************************************
 * ==> Class E_PolygonList --------------------------------------------------*
 * ***************************************************************************
 * Description : List of polygons                                            *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Polygonlist.h"
#include <memory>

//------------------------------------------------------------------------------
// Class E_PolygonContainer - c++ class
//------------------------------------------------------------------------------
E_PolygonContainer::E_PolygonContainer()
{
    // initialize memory
    m_pPolygon = NULL;
    m_pNext    = NULL;
}
//------------------------------------------------------------------------------
E_PolygonContainer::~E_PolygonContainer()
{
    // cleanup resource used by the polygon
    if (m_pPolygon != NULL)
    {
        delete m_pPolygon;
        m_pPolygon = NULL;
    }
}
//------------------------------------------------------------------------------
E_Polygon* E_PolygonContainer::GetPolygon()
{
    return m_pPolygon;
}
//------------------------------------------------------------------------------
void E_PolygonContainer::SetPolygon(E_Polygon* pPolygon)
{
    m_pPolygon = pPolygon;
}
//------------------------------------------------------------------------------
E_PolygonContainer* E_PolygonContainer::GetNext()
{
    return m_pNext;
}
//------------------------------------------------------------------------------
void E_PolygonContainer::SetNext(E_PolygonContainer* pNext)
{
    m_pNext = pNext;
}
//------------------------------------------------------------------------------
// Class E_PolygonList - c++ class
//------------------------------------------------------------------------------
E_PolygonList::E_PolygonList()
{
    m_pFirst        = NULL;
    m_pCurrent      = NULL;
    m_PolygonCount = 0;
}
//------------------------------------------------------------------------------
E_PolygonList::~E_PolygonList()
{
    m_pCurrent = m_pFirst;

    // release all objects in the list
    while (m_pCurrent != NULL)
    {
        E_PolygonContainer* p_Tmp = m_pCurrent->GetNext();
        delete m_pCurrent;
        m_pCurrent = p_Tmp;
    }

    m_pFirst   = NULL;
    m_pCurrent = NULL;
}
//------------------------------------------------------------------------------
bool E_PolygonList::AddPolygon(E_Polygon* pPolygon)
{
    try
    {
        // check if object is valid
        if (pPolygon == NULL)
            // if not, returns false
            return false;

        // create new polygon container
        std::auto_ptr<E_PolygonContainer> pNew(new E_PolygonContainer());

        // allocate pointer in the newly created node
        pNew->SetPolygon(pPolygon);

        // check if first node already exists
        if (m_pFirst == NULL )
        {
            // if not, set new container as first container of the list, and
            // set current pointer on the first container of the list
            m_pFirst   = pNew.release();
            m_pCurrent = m_pFirst;
        }
        else
        {
            // if yes, add the new container at the end of the list. First, we
            // reset the current pointer on the first container of the list
            m_pCurrent = m_pFirst;

            // iterate through the list to find the last node
            while (m_pCurrent->GetNext() != NULL )
                // get next object
                m_pCurrent = m_pCurrent->GetNext();

            // now m_pCurrent contains the pointer to the last node. Set the
            // next pointer of the last object to the new created node
            m_pCurrent->SetNext(pNew.release());
        }

        // increment polygon counter
        ++m_PolygonCount;

        // returns success
        return true;
    }
    catch (...)
    {
        return false;
    }
}
//------------------------------------------------------------------------------
bool E_PolygonList::AddPolygon(const E_Vector3D& v1,
                               const E_Vector3D& v2,
                               const E_Vector3D& v3)
{
    try
    {
        // creates new polygon
        std::auto_ptr<E_Polygon> pPolygon(new E_Polygon(v1, v2, v3));

        // add new created polygon in the list
        return AddPolygon(pPolygon.release());
    }
    catch (...)
    {
        return false;
    }
}
//------------------------------------------------------------------------------
int E_PolygonList::GetCount()
{
    return m_PolygonCount;
}
//------------------------------------------------------------------------------
E_PolygonContainer* E_PolygonList::GetFirst()
{
    return m_pFirst;
}
//------------------------------------------------------------------------------
