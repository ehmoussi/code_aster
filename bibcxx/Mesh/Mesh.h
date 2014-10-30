#ifndef MESH_H_
#define MESH_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "definition.h"
#include "DataStructure/DataStructure.h"
#include "RunManager/Initializer.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"
#include "DataFields/FieldOnNodes.h"
#include "Mesh/MeshEntities.h"
#include <assert.h>

class MeshInstance: public DataStructure
{
    private:
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
        * Recuperation des coordonnees du maillage
        * @return champ aux noeuds contenant les coordonnees des noeuds du maillage
        */
        const FieldOnNodesDouble getCoordinates() const
        {
            return _coordinates;
        };

        /**
        * Teste l'existence d'un groupe de mailles dans le maillage
        * @return true si le groupe existe 
        */
        bool hasGroupOfElements( string name ) const
        {
            return _groupsOfElements->existsObject(name) ;
        };

        /**
        * Teste l'existence d'un groupe de noeuds dans le maillage
        * @return true si le groupe existe 
        */
        bool hasGroupOfNodes( string name ) const
        {
            return _groupsOfNodes->existsObject(name) ;
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
        bool readMEDFile( string pathFichier );
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
        Mesh(bool initialisation = true): _meshPtr()
        {
            if ( initialisation == true )
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

        MeshInstance& operator*(void) const
        {
            return *_meshPtr;
        };

        bool isEmpty() const
        {
            if ( _meshPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MESH_H_ */
