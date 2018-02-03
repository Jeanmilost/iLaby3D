/*****************************************************************************
 * ==> E_Random -------------------------------------------------------------*
 * ***************************************************************************
 * Description : Class to generate random numbers                            *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_RANDOM_H
#define E_RANDOM_H
#include <cstdlib>
#include <ctime>
#include <iostream>

/**
* Class to generate random numbers
*@author Jean-Milost Reymond
*/
class E_Random
{
    public:
        /**
        * Initializes random number generator
        */
        static void Initialize();

        /**
        * Gets randomized number
        *@param range - range
        *@returns randomized number
        */
        static unsigned GetNumber(unsigned range = RAND_MAX);

    private:
        static bool m_Initialized;
};

#endif // E_RANDOM_H
