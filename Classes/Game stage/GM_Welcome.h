/*****************************************************************************
 * ==> GM_Welcome -----------------------------------------------------------*
 * ***************************************************************************
 * Description : Welcome class                                               *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "GM_Stage.h"
#import "IP_Delegate.h"
#import "IP_Camera.h"
#import "IP_MusicPlayer.h"
#import "IP_Sprite.h"
#import "IP_Texture.h"
#include <string>

#ifndef Show_Advertisements
    #define M_Nb_Welcome_Textures 16
    #define M_Nb_Welcome_Sprites  17
#else
    #define M_Nb_Welcome_Textures 17
    #define M_Nb_Welcome_Sprites  18
#endif

@interface GM_Welcome : GM_Stage <GM_StageProtocol>
{
    @private
        /**
        * Interface components names enumeration
        */
        enum IElements
        {
            IE_Logo                  = 0,
            IE_Level_Underground     = 1,
            IE_Level_Trees           = 2,
            IE_Level_Snow            = 3,
            IE_Level_Mars            = 4,
            IE_Button_Settings       = 5,
            IE_Button_Quit           = 6,
            IE_Logo_Sound            = 7,
            IE_Slide_Sound_BG        = 8,
            IE_Slide_Sound           = 9,
            IE_Logo_Music            = 10,
            IE_Slide_Music_BG        = 11,
            IE_Slide_Music           = 12,
            IE_Logo_Size             = 13,
            IE_Slide_Size_BG         = 14,
            IE_Slide_Size            = 15,
            IE_Button_Close_Settings = 16,
            #ifdef Show_Advertisements
                IE_Copyright         = 17,
            #endif
        };

        float           m_Offset;
        float           m_SoundSlidePos;
        float           m_MusicSlidePos;
        float           m_SizeSlidePos;
        bool            m_ToggleSettings;
        CFTimeInterval  m_Time;
        IP_Camera*      m_pCamera;
        IP_Sprite*      m_pSprite[M_Nb_Welcome_Sprites];
        IP_Texture*     m_pTexture[M_Nb_Welcome_Textures];
        IP_MusicPlayer* m_pMusic;
        IP_Delegate*    m_pOnBeginGame_Underground_Delegate;
        IP_Delegate*    m_pOnBeginGame_Trees_Delegate;
        IP_Delegate*    m_pOnBeginGame_Snow_Delegate;
        IP_Delegate*    m_pOnBeginGame_Mars_Delegate;
        IP_Delegate*    m_pOnExitDelegate;
}

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
* Open level
*@param backingWidth - iPhone display width
*@param backingHeight - iPhone display height
*@returns true on success, otherwise false
*/
- (bool)Open :(const GLint&)backingWidth :(const GLint&)backingHeight;

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
*@param end - whether or not control move ends
*/
- (void)OnControlMoves :(const CGPoint&)position :(bool)end;

/**
* Get sound volume
*@returns sound volume
*/
- (float) GetSoundVolume;

/**
* Get music volume
*@returns music volume
*/
- (float) GetMusicVolume;

/**
* Get maze size
*@returns smaze size
*/
- (unsigned) GetMazeSize;

/**
* Open settings from file
*@param fileName - settings file name
*/
- (void)OpenSettingsFromFile :(const std::string&)fileName;

/**
* Save settings to file
*@param fileName - settings file name
*/
- (void)SaveSettingsToFile :(const std::string&)fileName;

/**
* Calculate and set controls positions
*/
- (void)SetControls;

/**
* Set OnBeginGame (underground level) delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnBeginGame_Underground_Delegate :(id)pObject :(SEL)pDelegate;

/**
* Set OnBeginGame (trees level) delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnBeginGame_Trees_Delegate :(id)pObject :(SEL)pDelegate;

/**
* Set OnBeginGame (snow level) delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnBeginGame_Snow_Delegate :(id)pObject :(SEL)pDelegate;

/**
* Set OnBeginGame (mars level) delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnBeginGame_Mars_Delegate :(id)pObject :(SEL)pDelegate;

/**
* Set OnExit delegate
*@param pObject - function owner object
*@param pDelegate - function to delegate
*/
- (void)SetOnExitDelegate :(id)pObject :(SEL)pDelegate;

/**
* Called when application enters background
*/
- (void)OnAppEnterBackground;

/**
* Called when application enters foreground
*/
- (void)OnAppEnterForeground;

@end
