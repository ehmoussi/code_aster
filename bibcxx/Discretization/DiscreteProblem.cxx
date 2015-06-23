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

ElementaryMatrixPtr DiscreteProblemInstance::buildElementaryRigidityMatrix()
{
    ElementaryMatrixPtr retour( new ElementaryMatrixInstance( "DEPL_R" ) );
    ModelPtr curModel = _study->getSupportModel();
    MaterialOnMeshPtr curMater = _study->getMaterialOnMesh();

    _study->buildListOfLoads();
    JeveuxVectorChar24 jvListOfLoads = _study->getListOfLoads()->getListVector();
    jvListOfLoads->updateValuePointer();
    long nbLoad = jvListOfLoads->size();

    std::string blanc( 24, ' ' );
    std::string modelName = curModel->getName();
    modelName.resize(24);
    std::string materName = curMater->getName();
    materName.resize(24);
    std::string mate = blanc;
    CALL_RCMFMC( materName.c_str(), mate.c_str() );

    long exiti0 = 0, nh = 0;
    double time = 0.;
    CALL_MERIME_WRAP( modelName.c_str(), &nbLoad, jvListOfLoads->getDataPtr()->c_str(),
                      mate.c_str(), blanc.c_str(), &exiti0, &time,
                      blanc.c_str(), retour->getName().c_str(), &nh, "G" );
    retour->setEmpty( false );
    return retour;
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
