
#include "userobject/AsterModel.hpp"

#define CALL_OP0018() CALL0(OP0018, op0018)
extern "C"
{
    void DEF0(OP0018, op0018);
}

AsterModelInstance::AsterModelInstance():
                                _jeveuxName( initAster->getNewResultObjectName() ),
                                _typeOfElements( JeveuxVectorLong( string(_jeveuxName + ".MAILLE    ") ) ),
                                _typeOfNodes( JeveuxVectorLong( string(_jeveuxName + ".NOEUD     ") ) ),
                                _partition( JeveuxVectorChar8( string(_jeveuxName + ".PARTIT    ") ) ),
                                _supportMesh( AsterMesh(false) )
{};

bool AsterModelInstance::build()
{
    CommandSyntax syntaxeLireMaillage("AFFE_MODELE", true, initAster->getResultObjectName());
    commandeCourante = &syntaxeLireMaillage;

    SimpleKeyWordStr mCSMaillage = SimpleKeyWordStr("MAILLAGE");
    if ( _supportMesh.isEmpty() )
        throw string("Support mesh is undefined");
    mCSMaillage.addValues(_supportMesh->getJeveuxName());
    syntaxeLireMaillage.addSimpleKeywordStr(mCSMaillage);

    FactorKeyword motCleAFFE = FactorKeyword("AFFE", true);

    for ( listOfModsAndGrps::iterator curIter = _modelisations.begin();
          curIter != _modelisations.end();
          ++curIter )
    {
        FactorKeywordOccurence occurAFFE = FactorKeywordOccurence();

        SimpleKeyWordStr mCSPhenomene = SimpleKeyWordStr("PHENOMENE");
        mCSPhenomene.addValues((*curIter).first.physics());
        occurAFFE.addSimpleKeywordStr(mCSPhenomene);

        SimpleKeyWordStr mCSModelisation = SimpleKeyWordStr("MODELISATION");
        mCSModelisation.addValues((*curIter).first.modelisation());
        occurAFFE.addSimpleKeywordStr(mCSModelisation);

        if ( (*curIter).second == "TOUT" )
        {
            SimpleKeyWordStr mCSGroup = SimpleKeyWordStr("TOUT");
            mCSGroup.addValues("OUI");
            occurAFFE.addSimpleKeywordStr(mCSGroup);
            motCleAFFE.addOccurence(occurAFFE);
        }
        else
            throw "Not yet implemented";
    }

    syntaxeLireMaillage.addFactorKeyword(motCleAFFE);

    CALL_OP0018();
    // Attention, la connection des objets a leur image JEVEUX n'est pas necessaire
    _typeOfElements->updateValuePointer();
    commandeCourante = NULL;
    return true;
};
