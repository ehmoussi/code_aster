
#include "RunManager/Initializer.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "RunManager/CommandSyntax.h"

ElementaryMatrixInstance::ElementaryMatrixInstance():
                DataStructure( initAster->getNewResultObjectName(), "MATR_ELEM" ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _supportModel( Model( false ) ),
                _material( AllocatedMaterial( false ) )
{};

bool ElementaryMatrixInstance::computeMechanicalRigidity()
{
    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeCalcMatrElem( "CALC_MATR_ELEM", true,
                                       initAster->getResultObjectName(), getType() + "_DEPL_R" );
    // Ligne indispensable pour que les commandes GET* fonctionnent
    commandeCourante = &syntaxeCalcMatrElem;

    // Definition du mot cle simple MAILLAGE
    SimpleKeyWordStr mCSOption = SimpleKeyWordStr( "OPTION" );
    mCSOption.addValues( "RIGI_MECA" );
    syntaxeCalcMatrElem.addSimpleKeywordStr( mCSOption );

    // Definition du mot cle simple MODELE
    // ??? Ajouter des verifs pour savoir si l'interieur du modele est vide ???
    SimpleKeyWordStr mCSModele = SimpleKeyWordStr( "MODELE" );
    if ( _supportModel.isEmpty() || _supportModel->isEmpty() )
        throw string("Support model is undefined");
    mCSModele.addValues( _supportModel->getName() );
    syntaxeCalcMatrElem.addSimpleKeywordStr( mCSModele );

    // Definition du mot cle simple MAILLAGE
    SimpleKeyWordStr mCSChamMater = SimpleKeyWordStr( "CHAM_MATER" );
    if ( _material.isEmpty() )
        throw string("Material is empty");
    mCSChamMater.addValues( _material->getName() );
    syntaxeCalcMatrElem.addSimpleKeywordStr( mCSChamMater );

    CALL_EXECOP( 9 );

    // Mise a zero indispensable de commandeCourante
    commandeCourante = NULL;

    return true;
};
