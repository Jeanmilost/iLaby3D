/*****************************************************************************
 * ==> IP_Texture -----------------------------------------------------------*
 * ***************************************************************************
 * Description : Represents a texture                                        *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_Texture.h"

//------------------------------------------------------------------------------
// class IP_Texture - objective c
//------------------------------------------------------------------------------
@implementation IP_Texture
//------------------------------------------------------------------------------
- (id)init
{
    if (self = [super init])
        glEnable(GL_TEXTURE_2D);

    return self;
}
//------------------------------------------------------------------------------
- (bool)Load :(NSString*)pResourceName :(NSString*)pExtension
{
	// build file path from resources
    NSString* pPath = [[NSBundle mainBundle] pathForResource:pResourceName ofType:pExtension];

    if (pPath == nil)
	{
		NSLog(@"Load texture failed - cannot build texture path");
		return false;
	}

	// prepare texture data
    NSData* pTexData = [[NSData alloc] initWithContentsOfFile: pPath];

	if (pTexData == nil)
	{
		NSLog(@"Load texture failed - cannot get texture data");
		return false;
	}

	// load image containing texture
    UIImage* pImage = [[UIImage alloc] initWithData: pTexData];

    if (pImage == nil)
	{
        NSLog(@"Load texture failed - cannot get image");
		[pTexData release];
		return false;
    }

	// get texture info and reserve space in memory for data
    GLuint          width      = CGImageGetWidth(pImage.CGImage);
    GLuint          height     = CGImageGetHeight(pImage.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void*           pImageData = malloc(height * width * 4);

	if (pImageData == nil)
	{
        NSLog(@"Load texture failed - not enough memory to create image data");
		[pImage release];
		[pTexData release];
		return false;
	}

	// get image context
    CGContextRef context = CGBitmapContextCreate(pImageData,
												 width,
												 height,
												 8,
												 4 * width,
												 colorSpace,
												 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

	// configure image
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextTranslateCTM(context, 0, height - height);
    CGContextDrawImage(context, CGRectMake( 0, 0, width, height), pImage.CGImage);

	// create texture and set image data in OpenGL engine
    glGenTextures(1, &m_Texture[0]);
	glBindTexture(GL_TEXTURE_2D, m_Texture[0]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pImageData);

	// release context
    CGContextRelease(context);

	// release useless image objects
    free(pImageData);
    [pImage release];
    [pTexData release];

	return true;
}
//------------------------------------------------------------------------------
- (void)Render
{
	// configure OpenGL blender
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_SRC_COLOR);

	// configure OpenGL filters
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	// select texture to display
    glBindTexture(GL_TEXTURE_2D, m_Texture[0]);
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
