/*****************************************************************************
 * ==> IP_SoundPlayer -------------------------------------------------------*
 * ***************************************************************************
 * Description : Class to play a simple sound                                *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_SoundPlayer.h"
#import "IP_CatchMacros.h"

//------------------------------------------------------------------------------
// class IP_SoundPlayer - objective c
//------------------------------------------------------------------------------
@implementation IP_SoundPlayer
//------------------------------------------------------------------------------
- (id)init
{
	m_SoundID = 0;

    if (self = [super init])
    {}

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    //AudioServicesDisposeSystemSoundID(m_SoundID);

    [super dealloc];
}
//------------------------------------------------------------------------------
- (bool)Load :(NSString*)pResourceName :(NSString*)pExtension
{
	NSString* pSoundFilePath = [[NSBundle mainBundle]pathForResource:pResourceName ofType:pExtension];

	if (pSoundFilePath == nil)
	{
		NSLog(@"Load sound failed - cannot build sound path");
		return false;
	}

    OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath: pSoundFilePath], &m_SoundID);

    [pSoundFilePath release];

    if (error != kAudioServicesNoError)
    {
		NSLog(@"Load sound failed - error during creation of sound identifier");
        m_SoundID = 0;
		return false;
    }

    /*
    kAudioSessionCategory_AmbientSound               = 'ambi',
    kAudioSessionCategory_SoloAmbientSound           = 'solo',
    kAudioSessionCategory_MediaPlayback              = 'medi',
    kAudioSessionCategory_RecordAudio                = 'reca',
    kAudioSessionCategory_PlayAndRecord              = 'plar',
    kAudioSessionCategory_AudioProcessing            = 'proc'
    */
    UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;

    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof (sessionCategory), &sessionCategory);

    return true;
}
//------------------------------------------------------------------------------
- (void)Play
{
	AudioServicesAddSystemSoundCompletion(m_SoundID, NULL, NULL, OnPlayCompleted, (void*)self);
	m_IsPlaying = true;
    AudioServicesPlaySystemSound(m_SoundID);
}
//------------------------------------------------------------------------------
- (bool)IsPlaying
{
    return m_IsPlaying;
}
//------------------------------------------------------------------------------
- (bool)Pause
{
    M_THROW_EXCEPTION("Not implemented");
}
//------------------------------------------------------------------------------
-(void)Stop
{
	AudioServicesRemoveSystemSoundCompletion(m_SoundID);
	m_IsPlaying = false;
}
//------------------------------------------------------------------------------
- (bool)ChangeVolume :(float)value
{
    M_THROW_EXCEPTION("Not implemented");
}
//------------------------------------------------------------------------------
- (void)Loop :(bool)value
{
    M_THROW_EXCEPTION("Not implemented");
}
//------------------------------------------------------------------------------
static void OnPlayCompleted(SystemSoundID soundID, void* pSender)
{
	[(IP_SoundPlayer*)pSender Stop];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
