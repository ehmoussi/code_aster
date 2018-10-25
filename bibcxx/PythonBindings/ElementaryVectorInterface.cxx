/**
 * @file ElementaryVectorInterface.cxx
 * @brief Interface python de ElementaryVector
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <boost/python.hpp>
#include <PythonBindings/factory.h>
#include "PythonBindings/ElementaryVectorInterface.h"

void exportElementaryVectorToPython() {
    using namespace boost::python;

    FieldOnNodesDoublePtr ( ElementaryVectorInstance::*c1 )( const DOFNumberingPtr & ) =
        &ElementaryVectorInstance::assembleVector;
#ifdef _USE_MPI
    FieldOnNodesDoublePtr ( ElementaryVectorInstance::*c2 )( const ParallelDOFNumberingPtr & ) =
        &ElementaryVectorInstance::assembleVector;
#endif /* _USE_MPI */

    void ( ElementaryVectorInstance::*c3 )( const GenericMechanicalLoadPtr & ) =
        &ElementaryVectorInstance::addLoad;

    class_< ElementaryVectorInstance, ElementaryVectorInstance::ElementaryVectorPtr,
            bases< DataStructure > >( "ElementaryVector", no_init )
        .def( "__init__", make_constructor(&initFactoryPtr< ElementaryVectorInstance >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< ElementaryVectorInstance, std::string >))
        .def( "addMechanicalLoad", c3 )
        .def( "assembleVector", c1 )
        .def( "setType", &ElementaryVectorInstance::setType )
#ifdef _USE_MPI
        .def( "assembleVector", c2 )
#endif /* _USE_MPI */
        .def( "setListOfLoads", &ElementaryVectorInstance::setListOfLoads );
};
