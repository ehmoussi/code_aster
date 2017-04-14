#ifndef DYNAMICMACROELEMENT_H_
#define DYNAMICMACROELEMENT_H_

/**
 * @file DynamicMacroElement.h
 * @brief Fichier entete de la classe DynamicMacroElement
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "Discretization/DOFNumbering.h"


/**
 * @class DynamicMacroElementInstance
 * @brief Cette classe correspond a un MACR_ELEM_DYNA
 * @author Nicolas Sellenet
 */
class DynamicMacroElementInstance: public DataStructure
{
private:
    /** @brief Objet Jeveux '.DESM' */
    JeveuxVectorLong       _desm;
    /** @brief Objet Jeveux '.REFM' */
    JeveuxVectorChar8      _refm;
    /** @brief Objet Jeveux '.CONX' */
    JeveuxVectorLong       _conx;
    /** @brief Objet Jeveux '.LINO' */
    JeveuxVectorLong       _lino;
    /** @brief Objet Jeveux '.MAEL_DESC' */
    JeveuxVectorLong       _maelDesc;
    /** @brief Objet Jeveux '.MAEL_REFE' */
    JeveuxVectorChar24     _maelRefe;
    /** @brief Objet Jeveux '.LICH' */
    JeveuxCollectionChar8  _lich;
    /** @brief Objet Jeveux '.LICA' */
    JeveuxCollectionDouble _lica;
    /** @brief Objet Jeveux '.MAEL_RAID_DESC' */
    JeveuxVectorLong       _maelRaidDesc;
    /** @brief Objet Jeveux '.MAEL_RAID_REFE' */
    JeveuxVectorChar24     _maelRaidRefe;
    /** @brief Objet Jeveux '.MAEL_RAID_VALE' */
    JeveuxVectorDouble     _maelRaidVale;
    /** @brief Objet Jeveux '.MAEL_MASS_DESC' */
    JeveuxVectorLong       _maelMassDesc;
    /** @brief Objet Jeveux '.MAEL_MASS_REFE' */
    JeveuxVectorChar24     _maelMassRefe;
    /** @brief Objet Jeveux '.MAEL_MASS_VALE' */
    JeveuxVectorDouble     _maelMassVale;
    /** @brief Objet Jeveux '.MAEL_AMOR_DESC' */
    JeveuxVectorLong       _maelAmorDesc;
    /** @brief Objet Jeveux '.MAEL_AMOR_REFE' */
    JeveuxVectorChar24     _maelAmorRefe;
    /** @brief Objet Jeveux '.MAEL_AMOR_VALE' */
    JeveuxVectorDouble     _maelAmorVale;
    /** @brief Objet Jeveux '.MAEL_INER_REFE' */
    JeveuxVectorChar24     _maelInerRefe;
    /** @brief Objet Jeveux '.MAEL_INER_VALE' */
    JeveuxVectorDouble     _maelInterVale;
    /** @brief Objet NUME_DDL */
    DOFNumberingPtr        _numeDdl;

public:
    /**
     * @typedef DynamicMacroElementPtr
     * @brief Pointeur intelligent vers un DynamicMacroElementInstance
     */
    typedef std::shared_ptr< DynamicMacroElementInstance > DynamicMacroElementPtr;

    /**
     * @brief Constructeur
     */
    DynamicMacroElementInstance(): 
        DataStructure( "MACR_ELEM_DYNA", Permanent ),
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
        _numeDdl( new DOFNumberingInstance( getName() ) )
    {};

};

/**
 * @typedef DynamicMacroElementPtr
 * @brief Pointeur intelligent vers un DynamicMacroElementInstance
 */
typedef std::shared_ptr< DynamicMacroElementInstance > DynamicMacroElementPtr;

#endif /* DYNAMICMACROELEMENT_H_ */
