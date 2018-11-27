#ifndef TABLE_H_
#define TABLE_H_

/**
 * @file Table.h
 * @brief Fichier entete de la classe Table
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

#include <string>

#include "astercxx.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxVector.h"
#include "DataStructures/DataStructure.h"
#include "Supervis/ResultNaming.h"

/**
 * @class TableInstance
 * @brief Cette classe template permet de definir une table Aster
 * @author Nicolas Sellenet
 */
class TableInstance : public DataStructure {
  private:
    /** @brief Vecteur Jeveux '.TBBA' */
    JeveuxVectorChar8 _memoryLocation;
    /** @brief Vecteur Jeveux '.TBNP' */
    JeveuxVectorLong _description;
    /** @brief Vecteur Jeveux '.TBLP' */
    JeveuxVectorChar24 _parameterDescription;
    /** @brief Booléen indiquant si l'objet est vide */
    bool _isEmpty;

  public:
    /**
    * @typedef TablePtr
    * @brief Definition of a smart pointer to a TableInstance
    */
    typedef boost::shared_ptr< TableInstance > TablePtr;

    // FIXME: Development documentation says 17 chars + "  ", for 'LG' logicals.

    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux noeuds
     */
    TableInstance( const std::string &name )
        : DataStructure( name, 19, "TABLE" ),
          _memoryLocation( JeveuxVectorChar8( getName() + ".TBBA" ) ),
          _description( JeveuxVectorLong( getName() + ".TBNP" ) ),
          _parameterDescription( JeveuxVectorChar24( getName() + ".TBLP" ) ){
              // std::cout<< "name = "<< this->getName() << std::endl ;
          };

    /**
     * @brief Constructeur
     */
    TableInstance()
        : DataStructure( ResultNaming::getNewResultName(), 19, "TABLE" ),
          _memoryLocation( JeveuxVectorChar8( getName() + ".TBBA" ) ),
          _description( JeveuxVectorLong( getName() + ".TBNP" ) ),
          _parameterDescription( JeveuxVectorChar24( getName() + ".TBLP" ) ){
              // std::cout<< "name = "<< this->getName() << std::endl ;
          };

    ~TableInstance() {
#ifdef __DEBUG_GC__
        std::cout << "Table.destr: " << this->getName() << std::endl;
#endif
        if ( _parameterDescription->exists() && _description->exists() ) {
            _parameterDescription->updateValuePointer();
            _description->updateValuePointer();
            const int nbParam = ( *_description )[0];
            // Pour que la desctruction soit effective, on créé des JeveuxVector pour déclencher
            // l'appel à JEDETR
            for ( int i = 0; i < nbParam; ++i ) {
                const JeveuxChar24 &name1 = ( *_parameterDescription )[i * 4 + 2];
                JeveuxVectorDouble test1( name1.toString() );
                const JeveuxChar24 &name2 = ( *_parameterDescription )[i * 4 + 3];
                JeveuxVectorDouble test2( name2.toString() );
            }
        }
    };
};

/**
  * @typedef TablePtr
  * @brief Definition of a smart pointer to a TableInstance
  */
typedef boost::shared_ptr< TableInstance > TablePtr;

/**
 * @typedef TableOfFunctionsInstance
 * @brief Definition of TableOfFunctionsInstance (table_fonction)
 */
class TableOfFunctionsInstance : public TableInstance {
  public:
    /**
    * @typedef TableOfFunctionsPtr
    * @brief Definition of a smart pointer to a TableOfFunctionsInstance
    */
    typedef boost::shared_ptr< TableOfFunctionsInstance > TableOfFunctionsPtr;
    /**
    * @brief Constructeur
    * @param name Nom Jeveux du champ aux noeuds
    */
    TableOfFunctionsInstance( const std::string &name ) : TableInstance( name ) {
        this->setType( "TABLE_FONCTION" );
    };

    /**
     * @brief Constructeur
     */
    TableOfFunctionsInstance() : TableInstance() { this->setType( "TABLE_FONCTION" ); };
};

/**
 * @typedef TableContainerInstance
 * @brief Definition of TableContainerInstance (table_container)
 */

class TableContainerInstance : public TableInstance {
  public:
    /**
    * @typedef TableContainerPtr
    * @brief Definition of a smart pointer to a TableContainerInstance
    */
    typedef boost::shared_ptr< TableContainerInstance > TableContainerPtr;
    /**
    * @brief Constructeur
    * @param name Nom Jeveux du champ aux noeuds
    */
    TableContainerInstance( const std::string &name ) : TableInstance( name ) {
        this->setType( "TABLE_CONTAINER" );
    };

    /**
     * @brief Constructeur
     */
    TableContainerInstance() : TableInstance() { this->setType( "TABLE_CONTAINER" ); };
};

#endif /* TABLE_H_ */
