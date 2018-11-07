#ifndef MECHANICALMODECOMPLEXCONTAINER_H_
#define MECHANICALMODECOMPLEXCONTAINER_H_

/**
 * @file MechanicalModeComplexContainer.h
 * @brief Fichier entete de la classe MechanicalModeComplexContainer
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

/**
 * @class MechanicalModeComplexContainerInstance
 * @brief Cette classe correspond a un mode_meca_c
 * On a choisi de définir un MechanicalModeComplexContainerInstance comme
   un résultat disposant, en plus des membres usuels d'un résultat, de champs aux noeuds complexes.
 * @author Natacha Béreux
 */
class MechanicalModeComplexContainerInstance : public FullResultsContainerInstance {
  private:
    typedef std::vector< FieldOnNodesComplexPtr > VectorOfComplexFieldsNodes;

    /** @typedef std::map d'une chaine et des pointers vers toutes les DataStructure */
    typedef std::map< std::string, VectorOfComplexFieldsNodes > mapStrVOCFN;
    /** @typedef Iterateur sur le std::map */
    typedef mapStrVOCFN::iterator mapStrVOCFNIterator;
    /** @typedef Valeur contenue dans mapStrVOFN */
    typedef mapStrVOCFN::value_type mapStrVOCFNValue;
    /** @brief Liste des champs aux noeuds */
    mapStrVOCFN _dictOfVectorOfComplexFieldsNodes;
    /** */
    StructureInterfacePtr _structureInterface;
    /** @brief Damping matrix */
    AssemblyMatrixDisplacementDoublePtr _dampingMatrix;
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
    MechanicalModeComplexContainerInstance():
        FullResultsContainerInstance( "MODE_MECA_C" ),
        _structureInterface( StructureInterfacePtr() ),
        _dampingMatrix( nullptr ),
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
    MechanicalModeComplexContainerInstance( const std::string &name ):
        FullResultsContainerInstance( name, "MODE_MECA_C" ),
        _structureInterface( StructureInterfacePtr() ),
        _dampingMatrix( nullptr ),
        _rigidityDispDMatrix( nullptr ),
        _rigidityDispCMatrix( nullptr ),
        _rigidityTempDMatrix( nullptr ),
        _rigidityPressDMatrix( nullptr ),
        _rigidityGDMatrix( nullptr ),
        _rigidityGCMatrix( nullptr )
    {};

    /**
     * @brief Obtenir un champ aux noeuds complexe vide à partir de son nom et de son numéro d'ordre
     * @param name nom Aster du champ
     * @param rank numéro d'ordre
     * @return FieldOnNodesDoublePtr pointant vers le champ
     */
    FieldOnNodesComplexPtr
    getEmptyFieldOnNodesComplex( const std::string name,
                                 const int rank ) throw( std::runtime_error );

    /**
    * @brief Obtenir un champ aux noeuds complexe à partir de son nom et de son numéro d'ordre
    * @param name nom Aster du champ
    * @param rank numéro d'ordre
    * @return FieldOnNodesDoublePtr pointant vers le champ
    */
    FieldOnNodesComplexPtr getComplexFieldOnNodes( const std::string name, const int rank ) const
        throw( std::runtime_error );

    /**
     * @brief Set the damping matrix
     * @param matr AssemblyMatrixDisplacementDoublePtr
     */
    bool setDampingMatrix( const AssemblyMatrixDisplacementDoublePtr &matr ) {
        _dampingMatrix = matr;
        return true;
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
    bool
    setStructureInterface( StructureInterfacePtr &structureInterface ) throw( std::runtime_error ) {
        _structureInterface = structureInterface;
        return true;
    };

    bool update() throw( std::runtime_error ) {
        BaseDOFNumberingPtr numeDdl( nullptr );
        if ( _dampingMatrix != nullptr )
            numeDdl = _dampingMatrix->getDOFNumbering();
        if ( _rigidityDispDMatrix != nullptr )
            numeDdl = _rigidityDispDMatrix->getDOFNumbering();
        if ( _rigidityDispCMatrix != nullptr )
            numeDdl = _rigidityDispCMatrix->getDOFNumbering();
        if ( _rigidityTempDMatrix != nullptr )
            numeDdl = _rigidityTempDMatrix->getDOFNumbering();
        if ( _rigidityPressDMatrix != nullptr )
            numeDdl = _rigidityPressDMatrix->getDOFNumbering();

        if ( numeDdl != nullptr ) {
            const auto model = numeDdl->getSupportModel();
            if ( model != nullptr )
                _mesh = model->getSupportMesh();
        }
        return ResultsContainerInstance::update();
    };
};

/**
 * @typedef MechanicalModeComplexContainerPtr
 * @brief Pointeur intelligent vers un MechanicalModeComplexContainerInstance
 */
typedef boost::shared_ptr< MechanicalModeComplexContainerInstance >
    MechanicalModeComplexContainerPtr;

#endif /* MECHANICALMODECOMPLEXCONTAINER_H_ */
