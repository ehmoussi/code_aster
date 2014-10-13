#ifndef AUTHORIZEDMODELISATION_H_
#define AUTHORIZEDMODELISATION_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "ToolClasses/EnumClass.h"
#include "checkerobject/PhysicsAndModelisations.h"

/**
* class AuthorizedMechnicsModelisation
*   Modelisations autorisees pour la mecanique
* @author Nicolas Sellenet
*/
class AuthorizedMechnicsModelisation: public Enum<AuthorizedMechnicsModelisation>
{
    private:
        explicit AuthorizedMechnicsModelisation( int Value ):
            Enum<AuthorizedMechnicsModelisation>( Value )
        {}

    public:
        static const AuthorizedMechnicsModelisation ModelAxis;
        static const AuthorizedMechnicsModelisation Model3D;
        static const AuthorizedMechnicsModelisation ModelPlanar;
        static const AuthorizedMechnicsModelisation ModelDKT;
};

/**
* class AuthorizedThermalModelisation
*   Modelisations autorisees pour la thermique
* @author Nicolas Sellenet
*/
class AuthorizedThermalModelisation: public Enum<AuthorizedThermalModelisation>
{
    private:
        explicit AuthorizedThermalModelisation( int Value ):
            Enum<AuthorizedThermalModelisation>( Value )
        {}

    public:
        static const AuthorizedThermalModelisation ModelAxis;
        static const AuthorizedThermalModelisation Model3D;
        static const AuthorizedThermalModelisation ModelPlanar;
};

#endif /* AUTHORIZEDMODELISATION_H_ */
