/*****************************************************************************
 * ==> E_Maze ---------------------------------------------------------------*
 * ***************************************************************************
 * Description : Maze generator                                              *
 * Developer   : Jean-Milost Reymond                                         *
 *****************************************************************************/

#include "E_Maze.h"
#include "E_Exception.h"
#include "E_Random.h"

//------------------------------------------------------------------------------
// class E_Maze - C++
//------------------------------------------------------------------------------
E_Maze::E_Maze(unsigned width, unsigned height)
{
    m_Initialized = false;

    // initialize maze array with blank cells
    for (unsigned j = 0; j < height; ++j)
    {
        std::vector<ICell> line;

        for (unsigned i = 0; i < width; ++i)
        {
            ICell cell;
            cell.m_Type = ICell::IE_Empty;

            line.push_back(cell);
        }

        m_Maze.push_back(line);
    }

    ICoords min;
    min.m_X = 0;
    min.m_Y = 0;

    ICoords max;
    max.m_X = width;
    max.m_Y = height;

    // create maze
    Split(min, max);

    if (!CreateSpecialCell(ICell::IE_Start, ICell::IE_Area1))
    {
        bool created = false;

        for (unsigned j = 0; j < height; ++j)
        {
            if (created)
                break;

            for (unsigned i = 0; i < width; ++i)
                if (Get(i, j).m_Type == ICell::IE_Empty)
                {
                    ICell cell;
                    cell.m_Type = ICell::IE_Start;
                    Set(i, j, cell);
                    created = true;
                    break;
                }
        }
    }

    if (!CreateSpecialCell(ICell::IE_End, ICell::IE_Area3))
    {
        bool created = false;

        for (unsigned j = 0; j < height; ++j)
        {
            if (created)
                break;

            for (unsigned i = 0; i < width; ++i)
                if (Get(i, j).m_Type == ICell::IE_Empty)
                {
                    ICell cell;
                    cell.m_Type = ICell::IE_End;
                    Set(i, j, cell);
                    created = true;
                    break;
                }
        }
    }

    if (!CreateSpecialCell(ICell::IE_Key, ICell::IE_Area2))
    {
        bool created = false;

        for (unsigned j = 0; j < height; ++j)
        {
            if (created)
                break;

            for (unsigned i = 0; i < width; ++i)
                if (Get(i, j).m_Type == ICell::IE_Empty)
                {
                    ICell cell;
                    cell.m_Type = ICell::IE_Key;
                    Set(i, j, cell);
                    created = true;
                    break;
                }
        }
    }

    m_Initialized = true;
}
//------------------------------------------------------------------------------
unsigned E_Maze::GetWidth() const
{
    if (m_Maze.size() == 0)
        return 0;

    return m_Maze[0].size();
}
//------------------------------------------------------------------------------
unsigned E_Maze::GetHeight() const
{
    return m_Maze.size();
}
//------------------------------------------------------------------------------
E_Maze::ICell E_Maze::Get(unsigned x, unsigned y) const
{
    if (y >= GetHeight())
        M_THROW_EXCEPTION("Get - y is out of bounds")
    else
    if (x >= GetWidth())
        M_THROW_EXCEPTION("Get - x is out of bounds")

    return m_Maze[y][x];
}
//------------------------------------------------------------------------------
E_Maze::ICell E_Maze::Get(unsigned index) const
{
    if (GetWidth() == 0)
        M_THROW_EXCEPTION("Get - invalid width")
    else
    if (index >= GetWidth() * GetHeight())
        M_THROW_EXCEPTION("Get - index is out of bounds")

    unsigned y = index / GetWidth();
    unsigned x = index % (y * GetWidth());

    return m_Maze[y][x];
}
//------------------------------------------------------------------------------
void E_Maze::Set(unsigned x, unsigned y, const ICell& cell)
{
    if (y >= GetHeight())
        M_THROW_EXCEPTION("Set - y is out of bounds")
    else
    if (x >= GetWidth())
        M_THROW_EXCEPTION("Set - x is out of bounds")

    m_Maze[y][x] = cell;
}
//------------------------------------------------------------------------------
void E_Maze::Set(unsigned index, const ICell& cell)
{
    if (GetWidth() == 0)
        M_THROW_EXCEPTION("Set - invalid width")
    else
    if (index >= GetWidth() * GetHeight())
        M_THROW_EXCEPTION("Set - index is out of bounds")

    unsigned y = index / GetWidth();
    unsigned x = index % (y * GetWidth());

    m_Maze[y][x] = cell;
}
//------------------------------------------------------------------------------
bool E_Maze::IsReady() const
{
    return m_Initialized;
}
//------------------------------------------------------------------------------
bool E_Maze::CreateSpecialCell(const ICell::IE_Type& type, const ICell::IE_Area& area)
{
    unsigned count = 0;
    unsigned max   = 100000;

    do
    {
        unsigned areaLength = GetWidth() / ICell::IE_Last_Element;
        unsigned randomNbr  = E_Random::GetNumber(areaLength);
        unsigned x;

        switch (area)
        {
            case ICell::IE_Area1:
                x = randomNbr;
                break;

            case ICell::IE_Area2:
                x = areaLength + randomNbr;
                break;

            case ICell::IE_Area3:
                x = GetWidth() - randomNbr - 1;
                break;

            default:
                M_THROW_EXCEPTION("Create special cell - unknown area")
        }

        unsigned y    = E_Random::GetNumber(GetHeight() - 1);
        ICell    cell = Get(x, y);

        if (cell.m_Type == ICell::IE_Empty)
        {
            cell.m_Type = type;
            Set(x, y, cell);
            return true;
        }
        else
        if (count > max)
            return false;
        else
            ++count;
    }
    while (1);
}
//------------------------------------------------------------------------------
void E_Maze::Split(const ICoords& min, const ICoords& max, unsigned deep, unsigned maxDeep)
{
    unsigned deltaX = max.m_X - min.m_X;
    unsigned deltaY = max.m_Y - min.m_Y;

    ICoords childMinRight;
    ICoords childMaxRight;
    ICoords childMinLeft;
    ICoords childMaxLeft;

    ICell wallCell;
    wallCell.m_Type = ICell::IE_Wall;

    ICell doorCell;
    doorCell.m_Type = ICell::IE_Door;

    // determine the orientation of space to split
    if (deltaX > deltaY)
    {
        if (deltaX < 3 || deltaY < 3)
            return;

        // calculate the split point and the door position
        unsigned splitX = min.m_X + 1 + ((deltaX == 3) ? 0 : E_Random::GetNumber(deltaX - 2));
        unsigned door   = min.m_Y + E_Random::GetNumber(deltaY - 2);

        // create the wall
        for (unsigned i = min.m_Y; i < max.m_Y; ++i)
            if (i != door && i != door + 1)
                Set(splitX, i, wallCell);
            else
                Set(splitX, i, doorCell);

        // create children spaces to divide
        childMinRight.m_X = min.m_X;
        childMinRight.m_Y = min.m_Y;
        childMaxRight.m_X = splitX;
        childMaxRight.m_Y = max.m_Y;

        childMinLeft.m_X = ((splitX >= max.m_X) ? max.m_X : splitX + 1);
        childMinLeft.m_Y = min.m_Y;
        childMaxLeft.m_X = max.m_X;
        childMaxLeft.m_Y = max.m_Y;
    }
    else
    {
        if (deltaY < 3 || deltaX < 3)
            return;

        // calculate the split point and the door position
        unsigned splitY = min.m_Y + 1 + ((deltaY == 3) ? 0 : E_Random::GetNumber(deltaY - 2));
        unsigned door   = min.m_X + E_Random::GetNumber(deltaX - 2);

        // create the wall
        for (unsigned i = min.m_X; i < max.m_X; ++i)
            if (i != door && i != door + 1)
                Set(i, splitY, wallCell);
            else
                Set(i, splitY, doorCell);

        // create children spaces to divide
        childMinRight.m_X = min.m_X;
        childMinRight.m_Y = min.m_Y;
        childMaxRight.m_X = max.m_X;
        childMaxRight.m_Y = splitY;

        childMinLeft.m_X = min.m_X;
        childMinLeft.m_Y = ((splitY >= max.m_Y) ? max.m_Y : splitY + 1);
        childMaxLeft.m_X = max.m_X;
        childMaxLeft.m_Y = max.m_Y;
    }

    if (deep < maxDeep)
    {
        ++deep;

        // split right child
        if ((childMaxRight.m_X - childMinRight.m_X) > 1 && (childMaxRight.m_Y - childMinRight.m_Y) > 1)
            Split(childMinRight, childMaxRight, deep);

        // split left child
        if ((childMaxLeft.m_X - childMinLeft.m_X) > 1 && (childMaxLeft.m_Y - childMinLeft.m_Y) > 1)
            Split(childMinLeft, childMaxLeft, deep);
    }
}
//------------------------------------------------------------------------------
