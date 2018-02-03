/*****************************************************************************
 * ==> IP_ALSoundPlayer -----------------------------------------------------*
 * ***************************************************************************
 * Description : Class to play a simple sound based on OpenAL system         *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_ALSoundPlayer.h"
#import <AudioToolbox/AudioFile.h>

//------------------------------------------------------------------------------
// class IP_ALSoundPlayer - objective c
//------------------------------------------------------------------------------
@implementation IP_ALSoundPlayer
//------------------------------------------------------------------------------
- (id)init
{
    m_pDevice  = NULL;
    m_pContext = NULL;
    m_ID       = 0xFFFFFFFF;
    m_BufferID = 0xFFFFFFFF;
    m_ErrorID  = 0xFFFFFFFF;

    if (self = [super init])
    {}

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [self ReleaseOpenAL];
    [super dealloc];
}
//------------------------------------------------------------------------------
- (void)ReleaseOpenAL
{
    // delete the sources
    if (m_ID != m_ErrorID)
    {
        alDeleteSources(1, &m_ID);
        m_ID = m_ErrorID;
    }

    // delete the buffers
    if (m_BufferID != m_ErrorID)
    {
        alDeleteBuffers(1, &m_BufferID);
        m_BufferID = m_ErrorID;
    }

    // destroy the context
    if (m_pContext)
    {
        alcDestroyContext(m_pContext);
        m_pContext = NULL;
    }

    // close the device
    if (m_pDevice)
    {
        alcCloseDevice(m_pDevice);
        m_pDevice = NULL;
    }
}
//------------------------------------------------------------------------------
- (bool)Load :(NSString*)pResourceName :(NSString*)pExtension
{
    [self ReleaseOpenAL];

    // select the "preferred device"
    m_pDevice = alcOpenDevice(NULL);

    if (!m_pDevice)
    {
        NSLog(@"Load sound failed - unable to obtain OpenAL device");
        return false;
    }

    // use the device to make a context
    m_pContext = alcCreateContext(m_pDevice, NULL);

    if (!m_pContext)
    {
        NSLog(@"Load sound failed - unable to obtain OpenAL device context");
        return false;
    }

    // set my context to the currently active one
    alcMakeContextCurrent(m_pContext);

	NSString* pSoundFilePath = [[NSBundle mainBundle]pathForResource:pResourceName ofType:pExtension];

	if (pSoundFilePath == nil)
	{
		NSLog(@"Load sound failed - cannot build sound path");
		return false;
	}

    // use the NSURl instead of a cfurlref cuz it is easier
    NSURL* pFileURL = [[NSURL alloc]initFileURLWithPath:pSoundFilePath];

	if (pFileURL == nil)
	{
		NSLog(@"Load sound failed - cannot build URL sound path");
		return false;
	}

    AudioFileID fileID;

    // do some platform specific stuff..
    #if TARGET_OS_IPHONE
        OSStatus result = AudioFileOpenURL((CFURLRef)pFileURL, kAudioFileReadPermission, 0, &fileID);
    #else
        OSStatus result = AudioFileOpenURL((CFURLRef)pFileURL, fsRdPerm, 0, &fileID);
    #endif

    if (result != 0)
    {
        NSLog(@"Load sound failed - cannot open file: %@", pFileURL);
        return false;
    }

    UInt64 dataSize = 0;
    UInt32 propSize = sizeof(UInt64);

    result = AudioFileGetProperty(fileID, kAudioFilePropertyAudioDataByteCount, &propSize, &dataSize);

    if (result != 0)
    {
        NSLog(@"Load sound failed - cannot find file size");
        return false;
    }

    // find out how big the actual audio data is
    UInt32 fileSize = (UInt32)dataSize;

    // this is where the audio data will live for the moment
    unsigned char* pOutData = new unsigned char[fileSize];

    // this where we actually get the bytes from the file and put them into the data buffer
    result = AudioFileReadBytes(fileID, false, 0, &fileSize, pOutData);

    // close the file
    AudioFileClose(fileID);

    bool success = false;

    if (result != 0)
        NSLog(@"Load sound failed - cannot load effect: %@", pFileURL);
    else
    {
        // grab a buffer ID from openAL
        alGenBuffers(1, &m_BufferID);

        // jam the audio data into the new buffer
        alBufferData(m_BufferID, AL_FORMAT_STEREO16, pOutData, fileSize, 44100); 

        // grab a source ID from openAL
        alGenSources(1, &m_ID); 

        // attach the buffer to the source
        alSourcei(m_ID, AL_BUFFER, m_BufferID);

        // set some basic source prefs
        alSourcef(m_ID, AL_PITCH, 1.0f);

        success = true;
    }

    // clean up the buffer
    if (pOutData)
    {
        delete[] pOutData;
        pOutData = NULL;
    }

    return success;
}
//------------------------------------------------------------------------------
- (bool)Play
{
    if (m_ID == m_ErrorID)
        return false;

    alSourcePlay(m_ID);
    return true;
}
//------------------------------------------------------------------------------
- (bool)Pause
{
    if (m_ID == m_ErrorID)
        return false;

    alSourcePause(m_ID);
    return true;
}
//------------------------------------------------------------------------------
- (bool)Stop
{
    if (m_ID == m_ErrorID)
        return false;

    alSourceStop(m_ID);
    return true;
}
//------------------------------------------------------------------------------
- (bool)IsPlaying
{
    if (m_ID == m_ErrorID)
        return false;

    ALenum state;
    alGetSourcei(m_ID, AL_SOURCE_STATE, &state);
    return (state == AL_PLAYING);
}
//------------------------------------------------------------------------------
- (bool)ChangeVolume :(float)value
{
    if (m_ID == m_ErrorID)
        return false;

    if (value >= 0.0f && value <= 1.0f)
    {
        alSourcef(m_ID, AL_GAIN, value);
        return true;
    }
    else
        return false;
}
//------------------------------------------------------------------------------
- (void)Loop :(bool)value
{
    if (m_ID != m_ErrorID)
        alSourcei(m_ID, AL_LOOPING, AL_TRUE);
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
