#ifndef INIT_H_
#define INIT_H_

#include <stdio.h>
#include <string.h>
#include <assert.h>

#include "command/CommandSyntax.h"

#include "definition.h"

/* jeveux_status vaut :
      0 avant aster_init,
      1 pendant l'exécution,
      0 après xfini
   Cela permet de verrouiller l'appel à des fonctions jeveux hors de l'exécution
*/
extern int jeveux_status;

extern FILE* fileOut;

#ifdef __cplusplus

#include <boost/shared_ptr.hpp>

#define DEFSBSP(UN,LN,a,la,b,c,lb)               STDCALL(UN,LN)(a,la,b,c,lb)
#define CALLSBSP(UN,LN,a,b,c)                    F_FUNC(UN,LN)(a,strlen(a),b,c,strlen(b))

#define DEFSBSS(UN,LN,a,la,b,c,lb,lc)               STDCALL(UN,LN)(a,la,b,c,lb,lc)
#define CALLSBSS(UN,LN,a,b,c)                    F_FUNC(UN,LN)(a,strlen(a),b,c,strlen(b),strlen(c))

#define CALL_IBMAIN(a) CALLP(IBMAIN,ibmain,a)
#define CALL_DEBUT() CALL0(DEBUT,debut)
#define CALL_JELIRA(a, b, c, d)  CALLSSPS(JELIRA, jelira, a, b, c, d)
#define CALL_JEVEUOC(a, b, c) CALLSSP(JEVEUOC, jeveuoc, a, b, c)
#define CALL_JEEXIN(a, b) CALLSP(JEEXIN, jeexin, a, b)
#define CALL_JEXNUM(a, b, c) CALLSBSP(JEXNUM, jexnum, a, b, c)
#define CALL_JEXNOM(a, b, c) CALLSBSS(JEXNOM, jexnom, a, b, c)
#define CALL_JENUNO(a, b) CALLSS(JENUNO, jenuno, a, b)
#define CALL_JENONU(a, b) CALLSP(JENONU, jenonu, a, b)
extern "C"
{
    void DEFP(IBMAIN,ibmain, INTEGER*);
    void DEF0(DEBUT,debut);
    void DEFSSPS(JELIRA, jelira, const char*, STRING_SIZE, char*, STRING_SIZE, INTEGER*,
                 char*, STRING_SIZE );
    void DEFSSP(JEVEUOC, jeveuoc, const char *, STRING_SIZE, const char *, STRING_SIZE, void*);
    void DEFSP(JEEXIN, jeexin, const char *, STRING_SIZE, INTEGER*);
    // Attention, dans le cas d'appel de fonction la longueur de la chaine IN se retrouve a la fin...
    void DEFSBSP(JEXNUM, jexnum, char *, STRING_SIZE, const char *, INTEGER*, STRING_SIZE);
    void DEFSBSS(JEXNOM, jexnom, char *, STRING_SIZE, const char *, const char *, STRING_SIZE, STRING_SIZE);
    void DEFSS(JENUNO, jenuno, const char *, STRING_SIZE, char *, STRING_SIZE);
    void DEFSP(JENONU, jenonu, const char *, STRING_SIZE, INTEGER*);
    char* MakeBlankFStr( STRING_SIZE );
    void FreeStr( char * );
}

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

        CommandSyntax syntaxeDebut;
        unsigned long int _numberOfAsterObjects;
        // Maximum 16^8 Aster sd because of the base name of a sd aster (8 characters)
        // and because the hexadecimal system is used to give a name to a given sd
        static const unsigned long int _maxNumberOfAsterObjects = 4294967295;

    public:
        Initializer();

        ~Initializer()
        {
            cout << "~Initializer";
        }

        string getNewResultObjectName()
        {
            ostringstream oss;
            ++_numberOfAsterObjects;
            assert( _numberOfAsterObjects <= _maxNumberOfAsterObjects );
            oss << hex << _numberOfAsterObjects;
            return string(oss.str() + "        ", 0, 8);
        };

        string getResultObjectName()
        {
            ostringstream oss;
            oss << hex << _numberOfAsterObjects;
            return string(oss.str() + "        ", 0, 8);
        };

        int getIntLDC(char* chaineQuestion);

        double getDoubleLDC(char* chaineQuestion);

        char* getChaineLDC(char* chaineQuestion);

        void initForCataBuilder();

        void run();
};

extern Initializer* initAster;

#else

extern void* initAster;

#endif

#ifdef __cplusplus
extern "C" {
#endif

void init(int);

void initForCataBuilder();

int getIntLDC(char*);

double getDoubleLDC(char*);

char* getChaineLDC(char*);

/* defined in python.c, should be in a 'python.h' */
void initAsterModules();

#ifdef __cplusplus
}
#endif

#endif /* INIT_H_ */
