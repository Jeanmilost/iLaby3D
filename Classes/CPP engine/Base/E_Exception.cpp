/*****************************************************************************
 * ==> E_Exception ----------------------------------------------------------*
 * ***************************************************************************
 * Description : Engine exception class                                      *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Exception.h"
#include <sstream>

//------------------------------------------------------------------------------
// E_ExceptionFormatter - c++
//------------------------------------------------------------------------------
std::string E_ExceptionFormatter::Format(const std::string& type,
                                         const std::string& message,
                                         const std::string& file,
                                         const std::string& function,
                                         unsigned line)
{
    std::ostringstream sstr;

    sstr << "[";
    
    if (type.empty())
        sstr << "Unknown";
    else
        sstr << type;

    sstr << " exception raised]\n" << "[Message]  ";

    if (message.empty())
        sstr << "Unknown exception\n";
    else
        sstr << message << "\n";

    sstr << "[File]     " << file << "\n"
         << "[Function] " << function << "\n"
         << "[Line]     " << line << "\n";

    return sstr.str();
}
//------------------------------------------------------------------------------
std::string E_ExceptionFormatter::Message(const std::string& message,
                                          const std::string& function,
                                          unsigned line)
{
    std::ostringstream sstr;

    if (message.empty())
        sstr << "Unknown exception";
    else
        sstr << message;
    
    sstr << "\n";

    sstr << "[Function]\n" << function << "\n"
         << "[Line] " << line << "\n";

    return sstr.str();
}
//------------------------------------------------------------------------------
// E_Exception - c++
//------------------------------------------------------------------------------
E_Exception::E_Exception() throw()
{}
//------------------------------------------------------------------------------
E_Exception::E_Exception(const std::string& message,
                         const std::string& file,
                         const std::string& function,
                         unsigned           line) throw()
{
    m_Message  = message;
    m_File     = file;
    m_Function = function;
    m_Line     = line;
}
//------------------------------------------------------------------------------
E_Exception::~E_Exception() throw()
{}
//------------------------------------------------------------------------------
const char* E_Exception::what() const throw()
{
    return Format();
}
//------------------------------------------------------------------------------
const char* E_Exception::Format() const
{
    std::ostringstream sstr;

    sstr << "[E_Exception raised]\n" << "[Message]  ";

    if (m_Message.empty())
        sstr << "Unknown exception\n";
    else
        sstr << m_Message << "\n";

    sstr << "[File]     " << m_File << "\n"
         << "[Function] " << m_Function << "\n"
         << "[Line]     " << m_Line << "\n";

    return sstr.str().c_str();
}
//------------------------------------------------------------------------------
const std::string& E_Exception::Message() const
{
    return m_Message;
}
//------------------------------------------------------------------------------
