/*****************************************************************************
 * ==> IP_2DSprite ----------------------------------------------------------*
 * ***************************************************************************
 * Description : Special sprite that always in 2D coordinates system         *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_2DSprite.h"
#import "E_Exception.h"
#import "E_MemoryTools.h"
#import "E_Player.h"
#import "IP_OpenGLHelper.h"
#import <memory>

//------------------------------------------------------------------------------
// struct IP_2DObject - c++
//------------------------------------------------------------------------------
const GLfloat IP_2DObject::m_Vertices[] =
{
	-1.0f,  1.0f,
     1.0f,  1.0f,
    -1.0f, -1.0f,
     1.0f, -1.0f,
};
//------------------------------------------------------------------------------
const GLfloat IP_2DObject::m_TextureCoords[] =
{
	1.0, 0.0,
	0.0, 0.0,
	1.0, 1.0,
	0.0, 1.0,
};
//------------------------------------------------------------------------------
// class IP_2DSprite - objective c
//------------------------------------------------------------------------------
@implementation IP_2DSprite
//------------------------------------------------------------------------------
@synthesize m_Position;
@synthesize m_Deep;
//------------------------------------------------------------------------------
- (id)init
{
    if (self = [super init])
	{}

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [super dealloc];
}
//------------------------------------------------------------------------------
- (void)Create :(const float&)width :(const float&)height
{
    unsigned verticesSize = M_CountOf(IP_2DObject::m_Vertices);
    m_pSpriteData         = new GLfloat[verticesSize];

    for (unsigned i = 0; i < verticesSize / 2; ++i)
    {
        m_pSpriteData[2 * i]       = IP_2DObject::m_Vertices[2 * i] * width / 2.0f;
        m_pSpriteData[(2 * i) + 1] = IP_2DObject::m_Vertices[(2 * i) + 1] * height / 2.0f;
    }
}
//------------------------------------------------------------------------------
- (void)Set :(const E_Vector2D&)position :(const E_Vector3D&)rotation :(const float&)angle
{
    m_Position = position;
	m_Rotation = rotation;
	m_Angle    = angle;
}
//------------------------------------------------------------------------------
- (void)Render
{
    M_Assert(m_pSpriteData);
    M_Assert(m_pTexture);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

	// set vertex buffer of the object
    glVertexPointer(2, GL_FLOAT, 0, m_pSpriteData);
    glEnableClientState(GL_VERTEX_ARRAY);

    // set texture coordinates buffer
    glTexCoordPointer(2, GL_FLOAT, 0, IP_2DObject::m_TextureCoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    [m_pTexture Render];

    // set position of the object in the 3D world
    glRotatef(g_Player.m_Angle, g_Player.m_Rotation.m_X, g_Player.m_Rotation.m_Y, g_Player.m_Rotation.m_Z);
    glTranslatef(-((1.0f - m_Deep) * ((float)cosf(M_DegToRad(-(360.0f - g_Player.m_Angle)) + M_PI / 2))),
                    0.0f,
                 -((1.0f - m_Deep) * ((float)sinf(M_DegToRad(-(360.0f - g_Player.m_Angle)) + M_PI / 2))));
    glTranslatef(m_Position.m_X * ((float)cosf(M_DegToRad(-(360.0f - g_Player.m_Angle)))),
                 m_Position.m_Y,
                 m_Position.m_X * ((float)sinf(M_DegToRad(-(360.0f - g_Player.m_Angle)))));
    glRotatef(360.0f - g_Player.m_Angle, 0.0f, 1.0f, 0.0f);
    glRotatef(m_Angle, m_Rotation.m_X, m_Rotation.m_Y, m_Rotation.m_Z);

    // enable source blending to keep transparency
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    // draw object
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
