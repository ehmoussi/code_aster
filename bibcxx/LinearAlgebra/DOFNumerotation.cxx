
#include "LinearAlgebra/DOFNumerotation.h"

DOFNumerotationInstance::DOFNumerotationInstance():
            DataStructure( initAster->getNewResultObjectName(), "NUME_DDL" ),
            _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + "      .NSLV" ) ),
            _supportModel( Model( false ) ),
            _supportMatrix( ElementaryMatrix( false ) ),
            _load( MechanicalLoad( false ) ),
            _linearSolver( LinearSolver( MultFront, Metis ) ),
            _isEmpty( true )
{};

bool DOFNumerotationInstance::computeNumerotation()
{
    // Definition du bout de fichier de commande correspondant a AFFE_MODELE
    CommandSyntax syntaxeNumeDdl( "NUME_DDL", true,
                                     initAster->getResultObjectName(), getType() );

    if ( ! _supportModel.isEmpty() )
    {
        if ( _supportModel->isEmpty() )
            throw "Support Model is empty";
        throw "Not yet implemented";
    }
    else if ( ! _supportMatrix.isEmpty() )
    {
        if ( _supportMatrix->isEmpty() )
            throw "Support ElementaryMatrix is empty";

        SimpleKeyWordStr mCSMatrRigi = SimpleKeyWordStr( "MATR_RIGI" );
        mCSMatrRigi.addValues( _supportMatrix->getName() );
        syntaxeNumeDdl.addSimpleKeywordStr(mCSMatrRigi);

        SimpleKeyWordStr mCSSolveur = SimpleKeyWordStr( "METHODE" );
        mCSSolveur.addValues( _linearSolver->getSolverName() );
        syntaxeNumeDdl.addSimpleKeywordStr(mCSSolveur);

        SimpleKeyWordStr mCSRenum = SimpleKeyWordStr( "RENUM" );
        mCSRenum.addValues( _linearSolver->getRenumburingName() );
        syntaxeNumeDdl.addSimpleKeywordStr(mCSRenum);
    }
    else
        throw "No support matrix and support model defined";

    // Maintenant que le fichier de commande est pret, on appelle OP0018
    CALL_EXECOP( 11 );
    _isEmpty = false;

    return true;
};
