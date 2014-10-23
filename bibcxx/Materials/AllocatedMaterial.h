#ifndef ALLOCATEDMATERIAL_H_
#define ALLOCATEDMATERIAL_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataStructure/DataStructure.h"
#include "Modelisations/Model.h"
#include "Materials/Material.h"
#include "DataFields/PCFieldOnMesh.h"

/**
* class AllocatedMaterialInstance
*   produit une sd identique a celle produite par AFFE_MATERIAU
* @author Nicolas Sellenet
*/
class AllocatedMaterialInstance: public DataStructure
{
    private:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        typedef list< pair< Material, MeshEntityPtr > > listOfMatsAndGrps;
        typedef listOfMatsAndGrps::value_type listOfMatsAndGrpsValue;
        typedef listOfMatsAndGrps::iterator listOfMatsAndGrpsIter;

        // Carte '.CHAMP_MAT'
        PCFieldOnMeshChar8     _listOfMaterials;
        // Carte '.TEMPE_REF'
        PCFieldOnMeshDouble    _listOfTemperatures;
        // Liste contenant les materiaux ajoutes par l'utilisateur
        listOfMatsAndGrps      _materialsOnMeshEntity;
        // Maillage sur lequel repose la sd_cham_mater
        Mesh                   _supportMesh;

    public:
        /**
        * Constructeur
        */
        AllocatedMaterialInstance();

        /**
        * Ajout d'un materiau sur tout le maillage
        * @param curMater Materiau a ajouter
        */
        void addMaterialOnAllMesh( Material& curMater )
        {
            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMater,
                                                MeshEntityPtr( new AllMeshEntitiesInstance() ) ) );
        };

        /**
        * Ajout d'un materiau sur une entite du maillage
        * @param curMater Materiau a ajouter
        * @param nameOfGroup Nom du groupe de mailles
        */
        void addMaterialOnGroupOfElements( Material& curMater, string nameOfGroup )
        {
            if ( _supportMesh.isEmpty() ) throw "Support mesh is not defined";
            if ( ! _supportMesh->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            _materialsOnMeshEntity.push_back( listOfMatsAndGrpsValue( curMater,
                                                MeshEntityPtr( new GroupOfElementsInstance(nameOfGroup) ) ) );
        };

        /**
        * Construction (au sens Jeveux fortran) de la sd_cham_mater
        * @return booleen indiquant que la construction s'est bien deroulee
        */
        bool build();

        /**
        * Definition du maillage support
        * @param currentMesh objet Mesh sur lequel le modele reposera
        */
        bool setSupportMesh(Mesh& currentMesh)
        {
            if ( currentMesh->isEmpty() )
                throw string("Mesh is empty");
            _supportMesh = currentMesh;
            return true;
        };

        Mesh& getSupportMesh()
        {
            if ( _supportMesh->isEmpty() )
                throw string("support mesh of current model is empty");
            return _supportMesh;
        };
};

/**
* class AllocatedMaterial
*   Enveloppe d'un pointeur intelligent vers un AllocatedMaterialInstance
* @author Nicolas Sellenet
*/
class AllocatedMaterial
{
    public:
        typedef boost::shared_ptr< AllocatedMaterialInstance > AllocatedMaterialPtr;

    private:
        AllocatedMaterialPtr _materAllocPtr;

    public:
        AllocatedMaterial(bool initilisation = true): _materAllocPtr()
        {
            if ( initilisation == true )
                _materAllocPtr = AllocatedMaterialPtr( new AllocatedMaterialInstance() );
        };

        ~AllocatedMaterial()
        {};

        AllocatedMaterial& operator=(const AllocatedMaterial& tmp)
        {
            _materAllocPtr = tmp._materAllocPtr;
            return *this;
        };

        const AllocatedMaterialPtr& operator->() const
        {
            return _materAllocPtr;
        };

        AllocatedMaterialInstance& operator*(void) const
        {
            return *_materAllocPtr;
        };

        bool isEmpty() const
        {
            if ( _materAllocPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* ALLOCATEDMATERIAL_H_ */
