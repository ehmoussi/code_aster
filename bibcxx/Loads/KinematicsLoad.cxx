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
#include "astercxx.h"

#include "Loads/KinematicsLoad.h"
#include "RunManager/CommandSyntax.h"

KinematicsLoadInstance::KinematicsLoadInstance():
                    DataStructure( getNewResultObjectName(), "CHAR_CINE" ),
                    _supportModel( ModelPtr() )
{};

bool KinematicsLoadInstance::build() throw ( std::runtime_error )
{
/*
    std::string typSd;
    if ( _listOfDoubleImposedDisplacement.size() != 0 )
        typSd = getType() + "_MECA";
    if ( _listOfDoubleImposedTemperature.size() != 0 )
        typSd = getType() + "_THER";
    if ( _listOfDoubleImposedDisplacement.size() == 0 && _listOfDoubleImposedTemperature.size() == 0 )
        throw std::runtime_error( "KinematicsLoad empty" );
    // Definition du bout de fichier de commande correspondant a AFFE_CHAR_CINE
    CommandSyntax syntaxeAffeCharCine( "AFFE_CHAR_CINE", true, getResultObjectName(),
                                       typSd );

    // Definition du mot cle simple MAILLAGE
    SimpleKeyWordStr mCSModel = SimpleKeyWordStr("MODELE");
    if ( ! _supportModel )
        throw std::runtime_error( "Support model is undefined" );
    mCSModel.addValues( _supportModel->getName() );
    syntaxeAffeCharCine.addSimpleKeywordString(mCSModel);

    // Definition de mot cle facteur MECA_IMPO
    if ( _listOfDoubleImposedDisplacement.size() != 0 )
    {
        FactorKeyword motCleMECA_IMPO = FactorKeyword("MECA_IMPO", true);

        for ( ListDoubleDispIter curIter = _listOfDoubleImposedDisplacement.begin();
              curIter != _listOfDoubleImposedDisplacement.end();
              ++curIter )
        {
            // Definition d'une occurence d'un mot-cle facteur
            FactorKeywordOccurence occurMECA_IMPO = FactorKeywordOccurence();

            SimpleKeyWordStr mCSGroup;
            const MeshEntityPtr& tmp = curIter->getMeshEntityPtr();
            if ( typeid( *(tmp) ) == typeid( AllMeshEntities ) )
            {
                mCSGroup = SimpleKeyWordStr("TOUT");
                mCSGroup.addValues("OUI");
            }
            else
            {
                if ( typeid( *(tmp) ) == typeid( GroupOfNodes ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_NO");
                else if ( typeid( *(tmp) ) == typeid( GroupOfElements ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_MA");

                mCSGroup.addValues( tmp->getEntityName() );
            }
            occurMECA_IMPO.addSimpleKeywordString(mCSGroup);

            const std::string nomComp = curIter->getAsterCoordinateName();
            SimpleKeyWordDbl mCSComp = SimpleKeyWordDbl( nomComp );
            // Ajout de la valeur donnee par l'utilisateur
            mCSComp.addValues( curIter->getValue() );
            // Ajout du mot-cle simple a l'occurence du mot-cle facteur
            occurMECA_IMPO.addSimpleKeywordDouble(mCSComp);

            // Ajout de l'occurence au mot-cle facteur MECA_IMPO
            motCleMECA_IMPO.addOccurence(occurMECA_IMPO);
        }

        // Ajout du mot-cle facteur MECA_IMPO a la commande AFFE_CHAR_CINE
        syntaxeAffeCharCine.addFactorKeyword(motCleMECA_IMPO);
    }

    // Maintenant que le fichier de commande est pret, on appelle OP0018
    INTEGER op = 101;
    CALL_EXECOP( &op );
*/
    return true;
};
