/*****************************************************************************
 * ==> IP_SoundPlayer -------------------------------------------------------*
 * ***************************************************************************
 * Description : Class to play a simple sound                                *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "IP_PlayerProtocol.h"

@interface IP_SoundPlayer : NSObject <IP_PlayerProtocol>
{
    @private
        SystemSoundID m_SoundID;
        bool          m_IsPlaying;
}

/**
* Initializes class
*@returns self pointer
*/
- (id)init;

/**
* Deletes all resources
*/
- (void)dealloc;

/**
* Loads the given sound
*@param pResourceName - resource name to play
*@param pExtension - resource extension
*@returns true on success, otherwise false
*/
- (bool)Load :(NSString*)pResourceName :(NSString*)pExtension;

/**
* Plays the music
*@returns true on success, otherwise false
*/
- (void)Play;

/**
* Check if blayback is already playing
*@returns true if playback is already playing, otherwise false
*/
- (bool)IsPlaying;

/**
* Pauses the music
*@returns true on success, otherwise false
*/
- (bool)Pause;

/**
* Stops the music
*@returns true on success, otherwise false
*/
- (void)Stop;

/**
* Changes the volume
*@param value - volume value between 0.0f (lowest) et 1.0f (highest)
*@returns true on success, otherwise false
*/
- (bool)ChangeVolume :(float)value;

/**
* Loops the music
*@param value - whether or not hte music should be loop
*/
- (void)Loop :(bool)value;

/**
* Called when sound playing is completed
*@param soundID - sound identifier
*@param pSender - sender that raises the event
*/
static void OnPlayCompleted(SystemSoundID soundID, void* pSender);

@end
