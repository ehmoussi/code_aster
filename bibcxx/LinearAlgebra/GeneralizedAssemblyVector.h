#ifndef GENERALIZEDASSEMBLYVECTOR_H_
#define GENERALIZEDASSEMBLYVECTOR_H_

/**
 * @file GeneralizedAssemblyVector.h
 * @brief Fichier entete de la classe GeneralizedAssemblyVector
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
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"

/**
 * @class GenericGeneralizedAssemblyVectorClass
 * @brief Cette classe correspond a un matr_asse_gene
 * @author Nicolas Sellenet
 */
class GenericGeneralizedAssemblyVectorClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.DESC' */
    JeveuxVectorDouble _desc;
    /** @brief Objet Jeveux '.REFE' */
    JeveuxVectorChar24 _refe;

  public:
    /**
     * @brief Constructeur
     */
    GenericGeneralizedAssemblyVectorClass( const std::string name )
        : DataStructure( name, 19, "VECT_ASSE_GENE", Permanent ),
          _desc( JeveuxVectorDouble( getName() + ".DISC" ) ),
          _refe( JeveuxVectorChar24( getName() + ".REFE" ) ){};
};

/**
 * @class GeneralizedAssemblyVectorClass
 * @brief Cette classe correspond a un vect_asse_gene
 * @author Nicolas Sellenet
 */
template < class ValueType >
class GeneralizedAssemblyVectorClass : public GenericGeneralizedAssemblyVectorClass {
  private:
    /** @brief Objet Jeveux '.VALE' */
    JeveuxVector< ValueType > _valm;

    /**
     * @brief definir le type
     */
    template < class type = ValueType >
    typename std::enable_if< std::is_same< type, double >::value, void >::type setVectorType() {
        setType( "VECT_ASSE_GENE" );
    };

    /**
     * @brief definir le type
     */
    template < class type = ValueType >
    typename std::enable_if< std::is_same< type, DoubleComplex >::value, void >::type
    setVectorType() {
        setType( "VECT_ASSE_GENE_C" );
    };

  public:
    /**
     * @typedef GeneralizedAssemblyVectorPtr
     * @brief Pointeur intelligent vers un GeneralizedAssemblyVector
     */
    typedef boost::shared_ptr< GeneralizedAssemblyVectorClass< ValueType > >
        GeneralizedAssemblyVectorPtr;

    /**
     * @brief Constructeur
     */
    GeneralizedAssemblyVectorClass()
        : GeneralizedAssemblyVectorClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */

    GeneralizedAssemblyVectorClass( const std::string name )
        : GenericGeneralizedAssemblyVectorClass( name ),
          _valm( JeveuxVector< ValueType >( getName() + ".VALE" ) ) {
        GeneralizedAssemblyVectorClass< ValueType >::setVectorType();
    };
};

/** @typedef Definition d'une matrice assemblee généralisée de double */
typedef GeneralizedAssemblyVectorClass< double > GeneralizedAssemblyVectorDoubleClass;
/** @typedef Definition d'une matrice assemblee généralisée de complexe */
typedef GeneralizedAssemblyVectorClass< DoubleComplex > GeneralizedAssemblyVectorComplexClass;

/**
 * @typedef GenericGeneralizedAssemblyVectorPtr
 * @brief Pointeur intelligent vers un GenericGeneralizedAssemblyVectorClass
 */
typedef boost::shared_ptr< GenericGeneralizedAssemblyVectorClass >
    GenericGeneralizedAssemblyVectorPtr;

/**
 * @typedef GeneralizedAssemblyVectorDoublePtr
 * @brief Pointeur intelligent vers un GeneralizedAssemblyVectorDoubleClass
 */
typedef boost::shared_ptr< GeneralizedAssemblyVectorDoubleClass >
    GeneralizedAssemblyVectorDoublePtr;

/**
 * @typedef GeneralizedAssemblyVectorComplexPtr
 * @brief Pointeur intelligent vers un GeneralizedAssemblyVectorComplexClass
 */
typedef boost::shared_ptr< GeneralizedAssemblyVectorComplexClass >
    GeneralizedAssemblyVectorComplexPtr;

#endif /* GENERALIZEDASSEMBLYVECTOR_H_ */
