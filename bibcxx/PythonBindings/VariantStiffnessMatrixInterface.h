#ifndef VARIANTSTIFFNESSMATRIX_H_
#define VARIANTSTIFFNESSMATRIX_H_

/**
 * @file VairantStiffmessMatrix.h
 * @brief Fichier entete de la classe VairantStiffmessMatrix
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

#include "astercxx.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"
#include <boost/variant.hpp>
#include <boost/python.hpp>

namespace py = boost::python;

typedef boost::variant< AssemblyMatrixDisplacementRealPtr,
                        AssemblyMatrixDisplacementComplexPtr,
                        AssemblyMatrixTemperatureRealPtr,
                        AssemblyMatrixPressureRealPtr > MatrixVariant;


typedef boost::variant< GeneralizedAssemblyMatrixRealPtr,
                        GeneralizedAssemblyMatrixComplexPtr > GeneralizedMatrixVariant;

struct variant_to_object : boost::static_visitor< PyObject * >
{
    static result_type convert( MatrixVariant const &v )
    {
        return apply_visitor( variant_to_object(), v );
    };

    static result_type convert( GeneralizedMatrixVariant const &v )
    {
        return apply_visitor( variant_to_object(), v );
    };

    template < typename T > result_type operator()( T const &t ) const
    {
        return py::incref( py::object( t ).ptr() );
    };
};

template< typename ObjectPointer >
MatrixVariant getStiffnessMatrix( ObjectPointer self )
{
    auto mat1 = self->getDisplacementRealStiffnessMatrix();
    if ( mat1 != nullptr )
        return MatrixVariant( mat1 );
    auto mat3 = self->getDisplacementComplexStiffnessMatrix();
    if ( mat3 != nullptr )
        return MatrixVariant( mat3 );
    auto mat4 = self->getPressureRealStiffnessMatrix();
    if ( mat4 != nullptr )
        return MatrixVariant( mat4 );
    auto mat2 = self->getTemperatureRealStiffnessMatrix();
    return MatrixVariant( mat2 );
};

template< typename ObjectPointer >
GeneralizedMatrixVariant getGeneralizedStiffnessMatrix( ObjectPointer self)
{
    auto mat1 = self->getRealGeneralizedStiffnessMatrix();
    if ( mat1 != nullptr )
        return GeneralizedMatrixVariant( mat1 );
    auto mat2 = self->getComplexGeneralizedStiffnessMatrix();
    return GeneralizedMatrixVariant( mat2);
};

void exportStiffnessMatrixVariantToPython();

#endif /* VARIANTSTIFFNESSMATRIX_H_ */
