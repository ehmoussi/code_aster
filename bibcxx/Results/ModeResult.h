#ifndef MECHANICALMODERESULT_H_
#define MECHANICALMODERESULT_H_

/**
 * @file ModeResult.h
 * @brief Fichier entete de la classe ModeResult
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
#include "Interfaces/StructureInterface.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"
#include "Numbering/DOFNumbering.h"

/**
 * @class ModeResultClass
 * @brief Cette classe correspond a un mode_meca
 * @author Nicolas Sellenet
 */
class ModeResultClass : public FullResultClass
{
  private:
    StructureInterfacePtr _structureInterface;
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
    /** @brief Mass double displacement matrix */
    AssemblyMatrixDisplacementRealPtr _massDispDMatrix;
    /** @brief Mass complex displacement matrix */
    AssemblyMatrixDisplacementComplexPtr _massDispCMatrix;
    /** @brief Mass double temperature matrix */
    AssemblyMatrixTemperatureRealPtr _massTempDMatrix;
    /** @brief Mass double pressure matrix */
    AssemblyMatrixPressureRealPtr _massPressDMatrix;
    /** @brief Mass generalized double matrix */
    GeneralizedAssemblyMatrixRealPtr _massGDMatrix;
    /** @brief Mass generalized complex matrix */
    GeneralizedAssemblyMatrixComplexPtr _massGCMatrix;

  public:
    /**
     * @brief Constructeur
     */
    ModeResultClass():
        ModeResultClass( ResultNaming::getNewResultName(), "MODE_MECA" )
    {};

    /**
     * @brief Constructeur
     */
    ModeResultClass( const std::string &name,
                                     const std::string type = "MODE_MECA" ):
        FullResultClass( name, type ),
        _structureInterface( StructureInterfacePtr() ),
        _rigidityDispDMatrix( nullptr ),
        _rigidityDispCMatrix( nullptr ),
        _rigidityTempDMatrix( nullptr ),
        _rigidityPressDMatrix( nullptr ),
        _rigidityGDMatrix( nullptr ),
        _rigidityGCMatrix( nullptr ),
        _massDispDMatrix( nullptr ),
        _massDispCMatrix( nullptr ),
        _massTempDMatrix( nullptr ),
        _massPressDMatrix( nullptr ),
        _massGDMatrix( nullptr ),
        _massGCMatrix( nullptr )
    {};

     /**
     * @brief Get the DOFNumbering
     */
    BaseDOFNumberingPtr getDOFNumbering() const
    {
        if ( _dofNum != nullptr )
            return _dofNum;
        if ( _rigidityDispDMatrix != nullptr )
            return _rigidityDispDMatrix->getDOFNumbering();
        if ( _rigidityTempDMatrix != nullptr )
            return _rigidityTempDMatrix->getDOFNumbering();
        return BaseDOFNumberingPtr( nullptr );
    };

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
    /**
     * @brief Get the mass matrix
     */
    AssemblyMatrixDisplacementComplexPtr getDisplacementComplexMassMatrix() const
    {
        return _massDispCMatrix;
    };

    /**
     * @brief Get the mass matrix
     */
    AssemblyMatrixDisplacementRealPtr getDisplacementRealMassMatrix() const
    {
        return _massDispDMatrix;
    };


    /**
     * @brief Get the mass matrix
     */
    AssemblyMatrixPressureRealPtr getPressureRealMassMatrix() const
    {
        return _massPressDMatrix;
    };

    /**
     * @brief Get the mass matrix
     */
    AssemblyMatrixTemperatureRealPtr getTemperatureRealMassMatrix() const
    {
        return _massTempDMatrix;
    };

    /**
     * @brief Set the mass matrix
     * @param matr AssemblyMatrixDisplacementRealPtr
     */
    bool setMassMatrix( const AssemblyMatrixDisplacementRealPtr &matr )
    {
        _massDispDMatrix = matr;
        _massDispCMatrix = nullptr;
        _massTempDMatrix = nullptr;
        _massPressDMatrix = nullptr;
        _massGDMatrix = nullptr;
        _massGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the mass matrix
     * @param matr AssemblyMatrixDisplacementComplexPtr
     */
    bool setMassMatrix( const AssemblyMatrixDisplacementComplexPtr &matr )
    {
        _massDispDMatrix = nullptr;
        _massDispCMatrix = matr;
        _massTempDMatrix = nullptr;
        _massPressDMatrix = nullptr;
        _massGDMatrix = nullptr;
        _massGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the mass matrix
     * @param matr AssemblyMatrixTemperatureRealPtr
     */
    bool setMassMatrix( const AssemblyMatrixTemperatureRealPtr &matr )
    {
        _massDispDMatrix = nullptr;
        _massDispCMatrix = nullptr;
        _massTempDMatrix = matr;
        _massPressDMatrix = nullptr;
        _massGDMatrix = nullptr;
        _massGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the mass matrix
     * @param matr AssemblyMatrixPressureRealPtr
     */
    bool setMassMatrix( const AssemblyMatrixPressureRealPtr &matr )
    {
        _massDispDMatrix = nullptr;
        _massDispCMatrix = nullptr;
        _massTempDMatrix = nullptr;
        _massPressDMatrix = matr;
        _massGDMatrix = nullptr;
        _massGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the mass matrix
     * @param matr GeneralizedAssemblyMatrixRealPtr
     */
    bool setMassMatrix( const GeneralizedAssemblyMatrixRealPtr &matr )
    {
        _massDispDMatrix = nullptr;
        _massDispCMatrix = nullptr;
        _massTempDMatrix = nullptr;
        _massPressDMatrix = nullptr;
        _massGDMatrix = matr;
        _massGCMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set the mass matrix
     * @param matr GeneralizedAssemblyMatrixComplexPtr
     */
    bool setMassMatrix( const GeneralizedAssemblyMatrixComplexPtr &matr )
    {
        _massDispDMatrix = nullptr;
        _massDispCMatrix = nullptr;
        _massTempDMatrix = nullptr;
        _massPressDMatrix = nullptr;
        _massGDMatrix = nullptr;
        _massGCMatrix = matr;
        return true;
    };
    /**
     * @brief set interf_dyna
     * @param structureInterface objet StructureInterfacePtr
     */
    bool setStructureInterface( StructureInterfacePtr &structureInterface ) {
        _structureInterface = structureInterface;
        return true;
    };

    bool update() {
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
 * @typedef ModeResultPtr
 * @brief Pointeur intelligent vers un ModeResultClass
 */
typedef boost::shared_ptr< ModeResultClass > ModeResultPtr;

#endif /* MECHANICALMODERESULT_H_ */
