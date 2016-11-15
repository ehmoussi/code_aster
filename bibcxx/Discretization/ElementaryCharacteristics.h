#ifndef ELEMENTARYCHARACTERISTICS_H_
#define ELEMENTARYCHARACTERISTICS_H_

/**
 * @file ElementaryCharacteristics.h
 * @brief Fichier entete de la classe ElementaryCharacteristics
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
#include "definition.h"
#include "DataStructure/DataStructure.h"
#include "DataFields/PCFieldOnMesh.h"

/**
 * @class ElementaryCharacteristicsInstance
 * @brief Cette classe decrit un cara_elem
 * @author Nicolas Sellenet
 */
class ElementaryCharacteristicsInstance: public DataStructure
{
private:
    /** @brief Objet Jeveux '.CANBSP' */
    PCFieldOnMeshLongPtr   _nummberOfSubpoints;
    /** @brief Objet Jeveux '.CARARCPO' */
    PCFieldOnMeshPtrDouble _curveBeam;
    /** @brief Objet Jeveux '.CARCABLE' */
    PCFieldOnMeshPtrDouble _cable;
    /** @brief Objet Jeveux '.CARCOQUE' */
    PCFieldOnMeshPtrDouble _shell;
    /** @brief Objet Jeveux '.CARDISCA' */
    PCFieldOnMeshPtrDouble _dumping;
    /** @brief Objet Jeveux '.CARDISCK' */
    PCFieldOnMeshPtrDouble _rigidity;
    /** @brief Objet Jeveux '.CARDISCM' */
    PCFieldOnMeshPtrDouble _mass;
    /** @brief Objet Jeveux '.CARGENBA' */
    PCFieldOnMeshPtrDouble _bar;
    /** @brief Objet Jeveux '.CARGENPO' */
    PCFieldOnMeshPtrDouble _beamSection;
    /** @brief Objet Jeveux '.CARGEOPO' */
    PCFieldOnMeshPtrDouble _beamGeometry;
    /** @brief Objet Jeveux '.CARMASSI' */
    PCFieldOnMeshPtrDouble _orthotropicBasis;
    /** @brief Objet Jeveux '.CARORIEN' */
    PCFieldOnMeshPtrDouble _localBasis;
    /** @brief Objet Jeveux '.CARPOUFL' */
    PCFieldOnMeshPtrDouble _beamCharacteristics;

    /** @brief Booleen indiquant si le maillage est vide */
    bool                   _isEmpty;

public:
    /**
     * @brief Constructeur
     */
    ElementaryCharacteristicsInstance();

    /**
     * @brief Destructeur
     */
    ~ElementaryCharacteristicsInstance()
    {};

    /**
     * @brief Fonction permettant de savoir si un maillage est vide (non relu par exemple)
     * @return retourne true si le maillage est vide
     */
    bool isEmpty() const
    {
        return _isEmpty;
    };
};



/**
 * @typedef ElementaryCharacteristicsPtr
 * @brief Pointeur intelligent vers un ElementaryCharacteristicsInstance
 */
typedef boost::shared_ptr< ElementaryCharacteristicsInstance > ElementaryCharacteristicsPtr;

#endif /* ELEMENTARYCHARACTERISTICS_H_ */
