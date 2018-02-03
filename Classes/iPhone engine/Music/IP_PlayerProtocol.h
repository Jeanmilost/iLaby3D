/*****************************************************************************
 * ==> IP_PlayerProtocol ----------------------------------------------------*
 * ***************************************************************************
 * Description : Basic sound and music player protocol                       *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

/**
* Sound and music player protocol
*@author Jean-Milost Reymond
*/
@protocol IP_PlayerProtocol
    @required
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
