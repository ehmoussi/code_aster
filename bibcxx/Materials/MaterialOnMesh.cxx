/**
 * @file MaterialOnMesh.cxx
 * @brief Implementation de MaterialOnMesh
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
#include <typeinfo>
#include "astercxx.h"

#include "Materials/MaterialOnMesh.h"
#include "Utilities/SyntaxDictionary.h"


MaterialOnMeshInstance::MaterialOnMeshInstance():
                                DataStructure( getNewResultObjectName(), "CHAM_MATER" ),
                                _listOfMaterials( PCFieldOnMeshPtrChar8(
                                    new PCFieldOnMeshInstanceChar8( getName() + ".CHAMP_MAT " ) ) ),
                                _listOfTemperatures( PCFieldOnMeshPtrDouble(
                                    new PCFieldOnMeshInstanceDouble( getName() + ".TEMPE_REF " ) ) ),
                                _supportMesh( MeshPtr() )
{};

PyObject* MaterialOnMeshInstance::getCommandKeywords() throw ( std::runtime_error )
{
    SyntaxMapContainer dict;

    if ( ! _supportMesh )
        throw std::runtime_error("Support mesh is undefined");
    dict.container["MAILLAGE"] = _supportMesh->getName();

    ListSyntaxMapContainer listeAFFE;
    for ( listOfMatsAndGrpsIter curIter = _materialsOnMeshEntity.begin();
          curIter != _materialsOnMeshEntity.end();
          ++curIter )
    {
        SyntaxMapContainer dict2;
        dict2.container["MATER"] = curIter->first->getName();
        const MeshEntityPtr& tmp = curIter->second;
        if ( tmp->getType() == AllMeshEntitiesType )
        {
            dict2.container["TOUT"] = "OUI";
        }
        else
        {
            if ( tmp->getType() == GroupOfElementsType )
                dict2.container["GROUP_MA"] = (curIter->second)->getEntityName();
            else if ( tmp->getType() == GroupOfNodesType  )
                dict2.container["GROUP_NO"] = (curIter->second)->getEntityName();
            else
                throw std::runtime_error("Support entity undefined");
        }
        listeAFFE.push_back( dict2 );
    }
    dict.container["AFFE"] = listeAFFE;

    PyObject* returnDict = dict.convertToPythonDictionnary();
    return returnDict;
};

bool MaterialOnMeshInstance::build() throw ( std::runtime_error )
{
    // Maintenant que le fichier de commande est pret, on appelle OP0018
    try
    {
        INTEGER op = 6;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _listOfMaterials->updateValuePointers();

    return true;
};
