#ifndef ELEMENTARYMODELISATION_H_
#define ELEMENTARYMODELISATION_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Modelisations/AuthorizedModelisations.h"
#include <string>

using namespace std;

/**
* class ElementaryModellisation
*   Element de base d'un modele, c'est une paire PHYSIQUE, MODELISATION
* @author Nicolas Sellenet
*/
class ElementaryModelisation
{
    private:
        Physics       _physic;
        Modelisations _modelisation;

    public:
        /**
        * Constructeur
        */
        ElementaryModelisation( Physics phys, Modelisations mod ): _physic(phys), _modelisation(mod)
        {
            bool retour = PhysicsChecker::isAllowedModelisationForPhysics( phys, mod );
            if ( ! retour )
                throw string( PhysicNames[_physic] ) + " with " + ModelisationNames[_modelisation] + " not allowed";
        };

        /**
        * Recuperation de la chaine modelisation
        * @return chaine de caracteres
        */
        const string getModelisation()
        {
            return ModelisationNames[_modelisation];
        };

        /**
        * Recuperation de la chaine physics
        * @return chaine de caracteres
        */
        const string getPhysic()
        {
            return PhysicNames[_physic];
        };
};

#endif /* ELEMENTARYMODELISATION_H_ */
