#ifndef MESHENTITES_H_
#define MESHENTITES_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "definition.h"
#include "MemoryManager/JeveuxCollection.h"

/**
* class VirtualMeshEntityInstance
*   Cette classe permet de definir des entites de maillage :
*   groupe de mailles ou groupe de noeuds
* @author Nicolas Sellenet
*/
class VirtualMeshEntity
{
    private:
        // Nom de l'entite
        const string            _name;

    public:
        /**
        * Constructeur
        * @param name nom de l'entite
        */
        VirtualMeshEntity(string name): _name(name)
        {};

        /**
        * Obtenir le nom de l'entite
        * @return renvoit le nom de l'entite
        */
        const string& getEntityName()
        {
            return _name;
        };

        virtual string getType() = 0;
};

/**
* class GroupOfNodesInstanceInstance
*   Cette classe permet de definir des groupes de noeuds
* @author Nicolas Sellenet
*/
class GroupOfNodesInstance: public VirtualMeshEntity
{
    public:
        /**
        * Constructeur
        * @param name nom de l'entite
        */
        GroupOfNodesInstance(string name): VirtualMeshEntity(name)
        {};

        string getType()
        {
            return "GroupOfNodesInstance";
        }
};

/**
* class GroupOfElementsInstance
*   Cette classe permet de definir des groupes de mailles
* @author Nicolas Sellenet
*/
class GroupOfElementsInstance: public VirtualMeshEntity
{
    public:
        /**
        * Constructeur
        * @param name nom de l'entite
        */
        GroupOfElementsInstance(string name): VirtualMeshEntity(name)
        {};

        string getType()
        {
            return "GroupOfElementsInstance";
        }
};

/**
* class AllMeshEntitiesInstance
*   Cette classe permet de definir toutes les entites du maillage
*   Equivalent du mot cle simple TOUT = 'OUI'
* @author Nicolas Sellenet
*/
class AllMeshEntitiesInstance: public VirtualMeshEntity
{
    public:
        /**
        * Constructeur
        * @param name nom de l'entite
        */
        AllMeshEntitiesInstance(): VirtualMeshEntity( "TOUT" )
        {};

        string getType()
        {
            return "AllMeshEntitiesInstance";
        }
};

/**
* class template WrapperMeshEntity
*   Enveloppe d'un pointeur intelligent vers un MeshEntityInstance
* @author Nicolas Sellenet
*/
template< class MeshEntityInstance >
class WrapperMeshEntity
{
    public:
        typedef boost::shared_ptr< MeshEntityInstance > MeshEntityPtr;

    private:
        MeshEntityPtr _meshEntityPtr;

    public:
        WrapperMeshEntity(bool initialisation = true): _meshEntityPtr()
        {
            if ( initialisation == true )
                _meshEntityPtr = MeshEntityPtr( new MeshEntityInstance() );
        };

        WrapperMeshEntity(string name, JeveuxCollectionLong& grpOfEntities,
                          bool initialisation = true): _meshEntityPtr()
        {
            if ( initialisation == true )
                _meshEntityPtr = MeshEntityPtr( new MeshEntityInstance(name, grpOfEntities) );
        };

        WrapperMeshEntity(string name, bool initialisation = true): _meshEntityPtr()
        {
            if ( initialisation == true )
                _meshEntityPtr = MeshEntityPtr( new MeshEntityInstance(name) );
        };

        ~WrapperMeshEntity()
        {};

        const MeshEntityPtr& getPointer() const
        {
            return _meshEntityPtr;
        };

        WrapperMeshEntity& operator=(const WrapperMeshEntity& tmp)
        {
            _meshEntityPtr = tmp._meshEntityPtr;
            return *this;
        };

        const MeshEntityPtr& operator->() const
        {
            return _meshEntityPtr;
        };

        MeshEntityInstance& operator*(void) const
        {
            return *_meshEntityPtr;
        };

        bool isEmpty() const
        {
            if ( _meshEntityPtr.use_count() == 0 ) return true;
            return false;
        };
};

typedef class WrapperMeshEntity< VirtualMeshEntity > MeshEntity;
typedef class WrapperMeshEntity< GroupOfNodesInstance > GroupOfNodes;
typedef class WrapperMeshEntity< GroupOfElementsInstance > GroupOfElements;
typedef class WrapperMeshEntity< AllMeshEntitiesInstance > AllMeshEntities;

#endif /* MESHENTITES_H_ */
