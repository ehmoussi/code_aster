#ifndef ALLOWEDLINEARSOLVER_H_
#define ALLOWEDLINEARSOLVER_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* enum LinearSolverEnum
*   Tous les solveurs lineaires
* @author Nicolas Sellenet
*/
enum LinearSolverEnum { MultFront, Ldlt, Mumps, Petsc, Gcpc };
const int nbSolvers = 5;
extern const char* LinearSolverNames[nbSolvers];

/**
* Declaration des renumeroteurs
* @author Nicolas Sellenet
*/
enum Renumbering { MD, MDA, Metis, RCMK, AMD, AMF, PORD, QAMD, Scotch, Auto, Sans };
const int nbRenumberings = 11;
extern const char* RenumberingNames[nbRenumberings];

const int nbRenumberingMultFront = 3;
extern const Renumbering MultFrontRenumbering[nbRenumberingMultFront];

const int nbRenumberingLdlt = 2;
extern const Renumbering LdltRenumbering[nbRenumberingLdlt];

const int nbRenumberingMumps = 7;
extern const Renumbering MumpsRenumbering[nbRenumberingMumps];

const int nbRenumberingPetsc = 2;
extern const Renumbering PetscRenumbering[nbRenumberingPetsc];

const int nbRenumberingGcpc = 2;
extern const Renumbering GcpcRenumbering[nbRenumberingGcpc];

#endif /* ALLOWEDLINEARSOLVER_H_ */
