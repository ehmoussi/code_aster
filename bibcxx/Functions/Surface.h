#ifndef SURFACE_H_
#define SURFACE_H_

/**
 * @file Surface.h
 * @brief Fichier entete de la classe Surface
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
#include "MemoryManager/JeveuxCollection.h"
#include "Supervis/ResultNaming.h"


/**
 * @class SurfaceInstance
 * @brief Cette classe correspond a une nappe
 * @author Nicolas Sellenet
 */
class SurfaceInstance: public DataStructure
{
private:
    // Vecteur Jeveux '.PROL'
    JeveuxVectorChar24     _property;
    // Vecteur Jeveux '.PARA'
    JeveuxVectorDouble     _parameters;
    // Vecteur Jeveux '.VALE'
    JeveuxCollectionDouble _value;

public:
    /**
     * @typedef SurfacePtr
     * @brief Pointeur intelligent vers un Surface
     */
    typedef boost::shared_ptr< SurfaceInstance > SurfacePtr;

    /**
     * @brief Constructeur
     */
    SurfaceInstance():
        SurfaceInstance( ResultNaming::getNewResultName() )
    {};

    /**
     * @brief Constructeur
     */
    SurfaceInstance( const std::string name ):
        DataStructure( name, 19, "NAPPE", Permanent ),
        _property( JeveuxVectorChar24( getName() + ".PROL" ) ),
        _parameters( JeveuxVectorDouble( getName() + ".PARA" ) ),
        _value( JeveuxCollectionDouble( getName() + ".VALE" ) )
    {};
};

/**
 * @typedef SurfacePtr
 * @brief Pointeur intelligent vers un SurfaceInstance
 */
typedef boost::shared_ptr< SurfaceInstance > SurfacePtr;

#endif /* SURFACE_H_ */
