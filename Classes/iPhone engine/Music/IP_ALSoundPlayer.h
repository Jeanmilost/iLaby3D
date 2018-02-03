/*****************************************************************************
 * ==> IP_ALSoundPlayer -----------------------------------------------------*
 * ***************************************************************************
 * Description : Class to play a simple sound based on OpenAL system         *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import "IP_PlayerProtocol.h"

@interface IP_ALSoundPlayer : NSObject <IP_PlayerProtocol>
{
    @private
        ALCdevice*  m_pDevice;
        ALCcontext* m_pContext;
        ALuint      m_BufferID;
        ALuint      m_ID;
        ALuint      m_ErrorID;
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
* Release OpenAL resources
*/
- (void)ReleaseOpenAL;

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
- (bool)Play;

/**
* Pauses the music
*@returns true on success, otherwise false
*/
- (bool)Pause;

/**
* Stops the music
*@returns true on success, otherwise false
*/
- (bool)Stop;

/**
* Check if blayback is already playing
*@returns true if playback is already playing, otherwise false
*/
- (bool)IsPlaying;

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

@end
