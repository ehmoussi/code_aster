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

    long exiti0 = 0, nh = 0;

    CALL_MERIME_WRAP( modelName.c_str(), &nbLoad, jvListOfLoads->getDataPtr()->c_str(),
                      mate.c_str(), blanc.c_str(), &exiti0, &time,
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
