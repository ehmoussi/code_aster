#ifndef RESULTSCONTAINER_H_
#define RESULTSCONTAINER_H_

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "MemoryManager/JeveuxCollection.h"
#include "MemoryManager/JeveuxBidirectionalMap.h"

/**
* class ResultsContainerInstance
*   Cette classe correspond a la sd_resultat de Code_Aster
*   Elle permet de stocker les champs issus d'une resolution numerique
* @author Nicolas Sellenet
*/
class ResultsContainerInstance: public DataStructure
{
    private:
        JeveuxBidirectionalMap _symbolicNamesOfFields;
        JeveuxCollectionChar24 _namesOfFields;
        JeveuxBidirectionalMap _accessVariables;
        JeveuxCollectionChar8  _calculationParameter;
        JeveuxVectorLong       _serialNumber;

    public:
        /**
        * Constructeur
        */
        ResultsContainerInstance(): DataStructure( initAster->getNewResultObjectName(), "???" ),
                            _symbolicNamesOfFields( JeveuxBidirectionalMap( getName() + "           .DESC" ) ),
                            _namesOfFields( JeveuxCollectionChar24( getName() + "           .TACH" ) ),
                            _accessVariables( JeveuxBidirectionalMap( getName() + "           .NOVA" ) ),
                            _calculationParameter( JeveuxCollectionChar8( getName() + "           .TAVA" ) ),
                            _serialNumber( JeveuxVectorLong( getName() + "           .ORDR" ) )
        {};
};

/**
* class ResultsContainer
*   Enveloppe d'un pointeur intelligent vers un ResultsContainerInstance
* @author Nicolas Sellenet
*/
class ResultsContainer
{
    public:
        typedef boost::shared_ptr< ResultsContainerInstance > ResultsContainerPtr;

    private:
        ResultsContainerPtr _meshPtr;

    public:
        ResultsContainer(bool initilisation = true): _meshPtr()
        {
            if ( initilisation == true )
                _meshPtr = ResultsContainerPtr( new ResultsContainerInstance() );
        };

        ~ResultsContainer()
        {};

        ResultsContainer& operator=(const ResultsContainer& tmp)
        {
            _meshPtr = tmp._meshPtr;
            return *this;
        };

        const ResultsContainerPtr& operator->() const
        {
            return _meshPtr;
        };

        bool isEmpty() const
        {
            if ( _meshPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* RESULTSCONTAINER_H_ */
