#ifndef GENERALIZEDMODEL_H_
#define GENERALIZEDMODEL_H_

/**
 * @file GeneralizedModel.h
 * @brief Fichier entete de la classe GeneralizedModel
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "Modal/DynamicMacroElement.h"

/**
 * @class GeneralizedModelInstance
 * @brief Cette classe correspond a un sd_modele_gene
 * @author Nicolas Sellenet
 */
class GeneralizedModelInstance : public DataStructure {
  private:
    /** @brief Objet Jeveux '.MODG.DESC' */
    JeveuxVectorLong _modgDesc;
    /** @brief Objet Jeveux '.MODG.LIDF' */
    JeveuxCollectionChar8 _modgLidf;
    /** @brief Objet Jeveux '.MODG.LIPR' */
    JeveuxVectorLong _modgLipr;
    /** @brief Objet Jeveux '.MODG.LIMA' */
    JeveuxVectorDouble _modgLima;
    /** @brief Objet Jeveux '.MODG.SSME' */
    JeveuxVectorChar8 _modgSsme;
    /** @brief Objet Jeveux '.MODG.SSNO' */
    JeveuxVectorChar8 _modgSsno;
    /** @brief Objet Jeveux '.MODG.SSOR' */
    JeveuxVectorDouble _modgSsor;
    /** @brief Objet Jeveux '.MODG.SSTR' */
    JeveuxVectorDouble _modgSstr;
    typedef std::map< std::string, DynamicMacroElementPtr > MapStrMacroElem;
    typedef MapStrMacroElem::iterator MapStrMacroElemIter;
    /** @brief Map which associates a name to a DynamicMacroElementPtr */
    MapStrMacroElem _map;

  public:
    /**
     * @typedef GeneralizedModelPtr
     * @brief Pointeur intelligent vers un GeneralizedModelInstance
     */
    typedef boost::shared_ptr< GeneralizedModelInstance > GeneralizedModelPtr;

    /**
     * @brief Constructeur
     */
    GeneralizedModelInstance()
        : DataStructure( "MODELE_GENE", Permanent, 14 ),
          _modgDesc( JeveuxVectorLong( getName() + ".MODG.DESC" ) ),
          _modgLidf( JeveuxCollectionChar8( getName() + ".MODG.DESC" ) ),
          _modgLipr( JeveuxVectorLong( getName() + ".MODG.DESC" ) ),
          _modgLima( JeveuxVectorDouble( getName() + ".MODG.DESC" ) ),
          _modgSsme( JeveuxVectorChar8( getName() + ".MODG.DESC" ) ),
          _modgSsno( JeveuxVectorChar8( getName() + ".MODG.DESC" ) ),
          _modgSsor( JeveuxVectorDouble( getName() + ".MODG.DESC" ) ),
          _modgSstr( JeveuxVectorDouble( getName() + ".MODG.DESC" ) ){};

    /**
     * @brief Add a DynamicMacroElement associated to a name
     */
    bool addDynamicMacroElement( const std::string &name, const DynamicMacroElementPtr &elem ) {
        _map[name] = elem;
        return true;
    };

    /**
     * @brief Get DynamicMacroElementPtr from name
     */
    DynamicMacroElementPtr getDynamicMacroElementFromName( const std::string &name ) {
        return _map[name];
    };
};

/**
 * @typedef GeneralizedModelPtr
 * @brief Pointeur intelligent vers un GeneralizedModelInstance
 */
typedef boost::shared_ptr< GeneralizedModelInstance > GeneralizedModelPtr;

#endif /* GENERALIZEDMODEL_H_ */
