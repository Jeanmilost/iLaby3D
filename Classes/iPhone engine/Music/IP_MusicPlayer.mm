/*****************************************************************************
 * ==> IP_MusicPlayer -------------------------------------------------------*
 * ***************************************************************************
 * Description : Simple music player class                                   *
 * Developper  : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "IP_MusicPlayer.h"

//------------------------------------------------------------------------------
// class IP_MusicPlayer - objective c
//------------------------------------------------------------------------------
@implementation IP_MusicPlayer
//------------------------------------------------------------------------------
- (id)init
{
	m_pPlayer = nil;

    if (self = [super init])
    {}

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
	if (m_pPlayer)
        [m_pPlayer release];

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

	NSURL* pFileURL = [[NSURL alloc]initFileURLWithPath:pSoundFilePath];

	if (pFileURL == nil)
	{
		NSLog(@"Load sound failed - cannot build URL sound path");
		return false;
	}

	m_pPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:pFileURL error:nil];

	[pFileURL release];

	if (m_pPlayer != nil)
	{
        [m_pPlayer prepareToPlay];
        m_pPlayer.numberOfLoops = 0;
		return true;
	}
	else
	{
		NSLog(@"Load sound failed - cannot create player");
		return false;
	}
}
//------------------------------------------------------------------------------
- (void)PrepareToPlay
{
	if (m_pPlayer != nil)
        [m_pPlayer prepareToPlay];
}
//------------------------------------------------------------------------------
- (bool)Play
{
	if (m_pPlayer == nil)
		return false;

    [m_pPlayer play];
	return true;
}
//------------------------------------------------------------------------------
- (bool)Pause
{
	if (m_pPlayer == nil)
		return false;

    [m_pPlayer pause];
	return true;
}
//------------------------------------------------------------------------------
- (bool)Stop
{
	if (m_pPlayer == nil)
		return false;

    [m_pPlayer stop];
	return true;
}
//------------------------------------------------------------------------------
- (bool)IsPlaying
{
    if (m_pPlayer)
        return m_pPlayer.playing;
    else
        return false;
}
//------------------------------------------------------------------------------
- (bool)ChangeVolume :(float)value
{
	if (m_pPlayer == nil)
		return false;

    if (value >= 0.0f && value <= 1.0f)
    {
        m_pPlayer.volume = value;
        return true;
    }
    else
        return false;
}
//------------------------------------------------------------------------------
- (void)Loop :(bool)value
{
    m_pPlayer.numberOfLoops = (value) ? -1 : 0;
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
