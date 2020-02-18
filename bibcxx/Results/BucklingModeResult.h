#ifndef BUCKLINGMODERESULT_H_
#define BUCKLINGMODERESULT_H_

/**
 * @file BucklingModeResult.h
 * @brief Fichier entete de la classe BucklingModeResult
 * @author Natacha Béreux
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
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"

/**
 * @class BucklingModeResultClass
 * @brief Cette classe correspond a un mode_flamb
 * @author Natacha Béreux
 */
class BucklingModeResultClass : public FullResultClass
{
  private:
    /** @brief Stiffness double displacement matrix */
    AssemblyMatrixDisplacementRealPtr _rigidityDispDMatrix;
    /** @brief Stiffness complex displacement matrix */
    AssemblyMatrixDisplacementComplexPtr _rigidityDispCMatrix;
    /** @brief Stiffness double temperature matrix */
    AssemblyMatrixTemperatureRealPtr _rigidityTempDMatrix;
    /** @brief Stiffness double pressure matrix */
    AssemblyMatrixPressureRealPtr _rigidityPressDMatrix;
    /** @brief Stiffness generalized double matrix */
    GeneralizedAssemblyMatrixRealPtr _rigidityGDMatrix;
    /** @brief Stiffness generalized complex matrix */
    GeneralizedAssemblyMatrixComplexPtr _rigidityGCMatrix;

  public:
    /**
     * @brief Constructeur
     */
    BucklingModeResultClass():
        BucklingModeResultClass( ResultNaming::getNewResultName() )
    {};

    BucklingModeResultClass( const std::string &name ):
        FullResultClass( name, "MODE_FLAMB" ),
        _rigidityDispDMatrix( nullptr ),
        _rigidityDispCMatrix( nullptr ),
        _rigidityTempDMatrix( nullptr ),
        _rigidityPressDMatrix( nullptr ),
        _rigidityGDMatrix( nullptr ),
        _rigidityGCMatrix( nullptr )
    {};

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixDisplacementComplexPtr getDisplacementComplexStiffnessMatrix() const
    {
        return _rigidityDispCMatrix;
    };

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixDisplacementRealPtr getDisplacementRealStiffnessMatrix() const
    {
        return _rigidityDispDMatrix;
    };

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixPressureRealPtr getPressureRealStiffnessMatrix() const
    {
        return _rigidityPressDMatrix;
    };

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixTemperatureRealPtr getTemperatureRealStiffnessMatrix() const
    {
        return _rigidityTempDMatrix;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixDisplacementRealPtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixDisplacementRealPtr &matr )
    {
        _rigidityDispDMatrix = matr;
        _rigidityDispCMatrix = nullptr;
        _rigidityTempDMatrix = nullptr;
        _rigidityPressDMatrix = nullptr;
        _rigidityGDMatrix = nullptr;
        _rigidityGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixDisplacementComplexPtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixDisplacementComplexPtr &matr )
    {
        _rigidityDispDMatrix = nullptr;
        _rigidityDispCMatrix = matr;
        _rigidityTempDMatrix = nullptr;
        _rigidityPressDMatrix = nullptr;
        _rigidityGDMatrix = nullptr;
        _rigidityGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixTemperatureRealPtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixTemperatureRealPtr &matr )
    {
        _rigidityDispDMatrix = nullptr;
        _rigidityDispCMatrix = nullptr;
        _rigidityTempDMatrix = matr;
        _rigidityPressDMatrix = nullptr;
        _rigidityGDMatrix = nullptr;
        _rigidityGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixPressureRealPtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixPressureRealPtr &matr )
    {
        _rigidityDispDMatrix = nullptr;
        _rigidityDispCMatrix = nullptr;
        _rigidityTempDMatrix = nullptr;
        _rigidityPressDMatrix = matr;
        _rigidityGDMatrix = nullptr;
        _rigidityGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr GeneralizedAssemblyMatrixRealPtr
     */
    bool setStiffnessMatrix( const GeneralizedAssemblyMatrixRealPtr &matr )
    {
        _rigidityDispDMatrix = nullptr;
        _rigidityDispCMatrix = nullptr;
        _rigidityTempDMatrix = nullptr;
        _rigidityPressDMatrix = nullptr;
        _rigidityGDMatrix = matr;
        _rigidityGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr GeneralizedAssemblyMatrixComplexPtr
     */
    bool setStiffnessMatrix( const GeneralizedAssemblyMatrixComplexPtr &matr )
    {
        _rigidityDispDMatrix = nullptr;
        _rigidityDispCMatrix = nullptr;
        _rigidityTempDMatrix = nullptr;
        _rigidityPressDMatrix = nullptr;
        _rigidityGDMatrix = nullptr;
        _rigidityGCMatrix = matr;
        return true;
    };

    bool update()
    {
        BaseDOFNumberingPtr numeDdl( nullptr );
        if ( _rigidityDispDMatrix != nullptr )
            numeDdl = _rigidityDispDMatrix->getDOFNumbering();
        if ( _rigidityDispCMatrix != nullptr )
            numeDdl = _rigidityDispCMatrix->getDOFNumbering();
        if ( _rigidityTempDMatrix != nullptr )
            numeDdl = _rigidityTempDMatrix->getDOFNumbering();
        if ( _rigidityPressDMatrix != nullptr )
            numeDdl = _rigidityPressDMatrix->getDOFNumbering();

        if ( numeDdl != nullptr )
        {
            const auto model = numeDdl->getModel();
            if ( model != nullptr )
                _mesh = model->getMesh();
        }
        return ResultClass::update();
    };
};

/**
 * @typedef BucklingModeResultPtr
 * @brief Pointeur intelligent vers un BucklingModeResultClass
 */
typedef boost::shared_ptr< BucklingModeResultClass > BucklingModeResultPtr;

#endif /* BUCKLINGMODERESULT_H_ */
