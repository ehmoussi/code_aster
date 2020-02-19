#ifndef MECHANICALMODECOMPLEXCONTAINER_H_
#define MECHANICALMODECOMPLEXCONTAINER_H_

/**
 * @file ModeResultComplex.h
 * @brief Fichier entete de la classe ModeResultComplex
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

#include "Results/ModeResult.h"
#include "LinearAlgebra/StructureInterface.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"

/**
 * @class ModeResultComplexClass
 * @brief Cette classe correspond a un mode_meca_c
 * On a choisi de définir un ModeResultComplexClass comme
   un résultat disposant, en plus des membres usuels d'un résultat, de champs aux noeuds complexes.
 * @author Natacha Béreux
 */
class ModeResultComplexClass : public ModeResultClass {
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
    AssemblyMatrixDisplacementRealPtr _dampingMatrix;
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
    ModeResultComplexClass():
        ModeResultComplexClass( ResultNaming::getNewResultName() )
    {};

    /**
     * @brief Constructeur
     */
    ModeResultComplexClass( const std::string &name ):
       ModeResultClass ( name, "MODE_MECA_C" ),
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
     * @return FieldOnNodesRealPtr pointant vers le champ
     */
    FieldOnNodesComplexPtr
    getEmptyFieldOnNodesComplex( const std::string name,
                                 const int rank ) ;

    /**
    * @brief Obtenir un champ aux noeuds complexe à partir de son nom et de son numéro d'ordre
    * @param name nom Aster du champ
    * @param rank numéro d'ordre
    * @return FieldOnNodesRealPtr pointant vers le champ
    */
    FieldOnNodesComplexPtr getComplexFieldOnNodes( const std::string name, const int rank ) const
        ;

    /**
     * @brief Set the damping matrix
     * @param matr AssemblyMatrixDisplacementRealPtr
     */
    bool setDampingMatrix( const AssemblyMatrixDisplacementRealPtr &matr ) {
        _dampingMatrix = matr;
        return true;
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
     * @brief set interf_dyna
     * @param structureInterface objet StructureInterfacePtr
     */
    bool
    setStructureInterface( StructureInterfacePtr &structureInterface ) {
        _structureInterface = structureInterface;
        return true;
    };

    bool update() {
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
            const auto model = numeDdl->getModel();
            if ( model != nullptr )
                _mesh = model->getMesh();
        }
        return ResultClass::update();
    };
};

/**
 * @typedef ModeResultComplexPtr
 * @brief Pointeur intelligent vers un ModeResultComplexClass
 */
typedef boost::shared_ptr< ModeResultComplexClass >
    ModeResultComplexPtr;

#endif /* MECHANICALMODECOMPLEXCONTAINER_H_ */
