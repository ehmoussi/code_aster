#ifndef VARIANTMODALBASIS_H_
#define VARIANTMODALBASIS_H_

/**
 * @file VariantModalBasis.h
 * @brief Fichier entete de la classe VariantModalBasis
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

#include "astercxx.h"
#include "Results/MechanicalModeContainer.h"
#include "Results/GeneralizedModeContainer.h"
#include <boost/variant.hpp>
#include <boost/python.hpp>

typedef boost::variant< MechanicalModeContainerPtr,
                        GeneralizedModeContainerPtr > ModalBasisVariant;

struct ModalBasisToObject: boost::static_visitor< PyObject * >
{
    static result_type convert( ModalBasisVariant const &v )
    {
        return apply_visitor( ModalBasisToObject(), v );
    };

    template < typename T > result_type operator()( T const &t ) const
    {
        return boost::python::incref( boost::python::object( t ).ptr() );
    };
};

template< typename ObjectPointer >
ModalBasisVariant getModalBasis( ObjectPointer self )
{
    auto mat1 = self->getModalBasisFromGeneralizedModeContainer();
    if ( mat1 != nullptr )
        return ModalBasisVariant( mat1 );
    auto mat2 = self->getModalBasisFromMechanicalModeContainer();
    return ModalBasisVariant( mat2 );
};

void exportModalBasisVariantToPython();

#endif /* VARIANTMODALBASIS_H_ */
