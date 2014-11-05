
#include "RunManager/Initializer.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "RunManager/CommandSyntax.h"

ElementaryMatrixInstance::ElementaryMatrixInstance():
                DataStructure( initAster->getNewResultObjectName(), "MATR_ELEM" ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true ),
                _supportModel( Model( false ) ),
                _material( AllocatedMaterial( false ) )
{};

bool ElementaryMatrixInstance::computeMechanicalRigidity()
{
    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    setType( getType() + "_DEPL_R" );

    // Definition du bout de fichier de commande correspondant a CALC_MATR_ELEM
    CommandSyntax syntaxeCalcMatrElem( "CALC_MATR_ELEM", true,
                                       initAster->getResultObjectName(), getType() );

    // Definition du mot cle simple OPTION
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

    // Definition du mot cle simple CHAM_MATER
    SimpleKeyWordStr mCSChamMater = SimpleKeyWordStr( "CHAM_MATER" );
    if ( _material.isEmpty() )
        throw string("Material is empty");
    mCSChamMater.addValues( _material->getName() );
    syntaxeCalcMatrElem.addSimpleKeywordStr( mCSChamMater );

    if ( _listOfMechanicalLoads.size() != 0 )
    {
        SimpleKeyWordStr mCSCharge( "CHARGE" );
        for ( ListMecaLoadIter curIter = _listOfMechanicalLoads.begin();
              curIter != _listOfMechanicalLoads.end();
              ++curIter )
        {
            mCSCharge.addValues( (*curIter)->getName() );
        }
        syntaxeCalcMatrElem.addSimpleKeywordStr( mCSCharge );
    }

    CALL_EXECOP( 9 );
    _isEmpty = false;

    return true;
};
