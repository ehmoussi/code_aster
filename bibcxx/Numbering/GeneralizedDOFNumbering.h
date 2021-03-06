#ifndef GENERALIZEDDOFNUMBERING_H_
#define GENERALIZEDDOFNUMBERING_H_

/**
 * @file GeneralizedDOFNumbering.h
 * @brief Fichier entete de la classe GeneralizedDOFNumbering
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
#include "LinearAlgebra/MatrixStorage.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/GeneralizedModel.h"
#include "Supervis/ResultNaming.h"

#include "Results/ForwardModeResult.h"
#include "Results/ForwardGeneralizedModeResult.h"

/**
 * @class GeneralizedFieldOnNodesDescriptionClass
 * @brief This class describes the structure of dof stored in a field on nodes
 * @author Nicolas Sellenet
 */
class GeneralizedFieldOnNodesDescriptionClass : public DataStructure {
    /** @brief Objet Jeveux '.DESC' */
    JeveuxVectorLong _desc;
    /** @brief Objet Jeveux '.NEQU' */
    JeveuxVectorLong _nequ;
    /** @brief Objet Jeveux '.REFN' */
    JeveuxVectorChar24 _refn;
    /** @brief Objet Jeveux '.DEEQ' */
    JeveuxVectorLong _deeq;
    /** @brief Objet Jeveux '.DELG' */
    JeveuxVectorLong _delg;
    /** @brief Objet Jeveux '.LILI' */
    JeveuxVectorChar24 _lili;
    /** @brief Objet Jeveux '.NUEQ' */
    JeveuxVectorLong _nueq;
    /** @brief Objet Jeveux '.PRNO' */
    JeveuxCollectionLong _prno;
    /** @brief Objet Jeveux '.ORIG' */
    JeveuxCollectionLong _orig;

  public:
    /**
     * @brief Constructeur
     */
    GeneralizedFieldOnNodesDescriptionClass( const JeveuxMemory memType = Permanent )
        : DataStructure( ResultNaming::getNewResultName(), 19, "PROF_GENE", memType ),
          _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
          _nequ( JeveuxVectorLong( getName() + ".NEQU" ) ),
          _refn( JeveuxVectorChar24( getName() + ".REFN" ) ),
          _deeq( JeveuxVectorLong( getName() + ".DEEQ" ) ),
          _delg( JeveuxVectorLong( getName() + ".DELG" ) ),
          _lili( JeveuxVectorChar24( getName() + ".LILI" ) ),
          _nueq( JeveuxVectorLong( getName() + ".NUEQ" ) ),
          _prno( JeveuxCollectionLong( getName() + ".PRNO" ) ),
          _orig( JeveuxCollectionLong( getName() + ".ORIG" ) ){};

    /**
     * @brief Destructor
     */
    ~GeneralizedFieldOnNodesDescriptionClass(){};

    /**
     * @brief Constructeur
     * @param name nom souhaité de la sd (utile pour le GeneralizedFieldOnNodesDescriptionClass
     * d'une sd_resu)
     */
    GeneralizedFieldOnNodesDescriptionClass( const std::string name,
                                                const JeveuxMemory memType = Permanent )
        : DataStructure( name, 19, "PROF_GENE", memType ),
          _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
          _nequ( JeveuxVectorLong( getName() + ".NEQU" ) ),
          _refn( JeveuxVectorChar24( getName() + ".REFN" ) ),
          _deeq( JeveuxVectorLong( getName() + ".DEEQ" ) ),
          _delg( JeveuxVectorLong( getName() + ".DELG" ) ),
          _lili( JeveuxVectorChar24( getName() + ".LILI" ) ),
          _nueq( JeveuxVectorLong( getName() + ".NUEQ" ) ),
          _prno( JeveuxCollectionLong( getName() + ".PRNO" ) ),
          _orig( JeveuxCollectionLong( getName() + ".ORIG" ) ){};
};
typedef boost::shared_ptr< GeneralizedFieldOnNodesDescriptionClass >
    GeneralizedFieldOnNodesDescriptionPtr;

/**
 * @class GeneralizedDOFNumberingClass
 * @brief Cette classe correspond a un sd_nume_ddl_gene
 * @author Nicolas Sellenet
 */
class GeneralizedDOFNumberingClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.BASE' */
    JeveuxVectorReal _base;
    /** @brief Objet Jeveux '.NOMS' */
    JeveuxVectorChar8 _noms;
    /** @brief Objet Jeveux '.TAIL' */
    JeveuxVectorLong _tail;
    /** @brief Objet Jeveux '.SMOS' */
    MorseStoragePtr _smos;
    /** @brief Objet Jeveux '.SLCS' */
    LigneDeCielPtr _slcs;
    /** @brief GeneralizedFieldOnNodesDescription */
    GeneralizedFieldOnNodesDescriptionPtr _nume;
    /** @brief GeneralizedFieldOnNodesDescription */
    GeneralizedModelPtr _model;
    /** @brief modal basis */
    ForwardModeResultPtr _basis1;
    /** @brief modal basis */
    ForwardGeneralizedModeResultPtr _basis2;

  public:
    /**
     * @typedef GeneralizedDOFNumberingPtr
     * @brief Pointeur intelligent vers un GeneralizedDOFNumbering
     */
    typedef boost::shared_ptr< GeneralizedDOFNumberingClass > GeneralizedDOFNumberingPtr;

    /**
     * @brief Constructeur
     */
    GeneralizedDOFNumberingClass()
        : GeneralizedDOFNumberingClass( ResultNaming::getNewResultName() ){};

    /**
     * @brief Constructeur
     */
    GeneralizedDOFNumberingClass( const std::string name ):
        DataStructure( name, 14, "NUME_DDL_GENE", Permanent ),
        _base( JeveuxVectorReal( getName() + ".ELIM.BASE" ) ),
        _noms( JeveuxVectorChar8( getName() + ".ELIM.NOMS" ) ),
        _tail( JeveuxVectorLong( getName() + ".ELIM.TAIL" ) ),
        _smos( new MorseStorageClass( getName() + ".SMOS" ) ),
        _slcs( new LigneDeCielClass( getName() + ".SLCS" ) ),
        _nume( new GeneralizedFieldOnNodesDescriptionClass( getName() + ".NUME" ) ),
        _model( nullptr ),
        _basis1( nullptr ),
        _basis2( nullptr )
    {};

    /**
     * @brief Get the GeneralizedModel
     */
    GeneralizedModelPtr getGeneralizedModel() const { return _model; };

    /**
     * @brief Get modal basis
     */
    GeneralizedModeResultPtr getModalBasisFromGeneralizedModeResult()
    {
        if ( _basis2.isSet() )
            return _basis2.getPointer();
        return GeneralizedModeResultPtr( nullptr );
    };

    /**
     * @brief Get modal basis
     */
    ModeResultPtr getModalBasisFromModeResult()
    {
        if ( _basis1.isSet() )
            return _basis1.getPointer();
        return ModeResultPtr( nullptr );
    };

    /**
     * @brief Set the GeneralizedModel
     */
    bool setGeneralizedModel( const GeneralizedModelPtr &model ) {
        _model = model;
        return true;
    };

    /**
     * @brief Set modal basis
     */
    bool setModalBasis( const GeneralizedModeResultPtr &mecaModeC )
    {
        if ( mecaModeC != nullptr )
        {
            _basis2 = mecaModeC;
            _basis1 = nullptr;
            return true;
        }
        return false;
    };

    /**
     * @brief Set modal basis
     */
    bool setModalBasis( const ModeResultPtr &mecaModeC )
    {
        if ( mecaModeC != nullptr )
        {
            _basis1 = mecaModeC;
            _basis2 = nullptr;
            return true;
        }
        return false;
    };
};

/**
 * @typedef GeneralizedDOFNumberingPtr
 * @brief Pointeur intelligent vers un GeneralizedDOFNumberingClass
 */
typedef boost::shared_ptr< GeneralizedDOFNumberingClass > GeneralizedDOFNumberingPtr;

#endif /* GENERALIZEDDOFNUMBERING_H_ */
