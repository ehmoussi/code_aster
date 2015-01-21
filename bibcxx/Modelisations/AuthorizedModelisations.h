#ifndef AUTHORIZEDMODELISATION_H_
#define AUTHORIZEDMODELISATION_H_

/**
 * @file AuthorizedModelisations.h
 * @brief Fichier definissant les modelisations autorisees
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

#include "Modelisations/PhysicsAndModelisations.h"
#include <set>

using namespace std;

// Ces wrappers sont la pour autoriser que les set soitent const
// Sinon, on aurait pas pu passer directement des const set<> en parametre template
/**
 * @struct WrapMechanics
 * @brief Structure destinee a definir les modelisations autorisees en mecanique
 */
struct WrapMechanics
{
    static const set< Modelisations > setOfModelisations;
};

/**
 * @struct WrapThermal
 * @brief Structure destinee a definir les modelisations autorisees en thermique
 */
struct WrapThermal
{
    static const set< Modelisations > setOfModelisations;
};

/**
 * @struct ModelisationsChecker
 * @brief Structure template permettant de verifier qu'une modelisation est autoriser
          pour un physique donnee
 * @author Nicolas Sellenet
 */
template< class Wrapping >
struct ModelisationsChecker
{
    /**
     * @brief Fonction statique verifiant qu'une modelisation est autorisee pour la physique
     */
    static bool isAllowedModelisation( Modelisations test )
    {
        if ( Wrapping::setOfModelisations.find( test ) == Wrapping::setOfModelisations.end() )
            return false;
        return true;
    }
};

/** @typedef Definition du verificateur pour la mecanique */
typedef ModelisationsChecker< WrapMechanics > MechanicsModelisationsChecker;
/** @typedef Definition du verificateur pour la thermique */
typedef ModelisationsChecker< WrapThermal > ThermalModelisationsChecker;

/**
 * @struct PhysicsChecker
 * @brief Structure verifiant une paire Physics / Modelisations
 * @author Nicolas Sellenet
 */
struct PhysicsChecker
{
    /**
     * @brief Fonction statique verifiant qu'une paire physique modelisation est autorisee
     */
    static bool isAllowedModelisationForPhysics( Physics phys, Modelisations model )
    {
        switch ( phys )
        {
            case Mechanics:
                return MechanicsModelisationsChecker::isAllowedModelisation( model );
            case Thermal:
                return ThermalModelisationsChecker::isAllowedModelisation( model );
            default:
                throw "Not a valid physics";
        }
    };
};

#endif /* AUTHORIZEDMODELISATION_H_ */
