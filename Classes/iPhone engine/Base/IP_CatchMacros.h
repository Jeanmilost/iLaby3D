/*****************************************************************************
 * ==> IP_CatchMacros -------------------------------------------------------*
 * ***************************************************************************
 * Description : Some objective-c exceptions catching macros                 *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef IP_CATCHMACROS_H
#define IP_CATCHMACROS_H
#include "E_Exception.h"
#import "IP_StringTools.h"
#import "IP_MessageBox.h"

#define M_Try\
    @try\
    {\
        try

#define M_CatchSilent\
        catch (const E_Exception& e)\
        {\
            NSLog(@"%@", [IP_StringTools StrToNSStr:e.Format()]);\
        }\
        catch (const std::exception& e)\
        {\
            NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("STD", e.what())]);\
        }\
        catch (...)\
        {\
            NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("Runtime", "Runtime exception raised")]);\
        }\
    }\
    @catch (NSException* e)\
    {\
        NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("NS", [IP_StringTools NSStrToStr:e.reason])]);\
    }\
    @catch (id e)\
    {\
        NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("ID", [IP_StringTools NSStrToStr:(NSString*)e])]);\
    }\
    @catch (...)\
    {\
        NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("Runtime", "Runtime exception raised")]);\
    }

#define M_CatchShow\
        catch (const E_Exception& e)\
        {\
            NSLog(@"%@", [IP_StringTools StrToNSStr:e.Format()]);\
            [IP_MessageBox DisplayError :@"E_Exception" :[IP_StringTools StrToNSStr:M_FORMAT_MESSAGE(e.Message())]];\
        }\
        catch (const std::exception& e)\
        {\
            std::string msg = e.what();\
            NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("STD", msg)]);\
            [IP_MessageBox DisplayError :@"STD exception" :[IP_StringTools StrToNSStr:M_FORMAT_MESSAGE(msg)]];\
        }\
        catch (...)\
        {\
            std::string msg = "Runtime exception raised";\
            NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("Runtime", msg)]);\
            [IP_MessageBox DisplayError :@"Runtime exception" :[IP_StringTools StrToNSStr:M_FORMAT_MESSAGE(msg)]];\
        }\
    }\
    @catch (NSException* e)\
    {\
        std::string msg = [IP_StringTools NSStrToStr:e.reason];\
        NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("NS", msg)]);\
        [IP_MessageBox DisplayError :e.name :[IP_StringTools StrToNSStr:M_FORMAT_MESSAGE(msg)]];\
    }\
    @catch (id e)\
    {\
        std::string msg = [IP_StringTools NSStrToStr:(NSString*)e];\
        NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("ID", msg)]);\
        [IP_MessageBox DisplayError :@"ID exception" :[IP_StringTools StrToNSStr:M_FORMAT_MESSAGE(msg)]];\
    }\
    @catch (...)\
    {\
        std::string msg = "Runtime exception raised";\
        NSLog(@"%@", [IP_StringTools StrToNSStr:M_FORMAT_EXCEPTION("Runtime", msg)]);\
        [IP_MessageBox DisplayError :@"Runtime exception" :[IP_StringTools StrToNSStr:M_FORMAT_MESSAGE(msg)]];\
    }

#endif