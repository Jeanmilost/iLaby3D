/*****************************************************************************
 * ==> IP_Cell --------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a maze cell                                      *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_Cell.h"
#import "IP_CatchMacros.h"
#import "IP_StringTools.h"
#import "IP_MessageBox.h"
#include "E_MemoryTools.h"
#include "E_Collisions.h"
#include "E_Player.h"

#define M_Wall_Width  20.0f
#define M_Wall_Height 20.0f

//------------------------------------------------------------------------------
// class IP_Cell - objective c
//------------------------------------------------------------------------------
@implementation IP_Cell
//------------------------------------------------------------------------------
- (id)init
{
    m_pFloor   = nil;
    m_pCeiling = nil;
    m_pWall    = nil;

    if (self = [super init])
        m_pWall = [[NSMutableArray alloc]init];

    return self;
}
//-----------------------------------------------------------------------------
- (void)dealloc
{
    if (m_pFloor)
        [m_pFloor release];

    if (m_pCeiling)
        [m_pCeiling release];

    if (m_pWall)
        [m_pWall release];

    [super dealloc];
}
//------------------------------------------------------------------------------
- (void)SetWall :(IType)type :(const float&)x :(const float&)y :(IP_Texture*)pTexture
{
    M_Try
    {
        float posX = (M_Wall_Width * x);
        float posY = (M_Wall_Height * y);

        switch (type)
        {
            case IE_Soil:
            {
                IP_Sprite* m_pSprite = [[IP_Sprite alloc]init];
                [m_pSprite Create :M_Wall_Width :M_Wall_Height];
                [m_pSprite Set :E_Vector3D(-posX, -10.0f, -posY) :E_Vector3D(1.0f, 0.0f, 0.0f) :90.0f];
                m_pSprite.m_pTexture = pTexture;
                m_pFloor             = m_pSprite;
                break;
            }

            case IE_Wall_Top:
            {
                IP_Sprite* m_pSprite = [[[IP_Sprite alloc]init]autorelease];
                [m_pSprite Create :M_Wall_Width :M_Wall_Height];
                [m_pSprite Set :E_Vector3D(-posX, 0.0f, -(posY + 10.0f)) :E_Vector3D(0.0f, 1.0f, 0.0f) :180.0f];
                m_pSprite.m_pTexture = pTexture;
                [m_pWall insertObject:m_pSprite atIndex:[m_pWall count]];
                break;
            }

            case IE_Wall_Left:
            {
                IP_Sprite* m_pSprite = [[[IP_Sprite alloc]init]autorelease];
                [m_pSprite Create :M_Wall_Width :M_Wall_Height];
                [m_pSprite Set :E_Vector3D(-(posX + 10.0f), 0.0f, -posY) :E_Vector3D(0.0f, 1.0f, 0.0f) :-90.0f];
                m_pSprite.m_pTexture = pTexture;
                [m_pWall insertObject:m_pSprite atIndex:[m_pWall count]];
                break;
            }

            case IE_Wall_Bottom:
            {
                IP_Sprite* m_pSprite = [[[IP_Sprite alloc]init]autorelease];
                [m_pSprite Create :M_Wall_Width :M_Wall_Height];
                [m_pSprite Set :E_Vector3D(-posX, 0.0f, -(posY - 10.0f)) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
                m_pSprite.m_pTexture = pTexture;
                [m_pWall insertObject:m_pSprite atIndex:[m_pWall count]];
                break;
            }

            case IE_Wall_Right:
            {
                IP_Sprite* m_pSprite = [[[IP_Sprite alloc]init]autorelease];
                [m_pSprite Create :M_Wall_Width :M_Wall_Height];
                [m_pSprite Set :E_Vector3D(-(posX - 10.0f), 0.0f, -posY) :E_Vector3D(0.0f, 1.0f, 0.0f) :90.0f];
                m_pSprite.m_pTexture = pTexture;
                [m_pWall insertObject:m_pSprite atIndex:[m_pWall count]];
                break;
            }
                
            case IE_Ceiling:
            {
                IP_Sprite* m_pSprite = [[IP_Sprite alloc]init];
                [m_pSprite Create :M_Wall_Width :M_Wall_Height];
                [m_pSprite Set :E_Vector3D(-posX, 10.0f, -posY) :E_Vector3D(1.0f, 0.0f, 0.0f) :-90.0f];
                m_pSprite.m_pTexture = pTexture;
                m_pCeiling           = m_pSprite;
                break;
            }

            default:
                M_THROW_EXCEPTION("Unknown sprite type")
        }
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (bool)CheckCollisions :(const E_Vector3D&)nextPosition :(std::vector<E_Plane>&)planes
{
    M_Try
    {
        E_Plane plane;
        bool    collision;
        bool    multipleCollisions;

        // iterate through all walls of the cell and check if next position is in collision
        for (unsigned i = 0; i < [m_pWall count]; ++i)
        {
            g_Player.ValidateNextPosition(nextPosition,
                                          [[m_pWall objectAtIndex:i]m_pPolygonList],
                                          [[m_pWall objectAtIndex:i]m_WorldMatrix],
                                          collision,
                                          multipleCollisions,
                                          plane);

            if (collision)
                planes.push_back(plane);
        }

        return true;
    }
    M_CatchSilent

    return false;
}
//------------------------------------------------------------------------------
- (bool)IsClipped :(const E_Plane&)clippingPlane :(const E_Matrix16&)worldMatrix :(E_PolygonList*)pPolygonList
{
    M_Assert(pPolygonList);

    E_PolygonContainer* pCurrentPolygon = pPolygonList->GetFirst();	
    M_Assert(pCurrentPolygon);

    // iterate through all polygons contined in the sprite
    while (pCurrentPolygon != NULL)
    {
        E_Polygon* pPolygon = pCurrentPolygon->GetPolygon();
        M_Assert(pPolygon);

        E_Polygon testPolygon = pPolygon->ApplyMatrix(worldMatrix);

        for (unsigned i = 0; i < 3; ++i)
            if (E_Collisions::GetDistanceToPlane(clippingPlane, testPolygon.GetVertex(i)) >= 0.0f)
                return false;

        // go to next polygon
        pCurrentPolygon = pCurrentPolygon->GetNext();
    }

    return true;
}
//------------------------------------------------------------------------------
- (bool)RenderCell
{
    M_Try
    {
        // draw floor, ceiling and walls
        for (unsigned i = 0; i < [m_pWall count]; ++i)
            [[m_pWall objectAtIndex:i]Render];

        if (m_pFloor)
            [m_pFloor Render];

        if (m_pCeiling)
            [m_pCeiling Render];

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (bool)RenderCell :(const E_Plane&)nearClippingPlane :(const E_Plane&)farClippingPlane :(const E_Plane&)rightClippingPlane
        :(const E_Plane&)leftClippingPlane
{
    M_Try
    {
        // draw floor, ceiling and walls
        for (unsigned i = 0; i < [m_pWall count]; ++i)
            if (![self IsClipped :nearClippingPlane :[[m_pWall objectAtIndex:i]m_WorldMatrix] :[[m_pWall objectAtIndex:i]m_pPolygonList]]
                    && ![self IsClipped :farClippingPlane :[[m_pWall objectAtIndex:i]m_WorldMatrix] :[[m_pWall objectAtIndex:i]m_pPolygonList]]
                    && ![self IsClipped :rightClippingPlane :[[m_pWall objectAtIndex:i]m_WorldMatrix] :[[m_pWall objectAtIndex:i]m_pPolygonList]]
                    && ![self IsClipped :leftClippingPlane :[[m_pWall objectAtIndex:i]m_WorldMatrix] :[[m_pWall objectAtIndex:i]m_pPolygonList]])
                [[m_pWall objectAtIndex:i]Render];

        if (m_pFloor)
            if (![self IsClipped :nearClippingPlane :m_pFloor.m_WorldMatrix :m_pFloor.m_pPolygonList]
                    && ![self IsClipped :farClippingPlane :m_pFloor.m_WorldMatrix :m_pFloor.m_pPolygonList])
                [m_pFloor Render];

        if (m_pCeiling)
            if (![self IsClipped :nearClippingPlane :m_pCeiling.m_WorldMatrix :m_pCeiling.m_pPolygonList]
                    && ![self IsClipped :farClippingPlane :m_pCeiling.m_WorldMatrix :m_pCeiling.m_pPolygonList])
                [m_pCeiling Render];

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
