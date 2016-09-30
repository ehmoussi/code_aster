/**
 * @file DiscreteProblem.cxx
 * @brief Implementation de DiscreteProblem
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

#include <string>
#include <iostream>

#include "Discretization/DiscreteProblem.h"
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/MechanicalLoad.h"
#include "MemoryManager/JeveuxVector.h"

/* person_in_charge: nicolas.sellenet at edf.fr */

ElementaryVectorPtr DiscreteProblemInstance::buildElementaryDirichletVector( double time )
{
    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );

    ModelPtr curModel = _study->getSupportModel();
    std::string modelName = curModel->getName();
    modelName.resize(24, ' ');

    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    std::string nameLcha = jvListOfLoads->getName();
    nameLcha.resize(24, ' ');

    JeveuxVectorLong jvInfo = _study->getListOfLoads()->getInformationVector();
    std::string nameInfc = jvInfo->getName();
    nameInfc.resize(24, ' ');

    std::string typres( "R" );
    std::string resultName( retour->getName() );

    // CORICH appel getres
    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultName, "AUCUN" );

    CALL_VEDIME( modelName.c_str(), nameLcha.c_str(), nameInfc.c_str(), &time,
                 typres.c_str(), resultName.c_str() );
    retour->setEmpty( false );

    retour->setListOfLoads( _study->getListOfLoads() );
    return retour;
};

ElementaryVectorPtr DiscreteProblemInstance::buildElementaryLaplaceVector()
{
    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );

    ModelPtr curModel = _study->getSupportModel();
    std::string modelName = curModel->getName();
    modelName.resize(24, ' ');

    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    std::string nameLcha = jvListOfLoads->getName();
    nameLcha.resize(24, ' ');

    JeveuxVectorLong jvInfo = _study->getListOfLoads()->getInformationVector();
    std::string nameInfc = jvInfo->getName();
    nameInfc.resize(24, ' ');

    std::string blanc( " " );
    const std::string resultName( retour->getName() );

    // CORICH appel getres
    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultName, "AUCUN" );

    CALL_VELAME( modelName.c_str(), nameLcha.c_str(), nameInfc.c_str(), blanc.c_str(),
                 resultName.c_str() );
    retour->setEmpty( false );

    retour->setListOfLoads( _study->getListOfLoads() );
    return retour;
};

ElementaryVectorPtr DiscreteProblemInstance::buildElementaryNeumannVector( const VectorDouble time )
    throw ( std::runtime_error )
{
    if ( time.size() != 3 )
        throw std::runtime_error( "Invalid number of parameter" );

    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );
    MaterialOnMeshPtr curMater = _study->getMaterialOnMesh();

    ModelPtr curModel = _study->getSupportModel();
    std::string modelName = curModel->getName();

    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    std::string nameLcha = jvListOfLoads->getName();

    JeveuxVectorLong jvInfo = _study->getListOfLoads()->getInformationVector();
    std::string nameInfc = jvInfo->getName();

    const double& inst = time[0];
    std::string stop( "S" );
    std::string blanc( " " );
    std::string resultName( retour->getName() );
    std::string materName = curMater->getName();

    // CORICH appel getres
    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( resultName, "AUCUN" );

    CALL_VECHME_WRAP( stop.c_str(), modelName.c_str(), nameLcha.c_str(), nameInfc.c_str(), &inst,
                      blanc.c_str(), materName.c_str(), retour->getName().c_str(), blanc.c_str() );
    retour->setEmpty( false );

    retour->setListOfLoads( _study->getListOfLoads() );
    return retour;
};

ElementaryMatrixPtr DiscreteProblemInstance::buildElementaryRigidityMatrix( double time )
{
    ElementaryMatrixPtr retour( new ElementaryMatrixInstance( "DEPL_R", Permanent ) );
    ModelPtr curModel = _study->getSupportModel();
    MaterialOnMeshPtr curMater = _study->getMaterialOnMesh();

    _study->buildListOfLoads();
    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    jvListOfLoads->updateValuePointer();
    long nbLoad = jvListOfLoads->size();

    std::string blanc( 24, ' ' );
    std::string modelName = curModel->getName();
    modelName.resize(24, ' ');
    std::string materName = curMater->getName();
    materName.resize(24, ' ');
    std::string mate = blanc;
    CALL_RCMFMC( materName.c_str(), mate.c_str() );

    // MERIME appel getres
    CommandSyntaxCython cmdSt( "MECA_STATIQUE" );
    cmdSt.setResult( "AUCUN", "AUCUN" );

    long nh = 0;

    CALL_MERIME_WRAP( modelName.c_str(), &nbLoad, jvListOfLoads->getDataPtr()->c_str(),
                      mate.c_str(), blanc.c_str(), &time,
                      blanc.c_str(), retour->getName().c_str(), &nh, "G" );
//     try
//     {
//         testCythonException2();
//     }
//     catch(...)
//     {
//         throw;
//     }
    retour->setEmpty( false );
    return retour;
};

// TODO calcul de la matrice tangente pour l'étape de prédiction de la méthode de Newton
ElementaryMatrixPtr DiscreteProblemInstance::buildElementaryTangentMatrix( double time )
{
    return this-> buildElementaryRigidityMatrix( time );
};

// TODO calcul de la matrice jacobienne pour l'étape de correction de la méthode de Newton
ElementaryMatrixPtr DiscreteProblemInstance::buildElementaryJacobianMatrix( double time )
{
    return this-> buildElementaryRigidityMatrix( time );
};


DOFNumberingPtr DiscreteProblemInstance::computeDOFNumbering( DOFNumberingPtr dofNum )
{
    if ( dofNum->getName() == "" )
        dofNum = DOFNumberingPtr( new DOFNumberingInstance() );

    dofNum->setSupportModel( _study->getSupportModel() );
    dofNum->setListOfLoads( _study->getListOfLoads() );
    dofNum->computeNumerotation();

    return dofNum;
};

ElementaryVectorPtr DiscreteProblemInstance::buildElementaryMechanicalLoadsVector()
    throw ( std::runtime_error )
{
    ElementaryVectorPtr retour( new ElementaryVectorInstance( Permanent ) );

    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    retour->setType( retour->getType() + "_DEPL_R" );

    CommandSyntaxCython cmdSt( "CALC_VECT_ELEM" );
    cmdSt.setResult( retour->getName(), retour->getType() );

    SyntaxMapContainer dict;
    dict.container[ "OPTION" ] = "CHAR_MECA";

    if( _study->getMaterialOnMesh() )
        dict.container[ "CHAM_MATER" ] = _study->getMaterialOnMesh()->getName();

    const ListMecaLoad listOfMechanicalLoad = _study->getListOfMechanicalLoads();
    if( listOfMechanicalLoad.size() != 0 )
    {
        VectorString tmp;
        for ( const auto curIter : listOfMechanicalLoad )
            tmp.push_back( curIter->getName() );

        dict.container[ "CHARGE" ] = tmp;
    }
    cmdSt.define( dict );
    retour->setListOfLoads( _study->getListOfLoads() );

    try
    {
        ASTERINTEGER op = 8;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    retour->setEmpty(false);

    return retour;
};

SyntaxMapContainer DiscreteProblemInstance::computeMatrixSyntax( const std::string& optionName )
{
    SyntaxMapContainer dict;

    // Definition du mot cle simple MODELE
    if ( ( ! _study->getSupportModel() ) || _study->getSupportModel()->isEmpty() )
        throw std::runtime_error( "Model is empty" );
    dict.container[ "MODELE" ] = _study->getSupportModel()->getName();

    // Definition du mot cle simple CHAM_MATER
    if ( ! _study->getMaterialOnMesh() )
        throw std::runtime_error( "Material is empty" );
    dict.container[ "CHAM_MATER" ] = _study->getMaterialOnMesh()->getName();

    ListMecaLoad listMecaLoad = _study->getListOfMechanicalLoads();
    if ( listMecaLoad.size() != 0 )
    {
        VectorString tmp;
        for ( const auto curIter : listMecaLoad )
            tmp.push_back( curIter->getName() );
        dict.container[ "CHARGE" ] = tmp;
    }

    // Definition du mot cle simple OPTION
    dict.container[ "OPTION" ] = optionName;

    return dict;
};

ElementaryMatrixPtr DiscreteProblemInstance::computeMechanicalMatrix( const std::string& optionName )
    throw ( std::runtime_error )
{
    ElementaryMatrixPtr retour( new ElementaryMatrixInstance( Permanent ) );

    // Comme on calcul *_MECA, il faut preciser le type de la sd
    retour->setType( retour->getType() + "_DEPL_R" );

    // Definition du bout de fichier de commande correspondant a CALC_MATR_ELEM
    CommandSyntaxCython cmdSt( "CALC_MATR_ELEM" );
    cmdSt.setResult( retour->getName(), retour->getType() );

    SyntaxMapContainer dict = computeMatrixSyntax( optionName );

    cmdSt.define( dict );
    try
    {
        ASTERINTEGER op = 9;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    retour->setEmpty( false );

    return retour;
};

ElementaryMatrixPtr DiscreteProblemInstance::computeMechanicalDampingMatrix( const ElementaryMatrixPtr& rigidity,
                                                                             const ElementaryMatrixPtr& mass )
    throw ( std::runtime_error )
{
    ElementaryMatrixPtr retour( new ElementaryMatrixInstance( Permanent ) );

    // Comme on calcul *_MECA, il faut preciser le type de la sd
    retour->setType( retour->getType() + "_DEPL_R" );

    // Definition du bout de fichier de commande correspondant a CALC_MATR_ELEM
    CommandSyntaxCython cmdSt( "CALC_MATR_ELEM" );
    cmdSt.setResult( retour->getName(), retour->getType() );

    SyntaxMapContainer dict = computeMatrixSyntax( "AMOR_MECA" );
    dict.container[ "RIGI_MECA" ] = rigidity->getName();
    dict.container[ "MASS_MECA" ] = mass->getName();

    cmdSt.define( dict );
    try
    {
        ASTERINTEGER op = 9;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    retour->setEmpty( false );

    return retour;
};

ElementaryMatrixPtr DiscreteProblemInstance::computeMechanicalMassMatrix()
    throw ( std::runtime_error )
{
    return computeMechanicalMatrix( "RIGI_MECA" );
};

ElementaryMatrixPtr DiscreteProblemInstance::computeMechanicalRigidityMatrix()
    throw ( std::runtime_error )
{
    return computeMechanicalMatrix( "RIGI_MECA" );
};
