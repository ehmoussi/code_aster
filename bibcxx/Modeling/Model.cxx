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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include <stdexcept>
#include "astercxx.h"

#include "Modeling/Model.h"
#include <typeinfo>

#include "RunManager/CommandSyntaxCython.h"

ModelInstance::ModelInstance(): DataStructure( getNewResultObjectName(), "MODELE" ),
                                _typeOfElements( JeveuxVectorLong( getName() + ".MAILLE    " ) ),
                                _typeOfNodes( JeveuxVectorLong( getName() + ".NOEUD     " ) ),
                                _partition( JeveuxVectorChar8( getName() + ".PARTIT    " ) ),
                                _supportMesh( MeshPtr() ),
                                _isEmpty( true )
{};

bool ModelInstance::build() throw ( std::runtime_error )
{
    CommandSyntaxCython cmdSt( "AFFE_MODELE" );
    cmdSt.setResult( getResultObjectName(), "MODELE" );

    SyntaxMapContainer dict;

    dict.container["VERI_JACOBIEN"] = "OUI";
    if ( ! _supportMesh )
        throw std::runtime_error("Support mesh is undefined");
    dict.container["MAILLAGE"] = _supportMesh->getName();

    ListSyntaxMapContainer listeAFFE;
    for ( listOfModsAndGrpsIter curIter = _modelisations.begin();
          curIter != _modelisations.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container["PHENOMENE"] = curIter->first.getPhysic();
        dict2.container["MODELISATION"] = curIter->first.getModeling();

        if ( ( *(curIter->second) ).getType() == AllMeshEntitiesType )
        {
            dict2.container["TOUT"] = "OUI";
        }
        else
        {
            if ( ( *(curIter->second) ).getType() == GroupOfNodesType )
                dict2.container["GROUP_NO"] = (curIter->second)->getName();
            else if ( ( *(curIter->second) ).getType() == GroupOfElementsType )
                dict2.container["GROUP_MA"] = (curIter->second)->getName();
        }
        listeAFFE.push_back( dict2 );
    }
    dict.container["AFFE"] = listeAFFE;
    cmdSt.define( dict );

    // Maintenant que le fichier de commande est pret, on appelle OP0018
    try
    {
        INTEGER op = 18;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _typeOfElements->updateValuePointer();

    return true;
};

ModelPtr ModelInstance::enrichWithXfem( XfemCrackPtr &xfemCrack ) throw ( std::runtime_error )
{
    CommandSyntaxCython cmdSt( "MODI_MODELE_XFEM" );
    
    // Create empty model and get its name
    ModelPtr newModelPtr(new ModelInstance());
    cmdSt.setResult( newModelPtr->getName(), "MODELE" );

    SyntaxMapContainer dict;

    dict.container["MODELE_IN"] = this->getName();
    if ( _isEmpty )
        throw std::runtime_error("The Model must be built first");
    dict.container["FISSURE"] = xfemCrack->getName();

    // Set some default kwd values (TODO : support other values for the kwd)
    dict.container["DECOUPE_FACETTE"] = "DEFAUT";
    dict.container["CONTACT"] = "SANS";
    dict.container["PRETRAITEMENTS"] = "AUTO";

    cmdSt.define( dict );

    // Call  OP00113
    try
    {
        INTEGER op = 113;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }

    return newModelPtr;

};
