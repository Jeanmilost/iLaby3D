/*****************************************************************************
 * ==> E_MemoryTools --------------------------------------------------------*
 * ***************************************************************************
 * Description : Some memory tools                                           *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_MEMORYTOOLS_H
#define E_MEMORYTOOLS_H
#include "E_Exception.h"

#define M_CountOf(array) (sizeof(array)) / (sizeof(array[0]))

#define M_Assert(value)                        \
    if (!value)                                \
        M_THROW_EXCEPTION("Assertion failed");

#endif // E_MEMORYTOOLS_H
