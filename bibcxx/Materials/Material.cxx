
/* person_in_charge: nicolas.sellenet at edf.fr */

#include "Materials/Material.h"

MaterialInstance::MaterialInstance(): _jeveuxName( initAster->getNewResultObjectName() ),
                    _materialBehaviourNames( JeveuxVectorChar32( _jeveuxName + ".MATERIAU.NOMRC " ) ),
                    _nbMaterialBehaviour( 0 )
{};

bool MaterialInstance::build()
{
    // Recuperation du nombre de GeneralMaterialBehaviour ajoutes par l'utilisateur
    const int nbMCF = _vecMatBehaviour.size();
    // Creation du vecteur Jeveux ".MATERIAU.NOMRC"
    _materialBehaviourNames->allocate( "G", nbMCF );
    int num = 0;
    // Boucle sur les GeneralMaterialBehaviour
    for ( vector< GeneralMaterialBehaviour >::iterator curIter = _vecMatBehaviour.begin();
          curIter != _vecMatBehaviour.end();
          ++curIter )
    {
        // Recuperation du nom Aster (ELAS, ELAS_FO, ...) du GeneralMaterialBehaviour
        // sur lequel on travaille
        string curStr( (*curIter)->getAsterName().c_str() );
        curStr.resize( 32, ' ' );
        // Recopie dans le ".MATERIAU.NOMRC"
        CopyCStrToFStr( (*_materialBehaviourNames)[num], const_cast< char* > (curStr.c_str()), 32 );
        ++num;

        // Construction des objets Jeveux .CPT.XXXXXX.VALR, .CPT.XXXXXX.VALK, ...
        const bool retour = (*curIter)->build();
        if ( !retour ) return false;
    }
    return true;
};
