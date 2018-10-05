/**
 * @file KinematicsLoad.cxx
 * @brief Implementation de KinematicsLoad
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

#include <stdexcept>
#include <typeinfo>
#include <string>
#include "astercxx.h"

#include "Loads/KinematicsLoad.h"
#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

KinematicsLoadInstance::KinematicsLoadInstance( const std::string& type ):
    DataStructure( ResultNaming::getNewResultName(), 19, "CHAR_CINE" + type ),
    _supportModel( ModelPtr() ),
    _intParam( JeveuxVectorLong( getName() + ".AFCI" ) ),
    _charParam( JeveuxVectorChar8( getName() + ".AFCK" ) ),
    _doubleParam( JeveuxVectorDouble( getName() + ".AFCV" ) ),
    _isEmpty( true )
{};

KinematicsLoadInstance::KinematicsLoadInstance( const std::string& name, const std::string& type ):
    DataStructure( name, 19, "CHAR_CINE" + type ),
    _supportModel( ModelPtr() ),
    _intParam( JeveuxVectorLong( getName() + ".AFCI" ) ),
    _charParam( JeveuxVectorChar8( getName() + ".AFCK" ) ),
    _doubleParam( JeveuxVectorDouble( getName() + ".AFCV" ) ),
    _isEmpty( true )
{};

bool KinematicsLoadInstance::build() throw ( std::runtime_error )
{
    std::string cmd = "AFFE_CHAR_CINE";
    if (_listOfFunctionImposedTemperature.size() != 0)
        cmd += "_F";
    CommandSyntax cmdSt( cmd );
    cmdSt.setResult( ResultNaming::getCurrentName(), getType() );

    SyntaxMapContainer dict;
    if ( ! _supportModel )
        throw std::runtime_error( "Support model is undefined" );
    dict.container[ "MODELE" ] = _supportModel->getName();

    // Definition de mot cle facteur MECA_IMPO
    if ( _listOfDoubleImposedDisplacement.size() != 0 )
    {
        ListSyntaxMapContainer listeMecaImpo;
        for ( ListDoubleDispIter curIter = _listOfDoubleImposedDisplacement.begin();
              curIter != _listOfDoubleImposedDisplacement.end();
              ++curIter )
        {
            SyntaxMapContainer dict2;
            const MeshEntityPtr& tmp = curIter->getMeshEntityPtr();
            if ( tmp->getType() == AllMeshEntitiesType )
            {
                dict2.container[ "TOUI" ] = "OUI";
            }
            else
            {
                if ( tmp->getType() == GroupOfNodesType )
                    dict2.container[ "GROUP_NO" ] = tmp->getName();
                else if ( tmp->getType() == GroupOfElementsType )
                    dict2.container[ "GROUP_MA" ] = tmp->getName();
            }

            const std::string nomComp = curIter->getAsterCoordinateName();
            dict2.container[ nomComp ] = curIter->getValue();

            listeMecaImpo.push_back( dict2 );
        }

        dict.container[ "MECA_IMPO" ] = listeMecaImpo;
    }
    if ( _listOfFunctionImposedTemperature.size() != 0 )
    {
        ListSyntaxMapContainer listeTempImpo;
        for ( ListFunctionTemp::iterator curIter = _listOfFunctionImposedTemperature.begin();
              curIter != _listOfFunctionImposedTemperature.end();
              ++curIter )
        {
            SyntaxMapContainer dict2;
            const MeshEntityPtr& tmp = curIter->getMeshEntityPtr();
            if ( tmp->getType() == AllMeshEntitiesType )
            {
                dict2.container[ "TOUI" ] = "OUI";
            }
            else
            {
                if ( tmp->getType() == GroupOfNodesType )
                    dict2.container[ "GROUP_NO" ] = tmp->getName();
                else if ( tmp->getType() == GroupOfElementsType )
                    dict2.container[ "GROUP_MA" ] = tmp->getName();
            }
            const std::string nomComp = curIter->getAsterCoordinateName();
            dict2.container[ nomComp ] = curIter->getValue()->getName();

            listeTempImpo.push_back( dict2 );
        }

        dict.container[ "THER_IMPO" ] = listeTempImpo;
    }
    cmdSt.define( dict );

    try
    {
        ASTERINTEGER op = 101;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;

    return true;
};
