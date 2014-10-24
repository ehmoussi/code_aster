
#include "RunManager/Initializer.h"
#include "LinearAlgebra/ElementaryVector.h"
#include "RunManager/CommandSyntax.h"

ElementaryVectorInstance::ElementaryVectorInstance():
                DataStructure( initAster->getNewResultObjectName(), "VECT_ELEM" ),
                _description( JeveuxVectorChar24( getName() + "           .RERR" ) ),
                _listOfElementaryResults( JeveuxVectorChar24( getName() + "           .RELR" ) ),
                _isEmpty( true ),
                _material( AllocatedMaterial( false ) )
{};

bool ElementaryVectorInstance::computeMechanicalLoads()
{
    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    setType( getType() + "_DEPL_R" );

    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeCalcVectElem( "CALC_VECT_ELEM", true,
                                       initAster->getResultObjectName(), getType() );
    // Ligne indispensable pour que les commandes GET* fonctionnent
    commandeCourante = &syntaxeCalcVectElem;

    // Definition du mot cle simple MAILLAGE
    SimpleKeyWordStr mCSOption = SimpleKeyWordStr( "OPTION" );
    mCSOption.addValues( "CHAR_MECA" );
    syntaxeCalcVectElem.addSimpleKeywordStr( mCSOption );

    if ( ! _material.isEmpty() )
    {
        SimpleKeyWordStr mCSChamMater = SimpleKeyWordStr( "CHAM_MATER" );
        mCSChamMater.addValues( _material->getName() );
        syntaxeCalcVectElem.addSimpleKeywordStr( mCSChamMater );
    }

    if ( _listOfMechanicalLoad.size() == 0 )
        throw "At least one MechanicalLoad is required";

    SimpleKeyWordStr mCSCharge( "CHARGE" );
    for ( ListMechanicalLoadIter curIter = _listOfMechanicalLoad.begin();
          curIter != _listOfMechanicalLoad.end();
          ++curIter )
    {
        mCSCharge.addValues( (*curIter)->getName() );
    }
    syntaxeCalcVectElem.addSimpleKeywordStr( mCSCharge );

    CALL_EXECOP( 8 );
    _isEmpty = false;

    // Mise a zero indispensable de commandeCourante
    commandeCourante = NULL;

    return true;
};
