/*****************************************************************************
 * ==> IP_Door --------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a door                                           *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_Door.h"
#import "IP_CatchMacros.h"

//------------------------------------------------------------------------------
// class IP_Door - objective c
//------------------------------------------------------------------------------
@implementation IP_Door
//------------------------------------------------------------------------------
- (id)init
{
    m_Height = 0.0f;
    m_Open   = false;

    for (unsigned i = 0; i < M_Nb_Objects; ++i)
    {
        m_pTexture[i] = nil;
        m_pSprite[i]  = nil;
    }

    if (self = [super init])
    {
        // create doors textures
        for (unsigned i = 0; i < M_Nb_Objects; ++i)
            m_pTexture[i] = [[IP_Texture alloc]init];

        [m_pTexture[0] Load :@"Entry" :@"png"];
        [m_pTexture[1] Load :@"Exit_Closed" :@"png"];
        [m_pTexture[2] Load :@"Exit_Opened" :@"png"];

        // create doors sprites
        for (unsigned i = 0; i < M_Nb_Objects; ++i)
        {
            m_pSprite[i] = [[IP_Sprite alloc]init];
            [m_pSprite[i] Create :2.0f :2.0f];
            [m_pSprite[i] Set :E_Vector3D(-5.0f, 0.0f, -5.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
            m_pSprite[i].m_pTexture = m_pTexture[i];

            m_Position[i] = E_Vector3D(0.0f, 0.0f, 0.0f);
        }
    }

    return self;
}
//-----------------------------------------------------------------------------
- (void)dealloc
{
    for (unsigned i = 0; i < M_Nb_Objects; ++i)
    {
        if (m_pSprite[i] != nil)
            [m_pSprite[i] release];

        if (m_pTexture[i] != nil)
            [m_pTexture[i] release];
    }

    [super dealloc];
}
//------------------------------------------------------------------------------
- (const E_Vector3D&)GetEnterPosition
{
    return m_Position[0];
}
//------------------------------------------------------------------------------
- (void)SetEnterPosition :(const E_Vector3D&)position
{
    m_Position[0] = position;
}
//------------------------------------------------------------------------------
- (const E_Vector3D&)GetExitPosition
{
    return m_Position[2];
}
//------------------------------------------------------------------------------
- (void)SetExitPosition :(const E_Vector3D&)position
{
    m_Position[1] = position;
    m_Position[2] = position;
}
//------------------------------------------------------------------------------
- (bool)IsOpen
{
    return m_Open;
}
//------------------------------------------------------------------------------
- (void)SetOpen :(bool)value
{
    m_Open = value;
}
//------------------------------------------------------------------------------
- (bool)RenderDoor
{
    M_Try
    {
        m_Height += 0.1f;

        if (m_Height >= 360.0f)
            m_Height -= 360.0f;

        // draw doors
        for (unsigned i = 0; i < M_Nb_Objects; ++i)
        {
            // display ether open or close door, not the both
            if (m_Open && i == 1)
                continue;
            else
            if (!m_Open && i == 2)
                continue;

            if (m_pSprite[i])
            {
                [m_pSprite[i] Set :E_Vector3D(m_Position[i].m_X, 1.0f * cosf(m_Height), m_Position[i].m_Z)
                            :E_Vector3D(0.0f, 1.0f, 0.0f)
                            :180.0f - g_Player.m_Angle];
                [m_pSprite[i] Render];
            }
        }

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
