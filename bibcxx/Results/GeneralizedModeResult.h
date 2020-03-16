#ifndef GENERALIZEDMODERESULT_H_
#define GENERALIZEDMODERESULT_H_

/**
 * @file GeneralizedModeResult.h
 * @brief Fichier entete de la classe GeneralizedModeResult
 * @author Nicolas Tardieu
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

#include "Results/FullResult.h"
#include "Supervis/ResultNaming.h"
#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"
#include "Numbering/GeneralizedDOFNumbering.h"

/**
 * @class GeneralizedModeResultClass
 * @brief Cette classe correspond à un mode_gene
 * @author Nicolas Sellenet
 */
class GeneralizedModeResultClass : public FullResultClass {
  private:
    /** @brief Damping matrix */
    GeneralizedAssemblyMatrixRealPtr _dampingMatrix;
    /** @brief Stiffness double matrix */
    GeneralizedAssemblyMatrixRealPtr _rigidityRealMatrix;
    /** @brief Stiffness complex matrix */
    GeneralizedAssemblyMatrixComplexPtr _rigidityComplexMatrix;
    /** @brief generalized DOFNumbering */
    GeneralizedDOFNumberingPtr _genDOFNum;

  public:
    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    GeneralizedModeResultClass( const std::string &name )
        : FullResultClass( name, "MODE_GENE" ), _rigidityRealMatrix( nullptr ),
          _rigidityComplexMatrix( nullptr ), _genDOFNum( nullptr ){};

    /**
     * @brief Constructeur
     * @todo  Ajouter les objets Jeveux de la SD
     */
    GeneralizedModeResultClass()
        : GeneralizedModeResultClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Get GeneralizedDOFNumering
     */
    GeneralizedDOFNumberingPtr getGeneralizedDOFNumbering() const {
        if ( _genDOFNum != nullptr )
            return _genDOFNum;
        throw std::runtime_error( "GeneralizedDOFNumbering is empty" );
    };

    /**
     * @brief Set the damping matrix
     * @param matr GeneralizedAssemblyMatrixRealPtr
     */
    bool setDampingMatrix( const GeneralizedAssemblyMatrixRealPtr &matr ) {
        _dampingMatrix = matr;
        return true;
    };

    /**
     * @brief Get the damping matrix
     * @param matr GeneralizedAssemblyMatrixRealPtr
     */
    GeneralizedAssemblyMatrixRealPtr getDampingMatrix( void ) const {
        return _dampingMatrix;
    };

    /**
     * @brief Set GeneralizedDOFNumering
     */
    bool setGeneralizedDOFNumbering( const GeneralizedDOFNumberingPtr &dofNum ) {
        if ( dofNum != nullptr ) {
            _genDOFNum = dofNum;
            return true;
        }
        return false;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr GeneralizedAssemblyMatrixRealPtr
     */
    bool setStiffnessMatrix( const GeneralizedAssemblyMatrixRealPtr &matr ) {
        _rigidityComplexMatrix = nullptr;
        _rigidityRealMatrix = matr;
        return true;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr GeneralizedAssemblyMatrixComplexPtr
     */
    bool setStiffnessMatrix( const GeneralizedAssemblyMatrixComplexPtr &matr ) {
        _rigidityRealMatrix = nullptr;
        _rigidityComplexMatrix = matr;
        return true;
    };

    /**
     * @brief Get the stiffness matrix
     * @param matr GeneralizedAssemblyMatrixRealPtr
     */
    GeneralizedAssemblyMatrixRealPtr getRealGeneralizedStiffnessMatrix( void ) const {
        return _rigidityRealMatrix;
    };

    /**
     * @brief Get the stiffness matrix
     * @param matr GeneralizedAssemblyMatrixComplexPtr
     */
    GeneralizedAssemblyMatrixComplexPtr getComplexGeneralizedStiffnessMatrix( void ) const {
        return _rigidityComplexMatrix;
    };

    bool update() { return ResultClass::update(); };
};

/**
 * @typedef GeneralizedModeResultPtr
 * @brief Pointeur intelligent vers un GeneralizedModeResultClass
 */
typedef boost::shared_ptr< GeneralizedModeResultClass > GeneralizedModeResultPtr;

#endif /* GENERALIZEDMODERESULT_H_ */
