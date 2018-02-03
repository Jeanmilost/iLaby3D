/*****************************************************************************
 * ==> E_Log ----------------------------------------------------------------*
 * ***************************************************************************
 * Description : Class to log data to a given output                         *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Log.h"
#include <iostream>
#include <sstream>

//------------------------------------------------------------------------------
// E_Log - c++
//------------------------------------------------------------------------------
E_Log::E_Log()
{}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (const std::wstring& value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (char value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (unsigned char value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (short value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (unsigned short value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (int value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (unsigned value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (const long& value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (const unsigned long& value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (const float& value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
E_Log& E_Log::operator << (const double& value)
{
    std::wostringstream sstr;
    sstr << value;
    m_Log += sstr.str();
    return *this;
}
//------------------------------------------------------------------------------
void E_Log::Clear()
{
    m_Log.clear();
}
//------------------------------------------------------------------------------
const std::wstring& E_Log::Flush()
{
    m_Result = m_Log;

    Clear();

    return m_Result;
}
//------------------------------------------------------------------------------
void E_Log::ToCout()
{
    // convert wstring to string
    char* pStr = new char[m_Log.length()];
    sprintf(pStr, "%ls", m_Log.c_str());

    // send log to cout
    std::cout << pStr;

    // cleanup
    delete[] pStr;
    Clear();
}
//------------------------------------------------------------------------------
