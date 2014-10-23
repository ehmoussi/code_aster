#ifndef DATASTRUCTURE_H_
#define DATASTRUCTURE_H_

#include <string>
#include <map>
#include <iostream>

using namespace std;

/* person_in_charge: nicolas.sellenet at edf.fr */

class DataStructure
{
    private:
        const string _name;
        const string _type;

    public:
        DataStructure(string name, string type);

        ~DataStructure();

        const string& getName() const
        {
            return _name;
        };

        const string& getType() const
        {
            return _type;
        };

        void debugPrint(const int logicalUnit) const;
};

typedef map< string, DataStructure* > mapStrSD;
typedef mapStrSD::iterator mapStrSDIterator;
typedef mapStrSD::value_type mapStrSDValue;

extern mapStrSD* mapNameDataStructure;

#endif /* DATASTRUCTURE_H_ */
