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

#include "Utilities/SyntaxDictionary.h"

ModelInstance::ModelInstance(): DataStructure( getNewResultObjectName(), "MODELE" ),
                                _typeOfElements( JeveuxVectorLong( getName() + ".MAILLE    " ) ),
                                _typeOfNodes( JeveuxVectorLong( getName() + ".NOEUD     " ) ),
                                _partition( JeveuxVectorChar8( getName() + ".PARTIT    " ) ),
                                _supportMesh( MeshPtr() ),
                                _isEmpty( true )
{};

bool ModelInstance::build() throw ( std::runtime_error )
{
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

PyObject* ModelInstance::getCommandKeywords()
{
    SyntaxMapContainer dict;

    dict.container["VERI_JACOBIEN"] = "OUI";
    if ( ! _supportMesh )
        throw string("Support mesh is undefined");
    dict.container["MAILLAGE"] = _supportMesh->getName();

    ListSyntaxMapContainer listeAFFE;
    for ( listOfModsAndGrpsIter curIter = _modelisations.begin();
          curIter != _modelisations.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container["PHENOMENE"] = curIter->first.getPhysic();
        dict2.container["MODELISATION"] = curIter->first.getModeling();

        if ( typeid( *(curIter->second) ) == typeid( AllMeshEntitiesInstance ) )
        {
            dict2.container["TOUT"] = "OUI";
        }
        else
        {
            if ( typeid( *(curIter->second) ) == typeid( GroupOfNodesInstance ) )
                dict2.container["GROUP_NO"] = (curIter->second)->getEntityName();
            else if ( typeid( *(curIter->second) ) == typeid( GroupOfElementsInstance ) )
                dict2.container["GROUP_MA"] = (curIter->second)->getEntityName();
        }
        listeAFFE.push_back( dict2 );
    }
    dict.container["AFFE"] = listeAFFE;
    PyObject* returnDict = dict.convertToPythonDictionnary();
    return returnDict;
};
