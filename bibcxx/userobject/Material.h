#ifndef MATERIAL_H_
#define MATERIAL_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "userobject/MaterialBehaviour.h"

/**
* class MaterialInstance
*   produit une sd identique a celle produite par DEFI_MATERIAU
* @author Nicolas Sellenet
*/
class MaterialInstance
{
    private:
        // Nom Jeveux de la SD
        const string                       _jeveuxName;
        // Vecteur Jeveux '.MATERIAU.NOMRC'
        JeveuxVectorChar32                 _materialBehaviourNames;
        // Nombre de MaterialBehaviour deja ajoutes
        int                                _nbMaterialBehaviour;
        // Vecteur contenant les GeneralMaterialBehaviour ajoutes par l'utilisateur
        vector< GeneralMaterialBehaviour > _vecMatBehaviour;

    public:
        /**
        * Constructeur
        */
        MaterialInstance();

        /**
        * Ajout d'un GeneralMaterialBehaviour
        * @param curMaterBehav GeneralMaterialBehaviour a ajouter au MaterialInstance
        */
        void addMaterialBehaviour(GeneralMaterialBehaviour& curMaterBehav)
        {
            ++_nbMaterialBehaviour;

            ostringstream numString;
            numString << std::setw( 6 ) << std::setfill( '0' ) << _nbMaterialBehaviour;
            curMaterBehav->setJeveuxObjectNames( _jeveuxName + ".CPT." + numString.str() );

            _vecMatBehaviour.push_back(curMaterBehav);
        };

        /**
        * Construction du MaterialInstance
        *   A partir des GeneralMaterialBehaviour ajoutes par l'utilisateur :
        *   creation de objets Jeveux
        * @return Booleen indiquant que la construction s'est bien deroulee
        */
        bool build();
};

/**
* class Material
*   Enveloppe d'un pointeur intelligent vers un MaterialInstance
* @author Nicolas Sellenet
*/
class Material
{
    public:
        typedef boost::shared_ptr< MaterialInstance > MaterialPtr;

    private:
        MaterialPtr _materialPtr;

    public:
        Material(bool initilisation = true): _materialPtr()
        {
            if ( initilisation == true )
                _materialPtr = MaterialPtr( new MaterialInstance() );
        };

        ~Material()
        {};

        Material& operator=(const Material& tmp)
        {
            _materialPtr = tmp._materialPtr;
            return *this;
        };

        const MaterialPtr& operator->() const
        {
            return _materialPtr;
        };

        bool isEmpty() const
        {
            if ( _materialPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MATERIAL_H_ */
