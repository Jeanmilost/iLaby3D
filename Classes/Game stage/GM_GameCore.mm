/*****************************************************************************
 * ==> GM_GameCore ----------------------------------------------------------*
 * ***************************************************************************
 * Description : Core game class                                             *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "GM_GameCore.h"
#import <OpenGLES/ES1/gl.h>
#include <sstream>
#include "E_Random.h"
#include "E_MemoryTools.h"
#include "E_Collisions.h"
#import "IP_OpenGLHelper.h"
#import "IP_CatchMacros.h"

//------------------------------------------------------------------------------
// class GM_GameCore - objective c
//------------------------------------------------------------------------------
@implementation GM_GameCore
//------------------------------------------------------------------------------
@synthesize m_Play;
@synthesize m_Pause;
//------------------------------------------------------------------------------
- (id)init
{
    m_pCamera          = nil;
    m_pWalls           = nil;
    m_pMapButton       = nil;
    m_pPauseButton     = nil;
    m_pMenuButton      = nil;
    m_pUserControl     = nil;
	m_pStep            = nil;
    m_pAmbientSound1   = nil;
    m_pAmbientSound2   = nil;
    m_pOnRunDelegate   = nil;
    m_pOnPauseDelegate = nil;
    m_pOnQuitDelegate  = nil;
    m_pOnWinDelegate   = nil;
    m_LastTime         = 0;
    m_LastPlayedStep   = 0;
    m_BeginsTime       = 0;
    m_Time             = 0;
    m_Volume           = 100.0f;
    m_DisplayMap       = false;
    m_Pause            = false;
    m_Play             = false;
    m_Ready            = false;

    for (unsigned i = 0; i < 4; ++i)
        m_FogColor[i] = 0.0f;
        
    if (self = [super init])
	{
        // create camera, buttons, user control and random number generator
        m_pCamera      = [[IP_Camera alloc]init];
        m_pUserControl = [[IP_UserControl alloc]init];
        m_pMapButton   = [[IP_Button alloc]init:@"Map" :@"png"];
        m_pPauseButton = [[IP_Button alloc]init:@"Pause" :@"png"];
        m_pMenuButton  = [[IP_Button alloc]init:@"Home2" :@"png"];

        if (m_pMapButton)
        {
            m_pMapButton.m_X = 0.29f;
            m_pMapButton.m_Y = 0.85f;
        }

        if (m_pPauseButton)
        {
            m_pPauseButton.m_X = 0.42;
            m_pPauseButton.m_Y = 0.85;
        }

        if (m_pMenuButton)
        {
            m_pMenuButton.m_X = 0.55f;
            m_pMenuButton.m_Y = 0.85f;
        }
    }

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    if (m_pOnRunDelegate)
    {
        [m_pOnRunDelegate release];
        m_pOnRunDelegate = nil;
    }

    if (m_pOnPauseDelegate)
    {
        [m_pOnPauseDelegate release];
        m_pOnPauseDelegate = nil;
    }

    if (m_pOnQuitDelegate)
    {
        [m_pOnQuitDelegate release];
        m_pOnQuitDelegate = nil;
    }

    if (m_pOnWinDelegate)
    {
        [m_pOnWinDelegate release];
        m_pOnWinDelegate = nil;
    }

    [self Clear];

    if (m_pCamera)
        [m_pCamera release];

    if (m_pMapButton)
        [m_pMapButton release];

    if (m_pPauseButton)
        [m_pPauseButton release];

    if (m_pMenuButton)
        [m_pMenuButton release];

    if (m_pUserControl)
        [m_pUserControl release];

    [super dealloc];
}
//------------------------------------------------------------------------------
- (void)Clear
{
    m_LastTime       = 0;
    m_LastPlayedStep = 0;
    m_BeginsTime     = 0;
    m_Time           = 0;
    m_DisplayMap     = false;
    m_Pause          = false;
    m_Play           = false;
    m_Ready          = false;

    if (m_pStep)
    {
        [m_pStep release];
        m_pStep = nil;
    }

    if (m_pAmbientSound1)
    {
        [m_pAmbientSound1 release];
        m_pAmbientSound1 = nil;
    }

    if (m_pAmbientSound2)
    {
        [m_pAmbientSound2 release];
        m_pAmbientSound2 = nil;
    }

    if (m_pWalls)
    {
        [m_pWalls release];
        m_pWalls = nil;
    }
}
//------------------------------------------------------------------------------
- (bool)Open :(IE_Level)level :(unsigned)width :(unsigned)height :(const GLint&)backingWidth :(const GLint&)backingHeight
{
    M_Try
    {
        [self Clear];

        // initialize new camera
        if (m_pCamera)
            [m_pCamera Initialize :backingWidth :backingHeight :0.1f :100.0f];

        // create new level
        switch (level)
        {
            case IE_Underground:
            {
                m_pWalls = [[IP_Walls alloc]init :@"Soil_25_256x256" :@"Wall_Tilleable_64_256x256" :@"Ceiling_100_256x256"];
                [m_pWalls CreateMaze :width :height :true];

                m_pStep = [[IP_ALSoundPlayer alloc]init];
                [m_pStep Load :@"Sound_Step_Underground" :@"wav"];

                m_pAmbientSound1 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound1 Load:@"Goutte_Grotte" :@"mp3"];

                m_pAmbientSound2 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound2 Load:@"Gouttes_souterain_2" :@"mp3"];

                m_Red         = 0.1f;
                m_Green       = 0.1f;
                m_Blue        = 0.1f;
                m_Alpha       = 1.0f;
                m_FogColor[0] = 0.1f;
                m_FogColor[1] = 0.1f;
                m_FogColor[2] = 0.1f;
                m_FogColor[3] = 1.0f;

                break;
            }

            case IE_Trees:
            {
                m_pWalls = [[IP_Walls alloc]init :@"Grass_64_256x256" :@"tree_256_Texturized"];
                [m_pWalls CreateMaze :width :height :false];

                m_pStep = [[IP_ALSoundPlayer alloc]init];
                [m_pStep Load :@"Sound_Step_Grass" :@"wav"];

                m_pAmbientSound1 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound1 Load:@"Bird_Sound_1" :@"mp3"];

                m_pAmbientSound2 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound2 Load:@"Bird_Sound_2" :@"mp3"];

                m_Red         = (GLfloat)64 / (GLfloat)255;
                m_Green       = (GLfloat)129 / (GLfloat)255;
                m_Blue        = (GLfloat)219 / (GLfloat)255;
                m_Alpha       = 1.0f;
                m_FogColor[0] = (GLfloat)64 / (GLfloat)255;
                m_FogColor[1] = (GLfloat)129 / (GLfloat)255;
                m_FogColor[2] = (GLfloat)219 / (GLfloat)255;
                m_FogColor[3] = 1.0f;

                break;
            }

            case IE_Snow:
            {
                m_pWalls = [[IP_Walls alloc]init :@"Snow_Soil_100_256x256" :@"Snow_Walls_100_256x256"];
                [m_pWalls CreateMaze :width :height :false];

                m_pStep = [[IP_ALSoundPlayer alloc]init];
                [m_pStep Load :@"Sound_Step_Snow" :@"wav"];

                m_pAmbientSound1 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound1 Load:@"Sound_Wind_1" :@"mp3"];

                m_pAmbientSound2 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound2 Load:@"Sound_Wind_2" :@"mp3"];

                m_Red         = (GLfloat)122 / (GLfloat)255;
                m_Green       = (GLfloat)125 / (GLfloat)255;
                m_Blue        = (GLfloat)168 / (GLfloat)255;
                m_Alpha       = 1.0f;
                m_FogColor[0] = (GLfloat)122 / (GLfloat)255;
                m_FogColor[1] = (GLfloat)125 / (GLfloat)255;
                m_FogColor[2] = (GLfloat)168 / (GLfloat)255;
                m_FogColor[3] = 1.0f;

                break;
            }

            case IE_OnMars:
            {
                m_pWalls = [[IP_Walls alloc]init :@"Soil_Mars_100_256x256" :@"Wall_Mars_64_256x256"];
                [m_pWalls CreateMaze :width :height :false];

                m_pStep = [[IP_ALSoundPlayer alloc]init];
                [m_pStep Load :@"Sound_Step_Sand" :@"wav"];

                m_pAmbientSound1 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound1 Load:@"Sound_Mars_1" :@"mp3"];

                m_pAmbientSound2 = [[IP_MusicPlayer alloc]init];
                [m_pAmbientSound2 Load:@"Sound_Mars_2" :@"mp3"];

                m_Red         = (GLfloat)249 / (GLfloat)255;
                m_Green       = (GLfloat)209 / (GLfloat)255;
                m_Blue        = (GLfloat)160 / (GLfloat)255;
                m_Alpha       = 1.0f;
                m_FogColor[0] = (GLfloat)249 / (GLfloat)255;
                m_FogColor[1] = (GLfloat)209 / (GLfloat)255;
                m_FogColor[2] = (GLfloat)160 / (GLfloat)255;
                m_FogColor[3] = 1.0f;

                break;
            }

            default:
                M_THROW_EXCEPTION("Unknown level type");
        }

        g_Player.m_Position = [m_pWalls GetStartPosition];
        m_BeginsTime        = CFAbsoluteTimeGetCurrent();
        m_LastTime          = CFAbsoluteTimeGetCurrent();
        m_Play              = true;
        m_Ready             = true;

        if (m_pWalls)
            [m_pWalls SetOnWinDelegate:self :@selector(OnWin)];

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (void)OnDrawBegin
{
    M_Try
    {
        if (!m_Ready)
            return;

        [self PrepareSoundVolume];

        glCullFace(GL_BACK);

        // calculate new position and play sounds only if game is playing and if game is not paused
        if (m_Play && !m_Pause)
            // calculate player position
            if (![self SetPlayer])
            {
                m_Ready = false;
                return;
            }

        // set fog
        if (![self SetFog])
        {
            m_Ready = false;
            return;
        }

        [super OnDrawBegin];

        return;
    }
    M_CatchShow

    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnDraw
{
    M_Try
    {
        if (!m_Ready)
            return;

        // set user point of view
        [m_pCamera CreateProjection];

        // draw the maze
        if (![m_pWalls Render :g_Player.m_Position])
        {
            m_Ready = false;
            return;
        }

        // buttons and user controls are hidden if map is visible or if game is playing
        if (m_Play && !m_DisplayMap)
        {
            // draw map button
            if (m_pMapButton)
                [m_pMapButton Render];

            // draw pause button
            if (m_pPauseButton)
                [m_pPauseButton Render];

            // draw menu button
            if (m_pMenuButton)
                [m_pMenuButton Render];

            // draw user control
            if (m_pUserControl)
                [m_pUserControl Render];
        }

        [super OnDraw];

        return;
    }
    M_CatchShow

    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnDrawEnd
{
    M_Try
    {
        if (!m_Ready)
            return;

        [super OnDrawEnd];

        return;
    }
    M_CatchShow

    m_Ready = false;
}
//------------------------------------------------------------------------------
- (void)OnControlMoves :(const CGPoint&)position :(bool)end
{
    if (!m_HasFocus || !m_Play)
        return;

    if (m_pMapButton && [m_pMapButton IsClicked:position])
    {
        if (end && !m_Pause && !m_DisplayMap)
        {
            m_DisplayMap = true;

            if (m_pWalls)
                m_pWalls.m_ShowMap = true;
        }
    }
    else
    if (m_pPauseButton && [m_pPauseButton IsClicked:position])
    {
        if (end && !m_Pause && !m_DisplayMap)
        {
            m_Pause = true;
            m_Time  = CFAbsoluteTimeGetCurrent();

            if (m_pOnPauseDelegate)
                [m_pOnPauseDelegate Call];
        }
    }
    else
    if (m_pMenuButton && [m_pMenuButton IsClicked:position])
    {
        if (end && !m_Pause && !m_DisplayMap)
        {
            m_Pause = true;
            m_Time  = CFAbsoluteTimeGetCurrent();

            if (m_pOnPauseDelegate)
                [m_pOnPauseDelegate Call];

            if (m_pOnQuitDelegate)
                [m_pOnQuitDelegate Call];
        }
    }
    else
    {
        if (m_DisplayMap)
        {
            m_DisplayMap = false;

            if (m_pWalls)
                m_pWalls.m_ShowMap = false;
        }

        if (m_Pause)
        {
            if (m_pOnRunDelegate)
                [m_pOnRunDelegate Call];

            m_Pause      = false;
            m_BeginsTime = m_BeginsTime + (CFAbsoluteTimeGetCurrent() - m_Time);
        }

        // respond to user control
        if (end)
            [m_pUserControl ResetPosition];
        else
            [m_pUserControl SetPosition :position];
    }
}
//------------------------------------------------------------------------------
- (void)OnWin
{
    m_Play = false;

    if (m_pOnWinDelegate)
        [m_pOnWinDelegate Call];
}
//------------------------------------------------------------------------------
- (void)StopAllSounds
{
    if (m_pStep)
        [m_pStep Stop];

    if (m_pAmbientSound1)
        [m_pAmbientSound1 Stop];

    if (m_pAmbientSound2)
        [m_pAmbientSound2 Stop];
}
//------------------------------------------------------------------------------
- (void)PrepareSoundVolume
{
    if (m_pStep)
        [m_pStep ChangeVolume:(m_Volume / 100.0f)];

    if (m_pAmbientSound1)
        [m_pAmbientSound1 ChangeVolume:(m_Volume / 100.0f)];

    if (m_pAmbientSound2)
        [m_pAmbientSound2 ChangeVolume:(m_Volume / 100.0f)];
}
//------------------------------------------------------------------------------
- (bool)SetPlayer
{
    M_Try
    {
        E_Vector3D     oldPosition = g_Player.m_Position;
        CFTimeInterval now         = CFAbsoluteTimeGetCurrent();
        float          elapsed     = now - m_LastTime;
        m_LastTime                 = now;

        // calculate time based player position and direction velocities
        float timedDirVelocity = g_Player.m_DirVelocity * (elapsed * 25.0f);
        float timedPosVelocity = g_Player.m_PosVelocity * (elapsed * 25.0f);

        timedDirVelocity = (timedDirVelocity > g_Player.m_DirVelocity) ? g_Player.m_DirVelocity : timedDirVelocity;
        timedPosVelocity = (timedPosVelocity > g_Player.m_PosVelocity) ? g_Player.m_PosVelocity : timedPosVelocity;

        // update player direction
        g_Player.m_Rotation  = E_Vector3D(0.0f, 1.0f, 0.0f);
        g_Player.m_Angle    -= [m_pUserControl UpdateDirVelocity :timedDirVelocity];

        if (g_Player.m_Angle >= 360.0f)
            g_Player.m_Angle -= 360.0f;
        else
        if (g_Player.m_Angle < 0.0f)
            g_Player.m_Angle += 360.0f;

        float angle = M_DegToRad(g_Player.m_Angle) + (M_PI / 2);

        if (angle >= (M_PI * 2))
            angle -= (M_PI * 2);
        else
        if (angle < 0.0f)
            angle += (M_PI * 2);

        g_Player.m_Direction.m_X  = (float)cosf(angle);
        g_Player.m_Direction.m_Z  = (float)sinf(angle);

        // calculate player next position
        E_Vector3D nextPosition = g_Player.m_Position;

        float posVelocity = [m_pUserControl UpdatePosVelocity :timedPosVelocity];

        nextPosition.m_X -= (posVelocity * g_Player.m_Direction.m_X);
        nextPosition.m_Z -= (posVelocity * g_Player.m_Direction.m_Z);

        std::vector<E_Plane> planes;
        bool                 multipleCells;

        // check collisions
        if (![m_pWalls CheckCollisions:nextPosition :planes : multipleCells])
            return false;

        // no collision was found
        if (planes.size() == 0)
        {
            g_Player.m_Position = nextPosition;
            m_LastPlane = E_Plane(0.0f, 0.0f, 0.0f, 0.0f);
        }
        else
        // only one wall is in collision
        if (planes.size() == 1)
        {
            g_Player.m_Position = -(E_Collisions::GetSlidingPoint(planes[0],
                                                                  -nextPosition,
                                                                  g_Player.m_Radius));

            m_LastPlane = planes[0];
        }
        // more than 1 wall are in collision
        else
        {
            bool sameCollision = true;

            // check if sliding planes are the same
            for (unsigned i = 0; i < planes.size(); ++i)
                if (!E_Maths::ComparePlanes(planes[0], planes[i], 0.001f) && !E_Maths::ComparePlanes(planes[0], -planes[i], 0.001f))
                {
                    sameCollision = false;
                    break;
                }

            if (sameCollision)
            {
                g_Player.m_Position = -(E_Collisions::GetSlidingPoint(planes[0],
                                                                      -nextPosition,
                                                                      g_Player.m_Radius));

                m_LastPlane = planes[0];
            }
            else
            // check if collision happened with a convex edge (if collision implies more than 1 cell, the edge is necessarly convex)
            if (planes.size() == 2 && multipleCells)
            {
                // continue sliding on the same plane, if exists
                if (m_LastPlane != E_Plane(0.0f, 0.0f, 0.0f, 0.0f))
                    g_Player.m_Position = -(E_Collisions::GetSlidingPoint(m_LastPlane,
                                                                          -nextPosition,
                                                                          g_Player.m_Radius));
            }
            else
                m_LastPlane = E_Plane(0.0f, 0.0f, 0.0f, 0.0f);
        }

        // play step sound
        if (g_Player.m_Position != oldPosition)
        {
            // calculate sound frequency: most travel is faster, most the sound is repeated rapidly
            float soundElapsed  = ((now < 0) ? 0 - now : now) - m_LastPlayedStep;
            float soundVelocity = [m_pUserControl UpdatePosVelocity :1.0f];
                  soundVelocity = soundVelocity < 0.0f ? -soundVelocity : soundVelocity;
            float tickPlaySound = 0.1f / soundVelocity;

            if (soundElapsed >= tickPlaySound)
            {
                if (![m_pStep IsPlaying])
                    [m_pStep Play];

                m_LastPlayedStep = now;
            }
        }

        unsigned randomNumber = E_Random::GetNumber(10000);

        // play first ambient sound
        if (m_pAmbientSound1 && m_pAmbientSound2 && ![m_pAmbientSound1 IsPlaying] && ![m_pAmbientSound2 IsPlaying] && (randomNumber == 350
                || randomNumber == 2760 || randomNumber == 4450 || randomNumber == 9760))
            [m_pAmbientSound1 Play];

        // play second ambient sound
        if (m_pAmbientSound1 && m_pAmbientSound2 && ![m_pAmbientSound1 IsPlaying] && ![m_pAmbientSound2 IsPlaying] && (randomNumber == 860
                || randomNumber == 1440 || randomNumber == 6230 || randomNumber == 8440))
            [m_pAmbientSound2 Play];

        // check if player has found an object (key, door, ...)
        [m_pWalls OnCheckFoundObject :g_Player.m_Position];

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (bool)SetFog
{
    M_Try
    {
        glEnable(GL_FOG);
        glFogf(GL_FOG_MODE, GL_LINEAR);
        glFogfv(GL_FOG_COLOR, m_FogColor);
        glHint(GL_FOG_HINT, GL_DONT_CARE);
        glFogf(GL_FOG_START, 1.0f);
        glFogf(GL_FOG_END, 100.0f);

        return true;
    }
    M_CatchShow

    return false;
}
//------------------------------------------------------------------------------
- (void)SetVolume :(float)volume
{
    m_Volume = volume;
}
//------------------------------------------------------------------------------
- (CFTimeInterval)GetElapsedTime
{
    if (m_Pause)
        return m_Time - m_BeginsTime;
    else
        return CFAbsoluteTimeGetCurrent() - m_BeginsTime;
}
//------------------------------------------------------------------------------
- (std::wstring)FormatTime :(const CFTimeInterval&)time
{
    CFGregorianDate gregorianDate = CFAbsoluteTimeGetGregorianDate(time, NULL);

    std::wostringstream sstr;
    sstr.width(2);
    sstr.fill('0');
    sstr << gregorianDate.hour;
    sstr << L":";
    sstr.width(2);
    sstr.fill('0');
    sstr << gregorianDate.minute;
    sstr << L":";
    sstr.width(2);
    sstr.fill('0');
    sstr << (unsigned)(gregorianDate.second);

    return sstr.str();
}
//------------------------------------------------------------------------------
- (void)SetOnRunDelegate :(id)pObject :(SEL)pDelegate;
{
    if (!m_pOnRunDelegate)
        m_pOnRunDelegate = [[IP_Delegate alloc]init];

    if (m_pOnRunDelegate)
        [m_pOnRunDelegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
- (void)SetOnPauseDelegate :(id)pObject :(SEL)pDelegate
{
    if (!m_pOnPauseDelegate)
        m_pOnPauseDelegate = [[IP_Delegate alloc]init];

    if (m_pOnPauseDelegate)
        [m_pOnPauseDelegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
- (void)SetOnQuitDelegate :(id)pObject :(SEL)pDelegate
{
    if (!m_pOnQuitDelegate)
        m_pOnQuitDelegate = [[IP_Delegate alloc]init];

    if (m_pOnQuitDelegate)
        [m_pOnQuitDelegate Set :pObject :pDelegate];
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
