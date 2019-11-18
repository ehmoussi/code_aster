/**
 * @file FullTransientResultsContainerInterface.cxx
 * @brief Interface python de FullTransientResultsContainer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include "PythonBindings/FullTransientResultsContainerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportFullTransientResultsContainerToPython() {
    using namespace boost::python;

    class_< FullTransientResultsContainerInstance, FullTransientResultsContainerPtr,
            bases< FullResultsContainerInstance > >( "FullTransientResultsContainer", no_init )
        .def( "__init__",
              make_constructor(
                  &initFactoryPtr< FullTransientResultsContainerInstance, std::string >))
        .def( "__init__",
              make_constructor(&initFactoryPtr< FullTransientResultsContainerInstance >))
        .def( "printMedFile", &FullTransientResultsContainerInstance::printMedFile );
};
