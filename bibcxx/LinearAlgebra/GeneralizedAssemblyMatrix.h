#ifndef GENERALIZEDASSEMBLYMATRIX_H_
#define GENERALIZEDASSEMBLYMATRIX_H_

/**
 * @file GeneralizedAssemblyMatrix.h
 * @brief Fichier entete de la classe GeneralizedAssemblyMatrix
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
#include "Numbering/ForwardGeneralizedDOFNumbering.h"
#include "Results/ForwardModeResult.h"
#include "Results/ForwardGeneralizedModeResult.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"

/**
 * @class GenericGeneralizedAssemblyMatrixClass
 * @brief Cette classe correspond a un matr_asse_gene
 * @author Nicolas Sellenet
 */
class GenericGeneralizedAssemblyMatrixClass: public DataStructure
{
  private:
    /** @brief Objet Jeveux '.DESC' */
    JeveuxVectorReal _desc;
    /** @brief Objet Jeveux '.REFE' */
    JeveuxVectorChar24 _refe;
    /** @brief GeneralizedDOFNumbering */
    ForwardGeneralizedDOFNumberingPtr _dofNum;
    /** @brief ModeResult */
    ForwardModeResultPtr _mecaModeC;
    /** @brief GeneralizedModeResult */
    ForwardGeneralizedModeResultPtr _geneModeC;

  public:
    /**
     * @typedef GeneralizedAssemblyMatrixPtr
     * @brief Pointeur intelligent vers un GeneralizedAssemblyMatrix
     */
    typedef boost::shared_ptr< GenericGeneralizedAssemblyMatrixClass >
        GenericGeneralizedAssemblyMatrixPtr;

    /**
     * @brief Constructeur
     */
    GenericGeneralizedAssemblyMatrixClass( const std::string name ):
        DataStructure( name, 19, "MATR_ASSE_GENE", Permanent ),
        _desc( JeveuxVectorReal( getName() + ".DESC" ) ),
        _refe( JeveuxVectorChar24( getName() + ".REFE" ) ),
        _dofNum( nullptr ),
        _mecaModeC( nullptr ),
        _geneModeC( nullptr )
    {};

    /**
     * @brief Get GeneralizedDOFNumbering
     */
    GeneralizedDOFNumberingPtr getGeneralizedDOFNumbering() {
        if ( _dofNum.isSet() )
            return _dofNum.getPointer();
        return GeneralizedDOFNumberingPtr( nullptr );
    };

    /**
     * @brief Get GeneralizedModeResult
     */
    GeneralizedModeResultPtr getModalBasisFromGeneralizedModeResult()
    {
        if ( _geneModeC.isSet() )
            return _geneModeC.getPointer();
        return GeneralizedModeResultPtr( nullptr );
    };

    /**
     * @brief Get ModeResult
     */
    ModeResultPtr getModalBasisFromModeResult()
    {
        if ( _mecaModeC.isSet() )
            return _mecaModeC.getPointer();
        return ModeResultPtr( nullptr );
    };

    /**
     * @brief Set GeneralizedDOFNumbering
     */
    bool setGeneralizedDOFNumbering( const GeneralizedDOFNumberingPtr &dofNum )
    {
        if ( dofNum != nullptr )
        {
            _dofNum = dofNum;
            return true;
        }
        return false;
    };

    /**
     * @brief Set GeneralizedModeResult
     */
    bool setModalBasis( const GeneralizedModeResultPtr &mecaModeC )
    {
        if ( mecaModeC != nullptr )
        {
            _geneModeC = mecaModeC;
            _mecaModeC = nullptr;
            return true;
        }
        return false;
    };

    /**
     * @brief Set ModeResult
     */
    bool setModalBasis( const ModeResultPtr &mecaModeC )
    {
        if ( mecaModeC != nullptr )
        {
            _mecaModeC = mecaModeC;
            _geneModeC = nullptr;
            return true;
        }
        return false;
    };
};

/**
 * @class GeneralizedAssemblyMatrixClass
 * @brief Cette classe correspond a un matr_asse_gene
 * @author Nicolas Sellenet
 */
template < class ValueType >
class GeneralizedAssemblyMatrixClass : public GenericGeneralizedAssemblyMatrixClass
{
  private:
    /** @brief Objet Jeveux '.VALM' */
    JeveuxVector< ValueType > _valm;

    /**
     * @brief definir le type
     */
    template < class type = ValueType >
    typename std::enable_if< std::is_same< type, double >::value, void >::type setMatrixType()
    {
        setType( "MATR_ASSE_GENE_R" );
    };

    /**
     * @brief definir le type
     */
    template < class type = ValueType >
    typename std::enable_if< std::is_same< type, RealComplex >::value, void >::type
    setMatrixType()
    {
        setType( "MATR_ASSE_GENE_C" );
    };

  public:
    /**
     * @typedef GeneralizedAssemblyMatrixPtr
     * @brief Pointeur intelligent vers un GeneralizedAssemblyMatrix
     */
    typedef boost::shared_ptr< GeneralizedAssemblyMatrixClass< ValueType > >
        GeneralizedAssemblyMatrixPtr;

    /**
     * @brief Constructeur
     */
    GeneralizedAssemblyMatrixClass()
        : GeneralizedAssemblyMatrixClass( ResultNaming::getNewResultName() )
    {};

    /**
     * @brief Constructeur
     */
    GeneralizedAssemblyMatrixClass( const std::string name )
        : GenericGeneralizedAssemblyMatrixClass( name ),
          _valm( JeveuxVector< ValueType >( getName() + ".VALM" ) )
    {
        GeneralizedAssemblyMatrixClass< ValueType >::setMatrixType();
    };
};

/** @typedef Definition d'une matrice assemblee généralisée de double */
typedef GeneralizedAssemblyMatrixClass< double > GeneralizedAssemblyMatrixRealClass;
/** @typedef Definition d'une matrice assemblee généralisée de complexe */
typedef GeneralizedAssemblyMatrixClass< RealComplex > GeneralizedAssemblyMatrixComplexClass;

/**
 * @typedef GenericGeneralizedAssemblyMatrixPtr
 * @brief Pointeur intelligent vers un GenericGeneralizedAssemblyMatrixClass
 */
typedef boost::shared_ptr< GenericGeneralizedAssemblyMatrixClass >
    GenericGeneralizedAssemblyMatrixPtr;

/**
 * @typedef GeneralizedAssemblyMatrixRealPtr
 * @brief Pointeur intelligent vers un GeneralizedAssemblyMatrixRealClass
 */
typedef boost::shared_ptr< GeneralizedAssemblyMatrixRealClass >
    GeneralizedAssemblyMatrixRealPtr;

/**
 * @typedef GeneralizedAssemblyMatrixComplexPtr
 * @brief Pointeur intelligent vers un GeneralizedAssemblyMatrixComplexClass
 */
typedef boost::shared_ptr< GeneralizedAssemblyMatrixComplexClass >
    GeneralizedAssemblyMatrixComplexPtr;

#endif /* GENERALIZEDASSEMBLYMATRIX_H_ */
