#ifndef DATASTRUCTURE_H_
#define DATASTRUCTURE_H_

#include <string>
#include <map>
#include <iostream>

using namespace std;

/* person_in_charge: nicolas.sellenet at edf.fr */

/**
* class mere des classes representant de sd_aster
* @author Nicolas Sellenet
*/
class DataStructure
{
    private:
        const string _name;
        string       _type;

    public:
        /**
        * Constructeur
        * @param name Nom Jeveux de la sd
        * @param type Type Aster de la sd
        */
        DataStructure( string name, string type );

        /**
        * Destructeur
        */
        ~DataStructure();

        /**
        * Function membre getName
        * @return renvoit le nom de la sd
        */
        const string& getName() const
        {
            return _name;
        };

        /**
        * Function membre getType
        * @return renvoit le type de la sd
        */
        const string& getType() const
        {
            return _type;
        };

        /**
        * Function membre debugPrint
        *   appel IMPR_CO
        * @param logicalUnit Unite logique d'impression
        */
        void debugPrint( const int logicalUnit ) const;

    protected:
        /**
        * Methode servant a fixer a posteriori le type d'une sd
        *   appel IMPR_CO
        * @param newType chaine contenant le nouveau nom
        */
        void setType( const string newType )
        {
            _type = newType;
        };
};

typedef map< string, DataStructure* > mapStrSD;
typedef mapStrSD::iterator mapStrSDIterator;
typedef mapStrSD::value_type mapStrSDValue;

/**
* map< string, DataStructure* > mapNameDataStructure
*   Ce map contient toutes les DataStructures initialisees
*/
extern mapStrSD mapNameDataStructure;

#endif /* DATASTRUCTURE_H_ */
