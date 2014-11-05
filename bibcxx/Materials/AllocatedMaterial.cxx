
/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Materials/AllocatedMaterial.h"
#include <typeinfo>

AllocatedMaterialInstance::AllocatedMaterialInstance():
                                DataStructure( initAster->getNewResultObjectName(), "CHAM_MATER" ),
                                _listOfMaterials( PCFieldOnMeshChar8( getName() + ".CHAMP_MAT " ) ),
                                _listOfTemperatures( PCFieldOnMeshDouble( getName() + ".TEMPE_REF " ) ),
                                _supportMesh( Mesh(false) )
{};

bool AllocatedMaterialInstance::build()
{
    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeAffeMater( "AFFE_MATERIAU", true,
                                    initAster->getResultObjectName(), getType() );

    // Definition du mot cle simple MAILLAGE
    SimpleKeyWordStr mCSMaillage = SimpleKeyWordStr("MAILLAGE");
    if ( _supportMesh.isEmpty() )
        throw string("Support mesh is undefined");
    // Affectation d'une valeur au mot cle simple MAILLAGE
    // Si _supportMesh->getJeveuxName() = 'MA      ' alors
    // cela correspondra dans le fichier de commande emule a :
    // MAILLAGE = MA
    mCSMaillage.addValues( _supportMesh->getName() );
    syntaxeAffeMater.addSimpleKeywordStr(mCSMaillage);

    // Definition de mot cle facteur AFFE
    FactorKeyword motCleAFFE = FactorKeyword("AFFE", true);

    // Boucle sur les couples (physique / modelisation) ajoutes par l'utilisateur
    for ( listOfMatsAndGrpsIter curIter = _materialsOnMeshEntity.begin();
          curIter != _materialsOnMeshEntity.end();
          ++curIter )
    {
        // Definition d'une accourence d'un mot-cle facteur
        FactorKeywordOccurence occurAFFE = FactorKeywordOccurence();

        // Definition du mot-cle simple PHENOMENE
        SimpleKeyWordStr mCSMater = SimpleKeyWordStr("MATER");
        // Ajout de la valeur donnee par l'utilisateur
        mCSMater.addValues( (*curIter).first->getName() );
        // Ajout du mot-cle simple a l'occurence du mot-cle facteur
        occurAFFE.addSimpleKeywordStr(mCSMater);

        SimpleKeyWordStr mCSGroup;
        if ( typeid( *(curIter->second) ) == typeid( AllMeshEntitiesInstance ) )
        {
            mCSGroup = SimpleKeyWordStr("TOUT");
            mCSGroup.addValues("OUI");
        }
        else
        {
            if ( typeid( *(curIter->second) ) == typeid( GroupOfElementsInstance ) )
                mCSGroup = SimpleKeyWordStr("GROUP_MA");
            else throw "Bad type of mesh entity, group of elements required";

            mCSGroup.addValues( (curIter->second)->getEntityName() );
        }
        occurAFFE.addSimpleKeywordStr(mCSGroup);
        // Ajout de l'occurence au mot-cle facteur AFFE
        motCleAFFE.addOccurence(occurAFFE);
    }

    // Ajout du mot-cle facteur AFFE a la commande AFFE_MODELE
    syntaxeAffeMater.addFactorKeyword(motCleAFFE);

    // Definition du mot cle simple LIST_NOM_VARC
    SimpleKeyWordStr mCSLNomVarc = SimpleKeyWordStr("LIST_NOM_VARC");
    mCSLNomVarc.addValues( "TEMP" );
    syntaxeAffeMater.addSimpleKeywordStr(mCSLNomVarc);

    FactorKeyword motCleVarcTemp = FactorKeyword("VARC_TEMP", false);
    FactorKeywordOccurence occurVarcTemp = FactorKeywordOccurence();
    SimpleKeyWordStr mCSNomVarc = SimpleKeyWordStr("NOM_VARC");
    mCSNomVarc.addValues( "TEMP" );
    occurVarcTemp.addSimpleKeywordStr(mCSNomVarc);
    motCleVarcTemp.addOccurence(occurVarcTemp);
    syntaxeAffeMater.addFactorKeyword(motCleVarcTemp);

    // Maintenant que le fichier de commande est pret, on appelle OP0006
    CALL_EXECOP(6);
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _listOfMaterials->updateValuePointers();

    return true;
};
