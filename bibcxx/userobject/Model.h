#ifndef MODEL_H_
#define MODEL_H_

#include "userobject/Mesh.h"
#include <map>

class AsterElementaryModel
{
    private:
        string _physics;
        string _modelisation;

    public:
        AsterElementaryModel(string physics, string modelisation): _physics(physics),
                                                                   _modelisation(modelisation)
        {};

        const string& modelisation()
        {
            return _modelisation;
        };

        const string& physics()
        {
            return _physics;
        };
};

class ModelInstance
{
    private:
        typedef list< pair< AsterElementaryModel, string > > listOfModsAndGrps;

        const string      _jeveuxName;
        JeveuxVectorLong  _typeOfElements;
        JeveuxVectorLong  _typeOfNodes;
        JeveuxVectorChar8 _partition;
        listOfModsAndGrps _modelisations;
        Mesh         _supportMesh;

    public:
        ModelInstance();

        void addModelisation(string physics, string modelisation)
        {
            _modelisations.push_back( listOfModsAndGrps::value_type(AsterElementaryModel(physics,
                                                                                         modelisation),
                                                                    "TOUT") );
        };

        void addModelisation(string physics, string modelisation, MeshEntity& entity)
        {
            _modelisations.push_back( listOfModsAndGrps::value_type(AsterElementaryModel(physics,
                                                                                         modelisation),
                                                                    entity.getEntityName()) );
        };

        bool build();

        void setSplittingMethod()
        {
            throw "Not yet implemented";
        };

        bool setSupportMesh(Mesh& currentMesh)
        {
            if ( currentMesh->isEmpty() )
                throw string("Mesh is empty");
            _supportMesh = currentMesh;
            return true;
        };
};

class Model
{
    public:
        typedef boost::shared_ptr< ModelInstance > ModelPtr;

    private:
        ModelPtr _ModelPtr;

    public:
        Model(bool initilisation = true): _ModelPtr()
        {
            if ( initilisation == true )
                _ModelPtr = ModelPtr( new ModelInstance() );
        };

        ~Model()
        {};

        Model& operator=(const Model& tmp)
        {
            _ModelPtr = tmp._ModelPtr;
        };

        const ModelPtr& operator->() const
        {
            return _ModelPtr;
        };

        bool isEmpty() const
        {
            if ( _ModelPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* MODEL_H_ */
