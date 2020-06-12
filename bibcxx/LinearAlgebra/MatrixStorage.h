#ifndef MATRIXSTORAGE_H_
#define MATRIXSTORAGE_H_

/**
 * @file MatrixStorage.h
 * @brief Fichier entete de la classe MatrixStorage
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
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"

/**
 * @class MatrixStorageClass
 * @brief Cette classe correspond a un stockage
 * @author Nicolas Sellenet
 */
class MatrixStorageClass : public DataStructure {
  private:
  public:
    /**
     * @brief Constructeur
     */
    MatrixStorageClass( const std::string &name )
        : DataStructure( name, 19, "STOCKAGE", Permanent ){};
};

/**
 * @class LigneDeCielClass
 * @brief Cette classe correspond a un stockage ligne de ciel
 * @author Nicolas Sellenet
 */
class LigneDeCielClass : public MatrixStorageClass {
  private:
    /** @brief Objet Jeveux '.SCBL' */
    JeveuxVectorLong _scbl;
    /** @brief Objet Jeveux '.SCDI' */
    JeveuxVectorLong _scdi;
    /** @brief Objet Jeveux '.SCDE' */
    JeveuxVectorLong _scde;
    /** @brief Objet Jeveux '.SCHC' */
    JeveuxVectorLong _schc;
    /** @brief Objet Jeveux '.SCIB' */
    JeveuxVectorLong _scib;
    /** @brief Objet Jeveux '.M2LC' */
    JeveuxVectorLong _m2lc;
    /** @brief Objet Jeveux '.LC2M' */
    JeveuxVectorLong _lc2m;

  public:
    /**
     * @brief Constructeur
     */
    LigneDeCielClass( const std::string &name )
        : MatrixStorageClass( name ), _scbl( JeveuxVectorLong( getName() + ".SCBL" ) ),
          _scdi( JeveuxVectorLong( getName() + ".SCDI" ) ),
          _scde( JeveuxVectorLong( getName() + ".SCDE" ) ),
          _schc( JeveuxVectorLong( getName() + ".SCHC" ) ),
          _scib( JeveuxVectorLong( getName() + ".SCIB" ) ),
          _m2lc( JeveuxVectorLong( getName() + ".M2LC" ) ),
          _lc2m( JeveuxVectorLong( getName() + ".LC2M" ) ){};
};

/**
 * @typedef LigneDeCielPtr
 * @brief Pointeur intelligent vers un LigneDeCielClass
 */
typedef boost::shared_ptr< LigneDeCielClass > LigneDeCielPtr;

/**
 * @class MorseStorageClass
 * @brief Cette classe correspond a un stockage ligne de ciel
 * @author Nicolas Sellenet
 */
class MorseStorageClass : public MatrixStorageClass {
  private:
    /** @brief Objet Jeveux '.SMDI' */
    JeveuxVectorLong _smdi;
    /** @brief Objet Jeveux '.SMDE' */
    JeveuxVectorLong _smde;
    /** @brief Objet Jeveux '.SMHC' */
    JeveuxVectorLong _smhc;

  public:
    /**
     * @brief Constructeur
     */
    MorseStorageClass( const std::string &name )
        : MatrixStorageClass( name ), _smdi( JeveuxVectorLong( getName() + ".SMDI" ) ),
          _smde( JeveuxVectorLong( getName() + ".SMDE" ) ),
          _smhc( JeveuxVectorLong( getName() + ".SMHC" ) ){};
};

/**
 * @typedef MorseStoragePtr
 * @brief Pointeur intelligent vers un MorseStorageClass
 */
typedef boost::shared_ptr< MorseStorageClass > MorseStoragePtr;

/**
 * @class MultFrontStorageClass
 * @brief Cette classe correspond a un stockage ligne de ciel
 * @author Nicolas Sellenet
 */
class MultFrontStorageClass : public MatrixStorageClass {
  private:
    /** @brief Objet Jeveux '.ADNT' */
    JeveuxVectorShort _adnt;
    /** @brief Objet Jeveux '.GLOB' */
    JeveuxVectorShort _glob;
    /** @brief Objet Jeveux '.LOCL' */
    JeveuxVectorShort _locl;
    /** @brief Objet Jeveux '.PNTI' */
    JeveuxVectorShort _pnti;

  public:
    /**
     * @brief Constructeur
     */
    MultFrontStorageClass( const std::string &name )
        : MatrixStorageClass( name ), _adnt( JeveuxVectorShort( getName() + ".ADNT" ) ),
          _glob( JeveuxVectorShort( getName() + ".GLOB" ) ),
          _locl( JeveuxVectorShort( getName() + ".LOCL" ) ),
          _pnti( JeveuxVectorShort( getName() + ".PNTI" ) ){};
};

/**
 * @typedef MultFrontStoragePtr
 * @brief Pointeur intelligent vers un MultFrontStorageClass
 */
typedef boost::shared_ptr< MultFrontStorageClass > MultFrontStoragePtr;

#endif /* MATRIXSTORAGE_H_ */
