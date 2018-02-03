/*****************************************************************************
 * ==> IP_Button ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Button class                                                *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import  "IP_Button.h"
#include "E_MemoryTools.h"
#import  "IP_Constants.h"

//------------------------------------------------------------------------------
// class IP_Button - objective c
//------------------------------------------------------------------------------
@implementation IP_Button
//------------------------------------------------------------------------------
@synthesize m_X;
@synthesize m_Y;
//------------------------------------------------------------------------------
- (id)init :(NSString*)pTextureName :(NSString*)pTextureExt
{
    m_pSprite  = nil;
    m_pTexture = nil;
    m_X        = 0.0f;
    m_Y        = 0.0f;

    if (self = [super init])
	{
		m_pTexture = [[IP_Texture alloc]init];
		[m_pTexture Load :pTextureName :pTextureExt];

        // create user control sprite
        m_pSprite = [[IP_2DSprite alloc]init];
        [m_pSprite Create :0.1f :0.1f];
        m_pSprite.m_pTexture = m_pTexture;
    }

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    if (m_pSprite != nil)
        [m_pSprite release];

    if (m_pTexture != nil)
        [m_pTexture release];

    [super dealloc];
}
//------------------------------------------------------------------------------
- (bool)IsClicked :(const CGPoint&)position;
{
    // convert button center position in finger position. Note that Y is increased of 3, because the first Y on-screen position is 3
    int      x    = (int)(((m_X + IP_Constants::m_iPhoneScreen_X) * IP_Constants::m_FingerScreen_X) / (IP_Constants::m_iPhoneScreen_X * 2));
    int      y    = 3 + (int)(((-m_Y + IP_Constants::m_iPhoneScreen_Y) * IP_Constants::m_FingerScreen_Y) / (IP_Constants::m_iPhoneScreen_Y * 2));
    unsigned size = 12;

    return (position.x >= x - size && position.x <= x + size && position.y >= y - size && position.y <= y + size);
}
//------------------------------------------------------------------------------
- (void)Render
{
    M_Assert(m_pTexture);
    M_Assert(m_pSprite);

    [m_pSprite Set :E_Vector2D(m_X, m_Y) :E_Vector3D(0.0f, 1.0f, 0.0f) :180.0f];
    [m_pSprite Render];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
