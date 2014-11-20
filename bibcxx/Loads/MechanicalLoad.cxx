/**
 * @file MechanicalLoad.cxx
 * @brief Implementation de MechanicalLoad
 * @author Natacha Bereux
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

#include "Loads/MechanicalLoad.h"

MechanicalLoadInstance::MechanicalLoadInstance():
                                DataStructure( initAster->getNewResultObjectName(), "CHAR_MECA" ),
                                _jeveuxName( getName() ),
                                _cinematicLoad( PCFieldOnMeshDouble( string(_jeveuxName+".CHME.CIMPO") ) ),
                                _pressure( PCFieldOnMeshDouble( string(_jeveuxName+".CHME.PRESS") ) ),
                                _supportModel( Model(false) )
{};

bool MechanicalLoadInstance::build()
{
// syntaxeAffeCharMeca correspond au tronçon de fichier de commande contenant l'appel de 
// la commande AFFE_CHAR_MECA 
    CommandSyntax syntaxeAffeCharMeca( "AFFE_CHAR_MECA", true,
                                       initAster->getResultObjectName(), getType() );

// MODELE=
    SimpleKeyWordStr mCSModel = SimpleKeyWordStr("MODELE");
    if ( _supportModel.isEmpty() )
        throw string("Support model is undefined");
    mCSModel.addValues(_supportModel->getName());
    cout <<  "Nom du modele support: " << _supportModel->getName() << " . " << endl;
    syntaxeAffeCharMeca.addSimpleKeywordString(mCSModel);

    for (  listOfLoadsAndGrpsDouble::iterator curIter = _listOfLoadsDouble.begin();
          curIter != _listOfLoadsDouble.end();
          ++curIter )
    {
        cout <<  " Type de mot-clé facteur: " <<  (*curIter).first.getType() << endl;
        FactorKeywordOccurence occurLoad = FactorKeywordOccurence();

        SimpleKeyWordDbl mCSElemLoad = SimpleKeyWordDbl((*curIter).first.getName());
        mCSElemLoad.addValues((*curIter).first.getValue());
        cout <<  " Mot-clé simple: " <<  (*curIter).first.getName() << " = "<<  (*curIter).first.getValue()<< endl;

        occurLoad.addSimpleKeywordDouble(mCSElemLoad);

        SimpleKeyWordStr mCSGroup;
        if ( typeid( *(curIter->second) ) == typeid( AllMeshEntitiesInstance ) )
        {
            mCSGroup = SimpleKeyWordStr("TOUT");
            mCSGroup.addValues("OUI");
        }
        else
        {
            if ( typeid( *(curIter->second) ) == typeid( GroupOfNodesInstance ) )
                mCSGroup = SimpleKeyWordStr("GROUP_NO");
            else if ( typeid( *(curIter->second) ) == typeid( GroupOfElementsInstance ) )
                mCSGroup = SimpleKeyWordStr("GROUP_MA");

            mCSGroup.addValues( (curIter->second)->getEntityName() );
        }
        occurLoad.addSimpleKeywordString(mCSGroup);

        string nomFKW = (*curIter).first.getType();
        if ( syntaxeAffeCharMeca.isFactorKeywordPresent( nomFKW ) )
        {
            FactorKeyword& motCleLoad = syntaxeAffeCharMeca.getFactorKeyword( nomFKW );
            motCleLoad.addOccurence( occurLoad );
        }
        else
        {
            FactorKeyword motCleLoad = FactorKeyword( nomFKW, true );
            motCleLoad.addOccurence( occurLoad );
            syntaxeAffeCharMeca.addFactorKeyword( motCleLoad );
        }
    } 

   // Maintenant que le fichier de commande est pret, on appelle OP0007
    cout << " Appel de execop" << endl;
    CALL_EXECOP(7);
    return true;
};
