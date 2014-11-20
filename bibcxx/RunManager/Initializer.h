#ifndef INITIALIZER_H_
#define INITIALIZER_H_

/**
 * @file Initializer.h
 * @brief Fichier entete de la classe Initializer
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

#include <assert.h>
#include <stdio.h>

#include "RunManager/CommandSyntax.h"

/* jeveux_status vaut :
      0 avant aster_init,
      1 pendant l'exécution,
      0 après xfini
   Cela permet de verrouiller l'appel à des fonctions jeveux hors de l'exécution
*/
extern int jeveux_status;

extern FILE* fileOut;

extern int numOP;

#ifdef __cplusplus

#include <boost/shared_ptr.hpp>

#define DEFSBSP(UN,LN,a,la,b,c,lb)               STDCALL(UN,LN)(a,la,b,c,lb)
#define CALLSBSP(UN,LN,a,b,c)                    F_FUNC(UN,LN)(a,strlen(a),b,c,strlen(b))

#define DEFSBSS(UN,LN,a,la,b,c,lb,lc)               STDCALL(UN,LN)(a,la,b,c,lb,lc)
#define CALLSBSS(UN,LN,a,b,c)                    F_FUNC(UN,LN)(a,strlen(a),b,c,strlen(b),strlen(c))

#define CALL_EXECOP(a) numOP = a; CALL0(EXECOP, execop); numOP = 0;
#define CALL_IBMAIN(a) CALLP(IBMAIN,ibmain,a)
#define CALL_DEBUT() CALL0(DEBUT,debut)
#define CALL_JELIRA(a, b, c, d)  CALLSSPS(JELIRA, jelira, a, b, c, d)
/**
 * @def CALL_JEVEUOC
 * @brief Appel au jeveuo particulier au C++
 */
#define CALL_JEVEUOC(a, b, c) CALLSSP(JEVEUOC, jeveuoc, a, b, c)
/**
 * @def CALL_WKVECTC
 * @brief Appel au wkvect particulier au C++
 */
#define CALL_WKVECTC(a, b, c, d) CALLSSPP(wkvectc, wkvectc, a, b, c, d)
#define CALL_JEEXIN(a, b) CALLSP(JEEXIN, jeexin, a, b)
#define CALL_JEXNUM(a, b, c) CALLSBSP(JEXNUM, jexnum, a, b, c)
#define CALL_JEXNOM(a, b, c) CALLSBSS(JEXNOM, jexnom, a, b, c)
#define CALL_JENUNO(a, b) CALLSS(JENUNO, jenuno, a, b)
#define CALL_JENONU(a, b) CALLSP(JENONU, jenonu, a, b)
#define CALL_JEDETR(a) CALLS(JEDETR, jedetr, a)
extern "C"
{
    void DEF0(EXECOP, execop);
    void DEFP(IBMAIN,ibmain, INTEGER*);
    void DEF0(DEBUT,debut);
    void DEFSSPS(JELIRA, jelira, const char*, STRING_SIZE, char*, STRING_SIZE, INTEGER*,
                 char*, STRING_SIZE );
    void DEFSSP(JEVEUOC, jeveuoc, const char *, STRING_SIZE, const char *, STRING_SIZE, void*);
    void DEFSSPP(WKVECTC, wkvectc, const char *, STRING_SIZE, const char *, STRING_SIZE, INTEGER*, void*);
    void DEFSP(JEEXIN, jeexin, const char *, STRING_SIZE, INTEGER*);
    // Attention, dans le cas d'appel de fonction la longueur de la chaine IN se retrouve a la fin...
    void DEFSBSP(JEXNUM, jexnum, char *, STRING_SIZE, const char *, INTEGER*, STRING_SIZE);
    void DEFSBSS(JEXNOM, jexnom, char *, STRING_SIZE, const char *, const char *, STRING_SIZE, STRING_SIZE);
    void DEFSS(JENUNO, jenuno, const char *, STRING_SIZE, char *, STRING_SIZE);
    void DEFSP(JENONU, jenonu, const char *, STRING_SIZE, INTEGER*);
    void DEFS(JEDETR, jedetr, const char *, STRING_SIZE);
}

/**
 * @class Initializer
 *   Cette classe initialise le gestionnaire memoire de Code_Aster : Jeveux
 *   C'est aussi elle qui attribue les noms Jeveux aux objets crees en python
 *   Elle gere aussi les arguments de la ligne de commande
 * @author Nicolas Sellenet
 */
class Initializer
{
    private:
        typedef map< string, int > mapLDCEntier;
        typedef mapLDCEntier::iterator mapLDCEntierIterator;
        typedef mapLDCEntier::value_type mapLDCEntierValue;
        mapLDCEntier argsLDCEntiers;

        typedef map< string, double > mapLDCDouble;
        typedef mapLDCDouble::iterator mapLDCDoubleIterator;
        typedef mapLDCDouble::value_type mapLDCDoubleValue;
        mapLDCDouble argsLDCDoubles;

        typedef map< string, string > mapLDCString;
        typedef mapLDCString::iterator mapLDCStringIterator;
        typedef mapLDCString::value_type mapLDCStringValue;
        mapLDCString argsLDCStrings;

        unsigned long int _numberOfAsterObjects;
        // Maximum 16^8 Aster sd because of the base name of a sd aster (8 characters)
        // and because the hexadecimal system is used to give a name to a given sd
        static const unsigned long int _maxNumberOfAsterObjects = 4294967295;

    public:
        /**
         * @brief Constructeur
         */
        Initializer();

        /**
         * @brief Destructeur
         */
        ~Initializer()
        {};

        /**
         * @brief Recuperation d'un nouveau nom de concept Jeveux
         *   Au premier appel, la chaine "0       " est renvoyee
         *   Au deuxieme, "1       ", etc.
         * @return Une chaine de caractere contenant le nom
         */
        string getNewResultObjectName()
        {
            ostringstream oss;
            assert( _numberOfAsterObjects <= _maxNumberOfAsterObjects );
            oss << hex << _numberOfAsterObjects;
            ++_numberOfAsterObjects;
            return string(oss.str() + "        ", 0, 8);
        };

        /**
         * @brief Recuperation d'un nom du concept Jeveux en cours de creation
         * @return Une chaine de caractere contenant le nom
         */
        string getResultObjectName()
        {
            ostringstream oss;
            oss << hex << _numberOfAsterObjects - 1;
            return string(oss.str() + "        ", 0, 8);
        };

        /**
         * @brief Recuperation d'un argument entier de la ligne de commande
         * @param chaineQuestion Argument de la ligne de commande demande
         * @return Entier relu
         */
        int getIntLDC(char* chaineQuestion);

        /**
         * @brief Recuperation d'un argument double de la ligne de commande
         * @param chaineQuestion Argument de la ligne de commande demande
         * @return Double relu
         */
        double getDoubleLDC(char* chaineQuestion);

        /**
         * @brief Recuperation d'une chaine de caractere venant de la ligne de commande
         * @param chaineQuestion Argument de la ligne de commande demande
         * @return Chaine
         */
        char* getChaineLDC(char* chaineQuestion);

        /**
         * @brief Fonction permettant de generer les catalogues de Code_Aster
         */
        void initForCataBuilder( CommandSyntax& syntaxeDebut );

        /**
         * @brief Demarrage de Code_Aster
         *        Appel a ibmain et a debut
         */
        void run( int imode );
};

extern Initializer* initAster;

#else

extern void* initAster;

#endif

#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief Fonction permettant de demarrer Code_Aster
 * @param imode permettant de preciser si le code doit generer les catalogues
 * @return Chaine representant le nom Aster de la coordonnee
 */
void asterInitialization(int);

/**
 * @brief Fonction permettant d'arreter Code_Aster
 */
void asterFinalization();

/**
 * @brief Fonction permettant de faire du MAJ_CATA
 */
void initForCataBuilder();

/**
 * @brief Fonction d'interrogation de la ligne de commande pour un entier
 * @param chaineQuestion Mot-cle a relire sur la ligne de commande
 * @return Entier correspondant a l'argument
 */
int getIntLDC( char* );

/**
 * @brief Fonction d'interrogation de la ligne de commande pour un entier
 * @param chaineQuestion Mot-cle a relire sur la ligne de commande
 * @return Flottant correspondant a l'argument
 */
double getDoubleLDC( char* );

/**
 * @brief Fonction d'interrogation de la ligne de commande pour un entier
 * @param chaineQuestion Mot-cle a relire sur la ligne de commande
 * @return Chaine correspondant a l'argument
 */
char* getChaineLDC( char* );

/* defined in python.c, should be in a 'python.h' */
void initAsterModules();

#ifdef __cplusplus
}
#endif

#endif /* INITIALIZER_H_ */
