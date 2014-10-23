
#include "DataStructure/DataStructure.h"
#include "Debug/DebugPrint.h"

mapStrSD* mapNameDataStructure = new mapStrSD();

DataStructure::DataStructure(string name, string type): _name( name ), _type( type )
{
    cout << "Ctor DataStructure " << _name << endl;
    mapNameDataStructure->insert( mapStrSDValue( _name, this ) );
};

DataStructure::~DataStructure()
{
    cout << "Dtor DataStructure " << _name << endl;
    mapStrSDIterator curIter = mapNameDataStructure->find( _name );
    if ( curIter == mapNameDataStructure->end() )
        throw "Problem !!!";
    mapNameDataStructure->erase( curIter );
};

void DataStructure::debugPrint(int logicalUnit) const
{
    jeveuxDebugPrint( *this, logicalUnit );
};
