#ifndef AUTHORIZEDMODELISATION_H_
#define AUTHORIZEDMODELISATION_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "baseobject/EnumClass.h"

/**
* enum Modelisations
*   Modelisations existantes dans Code_Aster
* @author Nicolas Sellenet
*/
enum Modelisations { Axisymmetrical, Tridimensional, Planar, DKT };
static const char* const ModelisationNames[] = { "AXIS", "3D", "PLAN", "DKT" };

/**
* enum Physics
*   Physiques existantes dans Code_Aster
* @author Nicolas Sellenet
*/
enum Physics { Mechanics, Thermal, Acoustics };
static const char* const PhysicNames[] = { "MECANIQUE", "THERMIQUE", "ACOUSTIQUE" };

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
