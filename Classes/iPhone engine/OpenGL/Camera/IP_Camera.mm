/*****************************************************************************
 * ==> IP_Camera ------------------------------------------------------------*
 * ***************************************************************************
 * Description : Camera or point of view                                     *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_Camera.h"

//------------------------------------------------------------------------------
// class IP_Camera - objective c
//------------------------------------------------------------------------------
@implementation IP_Camera
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
- (void)Initialize :(const float&)width
                   :(const float&)height
                   :(const float&)near
                   :(const float&)far
{
    m_WindowsWidth  = width;
    m_WindowsHeight = height;
    m_Near          = near;
    m_Far           = far;
}
//------------------------------------------------------------------------------
- (void)Initialize :(const float&)width
                   :(const float&)height
                   :(const float&)deep
{
    m_WindowsWidth  = width;
    m_WindowsHeight = height;
    m_Deep          = deep;
}
//------------------------------------------------------------------------------
- (void)SetCamera
{
    [self CreateOrtho];
}
//------------------------------------------------------------------------------
- (void)SetCamera :(const E_Vector3D&)translation
                  :(const E_Vector3D&)rotation
                  :(const float&)angle
{
	[self CreateProjection];

    if (angle != 0.0f && (rotation.m_X != 0.0f || rotation.m_Y != 0.0f || rotation.m_Z != 0.0f))
        glRotatef(angle, rotation.m_X, rotation.m_Y, rotation.m_Z);

    glTranslatef(translation.m_X, translation.m_Y, translation.m_Z);
}
//------------------------------------------------------------------------------
- (void)CreateOrtho
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

	float minX = -m_WindowsWidth / 2.0f;
	float maxX =  m_WindowsWidth / 2.0f;
	float minY = -m_WindowsHeight / 2.0f;
	float maxY =  m_WindowsHeight / 2.0f;

	glOrthof(minX, maxX, minY, maxY, 0.0f, m_Deep);
}
//------------------------------------------------------------------------------
- (void)CreateProjection
{
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    
	float fov    = 45;
	float aspect = m_WindowsWidth / m_WindowsHeight;
	float top    = tanf(((fov * (2 * M_PI)) / 360.0f)) * m_Near;
	float bottom = -top;
	float left   = aspect * bottom;
	float right  = aspect * top;
    
	glFrustumf(left, right, bottom, top, m_Near, m_Far);
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
