#ifndef ASSEMBLYMATRIX_H_
#define ASSEMBLYMATRIX_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "LinearAlgebra/DOFNumerotation.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/KinematicsLoad.h"

/**
* class template AssemblyMatrixInstance
*   Class definissant une sd_matr_asse
*   Cette classe est volontairement succinte car on n'en connait pas encore l'usage
* @author Nicolas Sellenet
*/
template< class ValueType >
class AssemblyMatrixInstance: public DataStructure
{
    private:
        typedef list< KinematicsLoad > ListKinematicsLoad;
        typedef ListKinematicsLoad::iterator ListKinematicsLoadIter;

        // Objet Jeveux '.REFA'
        JeveuxVectorChar24            _description;
        // Collection '.VALM'
        JeveuxCollection< ValueType > _matrixValues;
        // Objet '.CONL'
        JeveuxVectorDouble            _scaleFactorLagrangian;
        // ElementaryMatrix sur lesquelles sera construit la matrice
        ElementaryMatrix              _elemMatrix;
        // Objet nume_ddl
        DOFNumerotation               _dofNum;
        // La matrice est elle vide ?
        bool                          _isEmpty;
        // Liste de charges cinematiques
        ListKinematicsLoad            _listOfLoads;

    public:
        /**
        * Constructeur
        */
        AssemblyMatrixInstance();

        /**
        * Destructeur
        */
        ~AssemblyMatrixInstance()
        {};

        /**
        * Methode permettant d'ajouter un chargement
        * @param currentLoad objet MechanicalLoad
        */
        void addKinematicsLoad( const KinematicsLoad& currentLoad )
        {
            _listOfLoads.push_back( currentLoad );
        };

        /**
        * Assemblage de la matrice
        */
        bool build();

        /**
        * Factorisation de la matrice
        */
        bool factorization();

        /**
        * Methode permettant de savoir si les matrices elementaires sont vides
        * @return true si les matrices elementaires sont vides
        */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
        * Methode permettant de definir la numerotation
        * @param currentElemMatrix objet ElementaryMatrix
        */
        void setDOFNumerotation( const DOFNumerotation& currentNum )
        {
            _dofNum = currentNum;
        };

        /**
        * Methode permettant de definir les matrices elementaires
        * @param currentElemMatrix objet ElementaryMatrix
        */
        void setElementaryMatrix( const ElementaryMatrix& currentElemMatrix )
        {
            _elemMatrix = currentElemMatrix;
        };
};

template< class ValueType >
AssemblyMatrixInstance< ValueType >::AssemblyMatrixInstance():
                DataStructure( initAster->getNewResultObjectName(), "MATR_ASSE" ),
                _description( JeveuxVectorChar24( getName() + "           .REFA" ) ),
                _matrixValues( JeveuxCollection< ValueType >( getName() + "           .VALM" ) ),
                _scaleFactorLagrangian( JeveuxVectorDouble( getName() + "           .CONL" ) ),
                _elemMatrix( ElementaryMatrix( false ) ),
                _dofNum( DOFNumerotation( false ) ),
                _isEmpty( true )
{};

template< class ValueType >
bool AssemblyMatrixInstance< ValueType >::factorization()
{
    if ( _isEmpty )
        throw "Assembly matrix is empty";

    // Definition du bout de fichier de commande correspondant a ASSE_MATRICE
    CommandSyntax syntaxeFactoriser( "FACTORISER", true, getName(), getType() );

    // Definition du mot cle simple MATR_ASSE
    SimpleKeyWordStr mCSMatrAsse = SimpleKeyWordStr( "MATR_ASSE" );
    mCSMatrAsse.addValues( getName() );
    syntaxeFactoriser.addSimpleKeywordStr( mCSMatrAsse );

    // !!! Rajouter un if MUMPS !!!
    // Definition du mot cle simple ELIM_LAGR
    SimpleKeyWordStr mCSElimLagr = SimpleKeyWordStr( "ELIM_LAGR" );
    mCSElimLagr.addValues( "LAGR2" );
    syntaxeFactoriser.addSimpleKeywordStr( mCSElimLagr );

    SimpleKeyWordStr mCSTypeResol = SimpleKeyWordStr( "TYPE_RESOL" );
    mCSTypeResol.addValues( "AUTO" );
    syntaxeFactoriser.addSimpleKeywordStr( mCSTypeResol );

    SimpleKeyWordStr mCSPretr = SimpleKeyWordStr( "PRETRAITEMENTS" );
    mCSPretr.addValues( "AUTO" );
    syntaxeFactoriser.addSimpleKeywordStr( mCSPretr );

    SimpleKeyWordInt mCSPcentPivot = SimpleKeyWordInt( "PCENT_PIVOT" );
    mCSPcentPivot.addValues( 20 );
    syntaxeFactoriser.addSimpleKeywordInteger( mCSPcentPivot );

    SimpleKeyWordStr mCSMemoire = SimpleKeyWordStr( "GESTION_MEMOIRE" );
    mCSMemoire.addValues( "IN_CORE" );
    syntaxeFactoriser.addSimpleKeywordStr( mCSMemoire );

    SimpleKeyWordDbl mCSRempl = SimpleKeyWordDbl( "REMPLISSAGE" );
    mCSRempl.addValues( 1.0 );
    syntaxeFactoriser.addSimpleKeywordDouble( mCSRempl );

    SimpleKeyWordInt mCSNiveRempl = SimpleKeyWordInt( "NIVE_REMPLISSAGE" );
    mCSNiveRempl.addValues( 0 );
    syntaxeFactoriser.addSimpleKeywordInteger( mCSNiveRempl );

    SimpleKeyWordStr mCSSing = SimpleKeyWordStr( "STOP_SINGULIER" );
    mCSSing.addValues( "OUI" );
    syntaxeFactoriser.addSimpleKeywordStr( mCSSing );

    SimpleKeyWordStr mCSPrecond = SimpleKeyWordStr( "PRE_COND" );
    mCSPrecond.addValues( "LDLT_INC" );
    syntaxeFactoriser.addSimpleKeywordStr( mCSPrecond );

    SimpleKeyWordInt mCSNprec = SimpleKeyWordInt( "NPREC" );
    mCSNprec.addValues( 8 );
    syntaxeFactoriser.addSimpleKeywordInteger( mCSNprec );

    CALL_EXECOP( 14 );
    _isEmpty = false;

    return true;
};

template< class ValueType >
bool AssemblyMatrixInstance< ValueType >::build()
{
    if ( _elemMatrix.isEmpty() || _elemMatrix->isEmpty() )
        throw "Elementary matrix is empty";
    if ( _elemMatrix->getType() == "MATR_ELEM_DEPL_R" )
        setType( getType() + "_DEPL_R" );
    else
        throw "Not yet implemented";

    if ( _dofNum.isEmpty() || _dofNum->isEmpty() )
        throw "Numerotation is empty";

    // Definition du bout de fichier de commande correspondant a ASSE_MATRICE
    CommandSyntax syntaxeAsseMatrice( "ASSE_MATRICE", true,
                                       initAster->getResultObjectName(), getType() );

    // Definition du mot cle simple MATR_ELEM
    SimpleKeyWordStr mCSMatrElem = SimpleKeyWordStr( "MATR_ELEM" );
    mCSMatrElem.addValues( _elemMatrix->getName() );
    syntaxeAsseMatrice.addSimpleKeywordStr( mCSMatrElem );

    // Definition du mot cle simple NUME_DDL
    SimpleKeyWordStr mCSNumeDdl = SimpleKeyWordStr( "NUME_DDL" );
    mCSNumeDdl.addValues( _dofNum->getName() );
    syntaxeAsseMatrice.addSimpleKeywordStr( mCSNumeDdl );

    if ( _listOfLoads.size() != 0 )
    {
        SimpleKeyWordStr mCSCharge( "CHAR_CINE" );
        for ( ListKinematicsLoadIter curIter = _listOfLoads.begin();
              curIter != _listOfLoads.end();
              ++curIter )
        {
            mCSCharge.addValues( (*curIter)->getName() );
        }
        syntaxeAsseMatrice.addSimpleKeywordStr( mCSCharge );
    }

    CALL_EXECOP( 12 );
    _isEmpty = false;

    return true;
};

/**
* class AssemblyMatrix
*   Enveloppe d'un pointeur intelligent vers un AssemblyMatrix
* @author Nicolas Sellenet
*/
template< class ValueType >
class AssemblyMatrix
{
    public:
        typedef boost::shared_ptr< AssemblyMatrixInstance< ValueType > > AssemblyMatrixPtr;

    private:
        AssemblyMatrixPtr _assemblyMatrixPtr;

    public:
        AssemblyMatrix(bool initialisation = true): _assemblyMatrixPtr()
        {
            if ( initialisation == true )
                _assemblyMatrixPtr = AssemblyMatrixPtr( new AssemblyMatrixInstance< ValueType >() );
        };

        ~AssemblyMatrix()
        {};

        AssemblyMatrix& operator=(const AssemblyMatrix& tmp)
        {
            _assemblyMatrixPtr = tmp._assemblyMatrixPtr;
            return *this;
        };

        const AssemblyMatrixPtr& operator->() const
        {
            return _assemblyMatrixPtr;
        };

        AssemblyMatrixInstance< ValueType >& operator*(void) const
        {
            return *_assemblyMatrixPtr;
        };

        bool isEmpty() const
        {
            if ( _assemblyMatrixPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef AssemblyMatrix< double > AssemblyMatrixDouble;
typedef AssemblyMatrix< double complex > AssemblyMatrixComplex;

#endif /* ASSEMBLYMATRIX_H_ */
