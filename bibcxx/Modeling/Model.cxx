/**
 * @file Model.cxx
 * @brief Implementation de ModelInstance
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include "Supervis/CommandSyntax.h"

const char *const ModelSplitingMethodNames[nbModelSplitingMethod] = {"CENTRALISE", "SOUS_DOMAINE",
                                                                     "GROUP_ELEM"};
const char *const GraphPartitionerNames[nbGraphPartitioner] = {"SCOTCH", "METIS"};

SyntaxMapContainer ModelInstance::buildModelingsSyntaxMapContainer() const {
    SyntaxMapContainer dict;

    dict.container["VERI_JACOBIEN"] = "OUI";
    if ( !_supportBaseMesh )
        throw std::runtime_error( "Support mesh is undefined" );
    dict.container["MAILLAGE"] = _supportBaseMesh->getName();

    ListSyntaxMapContainer listeAFFE;
    for ( listOfModsAndGrpsCIter curIter = _modelisations.begin(); curIter != _modelisations.end();
          ++curIter ) {
        SyntaxMapContainer dict2;
        dict2.container["PHENOMENE"] = curIter->first.getPhysic();
        dict2.container["MODELISATION"] = curIter->first.getModeling();

        if ( ( *( curIter->second ) ).getType() == AllMeshEntitiesType ) {
            dict2.container["TOUT"] = "OUI";
        } else {
            if ( ( *( curIter->second ) ).getType() == GroupOfNodesType )
                dict2.container["GROUP_NO"] = ( curIter->second )->getName();
            else if ( ( *( curIter->second ) ).getType() == GroupOfElementsType )
                dict2.container["GROUP_MA"] = ( curIter->second )->getName();
        }
        listeAFFE.push_back( dict2 );
    }
    dict.container["AFFE"] = listeAFFE;
    return dict;
};

bool ModelInstance::buildWithSyntax( SyntaxMapContainer &dict ) {
    CommandSyntax cmdSt( "AFFE_MODELE" );
    cmdSt.setResult( ResultNaming::getCurrentName(), "MODELE" );
    cmdSt.define( dict );

    // Maintenant que le fichier de commande est pret, on appelle OP0018
    try {
        ASTERINTEGER op = 18;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _typeOfElements->updateValuePointer();

    return true;
};

bool ModelInstance::build() {
    SyntaxMapContainer dict = buildModelingsSyntaxMapContainer();
    if ( _supportBaseMesh->isParallel() ) {
        ListSyntaxMapContainer listeDISTRIBUTION;
        SyntaxMapContainer dict2;
        dict2.container["METHODE"] = ModelSplitingMethodNames[(int)Centralized];
        listeDISTRIBUTION.push_back( dict2 );
        dict.container["DISTRIBUTION"] = listeDISTRIBUTION;
    } else {
        ListSyntaxMapContainer listeDISTRIBUTION;
        SyntaxMapContainer dict2;
        dict2.container["METHODE"] = ModelSplitingMethodNames[(int)getSplittingMethod()];
        dict2.container["PARTITIONNEUR"] = GraphPartitionerNames[(int)getGraphPartitioner()];
        listeDISTRIBUTION.push_back( dict2 );
        dict.container["DISTRIBUTION"] = listeDISTRIBUTION;
    }

    return buildWithSyntax( dict );
};

bool ModelInstance::existsThm() {
    const std::string typeco( "MODELE" );
    ASTERINTEGER repi = 0, ier = 0;
    JeveuxChar32 repk( " " );
    const std::string arret( "C" );
    const std::string questi( "EXI_THM" );

    CALLO_DISMOI( questi, getName(), typeco, &repi, repk, arret, &ier );
    auto retour = trim( repk.toString() );
    if ( retour == "OUI" )
        return true;
    return false;
};

bool ModelInstance::existsMultiFiberBeam() {
    const std::string typeco( "MODELE" );
    ASTERINTEGER repi = 0, ier = 0;
    JeveuxChar32 repk( " " );
    const std::string arret( "C" );
    const std::string questi( "EXI_STR2" );

    CALLO_DISMOI( questi, getName(), typeco, &repi, repk, arret, &ier );
    auto retour = trim( repk.toString() );
    if ( retour == "OUI" )
        return true;
    return false;
};

bool ModelInstance::xfemPreconditioningEnable() {
    const std::string typeco( "MODELE" );
    ASTERINTEGER repi = 0, ier = 0;
    JeveuxChar32 repk( " " );
    const std::string arret( "C" );
    const std::string questi( "PRE_COND_XFEM" );

    CALLO_DISMOI( questi, getName(), typeco, &repi, repk, arret, &ier );
    auto retour = trim( repk.toString() );
    if ( retour == "OUI" )
        return true;
    return false;
};
