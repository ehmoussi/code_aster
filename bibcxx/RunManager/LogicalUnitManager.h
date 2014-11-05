#ifndef LOGICALUNITMANAGER_H_
#define LOGICALUNITMANAGER_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "RunManager/CommandSyntax.h"

#define CALL_OPSEXE(a) CALLP(OPSEXE, opsexe, a)
extern "C"
{
    void DEFP(OPSEXE, opsexe, const INTEGER*);
}

/**
* Tableau contenant toutes les unites logiques autorisees de 19 a 99
* @author Nicolas Sellenet
*/
const int nbOfLogicalUnit = 81;
extern const int tabOfLogicalUnit[nbOfLogicalUnit];

/**
* Tableau FileType : ASCII, Binary ou Free
* @author Nicolas Sellenet
*/
enum FileType { ASCII, Binary, Free };
extern const char* const NameFileType[3];

/**
* Tableau FileAccess : New, Append ou Old
* @author Nicolas Sellenet
*/
enum FileAccess { New, Append, Old };
extern const char* const NameFileAccess[3];

/**
* class statique LogicalUnitManager
*   Cette classe permet de gerer les unitees logiques disponibles
* @author Nicolas Sellenet
*/
class LogicalUnitManager
{
    private:
        typedef set< int > SetInt;
        typedef SetInt::iterator SetIntIter;

        // Tableau contenant les UL encore disponibles
        static list< int > _freeLogicalUnit;
        static set< int >  _nonFreeLogicalUnit;

    public:
        /**
        * Methode permettant d'obtenir une unite logique libre
        * @return une entier correspondant a l'unite libre
        */
        static int getLogicalUnit()
        {
            if ( _freeLogicalUnit.size() == 0 )
                throw "No more logical unit";
            int retour = (*_freeLogicalUnit.begin());
            _freeLogicalUnit.erase( _freeLogicalUnit.begin() );

            _nonFreeLogicalUnit.insert( set< int >::value_type( retour ) );

            return retour;
        };

        /**
        * Methode permettant de liberer une unite logique
        * @param unitToRelease Numero de l'unite logique a liberer
        * @return true ou leve une exception
        */
        static bool releaseLogicalUnit( const int unitToRelease )
        {
            SetIntIter curIter = _nonFreeLogicalUnit.find( unitToRelease );
            if ( curIter == _nonFreeLogicalUnit.end() )
                throw "Unable to free this logical unit";

            _nonFreeLogicalUnit.erase( curIter );
            _freeLogicalUnit.push_back( unitToRelease );
            return true;
        };
};

/**
* class LogicalUnitFile
*   Cette classe permet de definir un fichier qui sera associe a une unite logique
* @author Nicolas Sellenet
*/
class LogicalUnitFile
{
    private:
        const string     _nomFichier;
        const FileType   _type;
        const FileAccess _access;
        const int        _logicalUnit;
        const long       _numOp26;

    public:
        /**
        * Constructeur
        *   Ce constructeur se charge d'appeler DEFI_FICHIER et de reserver l'unite logique
        * @param pathFichier Path vers le fichier a associer a une unite logique
        * @param FileType Type du fichier, a choisir dans l'enum FileType
        * @param FileAccess Acces au fichier, a choisir dans l'enum FileAccess
        */
        LogicalUnitFile( const string pathFichier, const FileType type,
                         const FileAccess access = Old ):
                        _nomFichier( pathFichier ),
                        _type( type ),
                        _access( access ),
                        _logicalUnit( LogicalUnitManager::getLogicalUnit() ),
                        _numOp26( 26 )
        {
            // Comme CommandSyntax n'autorise pas la creation de deux commandes
            // en meme temps, on ruse
            CommandSyntax* pointerSave = commandeCourante;
            commandeCourante = NULL;

            CommandSyntax* syntaxeDefiFichier = new CommandSyntax( "DEFI_FICHIER", false );

            SimpleKeyWordStr mCSAction( "ACTION" );
            mCSAction.addValues( "ASSOCIER" );
            syntaxeDefiFichier->addSimpleKeywordString( mCSAction );

            SimpleKeyWordInt mCSUnite = SimpleKeyWordInt( "UNITE" );
            mCSUnite.addValues( _logicalUnit );
            syntaxeDefiFichier->addSimpleKeywordInteger( mCSUnite );

            SimpleKeyWordStr mCSFichier( "FICHIER" );
            mCSFichier.addValues( _nomFichier );
            syntaxeDefiFichier->addSimpleKeywordString( mCSFichier );

            SimpleKeyWordStr mCSType( "TYPE" );
            mCSType.addValues( string( NameFileType[(int) type] ) );
            syntaxeDefiFichier->addSimpleKeywordString( mCSType );

            SimpleKeyWordStr mCSAcces( "ACCES" );
            mCSAcces.addValues( NameFileAccess[(int) access] );
            syntaxeDefiFichier->addSimpleKeywordString( mCSAcces );

            CALL_OPSEXE( &_numOp26 );

            delete syntaxeDefiFichier;
            commandeCourante = pointerSave;
        };

        /**
        * Destructeur
        *   Ce destructeur se charge d'appeler DEFI_FICHIER et de liberer l'unite logique
        */
        ~LogicalUnitFile()
        {
            LogicalUnitManager::releaseLogicalUnit( _logicalUnit );

            CommandSyntax* pointerSave = commandeCourante;
            commandeCourante = NULL;

            CommandSyntax* syntaxeDefiFichier = new CommandSyntax( "DEFI_FICHIER", false );

            SimpleKeyWordStr mCSAction( "ACTION" );
            mCSAction.addValues( "LIBERER" );
            syntaxeDefiFichier->addSimpleKeywordString( mCSAction );

            SimpleKeyWordInt mCSUnite( "UNITE" );
            mCSUnite.addValues( _logicalUnit );
            syntaxeDefiFichier->addSimpleKeywordInteger( mCSUnite );

            SimpleKeyWordStr mCSFichier( "FICHIER" );
            mCSFichier.addValues( _nomFichier );
            syntaxeDefiFichier->addSimpleKeywordString( mCSFichier );

            CALL_OPSEXE( &_numOp26 );

            delete syntaxeDefiFichier;
            commandeCourante = pointerSave;
        };

        /**
        * Fonction membre getLogicalUnit
        * @return le numero d'unite logique retenu
        */
        int getLogicalUnit() const
        {
            return _logicalUnit;
        };
};

#endif /* LOGICALUNITMANAGER_H_ */
