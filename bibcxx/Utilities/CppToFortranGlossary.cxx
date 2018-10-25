/**
 * @file CppToFortranGlossary.cxx
 * @brief Création du glossaire permettant de passer du Fortran au C++
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "Utilities/CppToFortranGlossary.h"

Glossary::Glossary() {
    for ( int i = 0; i < nbPhysics; ++i ) {
        const std::string curName( PhysicNames[i] );
        _strToInt[curName] = i;
    }

    for ( int i = 0; i < nbModelings; ++i ) {
        const std::string curName( ModelingNames[i] );
        _strToInt[curName] = i;
    }

    int i = 0;
    for ( const auto &component : ComponentNames ) {
        const std::string &toto = component.second;
        _strToInt[component.second] = i;
        ++i;
    }

    for ( int i = 0; i < nbSolvers; ++i ) {
        const std::string curName( LinearSolverNames[i] );
        _strToInt[curName] = i;
    }

    for ( int i = 0; i < nbRenumberings; ++i ) {
        const std::string curName( RenumberingNames[i] );
        _renum[curName] = i;
    }

    for ( int i = 0; i < nbPreconditionings; ++i ) {
        const std::string curName( PreconditioningNames[i] );
        _precond[curName] = i;
    }

    for ( int i = 0; i < nbLagrangeTreatments; ++i ) {
        const std::string curName( LagrangeTreatmentNames[i] );
        _lagrTreatment[curName] = i;
    }

    for ( int i = 0; i < nbMatrixTypes; ++i ) {
        const std::string curName( MatrixTypeNames[i] );
        _matrTyp[curName] = i;
    }

    for ( int i = 0; i < nbMemoryManagements; ++i ) {
        const std::string curName( MemoryManagementNames[i] );
        _memManagement[curName] = i;
    }

    for ( int i = 0; i < nbIterativeSolverAlgorithms; ++i ) {
        const std::string curName( IterativeSolverAlgorithmNames[i] );
        _algo[curName] = i;
    }

    for ( int i = 0; i < nbMumpsPostTreatments; ++i ) {
        const std::string curName( MumpsPostTreatmentNames[i] );
        _post[curName] = i;
    }

    for ( int i = 0; i < nbMumpsAcceleration; ++i ) {
        const std::string curName( MumpsAccelerationNames[i] );
        _acce[curName] = i;
    }
};

// Glossary fortranGlossary;
Glossary *fortranGlossary2 = new Glossary();

Glossary *getGlossary() { return fortranGlossary2; };

const Glossary &getReferenceToGlossary() { return *fortranGlossary2; };
