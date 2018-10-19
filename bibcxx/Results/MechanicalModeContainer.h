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
#include "Discretization/DOFNumbering.h"

/**
 * @class MechanicalModeContainerInstance
 * @brief Cette classe correspond a un mode_meca
 * @author Nicolas Sellenet
 */
class MechanicalModeContainerInstance : public FullResultsContainerInstance {
  private:
    StructureInterfacePtr _structureInterface;
    /** @brief Stiffness displacement matrix */
    AssemblyMatrixDisplacementDoublePtr _rigidityDispMatrix;
    /** @brief Stiffness temperature matrix */
    AssemblyMatrixTemperatureDoublePtr _rigidityTempMatrix;

  public:
    /**
     * @brief Constructeur
     */
    MechanicalModeContainerInstance()
        : FullResultsContainerInstance( "MODE_MECA" ),
          _structureInterface( StructureInterfacePtr() ), _rigidityDispMatrix( nullptr ),
          _rigidityTempMatrix( nullptr ){};

    /**
     * @brief Constructeur
     */
    MechanicalModeContainerInstance( const std::string &name )
        : FullResultsContainerInstance( name, "MODE_MECA" ),
          _structureInterface( StructureInterfacePtr() ), _rigidityDispMatrix( nullptr ),
          _rigidityTempMatrix( nullptr ){};

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixDisplacementDoublePtr getDisplacementStiffnessMatrix() const {
        return _rigidityDispMatrix;
    };

    /**
     * @brief Get the DOFNumbering
     */
    BaseDOFNumberingPtr getDOFNumbering() const throw( std::runtime_error ) {
        if ( _rigidityDispMatrix != nullptr )
            return _rigidityDispMatrix->getDOFNumbering();
        if ( _rigidityTempMatrix != nullptr )
            return _rigidityTempMatrix->getDOFNumbering();
        throw std::runtime_error( "No matrix set" );
    };

    /**
     * @brief Get the rigidity matrix
     */
    AssemblyMatrixTemperatureDoublePtr getTemperatureStiffnessMatrix() const {
        return _rigidityTempMatrix;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixDisplacementDoublePtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixDisplacementDoublePtr &matr ) {
        _rigidityTempMatrix = nullptr;
        _rigidityDispMatrix = matr;
        return true;
    };

    /**
     * @brief Set the rigidity matrix
     * @param matr AssemblyMatrixTemperatureDoublePtr
     */
    bool setStiffnessMatrix( const AssemblyMatrixTemperatureDoublePtr &matr ) {
        _rigidityDispMatrix = nullptr;
        _rigidityTempMatrix = matr;
        return true;
    };

    /**
     * @brief set interf_dyna
     * @param structureInterface objet StructureInterfacePtr
     */
    bool
    setStructureInterface( StructureInterfacePtr &structureInterface ) throw( std::runtime_error ) {
        _structureInterface = structureInterface;
        return true;
    };

    bool update() throw( std::runtime_error ) {
        BaseDOFNumberingPtr numeDdl( nullptr );
        if ( _rigidityDispMatrix != nullptr )
            numeDdl = _rigidityDispMatrix->getDOFNumbering();
        if ( _rigidityTempMatrix != nullptr )
            numeDdl = _rigidityTempMatrix->getDOFNumbering();

        if ( numeDdl != nullptr ) {
            const auto model = numeDdl->getSupportModel();
            const auto matrElem = numeDdl->getElementaryMatrix();
            if ( model != nullptr )
                _mesh = model->getSupportMesh();
            if ( matrElem != nullptr )
                _mesh = matrElem->getSupportModel()->getSupportMesh();
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
