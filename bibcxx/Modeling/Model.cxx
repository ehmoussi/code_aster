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

#include "astercxx.h"

#include "Modeling/Model.h"
#include <typeinfo>

ModelInstance::ModelInstance(): DataStructure( getNewResultObjectName(), "MODELE" ),
                                _typeOfElements( JeveuxVectorLong( getName() + ".MAILLE    " ) ),
                                _typeOfNodes( JeveuxVectorLong( getName() + ".NOEUD     " ) ),
                                _partition( JeveuxVectorChar8( getName() + ".PARTIT    " ) ),
                                _supportMesh( MeshPtr() ),
                                _isEmpty( true )
{};


PyObject* ModelInstance::getCommandKeywords()
{
    PyObject* dict = PyDict_New();
    // add simple keywords
    addStringKeyword( dict, "VERI_JACOBIEN", "OUI" );
    if ( ! _supportMesh )
        throw string("Support mesh is undefined");
    addStringKeyword( dict, "MAILLAGE", _supportMesh->getName().c_str() );

    // add AFFE factor keyword (list of 'dict')
    PyObject* listAffe = PyList_New( _modelisations.size() );
    PyDict_SetItemString( dict, "AFFE", listAffe );

    // Loop on couples (physics / modeling)
    std::string local;
    std::string entityName;
    int occ = 0;
    for ( listOfModsAndGrpsIter curIter = _modelisations.begin();
          curIter != _modelisations.end();
          ++curIter )
    {
        PyObject* affe = PyDict_New();
        addStringKeyword( affe, "PHENOMENE", curIter->first.getPhysic().c_str() );
        addStringKeyword( affe, "MODELISATION", curIter->first.getModeling().c_str() );

        if ( typeid( *(curIter->second) ) == typeid( AllMeshEntitiesInstance ) )
        {
            addStringKeyword( affe, "TOUT", "OUI" );
        }
        else
        {
            entityName = (curIter->second)->getEntityName();
            if ( typeid( *(curIter->second) ) == typeid( GroupOfNodesInstance ) )
                local = "GROUP_NO";
            else if ( typeid( *(curIter->second) ) == typeid( GroupOfElementsInstance ) )
                local = "GROUP_MA";
            addStringKeyword( affe, local.c_str(), entityName.c_str() );
        }
        PyList_SetItem( listAffe, occ, affe);
        ++occ;
    }
    return dict;
}

bool ModelInstance::build()
{

    // Maintenant que le fichier de commande est pret, on appelle OP0018
    INTEGER op = 18;
    CALL_EXECOP( &op );
    _isEmpty = false;
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _typeOfElements->updateValuePointer();

    return true;
};
