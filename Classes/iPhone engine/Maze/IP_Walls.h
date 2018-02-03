/*****************************************************************************
 * ==> IP_Walls -------------------------------------------------------------*
 * ***************************************************************************
 * Description : Walls for labyrinth 3D                                      *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import "IP_Delegate.h"
#import "IP_Texture.h"
#import "IP_Cell.h"
#import "IP_Door.h"
#import "IP_Key.h"
#include "E_Maze.h"

#define M_Nb_Walls_Textures     3
#define M_Nb_Walls_Map_Textures 6

/**
* Contains the maze 3D walls
*@author Jean-Milost Reymond
*/
@interface IP_Walls : NSObject
{
    @private
        IP_Texture*     m_pTexture[M_Nb_Walls_Textures];
        IP_Texture*     m_pMapTexture[M_Nb_Walls_Map_Textures];
        NSMutableArray* m_pMaze;
        NSMutableArray* m_pMap;
        IP_Door*        m_pDoor;
        IP_Key*         m_pKey;
        IP_2DSprite*    m_pYouAreHere;
        bool            m_ShowMap;
        bool            m_HasCeiling;
        unsigned        m_Width;
        unsigned        m_Height;
        float           m_CellMapSize;
        float           m_CellMapDeltaX;
        float           m_CellMapDeltaY;
        float           m_MapWidth;
        float           m_MapHeight;
        float           m_LabyWidth;
        float           m_LabyHeight;
        E_Vector3D      m_StartPosition;
        E_Vector3D      m_EndPosition;
        IP_Delegate*    m_pOnWinDelegate;
}

@property (nonatomic, assign) bool m_ShowMap;

/**
* Initializes the class
*@returns pointer to itself
*/
- (id)init;

/**
* Initializes the class
*@param pTextureSoil - soil texture name
*@param pTextureWalls - walls texture name
*@returns pointer to itself
*/
- (id)init :(NSString*)pTextureSoil:(NSString*)pTextureWalls;

/**
* Initializes the class
*@param pTextureSoil - soil texture name
*@param pTextureWalls - walls texture name
*@param pTextureCeiling - ceiling texture name
*@returns pointer to itself
*/
- (id)init :(NSString*)pTextureSoil:(NSString*)pTextureWalls :(NSString*)pTextureCeiling;

/**
* Releases class resources
*/
- (void)dealloc;

/**
* Creates level textures
*@param pTextureSoil - soil texture name
*@param pTextureWalls - walls texture name
*/
-(void)CreateTextures :(NSString*)pTextureSoil:(NSString*)pTextureWalls;

/**
* Creates level textures
*@param pTextureSoil - soil texture name
*@param pTextureWalls - walls texture name
*@param pTextureCeiling - ceiling texture name
*/
-(void)CreateTextures :(NSString*)pTextureSoil:(NSString*)pTextureWalls :(NSString*)pTextureCeiling;

/**
* Creates the 3D maze
*@param width - width of the maze (in maze coordinate)
*@param height - height of the maze (in maze coordinate)
*@param hasCeiling - whether or not the maze has ceiling
*/
-(void)CreateMaze :(unsigned)width :(unsigned)height :(bool)hasCeiling;

/**
* Calculates a cell
*@param x - x coordinate of the cell (in maze coordinate)
*@param y - y coordinate of the cell (in maze coordinate)
*@maze - maze
*/
- (void)CalculateCell :(unsigned)x :(unsigned)y :(const E_Maze&)maze;

/**
* Gets the cell at the given coordinate
*@param x - x coordinate (in maze coordinate)
*@param y - y coordinate (in maze coordinate)
*/
- (IP_Cell*)GetCell :(unsigned)x :(unsigned)y;

/**
* Gets the cell map component at the given coordinate
*@param x - x coordinate (in maze coordinate)
*@param y - y coordinate (in maze coordinate)
*/
- (IP_2DSprite*)GetCellMap :(unsigned)x :(unsigned)y;

/**
* Gets player start position
*@returns player start position
*/
- (const E_Vector3D&)GetStartPosition;

/**
* Gets key position
*@returns key position
*/
- (const E_Vector3D&)GetKeyPosition;

/**
* Gets player end position
*@returns player end position
*/
- (const E_Vector3D&)GetEndPosition;

/**
* Checks if the player is in collision with any wall of the maze
*@param nextPosition - position to check
*@param[out] planes - pointer to a vector of planes. If the planes vector containt at least 1 plane, then the player is in collision
*@param[out] multipleCells - whether or not many cells are implicated in collision
*@returns true on success, otherwise false
*/
- (bool)CheckCollisions :(const E_Vector3D&)nextPosition :(std::vector<E_Plane>&)planes :(bool&)multipleCells;

/**
* Called when engine should checks if any object was found by the player
*@param position - current player position
*/
- (void)OnCheckFoundObject :(const E_Vector3D&)position;

/**
* Checks if player has found key
*@param position - current player position
*@returns true if player has found key, otherwise false
*/
- (bool)HasFoundKey :(const E_Vector3D&)position;

/**
* Checks if player has found exit
*@param position - current player position
*@returns true if player has found exit, otherwise false
*/
- (bool)HasFoundExit :(const E_Vector3D&)position;

/**
* Renders the maze
*@param position - player position
*@returns true on success, otherwise false
*/
- (bool)Render :(const E_Vector3D&)position;

/**
* Renders the maze
*@param position - player position
*@param direction - player direction
*@returns true on success, otherwise false
*/
- (bool)Render :(const E_Vector3D&)position :(const E_Vector3D&)direction;

/**
* Set OnWin delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnWinDelegate :(id)pObject :(SEL)pDelegate;

@end
