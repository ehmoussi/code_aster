#ifndef STATICMACROELEMENT_H_
#define STATICMACROELEMENT_H_

/**
 * @file StaticMacroElement.h
 * @brief Fichier entete de la classe StaticMacroElement
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "LinearAlgebra/AssemblyMatrix.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Supervis/ResultNaming.h"

/**
 * @class ProjMesuClass
 * @brief Cette classe correspond a un PROJ_MESU
 * @author Nicolas Sellenet
 */
class ProjMesuClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.PJMNO' */
    JeveuxVectorLong _pjmno;
    /** @brief Objet Jeveux '.PJMRG' */
    JeveuxVectorChar8 _pjmrg;
    /** @brief Objet Jeveux '.PJMBP' */
    JeveuxVectorReal _pjmbp;
    /** @brief Objet Jeveux '.PJMRF' */
    JeveuxVectorChar16 _pjmrf;
    /** @brief Objet Jeveux '.PJMOR' */
    JeveuxVectorReal _pjmor;
    /** @brief Objet Jeveux '.PJMMM' */
    JeveuxVectorReal _pjmmm;
    /** @brief Objet Jeveux '.PJMIG' */
    JeveuxVectorReal _pjmig;

  public:
    /**
     * @brief Constructeur
     */
    ProjMesuClass( const std::string &name )
        : DataStructure( name, 18, "PROJ_MESU", Permanent ),
          _pjmno( JeveuxVectorLong( getName() + ".PJMNO" ) ),
          _pjmrg( JeveuxVectorChar8( getName() + ".PJMRG" ) ),
          _pjmbp( JeveuxVectorReal( getName() + ".PJMBP" ) ),
          _pjmrf( JeveuxVectorChar16( getName() + ".PJMRF" ) ),
          _pjmor( JeveuxVectorReal( getName() + ".PJMOR" ) ),
          _pjmmm( JeveuxVectorReal( getName() + ".PJMMM" ) ),
          _pjmig( JeveuxVectorReal( getName() + ".PJMIG" ) ){};
};

/**
 * @typedef ProjMesuClassPtr
 * @brief Pointeur intelligent vers un ProjMesuClass
 */
typedef boost::shared_ptr< ProjMesuClass > ProjMesuPtr;

/**
 * @class StaticMacroElementClass
 * @brief Cette classe correspond a un MACR_ELEM_STAT
 * @author Nicolas Sellenet
 */
class StaticMacroElementClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.DESM' */
    JeveuxVectorLong _desm;
    /** @brief Objet Jeveux '.LINO' */
    JeveuxVectorLong _lino;
    /** @brief Objet Jeveux '.REFM' */
    JeveuxVectorChar8 _refm;
    /** @brief Objet Jeveux '.VARM' */
    JeveuxVectorReal _varm;
    /** @brief Objet Jeveux '.CONX' */
    JeveuxVectorLong _conx;
    /** @brief Objet Jeveux '.RIGIMECA' */
    AssemblyMatrixDisplacementRealPtr _rigiMeca;
    /** @brief Objet Jeveux '.MAEL_RAID_VALE' */
    JeveuxVectorReal _maelRaidVale;
    /** @brief Objet Jeveux '.PHI_IE' */
    JeveuxCollectionReal _phiIe;
    /** @brief Objet Jeveux '.MASSMECA' */
    AssemblyMatrixDisplacementRealPtr _masseMeca;
    /** @brief Objet Jeveux '.MAEL_MASS_VALE' */
    JeveuxVectorReal _maelMassVale;
    /** @brief Objet Jeveux '.MAEL_AMOR_VALE' */
    JeveuxVectorReal _maelAmorVale;
    /** @brief Objet Jeveux '.LICA' */
    JeveuxCollectionReal _lica;
    /** @brief Objet Jeveux '.LICH' */
    JeveuxCollectionChar8 _lich;
    /** @brief Objet PROJ_MESU '        .PROJM    ' */
    ProjMesuPtr _projM;

  public:
    /**
     * @typedef StaticMacroElementPtr
     * @brief Pointeur intelligent vers un StaticMacroElementClass
     */
    typedef boost::shared_ptr< StaticMacroElementClass > StaticMacroElementPtr;

    /**
     * @brief Constructeur
     */
    StaticMacroElementClass( const std::string name = ResultNaming::getNewResultName() )
        : DataStructure( name, 8, "MACR_ELEM_STAT", Permanent ),
          _desm( JeveuxVectorLong( getName() + ".DESM" ) ),
          _lino( JeveuxVectorLong( getName() + ".LINO" ) ),
          _refm( JeveuxVectorChar8( getName() + ".REFM" ) ),
          _varm( JeveuxVectorReal( getName() + ".VARM" ) ),
          _conx( JeveuxVectorLong( getName() + ".CONX" ) ),
          _rigiMeca( new AssemblyMatrixDisplacementRealClass( getName() + ".RIGIMECA" ) ),
          _maelRaidVale( JeveuxVectorReal( getName() + ".MAEL_RAID_VALE" ) ),
          _phiIe( JeveuxCollectionReal( getName() + ".PHI_IE" ) ),
          _masseMeca( new AssemblyMatrixDisplacementRealClass( getName() + ".MASSMECA" ) ),
          _maelMassVale( JeveuxVectorReal( getName() + ".MAEL_MASS_VALE" ) ),
          _maelAmorVale( JeveuxVectorReal( getName() + ".MAEL_AMOR_VALE" ) ),
          _lica( JeveuxCollectionReal( getName() + ".LICA" ) ),
          _lich( JeveuxCollectionChar8( getName() + ".LICH" ) ),
          _projM( new ProjMesuClass( getName() + ".PROJM    " ) ){};
};

/**
 * @typedef StaticMacroElementPtr
 * @brief Pointeur intelligent vers un StaticMacroElementClass
 */
typedef boost::shared_ptr< StaticMacroElementClass > StaticMacroElementPtr;

#endif /* STATICMACROELEMENT_H_ */
