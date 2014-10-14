%module code_aster
%{
#include "Modelisations/ElementaryModelisation.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

enum Modelisations { Axisymmetrical, Tridimensional, Planar, DKT };
enum Physics { Mechanics, Thermal, Acoustics };

class ElementaryModelisation
{
    public:
        ElementaryModelisation( Physics phys, Modelisations mod );

        const string getModelisation();

        const string getPhysic();
};
