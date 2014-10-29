
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

FieldOnNodesDouble ElementaryVectorInstance::assembleVector( const DOFNumerotation& currentNumerotation )
{

    if ( _isEmpty )
        throw "The ElementaryVector is empty";

    if ( currentNumerotation.isEmpty() || currentNumerotation->isEmpty() )
        throw "Numerotation is empty";

    const string newName( initAster->getNewResultObjectName() );
    FieldOnNodesDouble vectTmp( newName );

    // Definition du bout de fichier de commande correspondant a ASSE_MATRICE
    CommandSyntax syntaxeAsseVecteur( "ASSE_VECTEUR", true, newName, "CHAM_NO" );

    // Definition du mot cle simple MATR_ELEM
    SimpleKeyWordStr mCSVectElem = SimpleKeyWordStr( "VECT_ELEM" );
    mCSVectElem.addValues( this->getName() );
    syntaxeAsseVecteur.addSimpleKeywordStr( mCSVectElem );

    // Definition du mot cle simple NUME_DDL
    SimpleKeyWordStr mCSNumeDdl = SimpleKeyWordStr( "NUME_DDL" );
    mCSNumeDdl.addValues( currentNumerotation->getName() );
    syntaxeAsseVecteur.addSimpleKeywordStr( mCSNumeDdl );

    CALL_EXECOP( 13 );
    _isEmpty = false;

    return vectTmp;
}

bool ElementaryVectorInstance::computeMechanicalLoads()
{
    if ( ! _isEmpty )
        throw "The MechanicalLoads is already compute";

    // Comme on calcul RIGI_MECA, il faut preciser le type de la sd
    setType( getType() + "_DEPL_R" );

    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeCalcVectElem( "CALC_VECT_ELEM", true, getName(), getType() );

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

    if ( _listOfMechanicalLoad.size() != 0 )
    {
        SimpleKeyWordStr mCSCharge( "CHARGE" );
        for ( ListMechanicalLoadIter curIter = _listOfMechanicalLoad.begin();
            curIter != _listOfMechanicalLoad.end();
            ++curIter )
        {
            mCSCharge.addValues( (*curIter)->getName() );
        }
        syntaxeCalcVectElem.addSimpleKeywordStr( mCSCharge );
    }

    CALL_EXECOP( 8 );
    _isEmpty = false;

    return true;
};
