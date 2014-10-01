
#include "userobject/Mesh.h"

#define CALL_OP0001() CALL0(OP0001, op0001)
extern "C"
{
    void DEF0(OP0001, op0001);
}

MeshInstance::MeshInstance(): _jeveuxName( initAster->getNewResultObjectName() ),
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

bool MeshInstance::readMEDFile(char* pathFichier)
{
    // Creation d'un bout de fichier commande correspondant a LIRE_MAILLAGE
    CommandSyntax syntaxeLireMaillage("LIRE_MAILLAGE", true, initAster->getResultObjectName());
    // Ligne indispensable pour que les commandes GET* fonctionnent
    commandeCourante = &syntaxeLireMaillage;

    // Remplissage des mots cles simples FORMAT et PATHFICHIER
    SimpleKeyWordStr mCSFormat = SimpleKeyWordStr("FORMAT");
    mCSFormat.addValues("MED");
    // Ajout du premier mot cle simple
    syntaxeLireMaillage.addSimpleKeywordStr(mCSFormat);

    SimpleKeyWordStr mCSPath = SimpleKeyWordStr("PATHFICHIER");
    mCSPath.addValues(pathFichier);
    syntaxeLireMaillage.addSimpleKeywordStr(mCSPath);

    // Appel a l'operateur de LIRE_MAILLAGE
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
