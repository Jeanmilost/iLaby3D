/*****************************************************************************
 * ==> IP_UserControl -------------------------------------------------------*
 * ***************************************************************************
 * Description : User control class                                          *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_UserControl.h"
#import "E_Exception.h"
#import "E_MemoryTools.h"

//------------------------------------------------------------------------------
// class IP_UserControl - objective c
//------------------------------------------------------------------------------
@implementation IP_UserControl
//------------------------------------------------------------------------------
- (id)init
{
    m_pSprite    = nil;
    m_pTexture   = nil;
    m_pBgSprite  = nil;
    m_pBgTexture = nil;

    if (self = [super init])
	{
		m_pTexture = [[IP_Texture alloc]init];
		[m_pTexture Load :@"User_Control" :@"png"];

		m_pBgTexture = [[IP_Texture alloc]init];
		[m_pBgTexture Load :@"Background_Control" :@"png"];

        // create user control sprite
        m_pSprite = [[IP_2DSprite alloc]init];
        [m_pSprite Create :0.1f :0.1f];
        m_pSprite.m_pTexture = m_pTexture;

        // create user control background sprite
        m_pBgSprite = [[IP_2DSprite alloc]init];
        [m_pBgSprite Create :0.35f :0.35];
        m_pBgSprite.m_pTexture = m_pBgTexture;

        // initialize the radius and default cursor position
        m_Radius   =  0.10f;
        m_DefaultX = -0.31f;
        m_DefaultY = -0.43f;

        // initialize default user control position
        [self ResetPosition];
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

    if (m_pBgSprite != nil)
        [m_pBgSprite release];

    if (m_pBgTexture != nil)
        [m_pBgTexture release];

    [super dealloc];
}
//------------------------------------------------------------------------------
- (void)ResetPosition
{
    m_Cursor.x = m_DefaultX;
    m_Cursor.y = m_DefaultY;
}
//------------------------------------------------------------------------------
- (void)SetPosition :(const CGPoint&)position
{
    // get and convert finger position in local coordinates
    m_Cursor.x = -((159.0f - position.x) * 0.62f) / 159.0f;
    m_Cursor.y =  ((239.0f - position.y) * 0.86f) / 239.0f;

    float angle;

    // calculate the angle formed by the x and y distances
    if ((m_Cursor.x < m_DefaultX || m_Cursor.y < m_DefaultY) && !(m_Cursor.x < m_DefaultX && m_Cursor.y < m_DefaultY))
        angle = -atanf((m_Cursor.y - m_DefaultY) / (m_Cursor.x - m_DefaultX));
    else
        angle =  atanf((m_Cursor.y - m_DefaultY) / (m_Cursor.x - m_DefaultX));

    // calculate the possible min and max values for each axis
    float minX = m_DefaultX - (cosf(angle) * m_Radius);
    float maxX = m_DefaultX + (cosf(angle) * m_Radius);
    float minY = m_DefaultY - (sinf(angle) * m_Radius);
    float maxY = m_DefaultY + (sinf(angle) * m_Radius);

    // limit the cursor in a radius distance
    if (m_Cursor.x > maxX)
        m_Cursor.x = maxX;
    else
    if (m_Cursor.x < minX)
        m_Cursor.x = minX;

    if (m_Cursor.y > maxY)
        m_Cursor.y = maxY;
    else
    if (m_Cursor.y < minY)
        m_Cursor.y = minY;
}
//------------------------------------------------------------------------------
- (float)UpdatePosVelocity :(const float&)velocity
{
    return ((velocity * (m_Cursor.y - m_DefaultY)) / m_DefaultY);
}
//------------------------------------------------------------------------------
- (float)UpdateDirVelocity :(const float&)velocity
{
    return (velocity * ((m_Cursor.x - m_DefaultX) / m_DefaultX));
}
//------------------------------------------------------------------------------
- (void)Render
{
    M_Assert(m_pTexture);
    M_Assert(m_pSprite);
    M_Assert(m_pBgTexture);
    M_Assert(m_pBgSprite);

    [m_pSprite Set :E_Vector2D(m_Cursor.x, m_Cursor.y) :E_Vector3D(0.0f, 1.0f, 0.0f) :180.0f];
    [m_pSprite Render];

    [m_pBgSprite Set :E_Vector2D(-0.31f, -0.43f) :E_Vector3D(0.0f, 1.0f, 0.0f) :180.0f];
    [m_pBgSprite Render];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
