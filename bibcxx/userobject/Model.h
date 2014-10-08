#ifndef MODEL_H_
#define MODEL_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "userobject/Mesh.h"
#include "userobject/ElementaryModelisation.h"
#include <map>

/**
* class ModelInstance
*   produit une sd identique a celle produite par AFFE_MODELE
* @author Nicolas Sellenet
*/
class ModelInstance
{
    private:
        typedef list< pair< ElementaryModelisation, string > > listOfModsAndGrps;

        // Nom Jeveux de la sd produite
        const string      _jeveuxName;
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
        void addElementaryModelisation( Physics phys, Modelisations mod )
        {
            _modelisations.push_back( listOfModsAndGrps::value_type( ElementaryModelisation(phys, mod),
                                                                     "TOUT" ) );
        };

        /**
        * Ajout d'une nouvelle modelisation sur une entite du maillage
        * @param phys Physique a ajouter
        * @param mod Modelisation a ajouter
        * @param MeshEntity Entite du maillage a affecter
        */
        void addElementaryModelisation( Physics phys, Modelisations mod, MeshEntity& entity)
        {
            _modelisations.push_back( listOfModsAndGrps::value_type( ElementaryModelisation(phys, mod),
                                                                     entity.getEntityName() ) );
        };

        /**
        * Construction (au sens Jeveux fortran) de la sd_modele
        * @return booleen indiquant que la construction s'est bien deroulee
        */
        bool build();

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
