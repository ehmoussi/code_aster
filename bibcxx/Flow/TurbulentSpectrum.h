#ifndef TURBULENTSPECTRUM_H_
#define TURBULENTSPECTRUM_H_

/**
 * @file TurbulentSpectrum.h
 * @brief Fichier entete de la classe TurbulentSpectrum
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

#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"


/**
 * @class TurbulentSpectrumInstance
 * @brief Cette classe correspond a une sd spectre
 * @author Nicolas Sellenet
 */
class TurbulentSpectrumInstance: public DataStructure
{
private:
    /** @brief Objet Jeveux '.VAIN' */
    JeveuxVectorLong   _vain;
    /** @brief Objet Jeveux '.VARE' */
    JeveuxVectorDouble _vare;
    /** @brief Objet Jeveux '.VATE' */
    JeveuxVectorChar16 _vate;
    /** @brief Objet Jeveux '.NNOE' */
    JeveuxVectorChar8  _nnoe;

public:
    /**
     * @typedef TurbulentSpectrumPtr
     * @brief Pointeur intelligent vers un TurbulentSpectrum
     */
    typedef boost::shared_ptr< TurbulentSpectrumInstance > TurbulentSpectrumPtr;

    /**
     * @brief Constructeur
     */
    static TurbulentSpectrumPtr create()
    {
        return TurbulentSpectrumPtr( new TurbulentSpectrumInstance );
    };

    /**
     * @brief Constructeur
     */
    TurbulentSpectrumInstance(): 
        DataStructure( "SPECTRE", Permanent, 19 ),
        _vain( JeveuxVectorLong( getName() + ".REFE" ) ),
        _vare( JeveuxVectorDouble( getName() + ".DISC" ) ),
        _vate( JeveuxVectorChar16( getName() + ".VALE" ) ),
        _nnoe( JeveuxVectorChar8( getName() + ".NUMI" ) )
    {};
};

/**
 * @typedef TurbulentSpectrumPtr
 * @brief Pointeur intelligent vers un TurbulentSpectrumInstance
 */
typedef boost::shared_ptr< TurbulentSpectrumInstance > TurbulentSpectrumPtr;

#endif /* TURBULENTSPECTRUM_H_ */