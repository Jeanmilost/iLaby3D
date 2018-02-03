/*****************************************************************************
 * ==> IP_SpriteBase --------------------------------------------------------*
 * ***************************************************************************
 * Description : Basic sprite class and protocol                             *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_SpriteBase.h"

//------------------------------------------------------------------------------
// class IP_SpriteBase - objective c
//------------------------------------------------------------------------------
@implementation IP_SpriteBase
//------------------------------------------------------------------------------
@synthesize m_Rotation;
@synthesize m_Angle;
@synthesize m_WorldMatrix;
@synthesize m_pPolygonList;
@synthesize m_pTexture;
//------------------------------------------------------------------------------
- (id)init
{
    m_pSpriteData  = NULL;
    m_pPolygonList = NULL;
    m_pTexture     = nil;
    m_Angle        = 0.0f;

    if (self = [super init])
        m_pPolygonList = new E_PolygonList();

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    if (m_pSpriteData)
    {
        delete[] m_pSpriteData;
        m_pSpriteData = NULL;
    }

    if (m_pPolygonList)
    {
        delete m_pPolygonList;
        m_pPolygonList = NULL;
    }

    if (m_pTexture)
        [m_pTexture release];

    [super dealloc];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
