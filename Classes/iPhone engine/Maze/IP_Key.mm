/*****************************************************************************
 * ==> IP_Key ---------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents the key of the maze                              *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_Key.h"
#import "IP_CatchMacros.h"

//------------------------------------------------------------------------------
// class IP_Key - objective c
//------------------------------------------------------------------------------
@implementation IP_Key
//------------------------------------------------------------------------------
- (id)init
{
    m_pTexture = nil;
    m_pKey     = nil;
    m_pMiniKey = nil;

    if (self = [super init])
    {
        m_pTexture = [[IP_Texture alloc]init];
        [m_pTexture Load :@"Key" :@"png"];

        m_pKey = [[IP_Sprite alloc]init];
        [m_pKey Create :2.0f :2.0f];
        [m_pKey Set :E_Vector3D(-5.0f, 0.0f, -5.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pKey.m_pTexture = m_pTexture;

        m_pMiniKey = [[IP_2DSprite alloc]init];
        [m_pMiniKey Create :0.1f :0.1f];
        [m_pMiniKey Set :E_Vector2D(-0.55f, 0.85f) :E_Vector3D(0.0f, 1.0f, 0.0f) :180.0f];
        m_pMiniKey.m_pTexture = m_pTexture;

        m_Height   = 0.0f;
        m_Position = E_Vector3D(0.0f, 0.0f, 0.0f);
        m_KeyFound = false;
    }

    return self;
}
//-----------------------------------------------------------------------------
- (void)dealloc
{
    if (m_pKey)
        [m_pKey release];

    if (m_pMiniKey)
        [m_pMiniKey release];

    if (m_pTexture)
        [m_pTexture release];

    [super dealloc];
}
//------------------------------------------------------------------------------
- (const E_Vector3D&)GetPosition
{
    return m_Position;
}
//------------------------------------------------------------------------------
- (void)SetPosition :(const E_Vector3D&)position
{
    m_Position = position;
}
//------------------------------------------------------------------------------
- (bool)IsKeyFound
{
    return m_KeyFound;
}
//------------------------------------------------------------------------------
- (void)SetKeyFound :(bool)value
{
    m_KeyFound = value;
}
//------------------------------------------------------------------------------
- (bool)RenderKey
{
    M_Try
    {
        if (!m_KeyFound)
        {
            if (m_pKey)
            {
                m_Height += 0.1f;

                if (m_Height >= 360.0f)
                    m_Height -= 360.0f;

                [m_pKey Set :E_Vector3D(m_Position.m_X, 1.0f * cosf(m_Height), m_Position.m_Z)
                            :E_Vector3D(0.0f, 1.0f, 0.0f)
                            :180.0f - g_Player.m_Angle];
                [m_pKey Render];
            }
        }
        else
        {
            if (m_pMiniKey)
                [m_pMiniKey Render];
        }

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
