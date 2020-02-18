#ifndef GENERALIZEDMODEL_H_
#define GENERALIZEDMODEL_H_

/**
 * @file GeneralizedModel.h
 * @brief Fichier entete de la classe GeneralizedModel
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "astercxx.h"

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "Modal/DynamicMacroElement.h"
#include "Supervis/ResultNaming.h"

/**
 * @class GeneralizedModelClass
 * @brief Cette classe correspond a un sd_modele_gene
 * @author Nicolas Sellenet
 */
class GeneralizedModelClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.MODG.DESC' */
    JeveuxVectorLong _modgDesc;
    /** @brief Objet Jeveux '.MODG.LIDF' */
    JeveuxCollectionChar8 _modgLidf;
    /** @brief Objet Jeveux '.MODG.LIPR' */
    JeveuxVectorLong _modgLipr;
    /** @brief Objet Jeveux '.MODG.LIMA' */
    JeveuxVectorReal _modgLima;
    /** @brief Objet Jeveux '.MODG.SSME' */
    JeveuxVectorChar8 _modgSsme;
    /** @brief Objet Jeveux '.MODG.SSNO' */
    JeveuxVectorChar8 _modgSsno;
    /** @brief Objet Jeveux '.MODG.SSOR' */
    JeveuxVectorReal _modgSsor;
    /** @brief Objet Jeveux '.MODG.SSTR' */
    JeveuxVectorReal _modgSstr;
    typedef std::map< std::string, DynamicMacroElementPtr > MapStrMacroElem;
    typedef MapStrMacroElem::iterator MapStrMacroElemIter;
    /** @brief Map which associates a name to a DynamicMacroElementPtr */
    MapStrMacroElem _map;

  public:
    /**
     * @typedef GeneralizedModelPtr
     * @brief Pointeur intelligent vers un GeneralizedModelClass
     */
    typedef boost::shared_ptr< GeneralizedModelClass > GeneralizedModelPtr;

    /**
     * @brief Constructeur
     */
    GeneralizedModelClass( const std::string name = ResultNaming::getNewResultName())
        : DataStructure( name, 14, "MODELE_GENE", Permanent ),
          _modgDesc( JeveuxVectorLong( getName() + ".MODG.DESC" ) ),
          _modgLidf( JeveuxCollectionChar8( getName() + ".MODG.DESC" ) ),
          _modgLipr( JeveuxVectorLong( getName() + ".MODG.DESC" ) ),
          _modgLima( JeveuxVectorReal( getName() + ".MODG.DESC" ) ),
          _modgSsme( JeveuxVectorChar8( getName() + ".MODG.DESC" ) ),
          _modgSsno( JeveuxVectorChar8( getName() + ".MODG.DESC" ) ),
          _modgSsor( JeveuxVectorReal( getName() + ".MODG.DESC" ) ),
          _modgSstr( JeveuxVectorReal( getName() + ".MODG.DESC" ) ){};

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
 * @brief Pointeur intelligent vers un GeneralizedModelClass
 */
typedef boost::shared_ptr< GeneralizedModelClass > GeneralizedModelPtr;

#endif /* GENERALIZEDMODEL_H_ */
