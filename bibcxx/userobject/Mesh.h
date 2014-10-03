#ifndef MESH_H_
#define MESH_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "definition.h"
#include "command/Initializer.h"
#include "baseobject/JeveuxCollection.h"
#include "baseobject/JeveuxBidirectionalMap.h"
#include "userobject/FieldOnNodes.h"
#include <assert.h>

/**
* class MeshEntity
*   Cette classe permet de definir des entites de maillage :
*   groupe de mailles ou groupe de noeuds
* @author Nicolas Sellenet
*/
class MeshEntity
{
    private:
        // Nom de l'entite
        const string            _name;
        // Collection .GROUPEMA ou .GROUPENO
        JeveuxCollectionLong    _groupsOfEntities;

    public:
        /**
        * Constructeur
        * @param name nom de l'entite
        * @param grpOfEntities Collection Jeveux contenant les "entites"
        */
        MeshEntity(string name, JeveuxCollectionLong& grpOfEntities): _name(name),
                                                                      _groupsOfEntities(grpOfEntities)
        {
            if ( ! _groupsOfEntities->existsObject(name) )
                throw string("Group " + name + " not in mesh");
        };

        /**
        * Obtenir le nom de l'entite
        * @return renvoit le nom de l'entite
        */
        const string& getEntityName()
        {
            return _name;
        };
};

/**
* class GroupOfNodes
*   Cette classe permet de definir des groupes de noeuds
* @author Nicolas Sellenet
*/
class GroupOfNodes: MeshEntity
{
    public:
        /**
        * Constructeur
        * @param name nom de l'entite
        * @param grpOfEntities Collection Jeveux contenant les "entites"
        */
        GroupOfNodes(string name, JeveuxCollectionLong& grpOfNodes):
            MeshEntity(name, grpOfNodes)
        {};
};

/**
* class GroupOfElements
*   Cette classe permet de definir des groupes de mailles
* @author Nicolas Sellenet
*/
class GroupOfElements: MeshEntity
{
    public:
        /**
        * Constructeur
        * @param name nom de l'entite
        * @param grpOfEntities Collection Jeveux contenant les "entites"
        */
        GroupOfElements(string name, JeveuxCollectionLong& grpOfElements):
            MeshEntity(name, grpOfElements)
        {};
};

class MeshInstance
{
    private:
        friend class MeshEntity;
        // Nom Jeveux du maillage
        const string           _jeveuxName;
        // Objet Jeveux '.DIME'
        JeveuxVectorLong       _dimensionInformations;
        // Pointeur de nom Jeveux '.NOMNOE'
        JeveuxBidirectionalMap _nameOfNodes;
        // Champ aux noeuds '.COORDO'
        FieldOnNodesDouble     _coordinates;
        // Collection Jeveux '.GROUPENO'
        JeveuxCollectionLong   _groupsOfNodes;
        // Collection Jeveux '.CONNEX'
        JeveuxCollectionLong   _connectivity;
        // Pointeur de nom Jeveux '.NOMMAIL'
        JeveuxBidirectionalMap _nameOfElements;
        // Objet Jeveux '.TYPMAIL'
        JeveuxVectorLong       _elementsType;
        // Objet Jeveux '.GROUPEMA'
        JeveuxCollectionLong   _groupsOfElements;
        // Booleen indiquant si le maillage est vide
        bool                   _isEmpty;

    public:
        /**
        * Constructeur
        */
        MeshInstance();

        /**
        * Destructeur
        */
        ~MeshInstance()
        {};

        /**
        * Recuperation du nom Jeveux
        * @return le nom Jeveux du maillage
        */
        const string& getJeveuxName() const
        {
            return _jeveuxName;
        };

        /**
        * Recuperation des coordonnees du maillage
        * @return champ aux noeuds contenant les coordonnees des noeuds du maillage
        */
        const FieldOnNodesDouble &getCoordinates() const
        {
            return _coordinates;
        };

        /**
        * Recuperation d'un groupe de mailles
        * @return class GroupOfElements
        */
        const GroupOfElements getGroupOfElements(string name)
        {
            return GroupOfElements(name, this->_groupsOfElements);
        };

        /**
        * Recuperation d'un groupe de noeuds
        * @return class GroupOfNodes
        */
        const GroupOfNodes getGroupOfNodes(string name)
        {
            return GroupOfNodes(name, this->_groupsOfNodes);
        };

        /**
        * Fonction permettant de savoir si un maillage est vide (non relu par exemple)
        * @return retourne true si le maillage est vide
        */
        bool isEmpty() const
        {
            return _isEmpty;
        };

        /**
        * Fonction permettant de relire un fichier MED
        * @param pathFichier path contenant le fichier fort.1 correspondant au fichier MED
        * @return retourne true si le maillage a correctement ete relu
        */
        bool readMEDFile(char* pathFichier);
};

/**
* class Mesh
*   Enveloppe d'un pointeur intelligent vers un MeshInstance
* @author Nicolas Sellenet
*/
class Mesh
{
    public:
        typedef boost::shared_ptr< MeshInstance > MeshPtr;

    private:
        MeshPtr _meshPtr;

    public:
        Mesh(bool initilisation = true): _meshPtr()
        {
            if ( initilisation == true )
                _meshPtr = MeshPtr( new MeshInstance() );
        };

        ~Mesh()
        {};

        Mesh& operator=(const Mesh& tmp)
        {
            _meshPtr = tmp._meshPtr;
            return *this;
        };

        const MeshPtr& operator->() const
        {
            return _meshPtr;
        };

        bool isEmpty() const
        {
            if ( _meshPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MESH_H_ */
