
#include "AsterMesh.hpp"

#define CALL_OP0001() CALL0(OP0001, op0001)
extern "C"
{
    void DEF0(OP0001, op0001);
}

AsterMeshInstance::AsterMeshInstance(): _jeveuxName( initAster->getNewResultObjectName() ),
                        _dimensionInformations( JeveuxVectorLong( string(_jeveuxName + ".DIME      ") ) ),
                        _nameOfNodes( JeveuxBidirectionalMap( string(_jeveuxName + ".NOMNOE    ") ) ),
                        _coordinates( FieldOnNodesDouble( string(_jeveuxName + ".COORDO    ") ) ),
                        _groupsOfNodes( JeveuxCollectionLong( string(_jeveuxName + ".GROUPENO  ") ) ),
                        _connectivity( JeveuxCollectionLong( string(_jeveuxName + ".CONNEX    ") ) ),
                        _nameOfElements( JeveuxBidirectionalMap( string(_jeveuxName + ".NOMMAI    ") ) ),
                        _elementsType( JeveuxVectorLong( string(_jeveuxName + ".TYPMAIL   ") ) ),
                        _groupsOfElements( JeveuxCollectionLong( string(_jeveuxName + ".GROUPEMA  ") ) ),
                        _isEmpty( true )
{
    assert(_jeveuxName.size() == 8);
};

bool AsterMeshInstance::readMEDFile(char* pathFichier)
{
    CommandSyntax syntaxeLireMaillage("LIRE_MAILLAGE", true, initAster->getResultObjectName());
    commandeCourante = &syntaxeLireMaillage;

    SimpleKeyWordStr mCSFormat = SimpleKeyWordStr("FORMAT");
    mCSFormat.addValues("MED");
    syntaxeLireMaillage.addSimpleKeywordStr(mCSFormat);

    SimpleKeyWordStr mCSPath = SimpleKeyWordStr("PATHFICHIER");
    mCSPath.addValues(pathFichier);
    syntaxeLireMaillage.addSimpleKeywordStr(mCSPath);

    CALL_OP0001();
    commandeCourante = NULL;
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _dimensionInformations->updateValuePointer();
    _coordinates->updateValuePointers();
    _groupsOfNodes->buildFromJeveux();
    _connectivity->buildFromJeveux();
    _elementsType->updateValuePointer();
    _groupsOfElements->buildFromJeveux();
    _isEmpty = false;
    /*cout << _nameOfNodes.findStringOfElement(1) << endl;
    cout << _nameOfNodes.findIntegerOfElement("N1") << endl;*/
    return true;
};
