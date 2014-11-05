
#include "Loads/KinematicsLoad.h"
#include <typeinfo>

KinematicsLoadInstance::KinematicsLoadInstance():
                    DataStructure( initAster->getNewResultObjectName(), "CHAR_CINE" ),
                    _supportModel( Model( false ) )
{};

bool KinematicsLoadInstance::build()
{
    string typSd;
    if ( _listOfDoubleImposedDisplacement.size() != 0 )
        typSd = getType() + "_MECA";
    if ( _listOfDoubleImposedTemperature.size() != 0 )
        typSd = getType() + "_THER";
    if ( _listOfDoubleImposedDisplacement.size() == 0 && _listOfDoubleImposedTemperature.size() == 0 )
        throw "KinematicsLoad empty";
    // Definition du bout de fichier de commande correspondant a AFFE_CHAR_CINE
    CommandSyntax syntaxeAffeCharCine( "AFFE_CHAR_CINE", true, initAster->getResultObjectName(),
                                       typSd );

    // Definition du mot cle simple MAILLAGE
    SimpleKeyWordStr mCSModel = SimpleKeyWordStr("MODELE");
    if ( _supportModel.isEmpty() )
        throw string("Support model is undefined");
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
            // Definition d'une accourence d'un mot-cle facteur
            FactorKeywordOccurence occurMECA_IMPO = FactorKeywordOccurence();

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
            occurMECA_IMPO.addSimpleKeywordString(mCSGroup);

            const string nomComp = curIter->getAsterCoordinateName();
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
    CALL_EXECOP(101);

    return true;
};
