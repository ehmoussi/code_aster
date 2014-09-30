
#include "MaterialBehaviour.h"

bool GeneralMaterialBehaviourInstance::build()
{
    const int nbOfMaterialProperties = _listOfNameOfMaterialProperties.size();
    _complexValues->allocate( "G", nbOfMaterialProperties );
    _doubleValues->allocate( "G", nbOfMaterialProperties );
    _char16Values->allocate( "G", 2*nbOfMaterialProperties );

    int position = 0;
    for ( list< string >::iterator curIter = _listOfNameOfMaterialProperties.begin();
          curIter != _listOfNameOfMaterialProperties.end();
          ++curIter )
    {
        mapStrEMPDIterator curIter2 = _mapOfDoubleMaterialProperties.find(*curIter);
        mapStrEMPCIterator curIter3 = _mapOfComplexMaterialProperties.find(*curIter);
        if ( curIter2 != _mapOfDoubleMaterialProperties.end() )
        {
            (*_doubleValues)[position] = (*curIter2).second.getValue();

            string nameOfProperty = (*curIter2).second.getName();
            nameOfProperty.resize( 16, ' ' );
            CopyCStrToFStr( (*_char16Values)[position], const_cast< char* > (nameOfProperty.c_str()), 16 );
        }
        else if ( curIter3 != _mapOfComplexMaterialProperties.end() )
        {
            throw "Pas encore implemente";
        }
        else
            throw "Le parametre materiau doit etre un double ou un complexe";
        ++position;
    }

    return true;
};