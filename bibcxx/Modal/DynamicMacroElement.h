#ifndef DYNAMICMACROELEMENT_H_
#define DYNAMICMACROELEMENT_H_

/**
 * @file DynamicMacroElement.h
 * @brief Fichier entete de la classe DynamicMacroElement
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "Discretization/DOFNumbering.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Results/MechanicalModeContainer.h"
#include "Supervis/ResultNaming.h"

/**
 * @class DynamicMacroElementInstance
 * @brief Cette classe correspond a un MACR_ELEM_DYNA
 * @author Nicolas Sellenet
 */
class DynamicMacroElementInstance : public DataStructure {
  private:
    /** @brief Objet Jeveux '.DESM' */
    JeveuxVectorLong _desm;
    /** @brief Objet Jeveux '.REFM' */
    JeveuxVectorChar8 _refm;
    /** @brief Objet Jeveux '.CONX' */
    JeveuxVectorLong _conx;
    /** @brief Objet Jeveux '.LINO' */
    JeveuxVectorLong _lino;
    /** @brief Objet Jeveux '.MAEL_DESC' */
    JeveuxVectorLong _maelDesc;
    /** @brief Objet Jeveux '.MAEL_REFE' */
    JeveuxVectorChar24 _maelRefe;
    /** @brief Objet Jeveux '.LICH' */
    JeveuxCollectionChar8 _lich;
    /** @brief Objet Jeveux '.LICA' */
    JeveuxCollectionDouble _lica;
    /** @brief Objet Jeveux '.MAEL_RAID_DESC' */
    JeveuxVectorLong _maelRaidDesc;
    /** @brief Objet Jeveux '.MAEL_RAID_REFE' */
    JeveuxVectorChar24 _maelRaidRefe;
    /** @brief Objet Jeveux '.MAEL_RAID_VALE' */
    JeveuxVectorDouble _maelRaidVale;
    /** @brief Objet Jeveux '.MAEL_MASS_DESC' */
    JeveuxVectorLong _maelMassDesc;
    /** @brief Objet Jeveux '.MAEL_MASS_REFE' */
    JeveuxVectorChar24 _maelMassRefe;
    /** @brief Objet Jeveux '.MAEL_MASS_VALE' */
    JeveuxVectorDouble _maelMassVale;
    /** @brief Objet Jeveux '.MAEL_AMOR_DESC' */
    JeveuxVectorLong _maelAmorDesc;
    /** @brief Objet Jeveux '.MAEL_AMOR_REFE' */
    JeveuxVectorChar24 _maelAmorRefe;
    /** @brief Objet Jeveux '.MAEL_AMOR_VALE' */
    JeveuxVectorDouble _maelAmorVale;
    /** @brief Objet Jeveux '.MAEL_INER_REFE' */
    JeveuxVectorChar24 _maelInerRefe;
    /** @brief Objet Jeveux '.MAEL_INER_VALE' */
    JeveuxVectorDouble _maelInterVale;
    /** @brief Objet NUME_DDL */
    DOFNumberingPtr _numeDdl;
    /** @brief Mode Meca sur lequel repose le macro emement */
    MechanicalModeContainerPtr _supportMechanicalMode;
    /** @brief double rigidity matrix */
    AssemblyMatrixDisplacementDoublePtr _rigidityDMatrix;
    /** @brief complex rigidity matrix */
    AssemblyMatrixDisplacementComplexPtr _rigidityCMatrix;
    /** @brief mass matrix */
    AssemblyMatrixDisplacementDoublePtr _massMatrix;
    /** @brief damping matrix */
    AssemblyMatrixDisplacementDoublePtr _dampingMatrix;
    /** @brief MATR_IMPE */
    GeneralizedAssemblyMatrixComplexPtr _impeMatrix;
    /** @brief MATR_IMPE_RIGI */
    GeneralizedAssemblyMatrixComplexPtr _impeRigiMatrix;
    /** @brief MATR_IMPE_MASS */
    GeneralizedAssemblyMatrixComplexPtr _impeMassMatrix;
    /** @brief MATR_IMPE_AMOR */
    GeneralizedAssemblyMatrixComplexPtr _impeAmorMatrix;

  public:
    /**
     * @typedef DynamicMacroElementPtr
     * @brief Pointeur intelligent vers un DynamicMacroElementInstance
     */
    typedef boost::shared_ptr< DynamicMacroElementInstance > DynamicMacroElementPtr;

    /**
     * @brief Constructeur
     */
    DynamicMacroElementInstance()
        : DynamicMacroElementInstance( ResultNaming::getNewResultName() ){};

    DynamicMacroElementInstance( const std::string name )
        : DataStructure( name, 8, "MACR_ELEM_DYNA", Permanent ),
          _desm( JeveuxVectorLong( getName() + ".DESM" ) ),
          _refm( JeveuxVectorChar8( getName() + ".REFM" ) ),
          _conx( JeveuxVectorLong( getName() + ".CONX" ) ),
          _lino( JeveuxVectorLong( getName() + ".LINO" ) ),
          _maelDesc( JeveuxVectorLong( getName() + ".MAEL_DESC" ) ),
          _maelRefe( JeveuxVectorChar24( getName() + ".MAEL_REFE" ) ),
          _lich( JeveuxCollectionChar8( getName() + ".LICH" ) ),
          _lica( JeveuxCollectionDouble( getName() + ".LICA" ) ),
          _maelRaidDesc( JeveuxVectorLong( getName() + ".MAEL_RAID_DESC" ) ),
          _maelRaidRefe( JeveuxVectorChar24( getName() + ".MAEL_RAID_REFE" ) ),
          _maelRaidVale( JeveuxVectorDouble( getName() + ".MAEL_RAID_VALE" ) ),
          _maelMassDesc( JeveuxVectorLong( getName() + ".MAEL_MASS_DESC" ) ),
          _maelMassRefe( JeveuxVectorChar24( getName() + ".MAEL_MASS_REFE" ) ),
          _maelMassVale( JeveuxVectorDouble( getName() + ".MAEL_MASS_VALE" ) ),
          _maelAmorDesc( JeveuxVectorLong( getName() + ".MAEL_AMOR_DESC" ) ),
          _maelAmorRefe( JeveuxVectorChar24( getName() + ".MAEL_AMOR_REFE" ) ),
          _maelAmorVale( JeveuxVectorDouble( getName() + ".MAEL_AMOR_VALE" ) ),
          _maelInerRefe( JeveuxVectorChar24( getName() + ".MAEL_INER_REFE" ) ),
          _maelInterVale( JeveuxVectorDouble( getName() + ".MAEL_INER_VALE" ) ),
          _numeDdl( nullptr ),
          _supportMechanicalMode( MechanicalModeContainerPtr() ), _rigidityDMatrix( nullptr ),
          _rigidityCMatrix( nullptr ), _massMatrix( nullptr ), _dampingMatrix( nullptr ),
          _impeMatrix( nullptr ), _impeRigiMatrix( nullptr ), _impeMassMatrix( nullptr ),
          _impeAmorMatrix( nullptr ){};

    /**
     * @brief Get damping matrix
     */
    AssemblyMatrixDisplacementDoublePtr getDampingMatrix() { return _dampingMatrix; };

    DOFNumberingPtr getDOFNumbering() const
    {
        return _numeDdl;
    };

    /**
     * @brief Get impedance matrix
     */
    GeneralizedAssemblyMatrixComplexPtr getImpedanceDampingMatrix() { return _impeAmorMatrix; };

    /**
     * @brief Get impedance matrix
     */
    GeneralizedAssemblyMatrixComplexPtr getImpedanceMatrix() { return _impeMatrix; };

    /**
     * @brief Get impedance matrix
     */
    GeneralizedAssemblyMatrixComplexPtr getImpedanceMassMatrix() { return _impeMassMatrix; };

    /**
     * @brief Get impedance matrix
     */
    GeneralizedAssemblyMatrixComplexPtr getImpedanceStiffnessMatrix() { return _impeRigiMatrix; };

    /**
     * @brief Get mass matrix
     */
    AssemblyMatrixDisplacementDoublePtr getMassMatrix() { return _massMatrix; };

    /**
     * @brief Get rigidity matrix
     */
    AssemblyMatrixDisplacementComplexPtr getComplexStiffnessMatrix() { return _rigidityCMatrix; };

    /**
     * @brief Get rigidity matrix
     */
    AssemblyMatrixDisplacementDoublePtr getDoubleStiffnessMatrix() { return _rigidityDMatrix; };

    /**
     * @brief Set damping matrix
     * @param matrix AssemblyMatrixDisplacementDoublePtr object
     */
    bool setDampingMatrix( const AssemblyMatrixDisplacementDoublePtr &matrix ) {
        _dampingMatrix = matrix;
        return true;
    };

    bool setDOFNumbering( const DOFNumberingPtr &dofNum )
    {
        _numeDdl = dofNum;
        return true;
    };

    /**
     * @brief Set impedance matrix
     * @param matrix AssemblyMatrixDisplacementDoublePtr object
     */
    bool setImpedanceDampingMatrix( const GeneralizedAssemblyMatrixComplexPtr &matrix ) {
        _impeAmorMatrix = matrix;
        return true;
    };

    /**
     * @brief Set impedance matrix
     * @param matrix AssemblyMatrixDisplacementDoublePtr object
     */
    bool setImpedanceMatrix( const GeneralizedAssemblyMatrixComplexPtr &matrix ) {
        _impeMatrix = matrix;
        return true;
    };

    /**
     * @brief Set impedance matrix
     * @param matrix AssemblyMatrixDisplacementDoublePtr object
     */
    bool setImpedanceMassMatrix( const GeneralizedAssemblyMatrixComplexPtr &matrix ) {
        _impeMassMatrix = matrix;
        return true;
    };

    /**
     * @brief Set impedance matrix
     * @param matrix AssemblyMatrixDisplacementDoublePtr object
     */
    bool setImpedanceStiffnessMatrix( const GeneralizedAssemblyMatrixComplexPtr &matrix ) {
        _impeRigiMatrix = matrix;
        return true;
    };

    /**
     * @brief Set mass matrix
     * @param matrix AssemblyMatrixDisplacementDoublePtr object
     */
    bool setMassMatrix( const AssemblyMatrixDisplacementDoublePtr &matrix ) {
        _massMatrix = matrix;
        return true;
    };

    /**
     * @brief Set the support MechanicalModeContainer
     * @param mechanicalMode MechanicalModeContainerPtr object
     */
    bool setSupportMechanicalMode( MechanicalModeContainerPtr &mechanicalMode ) {
        _supportMechanicalMode = mechanicalMode;
        return true;
    };

    /**
     * @brief Set rigidity matrix
     * @param matrix AssemblyMatrixDisplacementComplexPtr object
     */
    bool setStiffnessMatrix( const AssemblyMatrixDisplacementComplexPtr &matrix ) {
        _rigidityCMatrix = matrix;
        _rigidityDMatrix = nullptr;
        return true;
    };

    /**
     * @brief Set rigidity matrix
     * @param matrix AssemblyMatrixDisplacementDoublePtr object
     */
    bool setStiffnessMatrix( const AssemblyMatrixDisplacementDoublePtr &matrix ) {
        _rigidityDMatrix = matrix;
        _rigidityCMatrix = nullptr;
        return true;
    };
};

/**
 * @typedef DynamicMacroElementPtr
 * @brief Pointeur intelligent vers un DynamicMacroElementInstance
 */
typedef boost::shared_ptr< DynamicMacroElementInstance > DynamicMacroElementPtr;

#endif /* DYNAMICMACROELEMENT_H_ */
