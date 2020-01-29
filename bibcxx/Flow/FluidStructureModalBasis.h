#ifndef FLUIDSTRUCTMODALBASIS_H_
#define FLUIDSTRUCTMODALBASIS_H_

/**
 * @file FluidStructureModalBasis.h
 * @brief Fichier entete de la classe FluidStructureModalBasis
 * @author Natacha Béreux
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
#include "Supervis/ResultNaming.h"

/**
 * @class FluidStructureModalBasisClass
 * @brief Cette classe correspond a une sd_melasflu
 * @author Natacha Béreux
 */
class FluidStructureModalBasisClass : public DataStructure {
  private:
    /** @brief Objet Jeveux '.REMF' */
    JeveuxVectorChar8 _remf;
    /** @brief Objet Jeveux '.DESC' */
    JeveuxVectorChar16 _desc;
    /** @brief Objet Jeveux '.FACT' */
    JeveuxVectorDouble _fact;
    /** @brief Objet Jeveux '.FREQ' */
    JeveuxVectorDouble _freq;
    /** @brief Objet Jeveux '.MASG' */
    JeveuxVectorDouble _masg;
    /** @brief Objet Jeveux '.NUMO' */
    JeveuxVectorLong _numo;
    /** @brief Objet Jeveux '.VITE' */
    JeveuxVectorDouble _vite;

  public:
    /**
     * @typedef FluidStructureModalBasisPtr
     * @brief Pointeur intelligent vers un FluidStructureModalBasis
     */
    typedef boost::shared_ptr< FluidStructureModalBasisClass > FluidStructureModalBasisPtr;

    /**
     * @brief Constructeur
     */
    FluidStructureModalBasisClass()
        : FluidStructureModalBasisClass( ResultNaming::getNewResultName() ){};
    /**
     * @brief Constructeur
     */
    FluidStructureModalBasisClass( const std::string name )
        : DataStructure( name, 8, "MELASFLU", Permanent ),
          _remf( JeveuxVectorChar8( getName() + ".REMF" ) ),
          _desc( JeveuxVectorChar16( getName() + ".DESC" ) ),
          _fact( JeveuxVectorDouble( getName() + ".FACT" ) ),
          _freq( JeveuxVectorDouble( getName() + ".FREQ" ) ),
          _masg( JeveuxVectorDouble( getName() + ".MASG" ) ),
          _numo( JeveuxVectorLong( getName() + ".NUMO" ) ),
          _vite( JeveuxVectorDouble( getName() + ".VITE" ) ){};
};

/**
 * @typedef FluidStructureModalBasisPtr
 * @brief Pointeur intelligent vers un FluidStructureModalBasisClass
 */
typedef boost::shared_ptr< FluidStructureModalBasisClass > FluidStructureModalBasisPtr;

#endif /* FLUIDSTRUCTMODALBASIS_H_ */
