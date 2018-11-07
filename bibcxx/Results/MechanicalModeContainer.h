#ifndef MECHANICALMODECONTAINER_H_
#define MECHANICALMODECONTAINER_H_

/**
 * @file MechanicalModeContainer.h
 * @brief Fichier entete de la classe MechanicalModeContainer
 * @author Natacha Béreux
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

#include "astercxx.h"

#include "Results/FullResultsContainer.h"
#include "LinearAlgebra/StructureInterface.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"
#include "Discretization/DOFNumbering.h"

/**
 * @class MechanicalModeContainerInstance
 * @brief Cette classe correspond a un mode_meca
 * @author Nicolas Sellenet
 */
class MechanicalModeContainerInstance : public FullResultsContainerInstance
{
  private:
    StructureInterfacePtr _structureInterface;
    /** @brief Stiffness double displacement matrix */
    AssemblyMatrixDisplacementDoublePtr _rigidityDispDMatrix;
    /** @brief Stiffness complex displacement matrix */
    AssemblyMatrixDisplacementComplexPtr _rigidityDispCMatrix;
    /** @brief Stiffness double temperature matrix */
    AssemblyMatrixTemperatureDoublePtr _rigidityTempDMatrix;
    /** @brief Stiffness double pressure matrix */
    AssemblyMatrixPressureDoublePtr _rigidityPressDMatrix;
    /** @brief Stiffness generalized double matrix */
    GeneralizedAssemblyMatrixDoublePtr _rigidityGDMatrix;
    /** @brief Stiffness generalized complex matrix */
    GeneralizedAssemblyMatrixComplexPtr _rigidityGCMatrix;

  public:
    /**
     * @brief Constructeur
     */
    MechanicalModeContainerInstance():
        FullResultsContainerInstance( "MODE_MECA" ),
        _structureInterface( StructureInterfacePtr() ),
        _rigidityDispDMatrix( nullptr ),
        _rigidityDispCMatrix( nullptr ),
        _rigidityTempDMatrix( nullptr ),
        _rigidityPressDMatrix( nullptr ),
        _rigidityGDMatrix( nullptr ),
        _rigidityGCMatrix( nullptr )
    {};

    /**
     * @brief Constructeur
     */
    MechanicalModeContainerInstance( const std::string &name ):
        FullResultsContainerInstance( name, "MODE_MECA" ),
        _structureInterface( StructureInterfacePtr() ),
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
    AssemblyMatrixDisplacementDoublePtr getDisplacementDoubleStiffnessMatrix() const
    {
        return _rigidityDispDMatrix;
    };

    /**
     * @brief Get the DOFNumbering
     */
    BaseDOFNumberingPtr getDOFNumbering() const throw( std::runtime_error )
    {
        if ( _rigidityDispDMatrix != nullptr )
            return _rigidityDispDMatrix->getDOFNumbering();
        if ( _rigidityTempDMatrix != nullptr )
            return _rigidityTempDMatrix->getDOFNumbering();
        throw std::runtime_error( "No matrix set" );
    };

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixPressureDoublePtr getPressureDoubleStiffnessMatrix() const
    {
        return _rigidityPressDMatrix;
    };

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixTemperatureDoublePtr getTemperatureDoubleStiffnessMatrix() const
    {
        return _rigidityTempDMatrix;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixDisplacementDoublePtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixDisplacementDoublePtr &matr )
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
     * @param matr AssemblyMatrixTemperatureDoublePtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixTemperatureDoublePtr &matr )
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
     * @param matr AssemblyMatrixPressureDoublePtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixPressureDoublePtr &matr )
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
     * @param matr GeneralizedAssemblyMatrixDoublePtr
     */
    bool setStiffnessMatrix( const GeneralizedAssemblyMatrixDoublePtr &matr )
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

    /**
     * @brief set interf_dyna
     * @param structureInterface objet StructureInterfacePtr
     */
    bool setStructureInterface( StructureInterfacePtr &structureInterface )
        throw( std::runtime_error )
    {
        _structureInterface = structureInterface;
        return true;
    };

    bool update() throw( std::runtime_error )
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
            const auto model = numeDdl->getSupportModel();
            if ( model != nullptr )
                _mesh = model->getSupportMesh();
        }
        return ResultsContainerInstance::update();
    };
};

/**
 * @typedef MechanicalModeContainerPtr
 * @brief Pointeur intelligent vers un MechanicalModeContainerInstance
 */
typedef boost::shared_ptr< MechanicalModeContainerInstance > MechanicalModeContainerPtr;

#endif /* MECHANICALMODECONTAINER_H_ */
