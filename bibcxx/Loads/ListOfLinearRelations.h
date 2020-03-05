#ifndef LISTOFLINEARRELATIONS_H_
#define LISTOFLINEARRELATIONS_H_

/**
 * @file ListOfLinearRelations.h
 * @brief Fichier entete de la classe ListOfLinearRelations
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D     www.code-aster.org
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

#include <stdexcept>

#include "astercxx.h"
#include "MemoryManager/JeveuxVector.h"
#include "DataStructures/DataStructure.h"

/**
 * @class ListOfLinearRelationsClass
 * @brief Classe definissant une liste_rela
 * @author Nicolas Sellenet
 * @todo Prendre en compte le cas Function
 */
template < class ValueType > class ListOfLinearRelationsClass : public DataStructure {
  private:
    /** @brief Objet '.RLCO' */
    JeveuxVector< ValueType > _coefficients;
    /** @brief Objet '.RLBE' */
    JeveuxVector< ValueType > _rhs;
    /** @brief Objet '.RLDD' */
    JeveuxVectorChar8 _componentsNames;
    /** @brief Objet '.RLNO' */
    JeveuxVectorChar8 _nodesNames;
    /** @brief Objet '.RLNT' */
    JeveuxVectorLong _numberOfCoeff;
    /** @brief Objet '.RLPO' */
    JeveuxVectorLong _pointer;
    /** @brief Objet '.RLSU' */
    JeveuxVectorLong _onOrOff;
    /** @brief Objet '.RLTC' */
    JeveuxVectorChar8 _typeOfCoeff;
    /** @brief Objet '.RLTV' */
    JeveuxVectorChar8 _typeOfRhs;
    /** @brief Objet '.RLNR' */
    JeveuxVectorLong _numberOfRelations;
    /** @brief La chargement est-il vide ? */
    bool _isEmpty;

  public:
    /**
        * @brief Constructeur
        */
    ListOfLinearRelationsClass( const std::string name )
        : DataStructure( name, 19, "LISTE_RELA" ),
          _coefficients( JeveuxVector< ValueType >( getName() + ".RLCO" ) ),
          _rhs( JeveuxVector< ValueType >( getName() + ".RLBE" ) ),
          _componentsNames( JeveuxVectorChar8( getName() + ".RLDD" ) ),
          _nodesNames( JeveuxVectorChar8( getName() + ".RLNO" ) ),
          _numberOfCoeff( JeveuxVectorLong( getName() + ".RLNT" ) ),
          _pointer( JeveuxVectorLong( getName() + ".RLPO" ) ),
          _onOrOff( JeveuxVectorLong( getName() + ".RLSU" ) ),
          _typeOfCoeff( JeveuxVectorChar8( getName() + ".RLTC" ) ),
          _typeOfRhs( JeveuxVectorChar8( getName() + ".RLTV" ) ),
          _numberOfRelations( JeveuxVectorLong( getName() + ".RLNR" ) ), _isEmpty( true ) {
        if ( getName().size() != 19 )
            throw std::runtime_error( "Bad name size" );
    };
};

/** @typedef ConstantFieldOnCellsClassReal Class d'une carte de double */
typedef ListOfLinearRelationsClass< double > ListOfLinearRelationsReal;

/**
 * @typedef ListOfLinearRelationsReal
 * @brief Pointeur intelligent vers un ListOfLinearRelationsClass
 */
typedef boost::shared_ptr< ListOfLinearRelationsReal > ListOfLinearRelationsRealPtr;

#endif /* LISTOFLINEARRELATIONS_H_ */
