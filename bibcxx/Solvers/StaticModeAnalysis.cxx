/**
 * @file Model.cxx
 * @brief Implementation de ModelInstance
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

/* person_in_charge: guillaume.drouet at edf.fr */

#include <stdexcept>
#include "astercxx.h"

#include "Solvers/StaticModeAnalysis.h"
#include <typeinfo>

#include "RunManager/CommandSyntaxCython.h"

//StaticModeDeplInstance::StaticModeDeplInstance():  //?????
 //                                _supportModel( ModelPtr() ),
  //                               _materialOnMesh( MaterialOnMeshPtr() ),
   //                              _listOfLoads( ListOfLoadsPtr( new ListOfLoadsInstance() ) ),
    //                             _loadStep( TimeStepperPtr( new TimeStepperInstance( Temporary ) ) ), 
     //                            _nonLinearMethod( NonLinearMethodPtr())
                                 //?????
//{};


ResultsContainerPtr StaticModeDeplInstance::execute() throw ( std::runtime_error )
{
    ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "MODE_MECA" ) ) );
    std::string nameOfSD = resultC->getName();

    CommandSyntaxCython cmdSt( "MODE_STATIQUE" );
    cmdSt.setResult( nameOfSD, resultC->getType() );

    SyntaxMapContainer dict;
    // On récupère la matrice de rigidité et éventuellement de masse 
    if ( ! _StiffMatrix )
       throw std::runtime_error("Stiffness Matrix is undefined");
    dict.container["MATR_RIGI"] = _StiffMatrix->getName();
    if (_MassMatrix)
    {
    dict.container["MATR_MASS"] = _MassMatrix->getName();
    }
    
    ListSyntaxMapContainer FactorMODE_STAT;
    SyntaxMapContainer FactorMODE_STAT_1;
    SyntaxMapContainer FactorMODE_STAT_2;
    ListGenParam listParam;
    // FactorMODE_STAT_1 localization
    
    listParam.push_back(&_loc);
    FactorMODE_STAT_1=buildSyntaxMapFromParamList(listParam);
    listParam.pop_back();

    // FactorMODE_STAT_2 wanted cmp
    
    listParam.push_back(&_cmp);
    FactorMODE_STAT_2=buildSyntaxMapFromParamList(listParam);

    //Concatenate FactorMODE_STAT_1 + FactorMODE_STAT_2

    FactorMODE_STAT.push_back( FactorMODE_STAT_1 + FactorMODE_STAT_2);

    dict.container["MODE_STAT"] = FactorMODE_STAT;
    
    //Factor keyword Solver treatment
    
    ListSyntaxMapContainer FactorSOLVEUR;
    
    FactorSOLVEUR.push_back(buildSyntaxMapFromParamList(_linearSolver->getListOfParameters()));

    dict.container["SOLVEUR"] =  FactorSOLVEUR;
   
    cmdSt.define( dict );

    // Maintenant que le fichier de commande est pret, on appelle OP0093
    try
    {
        INTEGER op = 93;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    //_isEmpty = false;
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire ???
    //_typeOfElements->updateValuePointer();
    resultC->buildFromExisting();
    return resultC;
};

ResultsContainerPtr StaticModeForcInstance::execute() throw ( std::runtime_error )
{
    ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "MODE_MECA" ) ) );
    std::string nameOfSD = resultC->getName();

    CommandSyntaxCython cmdSt( "MODE_STATIQUE" );
    cmdSt.setResult( nameOfSD, resultC->getType() );

    SyntaxMapContainer dict;
    
    // On récupère la matrice de rigidité et éventuellement de masse 
    if ( ! _StiffMatrix )
       throw std::runtime_error("Stiffness Matrix is undefined");
    dict.container["MATR_RIGI"] = _StiffMatrix->getName();
    if (_MassMatrix)
    {
    dict.container["MATR_MASS"] = _MassMatrix->getName();
    }
    
    ListSyntaxMapContainer FactorMODE_STAT;
    SyntaxMapContainer FactorMODE_STAT_1;
    SyntaxMapContainer FactorMODE_STAT_2;
    ListGenParam listParam;
    // FactorMODE_STAT_1 localization
    
    listParam.push_back(&_loc);
    FactorMODE_STAT_1=buildSyntaxMapFromParamList(listParam);
    listParam.pop_back();

    // FactorMODE_STAT_2 wanted cmp
    
    listParam.push_back(&_cmp);
    FactorMODE_STAT_2=buildSyntaxMapFromParamList(listParam);

    //Concatenate FactorMODE_STAT_1 + FactorMODE_STAT_2

    FactorMODE_STAT.push_back( FactorMODE_STAT_1 + FactorMODE_STAT_2);

    dict.container["FORCE_NODALE"] = FactorMODE_STAT;
    
    //Factor keyword Solver treatment
    
    ListSyntaxMapContainer FactorSOLVEUR;
    
    FactorSOLVEUR.push_back(buildSyntaxMapFromParamList(_linearSolver->getListOfParameters()));

    dict.container["SOLVEUR"] =  FactorSOLVEUR;
   
    cmdSt.define( dict );

    

    // Maintenant que le fichier de commande est pret, on appelle OP0093
    try
    {
        INTEGER op = 93;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    //_isEmpty = false;
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire ???
    //_typeOfElements->updateValuePointer();
    resultC->buildFromExisting();
    return resultC;
};

ResultsContainerPtr StaticModePseudoInstance::execute() throw ( std::runtime_error )
{
    ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "MODE_MECA" ) ) );
    std::string nameOfSD = resultC->getName();

    CommandSyntaxCython cmdSt( "MODE_STATIQUE" );
    cmdSt.setResult( nameOfSD, resultC->getType() );

    SyntaxMapContainer dict;
    // On récupère les matrices de rigidité et de masse 
    if ( ! _StiffMatrix )
       throw std::runtime_error("Stiffness Matrix is undefined");
    dict.container["MATR_RIGI"] = _StiffMatrix->getName();
    if (! _MassMatrix)
       throw std::runtime_error("Mass Matrix is undefined");
    dict.container["MATR_MASS"] = _MassMatrix->getName();
    
    
    ListSyntaxMapContainer FactorPSEUDO;
    SyntaxMapContainer FactorPSEUDO_1;
    SyntaxMapContainer FactorPSEUDO_2;
    SyntaxMapContainer FactorPSEUDO_3;
    ListGenParam listParam;
    // FactorPSEUDO_1 localization
    
    listParam.push_back(&_loc);
    FactorPSEUDO_1=buildSyntaxMapFromParamList(listParam);
    listParam.pop_back();
    // FactorPSEUDO_2 wanted cmp
    if (_loc.getName()=="TOUT" | _loc.getName()=="GROUP_NO"){
        listParam.push_back(&_cmp);
        FactorPSEUDO_2=buildSyntaxMapFromParamList(listParam);
        listParam.pop_back();
        }
    // FactorPSEUDO_3 dirname
    if (_loc.getName()=="DIRECTION" && _dirname.isSet()){
        listParam.push_back(&_dirname);
        FactorPSEUDO_3=buildSyntaxMapFromParamList(listParam);
        listParam.pop_back();
        }
    //Concatenate FactorPSEUDO_1 + FactorPSEUDO_2 + FactorPSEUDO_3

    FactorPSEUDO.push_back( FactorPSEUDO_1 + FactorPSEUDO_2 + FactorPSEUDO_3);

    dict.container["PSEUDO_MODE"] = FactorPSEUDO;
    
    //Factor keyword Solver treatment
    
    ListSyntaxMapContainer FactorSOLVEUR;
    
    FactorSOLVEUR.push_back(buildSyntaxMapFromParamList(_linearSolver->getListOfParameters()));

    dict.container["SOLVEUR"] =  FactorSOLVEUR;

   
    cmdSt.define( dict );
    

    // Maintenant que le fichier de commande est pret, on appelle OP0093
    try
    {
        INTEGER op = 93;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    //_isEmpty = false;
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire ???
    //_typeOfElements->updateValuePointer();
    resultC->buildFromExisting();
    return resultC;
};

ResultsContainerPtr StaticModeInterfInstance::execute() throw ( std::runtime_error )
{
    ResultsContainerPtr resultC( new ResultsContainerInstance ( std::string( "MODE_MECA" ) ) );
    std::string nameOfSD = resultC->getName();

    CommandSyntaxCython cmdSt( "MODE_STATIQUE" );
    cmdSt.setResult( nameOfSD, resultC->getType() );

    SyntaxMapContainer dict;
    std::cout<<"cxx!"<<std::endl;
    // On récupère la matrice de rigidité et éventuellement de masse 
    if ( ! _StiffMatrix )
       throw std::runtime_error("Stiffness Matrix is undefined");
    dict.container["MATR_RIGI"] = _StiffMatrix->getName();
    if (! _MassMatrix)
       throw std::runtime_error("Mass Matrix is undefined");
    dict.container["MATR_MASS"] = _MassMatrix->getName();
    
    
    ListSyntaxMapContainer FactorMODE_STAT;
    SyntaxMapContainer FactorMODE_STAT_1;
    SyntaxMapContainer FactorMODE_STAT_2;
    SyntaxMapContainer FactorMODE_STAT_3;
    SyntaxMapContainer FactorMODE_STAT_4;
    ListGenParam listParam;
    // FactorMODE_STAT_1 localization
    
    listParam.push_back(&_loc);
    FactorMODE_STAT_1=buildSyntaxMapFromParamList(listParam);
    listParam.pop_back();

    // FactorMODE_STAT_2 wanted cmp
    
    listParam.push_back(&_cmp);
    FactorMODE_STAT_2=buildSyntaxMapFromParamList(listParam);
    listParam.pop_back();
    
    // FactorMODE_STAT_3 nb_mode
    
    listParam.push_back(&_nbmod);
    FactorMODE_STAT_3=buildSyntaxMapFromParamList(listParam);
    listParam.pop_back();
    
    // FactorMODE_STAT_4 shift
    
    listParam.push_back(&_shift);
    FactorMODE_STAT_4=buildSyntaxMapFromParamList(listParam);
    listParam.pop_back();
    
    //Concatenate FactorMODE_STAT_1 + FactorMODE_STAT_2

    FactorMODE_STAT.push_back( FactorMODE_STAT_1 + FactorMODE_STAT_2 );

    dict.container["MODE_INTERF"] = FactorMODE_STAT;
    
    //Factor keyword Solver treatment
    
    ListSyntaxMapContainer FactorSOLVEUR;
    
    FactorSOLVEUR.push_back(buildSyntaxMapFromParamList(_linearSolver->getListOfParameters()));

    dict.container["SOLVEUR"] =  FactorSOLVEUR;
   
    cmdSt.define( dict );
    

    std::cout<<"Je lance !"<<std::endl;

    // Maintenant que le fichier de commande est pret, on appelle OP0093
    try
    {
        INTEGER op = 93;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    std::cout<<"OK !"<<std::endl;
    //_isEmpty = false;
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire ???
    //_typeOfElements->updateValuePointer();
    resultC->buildFromExisting();
    return resultC;
};
