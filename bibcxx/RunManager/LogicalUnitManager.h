#ifndef LOGICALUNITMANAGER_H_
#define LOGICALUNITMANAGER_H_

/**
 * @file LogicalUnitManager.h
 * @brief Fichier entete de la classe LogicalUnitManager
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

/* person_in_charge: nicolas.sellenet at edf.fr */
#include "astercxx.h"

#include "aster_fort.h"
#include "RunManager/CommandSyntax.h"

const int nbOfLogicalUnit = 81;
/**
 * @var tabOfLogicalUnit
 * @brief Tableau contenant toutes les unites logiques autorisees de 19 a 99
 */
extern const int tabOfLogicalUnit[nbOfLogicalUnit];

/**
 * @enum FileType
 * @brief ASCII, Binary ou Free
 */
enum FileType { ASCII, Binary, Free };
extern const char* const NameFileType[3];

/**
 * @enum FileAccess
 * @brief New, Append ou Old
 */
enum FileAccess { New, Append, Old };
extern const char* const NameFileAccess[3];

/**
 * @class statique LogicalUnitManager
 * @brief  Cette classe permet de gerer les unitees logiques disponibles
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
         * @brief Methode permettant d'obtenir une unite logique libre
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
         * @brief Methode permettant de liberer une unite logique
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
 * @brief Cette classe permet de definir un fichier qui sera associe a une unite logique
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
         * @brief Le constructeur se charge d'appeler DEFI_FICHIER et de reserver l'unite logique
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

            CALL_OPSEXE( (INTEGER*)&_numOp26 );

            delete syntaxeDefiFichier;
            commandeCourante = pointerSave;
        };

        /**
         * @brief Le destructeur se charge d'appeler DEFI_FICHIER et de liberer l'unite logique
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

            CALL_OPSEXE( (INTEGER*)&_numOp26 );

            delete syntaxeDefiFichier;
            commandeCourante = pointerSave;
        };

        /**
         * @brief Fonction membre getLogicalUnit
         * @return le numero d'unite logique retenu
         */
        int getLogicalUnit() const
        {
            return _logicalUnit;
        };
};

#endif /* LOGICALUNITMANAGER_H_ */
