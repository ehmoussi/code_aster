
/* person_in_charge: nicolas.sellenet at edf.fr */

#include "LinearAlgebra/LinearSolver.h"

const set< Renumbering > WrapMultFront::setOfAllowedRenumbering( MultFrontRenumbering,
                                                                 MultFrontRenumbering + nbRenumberingMultFront );

const set< Renumbering > WrapLdlt::setOfAllowedRenumbering( LdltRenumbering,
                                                            LdltRenumbering + nbRenumberingLdlt );

const set< Renumbering > WrapMumps::setOfAllowedRenumbering( MumpsRenumbering,
                                                             MumpsRenumbering + nbRenumberingMumps );

const set< Renumbering > WrapPetsc::setOfAllowedRenumbering( PetscRenumbering,
                                                             PetscRenumbering + nbRenumberingPetsc );

const set< Renumbering > WrapGcpc::setOfAllowedRenumbering( GcpcRenumbering,
                                                            GcpcRenumbering + nbRenumberingGcpc );
