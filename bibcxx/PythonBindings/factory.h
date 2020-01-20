#ifndef FACTORY_H_
#define FACTORY_H_

/**
 * @file FunctionInterface.h
 * @brief Fichier entete de la classe FunctionInterface
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

namespace py = boost::python;

/** @brief Factory for '__init__' constructor without 'DSTypePtr'.
 */
template < typename DSType, typename... Args >
static boost::shared_ptr< DSType > initFactoryPtr( Args... args ) {
    return boost::shared_ptr< DSType >( new DSType( args... ) );
};

#endif /* FACTORY_H_ */
