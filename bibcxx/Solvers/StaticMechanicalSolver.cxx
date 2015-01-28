/**
 * @file StaticMechanicalSolver.cxx
 * @brief Fichier source contenant le source du solveur de mecanique statique
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

#include "Solvers/StaticMechanicalSolver.h"

StaticMechanicalSolverInstance::StaticMechanicalSolverInstance():
                _supportModel( ModelPtr() ),
                _materialOnMesh( MaterialOnMesh( false ) ),
                _linearSolver( LinearSolver() )
{};

ResultsContainer StaticMechanicalSolverInstance::execute()
{
    ResultsContainer resultC( string( "EVOL_ELAS" ) );
    string nameOfSD = resultC->getName();

    CommandSyntax syntaxeMecaStat( "MECA_STATIQUE", true,
                                   resultC->getName(), resultC->getType() );

    // Definition du mot cle simple MODELE
    SimpleKeyWordStr mCSModele = SimpleKeyWordStr( "MODELE" );
    if ( ( ! _supportModel ) || _supportModel->isEmpty() )
        throw string("Support model is undefined");
    mCSModele.addValues( _supportModel->getName() );
    syntaxeMecaStat.addSimpleKeywordString( mCSModele );

    // Definition du mot cle simple CHAM_MATER
    if ( ! _materialOnMesh.isEmpty() )
    {
        SimpleKeyWordStr mCSChamMater = SimpleKeyWordStr( "CHAM_MATER" );
        mCSChamMater.addValues( _materialOnMesh->getName() );
        syntaxeMecaStat.addSimpleKeywordString( mCSChamMater );
    }

    if ( _listOfMechanicalLoads.size() == 0 && _listOfKinematicsLoads.size() == 0 )
        throw string("At least one load is needed");

    FactorKeyword mCFExcit = FactorKeyword( "EXCIT", true );
    for ( ListMecaLoadIter curIter = _listOfMechanicalLoads.begin();
          curIter != _listOfMechanicalLoads.end();
          ++curIter )
    {
        // Definition d'une occurence d'un mot-cle facteur
        FactorKeywordOccurence occurExcit = FactorKeywordOccurence();

        SimpleKeyWordStr mCSCharge( "CHARGE" );
        mCSCharge.addValues( (*curIter)->getName() );
        occurExcit.addSimpleKeywordString( mCSCharge );

        SimpleKeyWordStr mCSTypChar( "TYPE_CHARGE" );
        mCSTypChar.addValues( "FIXE" );
        occurExcit.addSimpleKeywordString( mCSTypChar );

        // Ajout de l'occurence du MCF
        mCFExcit.addOccurence( occurExcit );
    }

    for ( ListKineLoadIter curIter = _listOfKinematicsLoads.begin();
          curIter != _listOfKinematicsLoads.end();
          ++curIter )
    {
        // Definition d'une occurence d'un mot-cle facteur
        FactorKeywordOccurence occurExcit = FactorKeywordOccurence();

        SimpleKeyWordStr mCSCharge( "CHARGE" );
        mCSCharge.addValues( (*curIter)->getName() );
        occurExcit.addSimpleKeywordString( mCSCharge );

        SimpleKeyWordStr mCSTypChar( "TYPE_CHARGE" );
        mCSTypChar.addValues( "FIXE" );
        occurExcit.addSimpleKeywordString( mCSTypChar );

        // Ajout de l'occurence du MCF
        mCFExcit.addOccurence( occurExcit );
    }
    syntaxeMecaStat.addFactorKeyword( mCFExcit );

    // A mettre ailleurs ?
    FactorKeyword mCFSolveur = FactorKeyword( "SOLVEUR", false );
    FactorKeywordOccurence occurSolveur = FactorKeywordOccurence();

    SimpleKeyWordStr mCSMethode( "METHODE" );
    mCSMethode.addValues( _linearSolver->getSolverName() );
    occurSolveur.addSimpleKeywordString( mCSMethode );

    SimpleKeyWordStr mCSRenum( "RENUM" );
    mCSRenum.addValues( _linearSolver->getRenumburingName() );
    occurSolveur.addSimpleKeywordString( mCSRenum );

    SimpleKeyWordStr mCSGestionMem( "GESTION_MEMOIRE" );
    mCSGestionMem.addValues( "OUT_OF_CORE" );
    occurSolveur.addSimpleKeywordString( mCSGestionMem );

    SimpleKeyWordStr mCSStopSing( "STOP_SINGULIER" );
    mCSStopSing.addValues( "OUI" );
    occurSolveur.addSimpleKeywordString( mCSStopSing );

    SimpleKeyWordStr mCSPretraitement( "PRETRAITEMENTS" );
    mCSPretraitement.addValues( "AUTO" );
    occurSolveur.addSimpleKeywordString( mCSPretraitement );

    SimpleKeyWordStr mCSTypeResol( "TYPE_RESOL" );
    mCSTypeResol.addValues( "AUTO" );
    occurSolveur.addSimpleKeywordString( mCSTypeResol );

    SimpleKeyWordStr mCSMatrD( "MATR_DISTRIBUEE" );
    mCSMatrD.addValues( "NON" );
    occurSolveur.addSimpleKeywordString( mCSMatrD );

    SimpleKeyWordStr mCSElimLagr( "ELIM_LAGR" );
    mCSElimLagr.addValues( "LAGR2" );
    occurSolveur.addSimpleKeywordString( mCSElimLagr );

    SimpleKeyWordStr mCSPostTraitement( "POSTTRAITEMENTS" );
    mCSPostTraitement.addValues( "AUTO" );
    occurSolveur.addSimpleKeywordString( mCSPostTraitement );

    SimpleKeyWordInt mCSPcentPivot( "PCENT_PIVOT" );
    mCSPcentPivot.addValues( 50 );
    occurSolveur.addSimpleKeywordInteger( mCSPcentPivot );

    SimpleKeyWordInt mCSNprec( "NPREC" );
    mCSNprec.addValues( -1 );
    occurSolveur.addSimpleKeywordInteger( mCSNprec );

    SimpleKeyWordDbl mCSResiRela( "RESI_RELA" );
    mCSResiRela.addValues( -1.0 );
    occurSolveur.addSimpleKeywordDouble( mCSResiRela );

    mCFSolveur.addOccurence( occurSolveur );
    syntaxeMecaStat.addFactorKeyword( mCFSolveur );

    SimpleKeyWordStr mCSOption = SimpleKeyWordStr( "OPTION" );
    mCSOption.addValues( "SIEF_ELGA" );
    syntaxeMecaStat.addSimpleKeywordString( mCSOption );

    CALL_EXECOP( 46 );

    return resultC;
};
