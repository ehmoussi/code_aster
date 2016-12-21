#ifndef GENERALIZEDDOFNUMBERING_H_
#define GENERALIZEDDOFNUMBERING_H_

/**
 * @file GeneralizedDOFNumbering.h
 * @brief Fichier entete de la classe GeneralizedDOFNumbering
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
#include "LinearAlgebra/MatrixStorage.h"


/**
 * @class GeneralizedDOFNumberingInstance
 * @brief Cette classe correspond a un sd_nume_ddl_gene
 * @author Nicolas Sellenet
 */
class GeneralizedDOFNumberingInstance: public DataStructure
{
private:
    /** @brief Objet Jeveux '.DESC' */
    JeveuxVectorLong       _desc;
    /** @brief Objet Jeveux '.NEQU' */
    JeveuxVectorLong       _nequ;
    /** @brief Objet Jeveux '.REFN' */
    JeveuxVectorChar24     _refn;
    /** @brief Objet Jeveux '.DEEQ' */
    JeveuxVectorLong       _deeq;
    /** @brief Objet Jeveux '.DELG' */
    JeveuxVectorLong       _delg;
    /** @brief Objet Jeveux '.LILI' */
    JeveuxVectorChar24     _lili;
    /** @brief Objet Jeveux '.NUEQ' */
    JeveuxVectorLong       _nueq;
    /** @brief Objet Jeveux '.PRNO' */
    JeveuxCollectionLong   _prno;
    /** @brief Objet Jeveux '.ORIG' */
    JeveuxCollectionLong   _orig;
    /** @brief Objet Jeveux '.BASE' */
    JeveuxVectorDouble     _base;
    /** @brief Objet Jeveux '.NOMS' */
    JeveuxVectorChar8      _noms;
    /** @brief Objet Jeveux '.TAIL' */
    JeveuxVectorLong       _tail;
    /** @brief Objet Jeveux '.SMOS' */
    MorseStoragePtr        _smos;
    /** @brief Objet Jeveux '.SLCS' */
    LigneDeCielPtr         _slcs;

public:
    /**
     * @brief Constructeur
     */
    GeneralizedDOFNumberingInstance(): 
        DataStructure( "NUME_DDL_GENE", Permanent, 14 ),
        _desc( JeveuxVectorLong( getName() + ".DESC" ) ),
        _nequ( JeveuxVectorLong( getName() + ".NEQU" ) ),
        _refn( JeveuxVectorChar24( getName() + ".REFN" ) ),
        _deeq( JeveuxVectorLong( getName() + ".DEEQ" ) ),
        _delg( JeveuxVectorLong( getName() + ".DELG" ) ),
        _lili( JeveuxVectorChar24( getName() + ".LILI" ) ),
        _nueq( JeveuxVectorLong( getName() + ".NUEQ" ) ),
        _prno( JeveuxCollectionLong( getName() + ".PRNO" ) ),
        _orig( JeveuxCollectionLong( getName() + ".ORIG" ) ),
        _base( JeveuxVectorDouble( getName() + ".BASE" ) ),
        _noms( JeveuxVectorChar8( getName() + ".NOMS" ) ),
        _tail( JeveuxVectorLong( getName() + ".TAIL" ) ),
        _smos( new MorseStorageInstance( getName() + ".SMOS" ) ),
        _slcs( new LigneDeCielInstance( getName() + ".SLCS" ) )
    {};

};

/**
 * @typedef GeneralizedDOFNumberingPtr
 * @brief Pointeur intelligent vers un GeneralizedDOFNumberingInstance
 */
typedef boost::shared_ptr< GeneralizedDOFNumberingInstance > GeneralizedDOFNumberingPtr;

#endif /* GENERALIZEDDOFNUMBERING_H_ */
