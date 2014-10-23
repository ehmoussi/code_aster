#ifndef MODEL_H_
#define MODEL_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataStructure/DataStructure.h"
#include "Mesh/Mesh.h"
#include "Modelisations/ElementaryModelisation.h"
#include <map>

#include "Loads/PhysicalQuantity.h"

/**
* class ModelInstance
*   produit une sd identique a celle produite par AFFE_MODELE
* @author Nicolas Sellenet
*/
class ModelInstance: public DataStructure
{
    private:
        // On redefinit le type MeshEntityPtr afin de pouvoir stocker les MeshEntity
        // dans la list
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        typedef list< pair< ElementaryModelisation, MeshEntityPtr > > listOfModsAndGrps;
        typedef listOfModsAndGrps::value_type listOfModsAndGrpsValue;
        typedef listOfModsAndGrps::iterator listOfModsAndGrpsIter;

        // Vecteur Jeveux '.MAILLE'
        JeveuxVectorLong  _typeOfElements;
        // Vecteur Jeveux '.NOEUD'
        JeveuxVectorLong  _typeOfNodes;
        // Vecteur Jeveux '.PARTIT'
        JeveuxVectorChar8 _partition;
        // Liste contenant les modelisations ajoutees par l'utilisateur
        listOfModsAndGrps _modelisations;
        // Maillage sur lequel repose la modelisation
        Mesh              _supportMesh;
        bool              _isEmpty;

    public:
        /**
        * Constructeur
        */
        ModelInstance();

        /**
        * Ajout d'une nouvelle modelisation sur tout le maillage
        * @param phys Physique a ajouter
        * @param mod Modelisation a ajouter
        */
        void addModelisationOnAllMesh( Physics phys, Modelisations mod )
        {
            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModelisation(phys, mod),
                                                              MeshEntityPtr( new AllMeshEntitiesInstance() ) ) );
        };

        /**
        * Ajout d'une nouvelle modelisation sur une entite du maillage
        * @param phys Physique a ajouter
        * @param mod Modelisation a ajouter
        * @param nameOfGroup Nom du groupe de mailles
        */
        void addModelisationOnGroupOfElements( Physics phys, Modelisations mod, string nameOfGroup )
        {
            if ( _supportMesh.isEmpty() ) throw "Support mesh is not defined";
            if ( ! _supportMesh->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModelisation(phys, mod),
                                            MeshEntityPtr( new GroupOfElementsInstance(nameOfGroup) ) ) );
        };

        /**
        * Ajout d'une nouvelle modelisation sur une entite du maillage
        * @param phys Physique a ajouter
        * @param mod Modelisation a ajouter
        * @param nameOfGroup Nom du groupe de noeuds
        */
        void addModelisationOnGroupOfNodes( Physics phys, Modelisations mod, string nameOfGroup )
        {
            if ( _supportMesh.isEmpty() ) throw "Support mesh is not defined";
            if ( ! _supportMesh->hasGroupOfNodes( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            _modelisations.push_back( listOfModsAndGrpsValue( ElementaryModelisation(phys, mod),
                                            MeshEntityPtr( new GroupOfNodesInstance(nameOfGroup) ) ) );
        };

        /**
        * Construction (au sens Jeveux fortran) de la sd_modele
        * @return booleen indiquant que la construction s'est bien deroulee
        */
        bool build();

        /**
        * Methode permettant de savoir si le modele est vide
        * @return true si le modele est vide
        */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
        * Definition de la methode de partition
        *   pas encore codee
        */
        void setSplittingMethod()
        {
            throw "Not yet implemented";
        };

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
* class Model
*   Enveloppe d'un pointeur intelligent vers un ModelInstance
* @author Nicolas Sellenet
*/
class Model
{
    public:
        typedef boost::shared_ptr< ModelInstance > ModelPtr;

    private:
        ModelPtr _modelPtr;

    public:
        Model(bool initilisation = true): _modelPtr()
        {
            if ( initilisation == true )
                _modelPtr = ModelPtr( new ModelInstance() );
        };

        ~Model()
        {};

        Model& operator=(const Model& tmp)
        {
            _modelPtr = tmp._modelPtr;
            return *this;
        };

        const ModelPtr& operator->() const
        {
            return _modelPtr;
        };

        bool isEmpty() const
        {
            if ( _modelPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MODEL_H_ */
