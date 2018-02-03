/*****************************************************************************
 * ==> IP_Sprite ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a sprite, usable e.g. for billboarding           *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_Sprite.h"
#import "E_Exception.h"
#import "E_MemoryTools.h"
#import "IP_OpenGLHelper.h"
#import <memory>

//------------------------------------------------------------------------------
// struct IP_3DObject - c++
//------------------------------------------------------------------------------
const GLfloat IP_3DObject::m_Vertices[] =
{
	-1.0f,  1.0f, 0.0f,
     1.0f,  1.0f, 0.0f,
    -1.0f, -1.0f, 0.0f,
     1.0f, -1.0f, 0.0f,
};
//------------------------------------------------------------------------------
const GLfloat IP_3DObject::m_TextureCoords[] =
{
	0.0, 0.0,
	1.0, 0.0,
	0.0, 1.0,
	1.0, 1.0
};
//------------------------------------------------------------------------------
// class IP_Sprite - objective c
//------------------------------------------------------------------------------
@implementation IP_Sprite
//------------------------------------------------------------------------------
@synthesize m_Position;
@synthesize m_UseOrtho;
@synthesize m_WorldMatrix;
//------------------------------------------------------------------------------
- (id)init
{
    m_UseOrtho = false;

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
    unsigned verticesSize = M_CountOf(IP_3DObject::m_Vertices);
    m_pSpriteData         = new GLfloat[verticesSize];

    E_Vector3D vertex[verticesSize / 3];

    for (unsigned i = 0; i < verticesSize / 3; ++i)
    {
        m_pSpriteData[3 * i]       = IP_3DObject::m_Vertices[3 * i] * width / 2.0f;
        m_pSpriteData[(3 * i) + 1] = IP_3DObject::m_Vertices[(3 * i) + 1] * height / 2.0f;
        m_pSpriteData[(3 * i) + 2] = IP_3DObject::m_Vertices[(3 * i) + 2];
        
        vertex[i] = E_Vector3D(m_pSpriteData[3 * i], m_pSpriteData[(3 * i) + 1], m_pSpriteData[(3 * i) + 2]);
    }

    if (m_pPolygonList)
    {
        for (unsigned i = 0; i < M_CountOf(vertex) - 2; ++i)
        {
            E_Polygon* pPolygon = new E_Polygon(vertex[i], vertex[i + 1], vertex[i + 2]);
            m_pPolygonList->AddPolygon(pPolygon);
        }
    }
    else
        M_THROW_EXCEPTION("Polygon list is NULL");
}
//------------------------------------------------------------------------------
- (void)Set :(const E_Vector3D&)position :(const E_Vector3D&)rotation :(const float&)angle
{
    m_Position = position;
	m_Rotation = rotation;
	m_Angle    = angle;

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

	// calculate the modelview matrix for the collisions and clipping plane, or set position of the object in the 3D world
    glTranslatef(m_Position.m_X, m_Position.m_Y, m_Position.m_Z);
	glRotatef(m_Angle, m_Rotation.m_X, m_Rotation.m_Y, m_Rotation.m_Z);

    // update object matrix
    IP_OpenGLMatrix openGLMatrix;
    glGetFloatv(GL_MODELVIEW_MATRIX, openGLMatrix.m_Table);
    m_WorldMatrix = [IP_OpenGLHelper OpenGLMatrixToEMatrix :openGLMatrix];
}
//------------------------------------------------------------------------------
- (void)Render
{
    M_Assert(m_pSpriteData);
    M_Assert(m_pTexture);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

	// set vertex buffer of the object
    glVertexPointer(3, GL_FLOAT, 0, m_pSpriteData);
    glEnableClientState(GL_VERTEX_ARRAY);

    // set texture coordinates buffer
    glTexCoordPointer(2, GL_FLOAT, 0, IP_3DObject::m_TextureCoords);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    [m_pTexture Render];

    if (m_UseOrtho)
    {
        // set position of the object in the 3D world (use the orthogonal world matrix)
        glRotatef(m_Angle, m_Rotation.m_X, m_Rotation.m_Y, m_Rotation.m_Z);
        glTranslatef(m_Position.m_X, -m_Position.m_Y, -m_Position.m_Z);
    }
    else
    {
        // set position of the object in the 3D world (the camera view is applied here)
        glRotatef(g_Player.m_Angle, g_Player.m_Rotation.m_X, g_Player.m_Rotation.m_Y, g_Player.m_Rotation.m_Z);
        glTranslatef(m_Position.m_X + g_Player.m_Position.m_X,
                     m_Position.m_Y + g_Player.m_Position.m_Y,
                     m_Position.m_Z + g_Player.m_Position.m_Z);
        glRotatef(m_Angle, m_Rotation.m_X, m_Rotation.m_Y, m_Rotation.m_Z);
    }

    // enable source blending to keep transparency
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	// draw object
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
