/*****************************************************************************
 * ==> GM_Welcome -----------------------------------------------------------*
 * ***************************************************************************
 * Description : Welcome class                                               *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#import "GM_Welcome.h"
#import "IP_Constants.h"
#import "IP_CatchMacros.h"
#include "E_MemoryTools.h"
#include "E_Collisions.h"
#include <map>
#include <sstream>

//------------------------------------------------------------------------------
#define M_Offset_Max        300.0f
#define M_Settings_FileName "settings.ini"
//------------------------------------------------------------------------------
// class GM_Welcome - objective c
//------------------------------------------------------------------------------
@implementation GM_Welcome
//------------------------------------------------------------------------------
- (id)init
{
    m_Offset                            = 0.0f;
    m_SoundSlidePos                     = 128.0f;
    m_MusicSlidePos                     = 128.0f;
    m_SizeSlidePos                      = 0.0f;
    m_ToggleSettings                    = false;
    m_Time                              = CFAbsoluteTimeGetCurrent();
    m_pCamera                           = nil;
    m_pMusic                            = nil;
    m_pOnBeginGame_Underground_Delegate = nil;
    m_pOnBeginGame_Trees_Delegate       = nil;
    m_pOnBeginGame_Snow_Delegate        = nil;
    m_pOnBeginGame_Mars_Delegate        = nil;
    m_pOnExitDelegate                   = nil;

    for (unsigned i = 0; i < M_Nb_Welcome_Textures; ++i)
        m_pTexture[i] = nil;

    for (unsigned i = 0; i < M_Nb_Welcome_Sprites; ++i)
        m_pSprite[i] = nil;

    if (self = [super init])
    {
        [self OpenSettingsFromFile:M_Settings_FileName];
        m_pCamera = [[IP_Camera alloc]init];
    }

    return self;
}
//------------------------------------------------------------------------------
- (void)dealloc
{
    [self SaveSettingsToFile:M_Settings_FileName];

    if (m_pOnBeginGame_Underground_Delegate)
    {
        [m_pOnBeginGame_Underground_Delegate release];
        m_pOnBeginGame_Underground_Delegate = nil;
    }

    if (m_pOnBeginGame_Trees_Delegate)
    {
        [m_pOnBeginGame_Trees_Delegate release];
        m_pOnBeginGame_Trees_Delegate = nil;
    }

    if (m_pOnBeginGame_Snow_Delegate)
    {
        [m_pOnBeginGame_Snow_Delegate release];
        m_pOnBeginGame_Snow_Delegate = nil;
    }

    if (m_pOnBeginGame_Mars_Delegate)
    {
        [m_pOnBeginGame_Mars_Delegate release];
        m_pOnBeginGame_Mars_Delegate = nil;
    }

    if (m_pOnExitDelegate)
    {
        [m_pOnExitDelegate release];
        m_pOnExitDelegate = nil;
    }

    if (m_pMusic)
        [m_pMusic release];

    if (m_pCamera)
        [m_pCamera release];

    for (unsigned i = 0; i < M_Nb_Welcome_Textures; ++i)
        [m_pTexture[i] release];

    for (unsigned i = 0; i < M_Nb_Welcome_Sprites; ++i)
        [m_pSprite[i] release];

    [super dealloc];
}
//------------------------------------------------------------------------------
- (bool)Open :(const GLint&)backingWidth :(const GLint&)backingHeight
{
    M_Try
    {
        // initialize music
        if (!m_pMusic)
        {
            m_pMusic = [[IP_MusicPlayer alloc]init];
            [m_pMusic Load :@"iLaby3D (Version 1)" :@"mp3"];
            [m_pMusic ChangeVolume:([self GetMusicVolume] / 100.0f)];
        }

        // initialize new camera
        if (m_pCamera)
            [m_pCamera Initialize :backingWidth :backingHeight :10.0f];

        for (unsigned i = 0; i < M_Nb_Welcome_Textures; ++i)
            m_pTexture[i] = [[IP_Texture alloc]init];

        [m_pTexture[0]  Load :@"Logo_Big" :@"png"];
        [m_pTexture[1]  Load :@"Underground_Screenshot" :@"jpg"];
        [m_pTexture[2]  Load :@"Trees_Screenshot" :@"jpg"];
        [m_pTexture[3]  Load :@"Snow_Screenshot" :@"jpg"];
        [m_pTexture[4]  Load :@"Mars_Screenshot" :@"jpg"];
        [m_pTexture[5]  Load :@"Settings_Button_No_Text" :@"png"];
        [m_pTexture[6]  Load :@"Settings_Button_Push_No_Text" :@"png"];
        [m_pTexture[7]  Load :@"Exit_Button_No_Text" :@"png"];
        [m_pTexture[8]  Load :@"Exit_Button_Push_No_Text" :@"png"];
        [m_pTexture[9]  Load :@"Slide_BG" :@"png"];
        [m_pTexture[10] Load :@"Slide" :@"png"];
        [m_pTexture[11] Load :@"MPhone" :@"png"];
        [m_pTexture[12] Load :@"Note" :@"png"];
        [m_pTexture[13] Load :@"Size" :@"png"];
        [m_pTexture[14] Load :@"Exit_Settings_Button_No_Text" :@"png"];
        [m_pTexture[15] Load :@"Exit_Settings_Button_Push_No_Text" :@"png"];

        for (unsigned i = 0; i < M_Nb_Welcome_Sprites; ++i)
        {
            m_pSprite[i]            = [[IP_Sprite alloc]init];
            m_pSprite[i].m_UseOrtho = true;
        }

        [m_pSprite[IE_Logo] Create:100.0f :100.0f];
        [m_pSprite[IE_Logo] Set :E_Vector3D(0.0f, -160.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Logo].m_pTexture = m_pTexture[0];

        [m_pSprite[IE_Level_Underground] Create:100.0f :100.0f];
        [m_pSprite[IE_Level_Underground] Set :E_Vector3D(-55.0f, -10.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Level_Underground].m_pTexture = m_pTexture[1];

        [m_pSprite[IE_Level_Trees] Create:100.0f :100.0f];
        [m_pSprite[IE_Level_Trees] Set :E_Vector3D(55.0f, -10.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Level_Trees].m_pTexture = m_pTexture[2];

        [m_pSprite[IE_Level_Snow] Create:100.0f :100.0f];
        [m_pSprite[IE_Level_Snow] Set :E_Vector3D(-55.0f, 100.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Level_Snow].m_pTexture = m_pTexture[3];

        [m_pSprite[IE_Level_Mars] Create:100.0f :100.0f];
        [m_pSprite[IE_Level_Mars] Set :E_Vector3D(55.0f, 100.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Level_Mars].m_pTexture = m_pTexture[4];

        [m_pSprite[IE_Button_Settings] Create:100.0f :24.0f];
        [m_pSprite[IE_Button_Settings] Set :E_Vector3D(-55.0f, 220.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Button_Settings].m_pTexture = m_pTexture[5];

        [m_pSprite[IE_Button_Quit] Create:100.0f :24.0f];
        [m_pSprite[IE_Button_Quit] Set :E_Vector3D(55.0f, 220.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Button_Quit].m_pTexture = m_pTexture[7];

        [m_pSprite[IE_Logo_Sound] Create:32.0f :32.0f];
        [m_pSprite[IE_Logo_Sound] Set :E_Vector3D(M_Offset_Max, -64.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Logo_Sound].m_pTexture = m_pTexture[11];

        [m_pSprite[IE_Slide_Sound_BG] Create:256.0f :8.0f];
        [m_pSprite[IE_Slide_Sound_BG] Set :E_Vector3D(M_Offset_Max, -30.0f, 2.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Slide_Sound_BG].m_pTexture = m_pTexture[9];

        [m_pSprite[IE_Slide_Sound] Create:16.0f :16.0f];
        [m_pSprite[IE_Slide_Sound] Set :E_Vector3D(m_SoundSlidePos + M_Offset_Max, -30.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Slide_Sound].m_pTexture = m_pTexture[10];

        [m_pSprite[IE_Logo_Music] Create:32.0f :32.0f];
        [m_pSprite[IE_Logo_Music] Set :E_Vector3D(M_Offset_Max, 26.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Logo_Music].m_pTexture = m_pTexture[12];

        [m_pSprite[IE_Slide_Music_BG] Create:256.0f :8.0f];
        [m_pSprite[IE_Slide_Music_BG] Set :E_Vector3D(M_Offset_Max, 60.0f, 2.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Slide_Music_BG].m_pTexture = m_pTexture[9];

        [m_pSprite[IE_Slide_Music] Create:16.0f :16.0f];
        [m_pSprite[IE_Slide_Music] Set :E_Vector3D(m_MusicSlidePos + M_Offset_Max, 60.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Slide_Music].m_pTexture = m_pTexture[10];

        [m_pSprite[IE_Logo_Size] Create:32.0f :32.0f];
        [m_pSprite[IE_Logo_Size] Set :E_Vector3D(M_Offset_Max, 116.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Logo_Size].m_pTexture = m_pTexture[13];

        [m_pSprite[IE_Slide_Size_BG] Create:256.0f :8.0f];
        [m_pSprite[IE_Slide_Size_BG] Set :E_Vector3D(M_Offset_Max, 150.0f, 2.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Slide_Size_BG].m_pTexture = m_pTexture[9];

        [m_pSprite[IE_Slide_Size] Create:16.0f :16.0f];
        [m_pSprite[IE_Slide_Size] Set :E_Vector3D(m_SizeSlidePos + M_Offset_Max, 150.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Slide_Size].m_pTexture = m_pTexture[10];

        [m_pSprite[IE_Button_Close_Settings] Create:100.0f :24.0f];
        [m_pSprite[IE_Button_Close_Settings] Set :E_Vector3D(M_Offset_Max, 220.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
        m_pSprite[IE_Button_Close_Settings].m_pTexture = m_pTexture[14];

        // this is a litthe "hack" to avoid that the button is visible with a blank texture the first time the user click on
        m_pSprite[IE_Button_Settings].m_pTexture = m_pTexture[6];
        [m_pSprite[IE_Button_Settings] Render];
        m_pSprite[IE_Button_Settings].m_pTexture = m_pTexture[5];
        m_pSprite[IE_Button_Quit].m_pTexture = m_pTexture[8];
        [m_pSprite[IE_Button_Quit] Render];
        m_pSprite[IE_Button_Quit].m_pTexture = m_pTexture[7];
        m_pSprite[IE_Button_Close_Settings].m_pTexture = m_pTexture[15];
        [m_pSprite[IE_Button_Close_Settings] Render];
        m_pSprite[IE_Button_Close_Settings].m_pTexture = m_pTexture[14];

        m_Ready = true;
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

        glCullFace(GL_FRONT);

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

        [m_pMusic Play];
        [self SetControls];

        // set user point of view
        if (m_pCamera)
            [m_pCamera CreateOrtho];
        else
            M_THROW_EXCEPTION("Camera is not created");

        for (unsigned i = 0; i < M_Nb_Welcome_Sprites; ++i)
            if (m_pSprite[i])
                [m_pSprite[i] Render];

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
    if (!m_HasFocus)
        return;

    m_pSprite[IE_Button_Settings].m_pTexture       = m_pTexture[5];
    m_pSprite[IE_Button_Quit].m_pTexture           = m_pTexture[7];
    m_pSprite[IE_Button_Close_Settings].m_pTexture = m_pTexture[14];

    for (unsigned i = 0; i < M_Nb_Welcome_Sprites; ++i)
    {
        E_PolygonContainer* pCurrentPolygon = m_pSprite[i].m_pPolygonList->GetFirst();	

        // iterate through all polygons contined in the sprite
        while (pCurrentPolygon != NULL)
        {
            E_Vector3D pointOnPlane;
            bool       coplanar;

            E_Polygon* pPolygon = pCurrentPolygon->GetPolygon();
            M_Assert(pPolygon);

            E_Polygon testPolygon = pPolygon->ApplyMatrix(m_pSprite[i].m_WorldMatrix);

            // calculate the intersection point
            pointOnPlane = E_Maths::PlaneIntersectLine(testPolygon.GetPlane(),
                                                       E_Vector3D(-IP_Constants::m_OrthoScreen_X + position.x,
                                                                  -IP_Constants::m_OrthoScreen_Y + position.y,
                                                                  0.0f),
                                                       E_Vector3D(-IP_Constants::m_OrthoScreen_X + position.x,
                                                                  -IP_Constants::m_OrthoScreen_Y + position.y,
                                                                  10.0f),
                                                       coplanar);

            // check if calculated point is inside the polygon
            if (E_Collisions::IsPointInTriangle(pointOnPlane, testPolygon) == true)
            {
                switch (i)
                {
                    case IE_Level_Underground:
                        if (end && m_pOnBeginGame_Underground_Delegate)
                        {
                            if (m_pMusic)
                                [m_pMusic Stop];

                            [m_pOnBeginGame_Underground_Delegate Call];
                        }

                        break;

                    case IE_Level_Trees:
                        if (end && m_pOnBeginGame_Trees_Delegate)
                        {
                            if (m_pMusic)
                                [m_pMusic Stop];

                            [m_pOnBeginGame_Trees_Delegate Call];
                        }

                        break;

                    case IE_Level_Snow:
                        if (end && m_pOnBeginGame_Snow_Delegate)
                        {
                            if (m_pMusic)
                                [m_pMusic Stop];

                            [m_pOnBeginGame_Snow_Delegate Call];
                        }

                        break;

                    case IE_Level_Mars:
                        if (end && m_pOnBeginGame_Mars_Delegate)
                        {
                            if (m_pMusic)
                                [m_pMusic Stop];

                            [m_pOnBeginGame_Mars_Delegate Call];
                        }

                        break;

                    case IE_Button_Settings:
                        if (end)
                            m_ToggleSettings = true;
                        else
                            m_pSprite[IE_Button_Settings].m_pTexture = m_pTexture[6];

                        break;

                    case IE_Button_Quit:
                        if (end)
                        {
                            if (m_pOnExitDelegate)
                            {
                                if (m_pMusic)
                                    [m_pMusic Stop];

                                [m_pOnExitDelegate Call];
                            }
                                
                            break;
                        }
                        else
                            m_pSprite[IE_Button_Quit].m_pTexture = m_pTexture[8];

                        break;

                    case IE_Button_Close_Settings:
                        if (end)
                            m_ToggleSettings = false;
                        else
                            m_pSprite[IE_Button_Close_Settings].m_pTexture = m_pTexture[15];

                        break;

                    case IE_Slide_Sound:
                    case IE_Slide_Sound_BG:
                    {
                        float newPos = position.x - IP_Constants::m_OrthoScreen_X;

                        if (newPos >= -128.0f && newPos <= 128.0f)
                            m_SoundSlidePos = newPos;

                        break;
                    }

                    case IE_Slide_Music:
                    case IE_Slide_Music_BG:
                    {
                        float newPos = position.x - IP_Constants::m_OrthoScreen_X;

                        if (newPos >= -128.0f && newPos <= 128.0f)
                            m_MusicSlidePos = newPos;

                        if (m_pMusic)
                            [m_pMusic ChangeVolume:([self GetMusicVolume] / 100.0f)];

                        break;
                    }

                    case IE_Slide_Size:
                    case IE_Slide_Size_BG:
                    {
                        float newPos = position.x - IP_Constants::m_OrthoScreen_X;

                        if (newPos >= -128.0f && newPos <= 128.0f)
                            m_SizeSlidePos = newPos;

                        break;
                    }

                    default:
                        M_THROW_EXCEPTION("Unknown interface element");
                }
            }

            // go to next polygon
            pCurrentPolygon = pCurrentPolygon->GetNext();
        }
    }
}
//------------------------------------------------------------------------------
- (float) GetSoundVolume
{
    return (((m_SoundSlidePos + 128.0f) * 100.0f) / 256.0f);
}
//------------------------------------------------------------------------------
- (float) GetMusicVolume
{
    return (((m_MusicSlidePos + 128.0f) * 100.0f) / 256.0f);
}
//------------------------------------------------------------------------------
- (unsigned) GetMazeSize
{
    float    position = (m_SizeSlidePos + (M_Offset_Max - (M_Offset_Max + m_Offset))) + 128.0f;
    unsigned result   = (unsigned)((position * 80.0f) / 256.0f);

    if (result < 5)
        result = 5;

    return result;
}
//------------------------------------------------------------------------------
- (void)OpenSettingsFromFile :(const std::string&)fileName
{
    M_Try
    {
        typedef std::map<std::string, std::string> ISettings;

        FILE* pFile;
        pFile = std::fopen(fileName.c_str(), "r");

        if (pFile != NULL)
        {
            std::fseek(pFile, 0, SEEK_END);
            unsigned size = std::ftell(pFile) + 1;
            std::fseek(pFile, 0, SEEK_SET);

            char fileData[size];
            std::fgets (fileData, size, pFile);

            std::string data  = fileData;
            unsigned    start = 0;
            std::string key;
            std::string value;
            ISettings   settings;

            for (unsigned i = 0; i < data.length(); ++i)
            {
                if (data[i] == '=')
                {
                    key = data.substr(start, i - start);

                    if (data.length() > i + 1)
                        ++i;

                    start = i;
                }
                else
                if (data[i] == '&')
                {
                    value = data.substr(start, i - start);

                    if (data.length() > i + 1)
                        ++i;

                    start         = i;
                    settings[key] = value;
                }
            }

            for (ISettings::iterator it = settings.begin(); it != settings.end(); ++it)
            {
                if ((*it).first == "[SoundVol]")
                    m_SoundSlidePos = atof((*it).second.c_str());
                else
                if ((*it).first == "[MusicVol]")
                    m_MusicSlidePos = atof((*it).second.c_str());
                else
                if ((*it).first == "[Size]")
                    m_SizeSlidePos = atof((*it).second.c_str());
            }
        }
    }
    M_CatchShow
}
//------------------------------------------------------------------------------
- (void)SaveSettingsToFile :(const std::string&)fileName
{
    FILE* pFile;
    pFile = std::fopen(fileName.c_str(), "w");

    if (pFile != NULL)
    {
        std::ostringstream sstr;
        sstr << "[SoundVol]=" << m_SoundSlidePos << "&";
        sstr << "[MusicVol]=" << m_MusicSlidePos << "&";
        sstr << "[Size]=" << m_SizeSlidePos << "&";
        std::fputs(sstr.str().c_str(), pFile);
        std::fclose(pFile);
    }
}
//------------------------------------------------------------------------------
- (void) SetControls
{
    CFTimeInterval now     = CFAbsoluteTimeGetCurrent();
    float          elapsed = now - m_Time;
    m_Time                 = now;

    if (m_ToggleSettings)
    {
        if (m_Offset > -M_Offset_Max)
            m_Offset -= 400.0f * elapsed;
        else
            m_Offset = -M_Offset_Max;
    }
    else
    {
        if (m_Offset < 0.0f)
            m_Offset += 400.0f * elapsed;
        else
            m_Offset = 0.0f;
    }

    if (m_pSprite[IE_Level_Underground])
        [m_pSprite[IE_Level_Underground] Set :E_Vector3D(-55.0f + m_Offset, -10.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Level_Trees])
        [m_pSprite[IE_Level_Trees] Set :E_Vector3D(55.0f + m_Offset, -10.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Level_Snow])
        [m_pSprite[IE_Level_Snow] Set :E_Vector3D(-55.0f + m_Offset, 100.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Level_Mars])
        [m_pSprite[IE_Level_Mars] Set :E_Vector3D(55.0f + m_Offset, 100.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Button_Settings])
        [m_pSprite[IE_Button_Settings] Set :E_Vector3D(-55.0f + m_Offset, 220.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Button_Quit])
        [m_pSprite[IE_Button_Quit] Set :E_Vector3D(55.0f + m_Offset, 220.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Logo_Sound])
        [m_pSprite[IE_Logo_Sound] Set :E_Vector3D(M_Offset_Max + m_Offset, -64.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Slide_Sound_BG])
        [m_pSprite[IE_Slide_Sound_BG] Set :E_Vector3D(M_Offset_Max + m_Offset, -30.0f, 2.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Slide_Sound])
        [m_pSprite[IE_Slide_Sound] Set :E_Vector3D(m_SoundSlidePos + M_Offset_Max + m_Offset, -30.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Logo_Music])
        [m_pSprite[IE_Logo_Music] Set :E_Vector3D(M_Offset_Max + m_Offset, 26.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Slide_Music_BG])
        [m_pSprite[IE_Slide_Music_BG] Set :E_Vector3D(M_Offset_Max + m_Offset, 60.0f, 2.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Slide_Music])
        [m_pSprite[IE_Slide_Music] Set :E_Vector3D(m_MusicSlidePos + M_Offset_Max + m_Offset, 60.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Logo_Size])
        [m_pSprite[IE_Logo_Size] Set :E_Vector3D(M_Offset_Max + m_Offset, 116.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Slide_Size_BG])
        [m_pSprite[IE_Slide_Size_BG] Set :E_Vector3D(M_Offset_Max + m_Offset, 150.0f, 2.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Slide_Size])
        [m_pSprite[IE_Slide_Size] Set :E_Vector3D(m_SizeSlidePos + M_Offset_Max + m_Offset, 150.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];

    if (m_pSprite[IE_Button_Close_Settings])
        [m_pSprite[IE_Button_Close_Settings] Set :E_Vector3D(M_Offset_Max + m_Offset, 220.0f, 1.0f) :E_Vector3D(0.0f, 0.0f, 0.0f) :0.0f];
}
//------------------------------------------------------------------------------
- (void)SetOnBeginGame_Underground_Delegate :(id)pObject :(SEL)pDelegate
{
    if (!m_pOnBeginGame_Underground_Delegate)
        m_pOnBeginGame_Underground_Delegate = [[IP_Delegate alloc]init];

    if (m_pOnBeginGame_Underground_Delegate)
        [m_pOnBeginGame_Underground_Delegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
- (void)SetOnBeginGame_Trees_Delegate :(id)pObject :(SEL)pDelegate
{
    if (!m_pOnBeginGame_Trees_Delegate)
        m_pOnBeginGame_Trees_Delegate = [[IP_Delegate alloc]init];

    if (m_pOnBeginGame_Trees_Delegate)
        [m_pOnBeginGame_Trees_Delegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
- (void)SetOnBeginGame_Snow_Delegate :(id)pObject :(SEL)pDelegate
{
    if (!m_pOnBeginGame_Snow_Delegate)
        m_pOnBeginGame_Snow_Delegate = [[IP_Delegate alloc]init];

    if (m_pOnBeginGame_Snow_Delegate)
        [m_pOnBeginGame_Snow_Delegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
- (void)SetOnBeginGame_Mars_Delegate :(id)pObject :(SEL)pDelegate
{
    if (!m_pOnBeginGame_Mars_Delegate)
        m_pOnBeginGame_Mars_Delegate = [[IP_Delegate alloc]init];

    if (m_pOnBeginGame_Mars_Delegate)
        [m_pOnBeginGame_Mars_Delegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
- (void)SetOnExitDelegate :(id)pObject :(SEL)pDelegate;
{
    if (!m_pOnExitDelegate)
        m_pOnExitDelegate = [[IP_Delegate alloc]init];

    if (m_pOnExitDelegate)
        [m_pOnExitDelegate Set :pObject :pDelegate];
}
//------------------------------------------------------------------------------
@end
//------------------------------------------------------------------------------
