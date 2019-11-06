/**
 * @file DiscreteProblem.cxx
 * @brief Implementation de DiscreteProblem
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include <iostream>
#include <string>

#include "Discretization/DiscreteProblem.h"
#include "Discretization/ParallelDOFNumbering.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/MechanicalLoad.h"
#include "Materials/MaterialOnMesh.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"

/* person_in_charge: nicolas.sellenet at edf.fr */

ElementaryVectorPtr DiscreteProblemInstance::buildElementaryDirichletVector( double time ) {
    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );

    ModelPtr curModel = _study->getModel();
    std::string modelName = curModel->getName();
    modelName.resize( 24, ' ' );

    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    std::string nameLcha = jvListOfLoads->getName();
    nameLcha.resize( 24, ' ' );

    JeveuxVectorLong jvInfo = _study->getListOfLoads()->getInformationVector();
    std::string nameInfc = jvInfo->getName();
    nameInfc.resize( 24, ' ' );

    std::string typres( "R" );
    std::string resultName( retour->getName() );

    // CORICH appel getres
    CommandSyntax cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultName, "AUCUN" );

    CALLO_VEDIME( modelName, nameLcha, nameInfc, &time, typres, resultName );
    retour->setEmpty( false );

    retour->setListOfLoads( _study->getListOfLoads() );
    return retour;
};

ElementaryVectorPtr DiscreteProblemInstance::buildElementaryLaplaceVector() {
    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );

    ModelPtr curModel = _study->getModel();
    std::string modelName = curModel->getName();
    modelName.resize( 24, ' ' );

    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    std::string nameLcha = jvListOfLoads->getName();
    nameLcha.resize( 24, ' ' );

    JeveuxVectorLong jvInfo = _study->getListOfLoads()->getInformationVector();
    std::string nameInfc = jvInfo->getName();
    nameInfc.resize( 24, ' ' );

    std::string blanc( " " );
    const std::string resultName( retour->getName() );

    // CORICH appel getres
    CommandSyntax cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultName, "AUCUN" );

    CALLO_VELAME( modelName, nameLcha, nameInfc, blanc, resultName );
    retour->setEmpty( false );

    retour->setListOfLoads( _study->getListOfLoads() );
    return retour;
};

ElementaryVectorPtr DiscreteProblemInstance::buildElementaryNeumannVector(
    const VectorDouble time, CalculationInputVariablesPtr varCom ) {
    if ( time.size() != 3 )
        throw std::runtime_error( "Invalid number of parameter" );

    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );
    const auto &curMater = _study->getCodedMaterial()->getCodedMaterialField();

    ModelPtr curModel = _study->getModel();
    std::string modelName = curModel->getName();

    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    std::string nameLcha = jvListOfLoads->getName();

    JeveuxVectorLong jvInfo = _study->getListOfLoads()->getInformationVector();
    std::string nameInfc = jvInfo->getName();

    const double &inst = time[0];
    std::string stop( "S" );
    std::string blanc( "        " );
    std::string varCName( blanc );
    if( varCom != nullptr )
        varCName = varCom->getName() + ".TOUT";
    std::string resultName( retour->getName() );
    std::string materName( curMater->getName() + "                " );

    std::string caraName( blanc );
    const auto &caraElem = _study->getElementaryCharacteristics();
    if ( caraElem != nullptr )
        caraName = caraElem->getName();

    // CORICH appel getres
    CommandSyntax cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultName, "AUCUN" );

    CALLO_VECHME_WRAP( stop, modelName, nameLcha, nameInfc, &inst, caraName, materName,
                       retour->getName(), varCName );
    retour->setEmpty( false );

    retour->setListOfLoads( _study->getListOfLoads() );
    return retour;
};

ElementaryMatrixDisplacementDoublePtr
    DiscreteProblemInstance::buildElementaryStiffnessMatrix( double time )
{
    ElementaryMatrixDisplacementDoublePtr
        retour( new ElementaryMatrixDisplacementDoubleInstance( Permanent ) );
    ModelPtr curModel = _study->getModel();
    retour->setSupportModel( curModel );
    MaterialOnMeshPtr curMater = _study->getMaterialOnMesh();
    auto compor = curMater->getBehaviourField();

    _study->buildListOfLoads();
    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    jvListOfLoads->updateValuePointer();
    ASTERINTEGER nbLoad = jvListOfLoads->size();

    std::string blanc( 24, ' ' );
    std::string modelName = curModel->getName();
    modelName.resize( 24, ' ' );

    const auto &codedMater = _study->getCodedMaterial()->getCodedMaterialField();

    std::string caraName( blanc );
    const auto &caraElem = _study->getElementaryCharacteristics();
    if ( caraElem != nullptr )
        caraName = caraElem->getName();

    // MERIME appel getres
    CommandSyntax cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( "AUCUN", "AUCUN" );
    SyntaxMapContainer dict;
    dict.container["INFO"] = (ASTERINTEGER)1;
    cmdSt.define( dict );

    ASTERINTEGER nh = 0;

    CALLO_MERIME_WRAP( modelName, &nbLoad, *( jvListOfLoads->getDataPtr() ), codedMater->getName(),
                       caraName, &time, compor->getName(), retour->getName(), &nh,
                       JeveuxMemoryTypesNames[0] );

    retour->setEmpty( false );
    return retour;
};

// TODO calcul de la matrice tangente pour l'étape de prédiction de la méthode de Newton
ElementaryMatrixDisplacementDoublePtr DiscreteProblemInstance::buildElementaryTangentMatrix
    ( double time )
{
    return this->buildElementaryStiffnessMatrix( time );
};

// TODO calcul de la matrice jacobienne pour l'étape de correction de la méthode de Newton
ElementaryMatrixDisplacementDoublePtr DiscreteProblemInstance::buildElementaryJacobianMatrix
    ( double time )
{
    return this->buildElementaryStiffnessMatrix( time );
};

FieldOnNodesDoublePtr DiscreteProblemInstance::buildKinematicsLoad(
    const BaseDOFNumberingPtr &curDOFNum, const double &time, const JeveuxMemory &memType ) const
    {
    const auto &_listOfLoad = _study->getListOfLoads();
    const auto &list = _listOfLoad->getListVector();
    const auto &loadInformations = _listOfLoad->getInformationVector();
    const auto &listOfFunctions = _listOfLoad->getListOfFunctions();
    if ( _listOfLoad->isEmpty() )
        _listOfLoad->build();
    //         throw std::runtime_error( "ListOfLoads is empty" );

    FieldOnNodesDoublePtr retour( new FieldOnNodesDoubleInstance( memType ) );
    std::string resuName = retour->getName();
    std::string dofNumName = curDOFNum->getName();

    std::string lLoadName = list->getName();
    lLoadName.resize( 24, ' ' );
    std::string infLoadName = loadInformations->getName();
    infLoadName.resize( 24, ' ' );
    std::string funcLoadName = listOfFunctions->getName();
    funcLoadName.resize( 24, ' ' );

    CALLO_ASCAVC_WRAP( lLoadName, infLoadName, funcLoadName, dofNumName, &time, resuName );

    return retour;
};

BaseDOFNumberingPtr DiscreteProblemInstance::computeDOFNumbering( BaseDOFNumberingPtr dofNum ) {
    if ( !dofNum ) {
#ifdef _USE_MPI
        if ( _study->getModel()->getMesh()->isParallel() )
            dofNum = ParallelDOFNumberingPtr( new ParallelDOFNumberingInstance() );
        else
#endif /* _USE_MPI */
            dofNum = DOFNumberingPtr( new DOFNumberingInstance() );
    }

    dofNum->setSupportModel( _study->getModel() );
    dofNum->setListOfLoads( _study->getListOfLoads() );
    dofNum->computeNumbering();

    return dofNum;
};

ElementaryVectorPtr
DiscreteProblemInstance::buildElementaryMechanicalLoadsVector() {
    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );

    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    retour->setType( retour->getType() + "_DEPL_R" );

    CommandSyntax cmdSt( "CALC_VECT_ELEM" );
    cmdSt.setResult( retour->getName(), retour->getType() );

    SyntaxMapContainer dict;
    dict.container["OPTION"] = "CHAR_MECA";
    dict.container["MODELE"] = _study->getModel()->getName();

    if ( _study->getMaterialOnMesh() )
        dict.container["CHAM_MATER"] = _study->getMaterialOnMesh()->getName();

    const ListMecaLoad listOfMechanicalLoad = _study->getListOfMechanicalLoads();
    if ( listOfMechanicalLoad.size() != 0 ) {
        VectorString tmp;
        for ( const auto curIter : listOfMechanicalLoad )
            tmp.push_back( curIter->getName() );

        dict.container["CHARGE"] = tmp;
    }
    cmdSt.define( dict );
    retour->setListOfLoads( _study->getListOfLoads() );

    try {
        ASTERINTEGER op = 8;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }
    retour->setEmpty( false );

    return retour;
};

SyntaxMapContainer DiscreteProblemInstance::computeMatrixSyntax( const std::string &optionName ) {
    SyntaxMapContainer dict;

    // Definition du mot cle simple MODELE
    if ( ( !_study->getModel() ) || _study->getModel()->isEmpty() )
        throw std::runtime_error( "Model is empty" );
    dict.container["MODELE"] = _study->getModel()->getName();

    // Definition du mot cle simple CHAM_MATER
    if ( !_study->getMaterialOnMesh() )
        throw std::runtime_error( "Material is empty" );
    dict.container["CHAM_MATER"] = _study->getMaterialOnMesh()->getName();

    ListMecaLoad listMecaLoad = _study->getListOfMechanicalLoads();
    if ( listMecaLoad.size() != 0 ) {
        VectorString tmp;
        for ( const auto curIter : listMecaLoad )
            tmp.push_back( curIter->getName() );
        dict.container["CHARGE"] = tmp;
    }

    // Definition du mot cle simple OPTION
    dict.container["OPTION"] = optionName;

    return dict;
};

ElementaryMatrixDisplacementDoublePtr DiscreteProblemInstance::computeMechanicalMatrix(
    const std::string &optionName )
{
    ElementaryMatrixDisplacementDoublePtr retour(
         new ElementaryMatrixDisplacementDoubleInstance( Permanent ) );
    retour->setSupportModel( _study->getModel() );

    // Definition du bout de fichier de commande correspondant a CALC_MATR_ELEM
    CommandSyntax cmdSt( "CALC_MATR_ELEM" );
    cmdSt.setResult( retour->getName(), retour->getType() );

    SyntaxMapContainer dict = computeMatrixSyntax( optionName );

    cmdSt.define( dict );
    try {
        ASTERINTEGER op = 9;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }
    retour->setEmpty( false );

    return retour;
};

ElementaryMatrixDisplacementDoublePtr DiscreteProblemInstance::computeMechanicalDampingMatrix(
    const ElementaryMatrixDisplacementDoublePtr &rigidity,
    const ElementaryMatrixDisplacementDoublePtr &mass )
{
    ElementaryMatrixDisplacementDoublePtr
        retour( new ElementaryMatrixDisplacementDoubleInstance( Permanent ) );
    retour->setSupportModel( rigidity->getModel() );

    // Definition du bout de fichier de commande correspondant a CALC_MATR_ELEM
    CommandSyntax cmdSt( "CALC_MATR_ELEM" );
    cmdSt.setResult( retour->getName(), retour->getType() );

    SyntaxMapContainer dict = computeMatrixSyntax( "AMOR_MECA" );
    dict.container["RIGI_MECA"] = rigidity->getName();
    dict.container["MASS_MECA"] = mass->getName();

    cmdSt.define( dict );
    try {
        ASTERINTEGER op = 9;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }
    retour->setEmpty( false );

    return retour;
};

ElementaryMatrixDisplacementDoublePtr
DiscreteProblemInstance::computeMechanicalMassMatrix() {
    return computeMechanicalMatrix( "RIGI_MECA" );
};

ElementaryMatrixDisplacementDoublePtr
DiscreteProblemInstance::computeMechanicalStiffnessMatrix() {
    return computeMechanicalMatrix( "RIGI_MECA" );
};
