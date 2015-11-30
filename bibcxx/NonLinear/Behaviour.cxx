/**
 * @file Behaviour.cxx
 * @brief Definition of the (nonlinear) behaviour 
 * @author Natacha Béreux
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

/* person_in_charge: natacha.bereux at edf.fr */

#include "astercxx.h"

#include "Utilities/SyntaxDictionary.h"

#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "NonLinear/Behaviour.h"

    bool BehaviourInstance::build() throw ( std::runtime_error )
    {
    // Construction du petit bout d'objet CommandSyntax correspondant au mot-clé COMPORTEMENT
    CommandSyntaxCython cmdStNL( "STAT_NON_LINE" );
    SyntaxMapContainer dict;
    ListSyntaxMapContainer listeCompor;
    SyntaxMapContainer dict2;
    dict2.container["RELATION"] = _relation ;
    dict2.container["DEFORMATION"] = _deformation ;
    /* Caractéristiques du MeshEntity */
    assert ( _supportMeshEntity->getType()  != GroupOfNodesType );
    if ( _supportMeshEntity->getType() == AllMeshEntitiesType )
    {
      dict2.container["TOUT"] = "OUI";
    }
    else if ( _supportMeshEntity->getType()  ==  GroupOfElementsType )
    {
      dict2.container["GROUP_MA"] = _supportMeshEntity->getEntityName();
    }
    listeCompor.push_back(dict2); 
    dict.container["COMPORTEMENT"] = listeCompor ; 
    // 
    cmdStNL.define( dict );
    long i_etat_init(1);
 /** TODO 
    CALL_NMDORC_WRAP( _supportModel->getName().c_str(),  _supportMaterialOnMesh->getName().c_str(), 
     &i_etat_init, " " , " " );
*/
    _isEmpty = false;
    return true;
    };

