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
#include <typeinfo>

MechanicalLoadInstance::MechanicalLoadInstance():
                                DataStructure( initAster->getNewResultObjectName(), "CHAR_MECA" ),
                                _jeveuxName( getName() ),
                                _kinematicLoad( PCFieldOnMeshPtrDouble(
                                    new PCFieldOnMeshInstanceDouble( string(_jeveuxName+".CHME.CIMPO") ) ) ),
                                _pressure( PCFieldOnMeshPtrDouble(
                                    new PCFieldOnMeshInstanceDouble( string(_jeveuxName+".CHME.PRESS") ) ) ),
                                _supportModel( ModelPtr() )
{};

bool MechanicalLoadInstance::build()
{
// Definition du bout de fichier de commande correspondant à l'appel de
// la commande AFFE_CHAR_MECA
    CommandSyntax syntaxeAffeCharMeca( "AFFE_CHAR_MECA", true,
                                       initAster->getResultObjectName(), getType() );

// Définition du mot clé simple MODELE
    SimpleKeyWordStr mCSModel = SimpleKeyWordStr("MODELE");
    if ( ! _supportModel )
        throw string("Support model is undefined");
    mCSModel.addValues(_supportModel->getName());
    cout <<  "Nom du modele support: " << _supportModel->getName() << " . " << endl;
    syntaxeAffeCharMeca.addSimpleKeywordString(mCSModel);

// Définition de mot clé facteur DDL_IMPO
// Impose un déplacement ou une pression
    if (( _listOfDoubleImposedDisplacement.size() != 0 ) || ( _listOfDoubleImposedPressure.size() != 0 ))
    {
    FactorKeyword motCleDDL_IMPO = FactorKeyword("DDL_IMPO", true);

// Boucle sur les déplacements imposés
    for ( ListDoubleDispIter curIter = _listOfDoubleImposedDisplacement.begin();
              curIter != _listOfDoubleImposedDisplacement.end();
              ++curIter )
    {
      // Definition d'une occurence d'un mot-cle facteur
            FactorKeywordOccurence occurDDL_IMPO = FactorKeywordOccurence();

            SimpleKeyWordStr mCSGroup;
            const MeshEntityPtr& tmp = curIter->getMeshEntityPtr();
            if ( typeid( *(tmp) ) == typeid( AllMeshEntitiesInstance ) )
            {
                mCSGroup = SimpleKeyWordStr("TOUT");
                mCSGroup.addValues("OUI");
            }
            else
            {
                if ( typeid( *(tmp) ) == typeid( GroupOfNodesInstance ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_NO");
                else if ( typeid( *(tmp) ) == typeid( GroupOfElementsInstance ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_MA");

                mCSGroup.addValues( tmp->getEntityName() );
            }
            occurDDL_IMPO.addSimpleKeywordString(mCSGroup);

            const string nomComp = curIter->getAsterCoordinateName();
            SimpleKeyWordDbl mCSComp = SimpleKeyWordDbl( nomComp );
            // Ajout de la valeur donnee par l'utilisateur
            mCSComp.addValues( curIter->getValue() );
            // Ajout du mot-cle simple a l'occurence du mot-cle facteur
            occurDDL_IMPO.addSimpleKeywordDouble(mCSComp);

            // Ajout de l'occurence au mot-cle facteur DDL_IMPO
            motCleDDL_IMPO.addOccurence(occurDDL_IMPO);
    }
// Boucle sur les pressions imposées
    for ( ListDoublePresIter curIter = _listOfDoubleImposedPressure.begin();
              curIter != _listOfDoubleImposedPressure.end();
              ++curIter )
    {
      // Definition d'une occurence d'un mot-cle facteur
            FactorKeywordOccurence occurDDL_IMPO = FactorKeywordOccurence();

            SimpleKeyWordStr mCSGroup;
            const MeshEntityPtr& tmp = curIter->getMeshEntityPtr();
            if ( typeid( *(tmp) ) == typeid( AllMeshEntitiesInstance ) )
            {
                mCSGroup = SimpleKeyWordStr("TOUT");
                mCSGroup.addValues("OUI");
            }
            else
            {
                if ( typeid( *(tmp) ) == typeid( GroupOfNodesInstance ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_NO");
                else if ( typeid( *(tmp) ) == typeid( GroupOfElementsInstance ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_MA");

                mCSGroup.addValues( tmp->getEntityName() );
            }
            occurDDL_IMPO.addSimpleKeywordString(mCSGroup);

            const string nomComp = curIter->getAsterCoordinateName();
            SimpleKeyWordDbl mCSComp = SimpleKeyWordDbl( nomComp );
            // Ajout de la valeur donnee par l'utilisateur
            mCSComp.addValues( curIter->getValue() );
            // Ajout du mot-cle simple a l'occurence du mot-cle facteur
            occurDDL_IMPO.addSimpleKeywordDouble(mCSComp);

            // Ajout de l'occurence au mot-cle facteur DDL_IMPO
            motCleDDL_IMPO.addOccurence(occurDDL_IMPO);
    }

        // Ajout du mot-cle facteur DDL_IMPO a la commande AFFE_CHAR_MECA
        syntaxeAffeCharMeca.addFactorKeyword(motCleDDL_IMPO);
  }
//
// Définition de mot clé facteur PRES_REP
// Impose une pression répartie sur un groupe de mailles
    if ( _listOfDoubleImposedDistributedPressure.size() != 0 )
    {
    FactorKeyword motClePRES_REP = FactorKeyword("PRES_REP", true);

// Boucle sur les pressions imposées
    for ( ListDoublePresIter curIter = _listOfDoubleImposedDistributedPressure.begin();
              curIter != _listOfDoubleImposedDistributedPressure.end();
              ++curIter )
    {
      // Definition d'une occurence d'un mot-cle facteur
            FactorKeywordOccurence occurPRES_REP = FactorKeywordOccurence();

            SimpleKeyWordStr mCSGroup;
            const MeshEntityPtr& tmp = curIter->getMeshEntityPtr();
            if ( typeid( *(tmp) ) == typeid( AllMeshEntitiesInstance ) )
            {
                mCSGroup = SimpleKeyWordStr("TOUT");
                mCSGroup.addValues("OUI");
            }
            else
            {
                if (  typeid( *(tmp) ) == typeid( GroupOfElementsInstance ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_MA");
// else error ?
                mCSGroup.addValues( tmp->getEntityName() );
            }
            occurPRES_REP.addSimpleKeywordString(mCSGroup);

            const string nomComp = curIter->getAsterCoordinateName();
            SimpleKeyWordDbl mCSComp = SimpleKeyWordDbl( nomComp );
            // Ajout de la valeur donnee par l'utilisateur
            mCSComp.addValues( curIter->getValue() );
            // Ajout du mot-cle simple a l'occurence du mot-cle facteur
            occurPRES_REP.addSimpleKeywordDouble(mCSComp);

            // Ajout de l'occurence au mot-cle facteur PRES_REP
            motClePRES_REP.addOccurence(occurPRES_REP);
    }
        // Ajout du mot-cle facteur PRES_REP a la commande AFFE_CHAR_MECA
        syntaxeAffeCharMeca.addFactorKeyword(motClePRES_REP);
//

    }
//
// Définition du mot clé facteur FORCE_TUYAU
// Impose une pression sur un groupe de mailles décrivant un tuyau
    if ( _listOfDoubleImposedPipePressure.size() != 0 )
    {
    FactorKeyword motCleFORCE_TUYAU = FactorKeyword("FORCE_TUYAU", true);

// Boucle sur les pressions imposées
    for ( ListDoublePresIter curIter = _listOfDoubleImposedPipePressure.begin();
              curIter != _listOfDoubleImposedPipePressure.end();
              ++curIter )
    {
      // Definition d'une occurence d'un mot-cle facteur
            FactorKeywordOccurence occurFORCE_TUYAU = FactorKeywordOccurence();

            SimpleKeyWordStr mCSGroup;
            const MeshEntityPtr& tmp = curIter->getMeshEntityPtr();
            if ( typeid( *(tmp) ) == typeid( AllMeshEntitiesInstance ) )
            {
                mCSGroup = SimpleKeyWordStr("TOUT");
                mCSGroup.addValues("OUI");
            }
            else
            {
                if ( typeid( *(tmp) ) == typeid( GroupOfNodesInstance ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_NO");
                else if ( typeid( *(tmp) ) == typeid( GroupOfElementsInstance ) )
                    mCSGroup = SimpleKeyWordStr("GROUP_MA");

                mCSGroup.addValues( tmp->getEntityName() );
            }
            occurFORCE_TUYAU.addSimpleKeywordString(mCSGroup);

            const string nomComp = curIter->getAsterCoordinateName();
            SimpleKeyWordDbl mCSComp = SimpleKeyWordDbl( nomComp );
            // Ajout de la valeur donnee par l'utilisateur
            mCSComp.addValues( curIter->getValue() );
            // Ajout du mot-cle simple a l'occurence du mot-cle facteur
            occurFORCE_TUYAU.addSimpleKeywordDouble(mCSComp);

            // Ajout de l'occurence au mot-cle facteur FORCE_TUYAU
            motCleFORCE_TUYAU.addOccurence(occurFORCE_TUYAU);
    }
        // Ajout du mot-cle facteur FORCE_TUYAU a la commande AFFE_CHAR_MECA
        syntaxeAffeCharMeca.addFactorKeyword(motCleFORCE_TUYAU);
//

    }
   // Maintenant que le fichier de commande est pret, on appelle OP0007
    cout << " Appel de execop" << endl;
    CALL_EXECOP(7);
    return true;
};
