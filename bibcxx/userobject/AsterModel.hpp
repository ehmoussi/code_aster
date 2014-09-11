#ifndef ASTERMODEL_HPP_
#define ASTERMODEL_HPP_

#include "userobject/AsterMesh.hpp"
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

class AsterModelInstance
{
    private:
        typedef list< pair< AsterElementaryModel, string > > listOfModsAndGrps;

        const string      _jeveuxName;
        JeveuxVectorLong  _typeOfElements;
        JeveuxVectorLong  _typeOfNodes;
        JeveuxVectorChar8 _partition;
        listOfModsAndGrps _modelisations;
        AsterMesh         _supportMesh;

    public:
        AsterModelInstance();

        void addModelisation(string physics, string modelisation)
        {
            _modelisations.push_back( listOfModsAndGrps::value_type(AsterElementaryModel(physics,
                                                                                         modelisation),
                                                                    "TOUT") );
        };

        void addModelisation(string physics, string modelisation, AsterMeshEntity& entity)
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

        bool setSupportMesh(AsterMesh& currentMesh)
        {
            if ( currentMesh->isEmpty() )
                throw string("Mesh is empty");
            _supportMesh = currentMesh;
            return true;
        };
};

class AsterModel
{
    public:
        typedef boost::shared_ptr< AsterModelInstance > AsterModelPtr;

    private:
        AsterModelPtr _asterModelPtr;

    public:
        AsterModel(bool initilisation = true): _asterModelPtr()
        {
            if ( initilisation == true )
                _asterModelPtr = AsterModelPtr( new AsterModelInstance() );
        };

        ~AsterModel()
        {};

        AsterModel& operator=(const AsterModel& tmp)
        {
            _asterModelPtr = tmp._asterModelPtr;
        };

        const AsterModelPtr& operator->() const
        {
            return _asterModelPtr;
        };

        bool isEmpty() const
        {
            if ( _asterModelPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* ASTERMODEL_HPP_ */
