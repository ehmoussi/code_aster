#ifndef MESH_H_
#define MESH_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "definition.h"
#include "RunManager/Initializer.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"
#include "DataFields/FieldOnNodes.h"
#include "Mesh/MeshEntities.h"
#include <assert.h>

class MeshInstance
{
    private:
        friend class VirtualMeshEntity;
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
        {
            cout << "~MeshInstance" << endl;
        };

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
        const FieldOnNodesDouble getCoordinates() const
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
