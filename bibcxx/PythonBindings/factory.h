#ifndef FACTORY_H_
#define FACTORY_H_

/**
 * @file FunctionInterface.h
 * @brief Fichier entete de la classe FunctionInterface
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <boost/python.hpp>
#include "astercxx.h"

/** @brief 'factory0' means 'factory for __init__', variant without argument.
 */
template< typename DSType, typename DSTypePtr >
static DSTypePtr factory0()
{
    return DSTypePtr( new DSType() );
}

/** @brief 'factory for __init__', variant with the jeveux datastructure name
 * as argument, needed for unpickling.
 */
template< typename DSType, typename DSTypePtr >
static DSTypePtr factory0Name( const std::string &jeveuxName )
{
    return DSTypePtr( new DSType( jeveuxName ) );
}

/** @brief 'factory for __init__', variant with an argument.
 */
template< typename DSType, typename DSTypePtr, typename Arg1 >
static DSTypePtr factory0Arg( const Arg1 &arg1 )
{
    return DSTypePtr( new DSType( arg1 ) );
}

/** @brief 'factory for __init__', variant with the jeveux datastructure name
 * and another argument, needed for unpickling.
 */
template< typename DSType, typename DSTypePtr, typename Arg1 >
static DSTypePtr factory0NameArg( const std::string &jeveuxName,
                                  const Arg1 &arg1 )
{
    return DSTypePtr( new DSType( jeveuxName, arg1 ) );
}


#endif /* FACTORY_H_ */
