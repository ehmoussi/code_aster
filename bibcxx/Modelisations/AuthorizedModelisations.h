#ifndef AUTHORIZEDMODELISATION_H_
#define AUTHORIZEDMODELISATION_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Modelisations/PhysicsAndModelisations.h"
#include <set>

using namespace std;

// Ces wrappers sont la pour autoriser que les set soitent const
// Sinon, on aurait pas pu passer directement des const set<> en parametre template
struct WrapMechanics
{
    static const set< Modelisations > setOfModelisations;
};

struct WrapThermal
{
    static const set< Modelisations > setOfModelisations;
};

/**
* class template ModelisationsChecker
* @author Nicolas Sellenet
*/
template< class Wrapping >
class ModelisationsChecker
{
    public:
        static bool isAllowedModelisation( Modelisations test )
        {
            if ( Wrapping::setOfModelisations.find( test ) == Wrapping::setOfModelisations.end() )
                return false;
            return true;
        }
};

typedef ModelisationsChecker< WrapMechanics > MechanicsModelisationsChecker;
typedef ModelisationsChecker< WrapThermal > ThermalModelisationsChecker;

class PhysicsChecker
{
    public:
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
