
#include "LinearAlgebra/AllowedLinearSolver.h"

const char* LinearSolverNames[nbSolvers] = { "MUMPS", "MULT_FRONT", "LDLT", "PETSC", "GCPC" };
const char* RenumberingNames[nbRenumberings] = { "MD", "MDA", "METIS", "RCMK", "AMD",
                                                 "AMF", "PORD", "QAMD", "SCOTCH", "AUTO", "SANS" };


const Renumbering MultFrontRenumbering[nbRenumberingMultFront] = { MD, MDA, Metis };

const Renumbering LdltRenumbering[nbRenumberingLdlt] = { RCMK, Sans };

const Renumbering MumpsRenumbering[nbRenumberingMumps] = { AMD, AMF, PORD, Metis, QAMD, Scotch, Auto };

const Renumbering PetscRenumbering[nbRenumberingPetsc] = { RCMK, Sans };

const Renumbering GcpcRenumbering[nbRenumberingGcpc] = { RCMK, Sans };
