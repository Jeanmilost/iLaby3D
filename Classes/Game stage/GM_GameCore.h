/*****************************************************************************
 * ==> GM_GameCore ----------------------------------------------------------*
 * ***************************************************************************
 * Description : Core game class                                             *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "GM_Stage.h"
#import "IP_Delegate.h"
#import "IP_Camera.h"
#import "IP_MusicPlayer.h"
#import "IP_ALSoundPlayer.h"
#import "IP_UserControl.h"
#import "IP_Walls.h"
#import "IP_Button.h"

/**
* Core game class
*@author Jean-Milost Reymond
*/
@interface GM_GameCore : GM_Stage <GM_StageProtocol>
{
    @public
        /**
        * Levels type enumeration
        */
        enum IE_Level
        {
            IE_Unknown,
            IE_Underground,
            IE_Trees,
            IE_Snow,
            IE_OnMars
        };

    @private
        IP_Camera*        m_pCamera;
        IP_Walls*         m_pWalls;
        IP_Button*        m_pMapButton;
        IP_Button*        m_pPauseButton;
        IP_Button*        m_pMenuButton;
        IP_UserControl*   m_pUserControl;
        IP_MusicPlayer*   m_pAmbientSound1;
        IP_MusicPlayer*   m_pAmbientSound2;
        IP_ALSoundPlayer* m_pStep;
        GLfloat           m_FogColor[4];
        CFTimeInterval    m_LastTime;
        CFTimeInterval    m_LastPlayedStep;
        CFTimeInterval    m_BeginsTime;
        CFTimeInterval    m_Time;
        E_Plane           m_LastPlane;
        float             m_Volume;
        bool              m_DisplayMap;
        bool              m_Pause;
        bool              m_Play;
        IP_Delegate*      m_pOnRunDelegate;
        IP_Delegate*      m_pOnPauseDelegate;
        IP_Delegate*      m_pOnQuitDelegate;
        IP_Delegate*      m_pOnWinDelegate;
        IE_Level          m_Level;
}

@property (readonly, nonatomic, assign) bool m_Play;
@property (readonly, nonatomic, assign) bool m_Pause;

/**
* Initializes class
*@returns self object
*/
- (id)init;

/**
* Deletes all resources
*/
- (void)dealloc;

/**
* Clear data
*/
- (void)Clear;

/**
* Open level
*@param level - level type
*@param width - maze width (in cells)
*@param height - maze height (in cells)
*@param backingWidth - iPhone display width
*@param backingHeight - iPhone display height
*@returns true on success, otherwise false
*/
- (bool)Open :(IE_Level)level :(unsigned)width :(unsigned)height :(const GLint&)backingWidth :(const GLint&)backingHeight;

/**
* Called before draw begins
*/
- (void)OnDrawBegin;

/**
* Called when the scene should be drawn
*/
- (void)OnDraw;

/**
* Called after draw ends
*/
- (void)OnDrawEnd;

/**
* Called when control moves
*@param position - 2D screen coordinates position
*@param doReset - whether or not control move ends
*/
- (void)OnControlMoves :(const CGPoint&)position :(bool)end;

/**
* Called when player wins
*/
- (void)OnWin;

/**
* Stops all sounds
*/
- (void)StopAllSounds;

/**
* Prepares the sound volume
*/
- (void)PrepareSoundVolume;

/**
* Sets the player
*@returns true on success, otherwise false
*/
- (bool)SetPlayer;

/**
* Sets the fog
*@returns true on success, otherwise false
*/
- (bool)SetFog;

/**
* Set sound volume
*@param voulme - sound volume
*/
- (void)SetVolume :(float)volume;

/**
* Get elapsed time from beginning
*@returns elapsed time from beginning
*/
- (CFTimeInterval)GetElapsedTime;

/**
* Format time
*@param time - time to format
*@returns string containing formatted string
*@note Time is formatted as follow: 00:00:00
*/
- (std::wstring)FormatTime :(const CFTimeInterval&)time;

/**
* Set OnRun delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnRunDelegate :(id)pObject :(SEL)pDelegate;

/**
* Set OnPause delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnPauseDelegate :(id)pObject :(SEL)pDelegate;

/**
* Set OnQuit delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnQuitDelegate :(id)pObject :(SEL)pDelegate;

/**
* Set OnWin delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnWinDelegate :(id)pObject :(SEL)pDelegate;

/**
* Called when application enters background
*/
- (void)OnAppEnterBackground;

/**
* Called when application enters foreground
*/
- (void)OnAppEnterForeground;

@end
