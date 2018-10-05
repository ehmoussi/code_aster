/**
 * @file MechanicalModeContainerInterface.cxx
 * @brief Interface python de MechanicalModeContainer
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

#include "PythonBindings/MechanicalModeContainerInterface.h"
#include "PythonBindings/factory.h"
#include <boost/python.hpp>
#include <boost/variant.hpp>

typedef boost::variant< AssemblyMatrixDisplacementDoublePtr,
                        AssemblyMatrixTemperatureDoublePtr > MatrixVariant;

struct variant_to_object: boost::static_visitor< PyObject * >
{
    static result_type convert( MatrixVariant const &v )
    {
        return apply_visitor( variant_to_object(), v );
    }

    template< typename T >
    result_type operator()( T const &t ) const
    {
        return boost::python::incref( boost::python::object(t).ptr() );
    }
};

MatrixVariant getStiffnessMatrix( MechanicalModeContainerPtr self )
{
    auto mat1 = self->getDisplacementStiffnessMatrix();
    if( mat1 != nullptr )
        return MatrixVariant( mat1 );
    auto mat2 = self->getTemperatureStiffnessMatrix();
    return MatrixVariant( mat2 );
};

void exportMechanicalModeContainerToPython()
{
    using namespace boost::python;

    bool (MechanicalModeContainerInstance::*c1)( const AssemblyMatrixDisplacementDoublePtr& ) =
        &MechanicalModeContainerInstance::setStiffnessMatrix;
    bool (MechanicalModeContainerInstance::*c2)( const AssemblyMatrixTemperatureDoublePtr& ) =
        &MechanicalModeContainerInstance::setStiffnessMatrix;

    class_< MechanicalModeContainerInstance, MechanicalModeContainerPtr,
            bases< FullResultsContainerInstance > > ( "MechanicalModeContainer", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MechanicalModeContainerInstance > ) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MechanicalModeContainerInstance,
                             std::string > ) )
        .def( "getDOFNumbering", &MechanicalModeContainerInstance::getDOFNumbering )
        .def( "getStiffnessMatrix", &getStiffnessMatrix )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStructureInterface", &MechanicalModeContainerInstance::setStructureInterface )
    ;

    to_python_converter< MatrixVariant, variant_to_object >();
    implicitly_convertible< AssemblyMatrixDisplacementDoublePtr, MatrixVariant >();
    implicitly_convertible< AssemblyMatrixTemperatureDoublePtr, MatrixVariant >();
};

void exportMechanicalModeComplexContainerToPython()
{
    using namespace boost::python;

    bool (MechanicalModeComplexContainerInstance::*c1)(const AssemblyMatrixDisplacementDoublePtr&)=
        &MechanicalModeComplexContainerInstance::setStiffnessMatrix;
    bool (MechanicalModeComplexContainerInstance::*c2)(const AssemblyMatrixDisplacementComplexPtr&)=
        &MechanicalModeComplexContainerInstance::setStiffnessMatrix;

    class_< MechanicalModeComplexContainerInstance, MechanicalModeComplexContainerPtr,
            bases< FullResultsContainerInstance > > ( "MechanicalModeComplexContainer", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MechanicalModeComplexContainerInstance > ) )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MechanicalModeComplexContainerInstance,
                             std::string > ) )
        .def( "setDampingMatrix", &MechanicalModeComplexContainerInstance::setDampingMatrix )
        .def( "setStiffnessMatrix", c1 )
        .def( "setStiffnessMatrix", c2 )
        .def( "setStructureInterface",
              &MechanicalModeComplexContainerInstance::setStructureInterface )
    ;
};
