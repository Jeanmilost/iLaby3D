/*****************************************************************************
 * ==> IP_Walls -------------------------------------------------------------*
 * ***************************************************************************
 * Description : Walls for labyrinth 3D                                      *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_Walls.h"
#include "E_Log.h"
#import "IP_Constants.h"
#import "IP_CatchMacros.h"
#import "IP_OpenGLHelper.h"

#define M_Cell_Dimension 20.0f

//------------------------------------------------------------------------------
// class IP_Walls - objective c
//------------------------------------------------------------------------------
@implementation IP_Walls
//------------------------------------------------------------------------------
@synthesize m_ShowMap;
//------------------------------------------------------------------------------
- (id)init
{
    m_ShowMap        = false;
    m_HasCeiling     = false;
    m_pMaze          = nil;
    m_pMap           = nil;
    m_pDoor          = nil;
    m_pKey           = nil;
    m_pYouAreHere    = nil;
    m_pOnWinDelegate = nil;
    m_CellMapSize    = 0.0f;
    m_CellMapDeltaX  = 0.0f;
    m_CellMapDeltaY  = 0.0f;
    m_MapWidth       = 0.0f;
    m_MapHeight      = 0.0f;
    m_LabyWidth      = 0.0f;
    m_LabyHeight     = 0.0f;
    m_StartPosition  = E_Vector3D(0.0f, 0.0f, 0.0f);
    m_EndPosition    = E_Vector3D(0.0f, 0.0f, 0.0f);

    for (unsigned i = 0; i < M_Nb_Walls_Textures; ++i)
        m_pTexture[i] = nil;

    for (unsigned i = 0; i < M_Nb_Walls_Map_Textures; ++i)
        m_pMapTexture[i] = nil;

    if (self = [super init])
    {
        // create maze objects
        m_pDoor = [[IP_Door alloc]init];
        m_pKey  = [[IP_Key alloc]init];

        m_pMapTexture[0] = [[IP_Texture alloc]init];
        [m_pMapTexture[0] Load :@"Transparent" :@"png"];
        m_pMapTexture[1] = [[IP_Texture alloc]init];
        [m_pMapTexture[1] Load :@"Walls_Map" :@"png"];
        m_pMapTexture[2] = [[IP_Texture alloc]init];
        [m_pMapTexture[2] Load :@"Key_Map" :@"png"];
        m_pMapTexture[3] = [[IP_Texture alloc]init];
        [m_pMapTexture[3] Load :@"Entry" :@"png"];
        m_pMapTexture[4] = [[IP_Texture alloc]init];
        [m_pMapTexture[4] Load :@"Exit_Opened" :@"png"];
        m_pMapTexture[5] = [[IP_Texture alloc]init];
        [m_pMapTexture[5] Load :@"YouAreHere" :@"png"];
    }

    return self;
}
//------------------------------------------------------------------------------
- (id)init :(NSString*)pTextureSoil:(NSString*)pTextureWalls
{
    if ([self init] != nil)
        [self CreateTextures :pTextureSoil :pTextureWalls];

    return self;
}
//------------------------------------------------------------------------------
- (id)init :(NSString*)pTextureSoil:(NSString*)pTextureWalls :(NSString*)pTextureCeiling
{
    if ([self init] != nil)
        [self CreateTextures :pTextureSoil :pTextureWalls :pTextureCeiling];

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    if (m_pOnWinDelegate)
    {
        [m_pOnWinDelegate release];
        m_pOnWinDelegate = nil;
    }

    if (m_pMaze)
        [m_pMaze release];

    if (m_pMap)
        [m_pMap release];

    if (m_pDoor)
        [m_pDoor release];

    if (m_pKey)
        [m_pKey release];

    if (m_pYouAreHere)
        [m_pYouAreHere release];

    for (unsigned i = 0; i < M_Nb_Walls_Textures; ++i)
        if (m_pTexture[i] != nil)
            [m_pTexture[i] release];

    for (unsigned i = 0; i < M_Nb_Walls_Map_Textures; ++i)
        if (m_pMapTexture[i] != nil)
            [m_pMapTexture[i] release];

    [super dealloc];
}
//------------------------------------------------------------------------------
-(void)CreateTextures :(NSString*)pTextureSoil:(NSString*)pTextureWalls
{
    m_pTexture[0] = [[IP_Texture alloc]init];
    [m_pTexture[0] Load :pTextureSoil :@"jpg"];
    m_pTexture[1] = [[IP_Texture alloc]init];
    [m_pTexture[1] Load :pTextureWalls :@"jpg"];
}
//------------------------------------------------------------------------------
-(void)CreateTextures :(NSString*)pTextureSoil:(NSString*)pTextureWalls :(NSString*)pTextureCeiling
{
    m_pTexture[0] = [[IP_Texture alloc]init];
    [m_pTexture[0] Load :pTextureSoil :@"jpg"];
    m_pTexture[1] = [[IP_Texture alloc]init];
    [m_pTexture[1] Load :pTextureWalls :@"jpg"];
    m_pTexture[2] = [[IP_Texture alloc]init];
    [m_pTexture[2] Load :pTextureCeiling :@"jpg"];
}
//------------------------------------------------------------------------------
-(void)CreateMaze :(unsigned)width :(unsigned)height :(bool)hasCeiling
{
    M_Try
    {
        m_HasCeiling = hasCeiling;
        m_pMaze      = [[NSMutableArray alloc]init];
        m_pMap       = [[NSMutableArray alloc]init];
        m_Width      = width;
        m_Height     = height;
        m_LabyWidth  = m_Width * M_Cell_Dimension;
        m_LabyHeight = m_Height * M_Cell_Dimension;

        E_Maze maze(width, height);

        // convert in memory maze to graphic maze
        for (unsigned j = 0; j < maze.GetHeight(); ++j)
            for (unsigned i = 0; i < maze.GetWidth(); ++i)
                [self CalculateCell :i :j :maze];

        float sizeX = ((IP_Constants::m_iPhoneScreen_X * 2.0f) / (m_Width + 2));
        float sizeY = ((IP_Constants::m_iPhoneScreen_Y * 2.0f) / (m_Height + 2));

        m_CellMapSize   = sizeX > sizeY ? sizeY : sizeX;
        m_CellMapDeltaX = IP_Constants::m_iPhoneScreen_X - (IP_Constants::m_iPhoneScreen_X - (((maze.GetWidth() + 2) * m_CellMapSize) / 2.0f));
        m_CellMapDeltaY = IP_Constants::m_iPhoneScreen_Y - (IP_Constants::m_iPhoneScreen_Y - (((maze.GetHeight() + 2) * m_CellMapSize) / 2.0f));
        m_MapWidth      = -m_CellMapSize * maze.GetWidth();
        m_MapHeight     = -m_CellMapSize * maze.GetHeight();

        m_pYouAreHere = [[IP_2DSprite alloc]init];
        [m_pYouAreHere Create :m_CellMapSize :m_CellMapSize];
        m_pYouAreHere.m_Deep     = 0.001f;
        m_pYouAreHere.m_pTexture = m_pMapTexture[5];

        // build maze map
        for (unsigned j = 0; j < maze.GetHeight() + 2; ++j)
            for (unsigned i = 0; i < maze.GetWidth() + 2; ++i)
            {
                // build cell map sprite
                IP_2DSprite* pMapCell = [[[IP_2DSprite alloc]init]autorelease];
                [pMapCell Create :m_CellMapSize :m_CellMapSize];
                [pMapCell Set :E_Vector2D(  ((i * m_CellMapSize) + (m_CellMapSize / 2.0f) - m_CellMapDeltaX),
                                          -(((j * m_CellMapSize) + (m_CellMapSize / 2.0f) - m_CellMapDeltaY)))
                              :E_Vector3D(0.0f, 1.0f, 0.0f)
                              :180.0f];

                if (i == 0 || j == 0 || i == maze.GetWidth() + 1 || j == maze.GetHeight() + 1)
                    pMapCell.m_pTexture = m_pMapTexture[1];
                else
                if (maze.Get(i - 1, j - 1).m_Type == E_Maze::ICell::IE_Wall)
                    pMapCell.m_pTexture = m_pMapTexture[1];
                else
                if (maze.Get(i - 1, j - 1).m_Type == E_Maze::ICell::IE_Key)
                    pMapCell.m_pTexture = m_pMapTexture[2];
                else
                if (maze.Get(i - 1, j - 1).m_Type == E_Maze::ICell::IE_Start)
                    pMapCell.m_pTexture = m_pMapTexture[3];
                else
                if (maze.Get(i - 1, j - 1).m_Type == E_Maze::ICell::IE_End)
                    pMapCell.m_pTexture = m_pMapTexture[4];
                else
                    pMapCell.m_pTexture = m_pMapTexture[0];

                [m_pMap insertObject:pMapCell atIndex:(((maze.GetWidth() + 2) * j) + i)];
            }
    }
    M_CatchShow
}
//------------------------------------------------------------------------------
- (void)CalculateCell :(unsigned)x :(unsigned)y :(const E_Maze&)maze
{
    IP_Cell* pCell = [[[IP_Cell alloc]init]autorelease];

    // check if current cell contains walls
    if (maze.Get(x, y).m_Type != E_Maze::ICell::IE_Wall)
    {
        // check if right wall was found, and create it if yes
        if (x == 0 || maze.Get(x - 1, y).m_Type == E_Maze::ICell::IE_Wall)
            [pCell SetWall :IE_Wall_Right :x :y :m_pTexture[1]];

        // check if left wall was found, and create it if yes
        if (x == (maze.GetWidth() - 1) || maze.Get(x + 1, y).m_Type == E_Maze::ICell::IE_Wall)
            [pCell SetWall :IE_Wall_Left :x :y :m_pTexture[1]];

        // check if bottom wall was found, and create it if yes
        if (y == 0 || maze.Get(x, y - 1).m_Type == E_Maze::ICell::IE_Wall)
            [pCell SetWall :IE_Wall_Bottom :x :y :m_pTexture[1]];

        // check if top wall was found, and create it if yes
        if (y == (maze.GetHeight() - 1) || maze.Get(x, y + 1).m_Type == E_Maze::ICell::IE_Wall)
            [pCell SetWall :IE_Wall_Top :x :y :m_pTexture[1]];

        // check if cell contains start position
        if (maze.Get(x, y).m_Type == E_Maze::ICell::IE_Start)
        {
            m_StartPosition = E_Vector3D((x * M_Cell_Dimension), 0.0f, (y * M_Cell_Dimension));

            if (m_pDoor)
                // configure entry door
                [m_pDoor SetEnterPosition :E_Vector3D(-(x * M_Cell_Dimension), 0.0f, -(y * M_Cell_Dimension))];
        }

        // check if cell contains key
        if (maze.Get(x, y).m_Type == E_Maze::ICell::IE_Key)
            if (m_pKey)
                [m_pKey SetPosition :E_Vector3D(-(x * M_Cell_Dimension), 0.0f, -(y * M_Cell_Dimension))];

        // check if cell contains end position
        if (maze.Get(x, y).m_Type == E_Maze::ICell::IE_End)
        {
            m_EndPosition = E_Vector3D((x * M_Cell_Dimension), 0.0f, (y * M_Cell_Dimension));

            if (m_pDoor)
                // configure exit door
                [m_pDoor SetExitPosition :E_Vector3D(-(x * M_Cell_Dimension), 0.0f, -(y * M_Cell_Dimension))];
        }

        // add cell soil
        [pCell SetWall :IE_Soil :x :y :m_pTexture[0]];

        // add cell ceiling if needed
        if (m_HasCeiling)
            [pCell SetWall :IE_Ceiling :x :y :m_pTexture[2]];
    }

    [m_pMaze insertObject:pCell atIndex:((maze.GetWidth() * y) + x)];
}
//------------------------------------------------------------------------------
- (IP_Cell*)GetCell :(unsigned)x :(unsigned)y
{
    M_Try
    {
        return [m_pMaze objectAtIndex:((m_Width * y) + x)];
    }
    M_CatchSilent

    return nil;
}
//------------------------------------------------------------------------------
- (IP_2DSprite*)GetCellMap :(unsigned)x :(unsigned)y
{
    M_Try
    {
        return [m_pMap objectAtIndex:(((m_Width + 2) * y) + x)];
    }
    M_CatchSilent

    return nil;
}
//------------------------------------------------------------------------------
- (const E_Vector3D&)GetStartPosition
{
    return m_StartPosition;
}
//------------------------------------------------------------------------------
- (const E_Vector3D&)GetKeyPosition
{
    return [m_pKey GetPosition];
}
//------------------------------------------------------------------------------
- (const E_Vector3D&)GetEndPosition
{
    return m_EndPosition;
}
//------------------------------------------------------------------------------
- (bool)CheckCollisions :(const E_Vector3D&)nextPosition :(std::vector<E_Plane>&)planes :(bool&)multipleCells
{
    M_Try
    {
        int x = nextPosition.m_X / M_Cell_Dimension;
        int y = nextPosition.m_Z / M_Cell_Dimension;

        unsigned nbCellsInCollision = 0;

        // check only the 3x3 cells around the player
        for (int j = (y - 1); j <= (y + 1); ++j)
            for (int i = (x - 1); i <= (x + 1); ++i)
                if (i >= 0 && i < m_Width && j >= 0 && j < m_Height)
                {
                    unsigned nbCollisions = planes.size();

                    [[self GetCell :i :j]CheckCollisions :nextPosition :planes];

                    if (nbCollisions != planes.size())
                        ++nbCellsInCollision;
                }

        if (nbCellsInCollision > 1)
            multipleCells = true;
        else
            multipleCells = false;

        return true;
    }
    M_CatchSilent

    return false;
}
//------------------------------------------------------------------------------
- (void)OnCheckFoundObject :(const E_Vector3D&)position
{
    M_Try
    {
        if ([self HasFoundKey:position])
        {
            if (m_pKey)
                [m_pKey SetKeyFound:true];

            if (m_pDoor)
                [m_pDoor SetOpen:true];
        }

        if (m_pDoor && [m_pDoor IsOpen] && [self HasFoundExit:position])
            if (m_pOnWinDelegate)
                [m_pOnWinDelegate Call];
            else
                M_THROW_EXCEPTION("OnWin delegate is not declared");
    }
    M_CatchSilent
}
//------------------------------------------------------------------------------
- (bool)HasFoundKey :(const E_Vector3D&)position
{
    M_Try
    {
        int x    = position.m_X / M_Cell_Dimension;
        int y    = position.m_Z / M_Cell_Dimension;
        int keyX = -[m_pKey GetPosition].m_X / M_Cell_Dimension;
        int keyY = -[m_pKey GetPosition].m_Z / M_Cell_Dimension;

        return (x == keyX && y == keyY);
    }
    M_CatchSilent

    return false;
}
//------------------------------------------------------------------------------
- (bool)HasFoundExit :(const E_Vector3D&)position
{
    M_Try
    {
        int x     = position.m_X / M_Cell_Dimension;
        int y     = position.m_Z / M_Cell_Dimension;
        int exitX = -[m_pDoor GetExitPosition].m_X / M_Cell_Dimension;
        int exitY = -[m_pDoor GetExitPosition].m_Z / M_Cell_Dimension;

        return (x == exitX && y == exitY);
    }
    M_CatchSilent

    return false;
}
//------------------------------------------------------------------------------
- (bool)Render :(const E_Vector3D&)position
{
    M_Try
    {
        int x = position.m_X / M_Cell_Dimension;
        int y = position.m_Z / M_Cell_Dimension;

        // draw only the 12x12 cells around the player
        for (int j = (y - 6); j <= (y + 6); ++j)
            for (int i = (x - 6); i <= (x + 6); ++i)
                if (i >= 0 && i < m_Width && j >= 0 && j < m_Height)
                    if (![[self GetCell :i :j]RenderCell])
                        return false;

        // display the map if needed
        if (m_ShowMap)
        {
            // draw map
            for (unsigned j = 0; j < m_Height + 2; ++j)
                for (unsigned i = 0; i < m_Width + 2; ++i)
                {
                    IP_2DSprite* pSprite = [self GetCellMap :i :j];

                    if (pSprite)
                        [pSprite Render];
                }

            // draw player position
            if (m_pYouAreHere)
            {
                float posOnMapX = (position.m_X * m_MapWidth)  / m_LabyWidth;
                float posOnMapY = (position.m_Z * m_MapHeight) / m_LabyHeight;

                [m_pYouAreHere Set :E_Vector2D( ( ((m_CellMapSize / 2.0f) - m_CellMapDeltaX) + m_CellMapSize) - posOnMapX,
                                                (-((m_CellMapSize / 2.0f) - m_CellMapDeltaY) - m_CellMapSize) + posOnMapY)
                                   :E_Vector3D(0.0f, 1.0f, 0.0f)
                                   :180.0f];
                [m_pYouAreHere Render];
            }
        }

        // draw the key
        if (m_pKey)
            [m_pKey RenderKey];

        // draw the doors (enter and exit)
        if (m_pDoor)
            [m_pDoor RenderDoor];

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (bool)Render :(const E_Vector3D&)position :(const E_Vector3D&)direction
{
    M_Try
    {
        // calculate near and far clipping planes
        E_Plane nearClippingPlane = E_Maths::PlaneFromPointNormal(position, direction);
        E_Plane farClippingPlane  = E_Maths::PlaneFromPointNormal(E_Vector3D(position.m_X + (100.0f * direction.m_X), position.m_Y,
                position.m_Z + (100.0f * direction.m_Z)), -direction);

        float rAngle = M_DegToRad(g_Player.m_Angle) + (M_PI / 2) + M_DegToRad(45);

        if (rAngle >= (M_PI * 2))
            rAngle -= (M_PI * 2);
        else
        if (rAngle < 0.0f)
            rAngle += (M_PI * 2);

        // calculate right clipping plane
        float dirRX = (float)cosf(rAngle);
        float dirRZ = (float)sinf(rAngle);
        E_Plane rightClippingPlane = E_Maths::PlaneFromPointNormal(position, -E_Vector3D(dirRX, g_Player.m_Direction.m_Y, dirRZ));

        float lAngle = M_DegToRad(g_Player.m_Angle) + (M_PI / 2) - M_DegToRad(45);

        if (lAngle >= (M_PI * 2))
            lAngle -= (M_PI * 2);
        else
        if (lAngle < 0.0f)
            lAngle += (M_PI * 2);

        // calculate left clipping plane
        dirRX = (float)cosf(lAngle);
        dirRZ = (float)sinf(lAngle);
        E_Plane leftClippingPlane = E_Maths::PlaneFromPointNormal(position, -E_Vector3D(dirRX, g_Player.m_Direction.m_Y, dirRZ));

        // render cells that are not clipped
        for (unsigned i = 0; i < [m_pMaze count]; ++i)
            if (![[m_pMaze objectAtIndex:i]RenderCell :nearClippingPlane :farClippingPlane :rightClippingPlane :leftClippingPlane])
                return false;

        // display the map if needed
        if (m_ShowMap)
        {
            // draw map
            for (unsigned j = 0; j < m_Height + 2; ++j)
                for (unsigned i = 0; i < m_Width + 2; ++i)
                {
                    IP_2DSprite* pSprite = [self GetCellMap :i :j];

                    if (pSprite)
                        [pSprite Render];
                }

            // draw player position
            if (m_pYouAreHere)
            {
                float posOnMapX = (position.m_X * m_MapWidth)  / m_LabyWidth;
                float posOnMapY = (position.m_Z * m_MapHeight) / m_LabyHeight;

                [m_pYouAreHere Set :E_Vector2D( ( ((m_CellMapSize / 2.0f) - m_CellMapDeltaX) + m_CellMapSize) - posOnMapX,
                                                (-((m_CellMapSize / 2.0f) - m_CellMapDeltaY) - m_CellMapSize) + posOnMapY)
                                   :E_Vector3D(0.0f, 1.0f, 0.0f)
                                   :180.0f];
                [m_pYouAreHere Render];
            }
        }

        // draw the key
        if (m_pKey)
            [m_pKey RenderKey];

        // draw the doors (enter and exit)
        if (m_pDoor)
            [m_pDoor RenderDoor];

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (void)SetOnWinDelegate :(id)pObject :(SEL)pDelegate
{
    if (!m_pOnWinDelegate)
        m_pOnWinDelegate = [[IP_Delegate alloc]init];

    if (m_pOnWinDelegate)
        [m_pOnWinDelegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
