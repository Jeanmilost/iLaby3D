/*****************************************************************************
 * ==> E_Maze ---------------------------------------------------------------*
 * ***************************************************************************
 * Description : Maze generator                                              *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#ifndef E_MAZE_H
#define E_MAZE_H

#include <vector>

/**
* Maze generator
@author Jean-Milost Reymond
*/
class E_Maze
{
    public:
        /**
        * Maze cell
        *@author Jean-Milost Reymond
        */
        struct ICell
        {
            /**
            * Maze cell type
            *@author Jean-Milost Reymond
            */
            enum IE_Type
            {
                IE_Empty, // empty cell (passage)
                IE_Wall,  // wall
                IE_Door,  // door
                IE_Key,   // this cell contains key
                IE_Start, // start point
                IE_End,   // end point
            };

            /**
            * Maze cell area
            *@author Jean-Milost Reymond
            */
            enum IE_Area
            {
                IE_Area1 = 0,
                IE_Area2,
                IE_Area3,
                IE_Last_Element,
            };

            IE_Type m_Type;
        };

        /**
        * Constructor
        *@param width - width of the maze
        *@param height - height of the maze
        */
        E_Maze(unsigned width, unsigned height);

        /**
        * Gets maze width (in cells)
        *@returns maze width (in cells)
        */
        unsigned GetWidth() const;

        /**
        * Gets maze height (in cells)
        *@returns maze height (in cells)
        */
        unsigned GetHeight() const;

        /**
        * Gets cell at the given location
        *@param x - x location
        *@param y - y location
        *@returns cell at the given location
        */
        ICell Get(unsigned x, unsigned y) const;

        /**
        * Gets cell at the given index
        *@param index - cell index
        *@returns cell at the given index
        */
        ICell Get(unsigned index) const;

        /**
        * Sets cell at the given location
        *@param x - x location
        *@param y - y location
        *@param cell - cell to set
        */
        void Set(unsigned x, unsigned y, const ICell& cell);

        /**
        * Sets cell at the given index
        *@param index - index to set
        *@param cell - cell to set
        */
        void Set(unsigned index, const ICell& cell);

        /**
        * Checks if maze is ready
        *@returns true if ready, otherwise false
        */
        bool IsReady() const;

    private:
        /**
        * Structure to represent a coordinate
        *@author Jean-Milost Reymond
        */
        struct ICoords
        {
            unsigned m_X;
            unsigned m_Y;
        };

        std::vector< std::vector<ICell> > m_Maze;
        bool                              m_Initialized;

        /**
        * Creates special cell of given type
        *@param type - type of cell to create
        *@returns true on success, otherwise false
        */
        bool CreateSpecialCell(const ICell::IE_Type& type, const ICell::IE_Area& area);

        /**
        * Splits blank space to create a wall
        *@param min - min corner of the space to split
        *@param ma - max corner of the space to split
        *@param deep - current recursive deep
        *@param maxDeep - maximum recursive deep
        */
        void Split(const ICoords& min, const ICoords& max, unsigned deep = 0, unsigned maxDeep = -1);
};

#endif // E_MAZE_H
