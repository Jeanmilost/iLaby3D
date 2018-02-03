/*****************************************************************************
 * ==> E_Log ----------------------------------------------------------------*
 * ***************************************************************************
 * Description : Class to log data to a given output                         *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_LOG_H
#define E_LOG_H
#include <string>

#define M_EndLineW L"\r\n"

/**
* Log class
*@author Jean-Milost Reymond
*/
class E_Log
{
    public:
        /**
        * Constructor
        */
        E_Log();

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (const std::wstring& value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (char value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (unsigned char value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (short value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (unsigned short value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (int value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (unsigned value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (const long& value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (const unsigned long& value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (const float& value);

        /**
        * Operator <<
        *@param value - value to add to stream
        *@returns itself
        */
        E_Log& operator << (const double& value);

        /**
        * Clears all data
        */
        void Clear();

        /**
        * Flushs log
        *@returns log
        */
        const std::wstring& Flush();

        /**
        * Sends log to cout
        */
        void ToCout();

    private:
        std::wstring m_Log;
        std::wstring m_Result;
};
#endif // E_LOG_H
