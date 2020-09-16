/**
 * @file AssemblyMatrix.cxx
 * @brief Implementation de AssemblyMatrix vide car AssemblyMatrix est un template
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

#include "LinearAlgebra/AssemblyMatrix.h"

// Specialization for <double, Displacement>
template <> void AssemblyMatrixClass< double, Displacement >::setValues(const VectorLong idx, 
        const VectorLong jdx, const VectorReal values) {
        if (get_sh_jeveux_status() == 1 ) {
            const ASTERINTEGER dim = idx.size();
            if (idx.size() != jdx.size() || idx.size() != values.size()){
                throw std::runtime_error( "All lists must have same length" );
            }
            CALLO_MATR_ASSE_SET_VALUES(getName(), &dim, idx.data(), jdx.data(), values.data());
            _isFactorized = false;
       }
    };

// Specialization for <double, Temperature>
template <> void AssemblyMatrixClass< double, Temperature >::setValues(const VectorLong idx, 
        const VectorLong jdx, const VectorReal values) {
        if (get_sh_jeveux_status() == 1 ) {
            const ASTERINTEGER dim = idx.size();
            if (idx.size() != jdx.size() || idx.size() != values.size()){
                throw std::runtime_error( "All lists must have same length" );
            }
            CALLO_MATR_ASSE_SET_VALUES(getName(), &dim, idx.data(), jdx.data(), values.data());
            _isFactorized = false;
        }
    };

// Specialization for <double, Pressure>
template <> void AssemblyMatrixClass< double, Pressure >::setValues(const VectorLong idx, 
        const VectorLong jdx, const VectorReal values) {
        if (get_sh_jeveux_status() == 1 ) {
            const ASTERINTEGER dim = idx.size();
            if (idx.size() != jdx.size() || idx.size() != values.size()){
                throw std::runtime_error( "All lists must have same length" );
            }
            CALLO_MATR_ASSE_SET_VALUES(getName(), &dim, idx.data(), jdx.data(), values.data());
            _isFactorized = false;
        }
    };
