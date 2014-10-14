
/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Modelisations/Model.h"
#include <typeinfo>

ModelInstance::ModelInstance(): _jeveuxName( initAster->getNewResultObjectName() ),
                                _typeOfElements( JeveuxVectorLong( string(_jeveuxName + ".MAILLE    ") ) ),
                                _typeOfNodes( JeveuxVectorLong( string(_jeveuxName + ".NOEUD     ") ) ),
                                _partition( JeveuxVectorChar8( string(_jeveuxName + ".PARTIT    ") ) ),
                                _supportMesh( Mesh(false) )
{};

bool ModelInstance::build()
{
    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeAffeModele("AFFE_MODELE", true, initAster->getResultObjectName());
    // Ligne indispensable pour que les commandes GET* fonctionnent
    commandeCourante = &syntaxeAffeModele;

    // Definition du mot cle simple MAILLAGE
    SimpleKeyWordStr mCSMaillage = SimpleKeyWordStr("MAILLAGE");
    if ( _supportMesh.isEmpty() )
        throw string("Support mesh is undefined");
    // Affectation d'une valeur au mot cle simple MAILLAGE
    // Si _supportMesh->getJeveuxName() = 'MA      ' alors
    // cela correspondra dans le fichier de commande emule a :
    // MAILLAGE = MA
    mCSMaillage.addValues( _supportMesh->getJeveuxName() );
    syntaxeAffeModele.addSimpleKeywordStr(mCSMaillage);

    // Definition de mot cle facteur AFFE
    FactorKeyword motCleAFFE = FactorKeyword("AFFE", true);

    // Boucle sur les couples (physique / modelisation) ajoutes par l'utilisateur
    for ( listOfModsAndGrpsIter curIter = _modelisations.begin();
          curIter != _modelisations.end();
          ++curIter )
    {
        // Definition d'une accourence d'un mot-cle facteur
        FactorKeywordOccurence occurAFFE = FactorKeywordOccurence();

        // Definition du mot-cle simple PHENOMENE
        SimpleKeyWordStr mCSPhenomene = SimpleKeyWordStr("PHENOMENE");
        // Ajout de la valeur donnee par l'utilisateur
        mCSPhenomene.addValues((*curIter).first.getPhysic());
        // Ajout du mot-cle simple a l'occurence du mot-cle facteur
        occurAFFE.addSimpleKeywordStr(mCSPhenomene);

        SimpleKeyWordStr mCSModelisation = SimpleKeyWordStr("MODELISATION");
        mCSModelisation.addValues((*curIter).first.getModelisation());
        occurAFFE.addSimpleKeywordStr(mCSModelisation);

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
        occurAFFE.addSimpleKeywordStr(mCSGroup);
        // Ajout de l'occurence au mot-cle facteur AFFE
        motCleAFFE.addOccurence(occurAFFE);
    }

    // Ajout du mot-cle facteur AFFE a la commande AFFE_MODELE
    syntaxeAffeModele.addFactorKeyword(motCleAFFE);

    // Maintenant que le fichier de commande est pret, on appelle OP0018
    CALL_EXECOP(18);
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _typeOfElements->updateValuePointer();

    // Mise a zero indispensable de commandeCourante
    commandeCourante = NULL;
    return true;
};
