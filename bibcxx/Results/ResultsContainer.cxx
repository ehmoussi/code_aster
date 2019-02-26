/**
 * @file ResultsContainer.cxx
 * @brief Implementation de ResultsContainer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   Code_Aster is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "aster_fort.h"

#include "Results/ResultsContainer.h"
#include "RunManager/LogicalUnitManagerCython.h"
#include "Supervis/CommandSyntax.h"
#include "Utilities/Tools.h"

void
ResultsContainerInstance::addElementaryCharacteristics( const ElementaryCharacteristicsPtr &cara,
                                                        int rank ) {
    if( !cara )
        throw std::runtime_error( "ElementaryCharacteristics is empty" );
    _mapElemCara[rank] = cara;
    ASTERINTEGER rang = rank;
    std::string type( "CARAELEM" );
    CALLO_RSADPA_ZK8_WRAP( getName(), &rang, cara->getName(), type );
};

void ResultsContainerInstance::addListOfLoads( const ListOfLoadsPtr &load,
                                               int rank ) {
    _mapLoads[rank] = load;
    ASTERINTEGER rang = rank;
    std::string type( "EXCIT" );
    CALLO_RSADPA_ZK24_WRAP( getName(), &rang, load->getName(), type );
};

void ResultsContainerInstance::addMaterialOnMesh( const MaterialOnMeshPtr &mater,
                                                  int rank ) {
    if( !mater )
        throw std::runtime_error( "MaterialOnMesh is empty" );
    _mapMaterial[rank] = mater;
    ASTERINTEGER rang = rank;
    std::string type( "CHAMPMAT" );
    CALLO_RSADPA_ZK8_WRAP( getName(), &rang, mater->getName(), type );
};

void ResultsContainerInstance::addModel( const ModelPtr &model,
                                         int rank ) {
    if( !model )
        throw std::runtime_error( "Model is empty" );
    _mapModel[rank] = model;
    ASTERINTEGER rang = rank;
    std::string type( "MODELE" );
    CALLO_RSADPA_ZK8_WRAP( getName(), &rang, model->getName(), type );
    const auto fed = model->getFiniteElementDescriptor();
    _fieldBuidler.addFiniteElementDescriptor( fed );
};

void ResultsContainerInstance::addTimeValue( double value, int rank ) {
    ASTERINTEGER rang = rank;
    std::string type( "INST" );
    CALLO_RSADPA_ZR_WRAP( getName(), &rang, &value, type );
};

bool ResultsContainerInstance::allocate( int nbRanks ) {
    std::string base( JeveuxMemoryTypesNames[getMemoryType()] );
    ASTERINTEGER nbordr = nbRanks;
    CALLO_RSCRSD( base, getName(), getType(), &nbordr );
    _nbRanks = nbRanks;
    return true;
};

void ResultsContainerInstance::appendElementaryCharacteristicsOnAllRanks
    ( const ElementaryCharacteristicsPtr& cara )
{
    _serialNumber->updateValuePointer();
    ASTERINTEGER nbRanks = _serialNumber->usedSize();
    for ( int rank = 0; rank < nbRanks; ++rank ) {
        const ASTERINTEGER iordr = ( *_serialNumber )[rank];
        if ( _mapElemCara.find( iordr ) == _mapElemCara.end() )
            addElementaryCharacteristics( cara, iordr );
    }
};

void ResultsContainerInstance::appendMaterialOnMeshOnAllRanks( const MaterialOnMeshPtr &mater ) {
    _serialNumber->updateValuePointer();
    ASTERINTEGER nbRanks = _serialNumber->usedSize();
    for ( int rank = 0; rank < nbRanks; ++rank ) {
        const ASTERINTEGER iordr = ( *_serialNumber )[rank];
        if ( _mapMaterial.find( iordr ) == _mapMaterial.end() )
            addMaterialOnMesh( mater, iordr );
    }
};

void ResultsContainerInstance::appendModelOnAllRanks( const ModelPtr &model ) {
    _serialNumber->updateValuePointer();
    ASTERINTEGER nbRanks = _serialNumber->usedSize();
    for ( int rank = 0; rank < nbRanks; ++rank ) {
        const ASTERINTEGER iordr = ( *_serialNumber )[rank];
        if ( _mapModel.find( iordr ) == _mapModel.end() )
            addModel( model, iordr );
    }
};

BaseDOFNumberingPtr ResultsContainerInstance::getEmptyDOFNumbering() {
    std::string resuName( getName() );
    std::string name( "12345678.00000          " );
    ASTERINTEGER a = 10, b = 14;
    CALLO_GNOMSD( resuName, name, &a, &b );
    DOFNumberingPtr retour( new DOFNumberingInstance( name.substr( 0, 14 ) ) );
    _listOfDOFNum.push_back( retour );
    return retour;
};

FieldOnNodesDoublePtr
ResultsContainerInstance::getEmptyFieldOnNodesDouble( const std::string name,
                                                      const int rank ) {
    if ( rank > _nbRanks || rank <= 0 )
        throw std::runtime_error( "Order number out of range" );
    ASTERINTEGER retour;
    retour = 0;
    const ASTERINTEGER rankLong = rank;
    std::string null( " " );
    std::string returnName( 19, ' ' );
    CALLO_RSEXCH( null, getName(), name, &rankLong, returnName, &retour );
    CALLO_RSNOCH( getName(), name, &rankLong );
    std::string bis( returnName.c_str(), 19 );
    FieldOnNodesDoublePtr result( new FieldOnNodesDoubleInstance( bis ) );

    auto curIter = _dictOfVectorOfFieldsNodes.find( name );
    if ( curIter == _dictOfVectorOfFieldsNodes.end() ) {
        _dictOfVectorOfFieldsNodes[name] = VectorOfFieldsNodes( _nbRanks );
    }
    _dictOfVectorOfFieldsNodes[name][rank - 1] = result;
    return result;
};

#ifdef _USE_MPI
BaseDOFNumberingPtr ResultsContainerInstance::getEmptyParallelDOFNumbering() {
    std::string resuName( getName() );
    std::string name( "12345678.00000          " );
    ASTERINTEGER a = 10, b = 14;
    CALLO_GNOMSD( resuName, name, &a, &b );
    ParallelDOFNumberingPtr retour( new ParallelDOFNumberingInstance( name.substr( 0, 14 ) ) );
    _listOfDOFNum.push_back( retour );
    return retour;
};
#endif /* _USE_MPI */

ElementaryCharacteristicsPtr ResultsContainerInstance::getElementaryCharacteristics() {
    std::string name( "" );
    ElementaryCharacteristicsPtr toReturn( nullptr );
    for ( const auto &curIter : _mapElemCara ) {
        if ( name == "" ) {
            toReturn = curIter.second;
            name = toReturn->getName();
        }
        if ( name != curIter.second->getName() )
            throw std::runtime_error( "Error: multiple elementary characteristics" );
    }
    return toReturn;
};

ElementaryCharacteristicsPtr
ResultsContainerInstance::getElementaryCharacteristics( int rank ) {
    auto curIter = _mapElemCara.find( rank );
    if ( curIter == _mapElemCara.end() )
        throw std::runtime_error( "Rank not find" );
    return ( *curIter ).second;
};

ListOfLoadsPtr ResultsContainerInstance::getListOfLoads( int rank ) {
    auto curIter = _mapLoads.find( rank );
    if ( curIter == _mapLoads.end() )
        throw std::runtime_error( "Rank not find" );
    return ( *curIter ).second;
};

MaterialOnMeshPtr ResultsContainerInstance::getMaterialOnMesh() {
    std::string name( "" );
    MaterialOnMeshPtr toReturn( nullptr );
    for ( const auto &curIter : _mapMaterial ) {
        if ( name == "" ) {
            toReturn = curIter.second;
            name = toReturn->getName();
        }
        if ( name != curIter.second->getName() )
            throw std::runtime_error( "Error: multiple materials" );
    }
    return toReturn;
};

MaterialOnMeshPtr
ResultsContainerInstance::getMaterialOnMesh( int rank ) {
    auto curIter = _mapMaterial.find( rank );
    if ( curIter == _mapMaterial.end() )
        throw std::runtime_error( "Rank not find" );
    return ( *curIter ).second;
};

BaseMeshPtr ResultsContainerInstance::getMesh()
{
    if( _mesh != nullptr )
        return _mesh;
    const auto model = getModel();
    if( model != nullptr )
        return model->getSupportMesh();
    return nullptr;
};

ModelPtr ResultsContainerInstance::getModel() {
    std::string name( "" );
    ModelPtr toReturn( nullptr );
    for ( const auto &curIter : _mapModel ) {
        if ( name == "" ) {
            toReturn = curIter.second;
            name = toReturn->getName();
        }
        if ( name != curIter.second->getName() )
            throw std::runtime_error( "Error: multiple models" );
    }
    return toReturn;
};

ModelPtr ResultsContainerInstance::getModel( int rank )
{
    auto curIter = _mapModel.find( rank );
    if ( curIter == _mapModel.end() )
        throw std::runtime_error( "Rank not find" );
    return ( *curIter ).second;
};

int ResultsContainerInstance::getNumberOfRanks() const
{
    return _serialNumber->usedSize();
};

std::vector< long > ResultsContainerInstance::getRanks() const
{
    std::vector< long > v;
    _serialNumber->updateValuePointer();
    for ( int j = 0; j < _serialNumber->usedSize(); ++j ) {
        v.push_back( ( *_serialNumber )[j] );
    }
    return v;
};

FieldOnElementsDoublePtr ResultsContainerInstance::getRealFieldOnElements( const std::string name,
                                                                           const int rank ) const
{
    if ( rank > _nbRanks || rank <= 0 )
        throw std::runtime_error( "Order number out of range" );

    auto curIter = _dictOfVectorOfFieldsElements.find( trim( name ) );
    if ( curIter == _dictOfVectorOfFieldsElements.end() )
        throw std::runtime_error( "Field " + name + " unknown in the results container" );

    FieldOnElementsDoublePtr toReturn = curIter->second[rank - 1];
    return toReturn;
};

FieldOnNodesDoublePtr ResultsContainerInstance::getRealFieldOnNodes( const std::string name,
                                                                     const int rank ) const
{
    if ( rank > _nbRanks || rank <= 0 )
        throw std::runtime_error( "Order number out of range" );

    auto curIter = _dictOfVectorOfFieldsNodes.find( trim( name ) );
    if ( curIter == _dictOfVectorOfFieldsNodes.end() )
        throw std::runtime_error( "Field " + name + " unknown in the results container" );

    FieldOnNodesDoublePtr toReturn = curIter->second[rank - 1];
    return toReturn;
};

void ResultsContainerInstance::listFields() const
{
    std::cout << "Content of DataStructure : ";
    for ( auto curIter : _dictOfVectorOfFieldsNodes ) {
        std::cout << curIter.first << " - ";
    }
    for ( auto curIter : _dictOfVectorOfFieldsElements ) {
        std::cout << curIter.first << " - ";
    }
    std::cout << std::endl;
};

bool ResultsContainerInstance::printMedFile( const std::string fileName ) const
{
    LogicalUnitFileCython a( fileName, Binary, New );
    ASTERINTEGER retour = a.getLogicalUnit();
    CommandSyntax cmdSt( "IMPR_RESU" );

    SyntaxMapContainer dict;
    dict.container["FORMAT"] = "MED";
    dict.container["UNITE"] = retour;

    ListSyntaxMapContainer listeResu;
    SyntaxMapContainer dict2;
    dict2.container["RESULTAT"] = getName();
    dict2.container["TOUT_ORDRE"] = "OUI";
    listeResu.push_back( dict2 );
    dict.container["RESU"] = listeResu;

    cmdSt.define( dict );

    try {
        ASTERINTEGER op = 39;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }

    return true;
};

bool ResultsContainerInstance::update()
{
    _serialNumber->updateValuePointer();
    auto boolRet = _namesOfFields->buildFromJeveux( true );
    const auto numberOfSerialNum = _serialNumber->usedSize();
    _nbRanks = numberOfSerialNum;
    BaseMeshPtr curMesh( nullptr );
    const ASTERINTEGER iordr = ( *_serialNumber )[_nbRanks - 1];
    if ( _mapModel.find( iordr ) != _mapModel.end() )
        curMesh = _mapModel[iordr]->getSupportMesh();
    else if ( _mesh != nullptr )
        curMesh = _mesh;

    int cmpt = 1;
    for ( const auto curIter : _namesOfFields->getVectorOfObjects() ) {
        auto nomSymb = trim( _symbolicNamesOfFields->findStringOfElement( cmpt ) );
        if ( numberOfSerialNum > curIter.size() )
            throw std::runtime_error( "Programming error" );

        for ( int rank = 0; rank < numberOfSerialNum; ++rank ) {
            std::string name( trim( curIter[rank].toString() ) );
            if ( name != "" ) {
                const std::string questi( "TYPE_CHAMP" );
                const std::string typeco( "CHAMP" );
                ASTERINTEGER repi = 0, ier = 0;
                JeveuxChar32 repk( " " );
                const std::string arret( "C" );
                const std::string questi2( "TYPE_SCA" );

                CALLO_DISMOI( questi2, name, typeco, &repi, repk, arret, &ier );
                const std::string resu2( trim( repk.toString() ) );
                /*if( resu2 != "R" )
                    throw std::runtime_error( "Not yet implemented" );*/

                CALLO_DISMOI( questi, name, typeco, &repi, repk, arret, &ier );
                const std::string resu( trim( repk.toString() ) );

                if ( resu == "NOEU" ) {
                    const auto &curIter2 = _dictOfVectorOfFieldsNodes.find( nomSymb );
                    if ( curIter2 == _dictOfVectorOfFieldsNodes.end() )
                        _dictOfVectorOfFieldsNodes[nomSymb] = VectorOfFieldsNodes(
                            numberOfSerialNum, FieldOnNodesDoublePtr( nullptr ) );
                    else if ( curIter2->second.size() != numberOfSerialNum ) {
                        curIter2->second.resize( numberOfSerialNum,
                                                 FieldOnNodesDoublePtr( nullptr ) );
                    }

                    ASTERINTEGER test2 = _dictOfVectorOfFieldsNodes[nomSymb][rank].use_count();
                    if ( test2 == 0 ) {
                        FieldOnNodesDoublePtr result =
                            _fieldBuidler.buildFieldOnNodes< double >( name );
                        _dictOfVectorOfFieldsNodes[nomSymb][rank] = result;
                    }
                } else if ( resu == "ELEM" || resu == "ELNO" || resu == "ELGA" ) {
                    const auto &curIter2 = _dictOfVectorOfFieldsElements.find( nomSymb );
                    if ( curIter2 == _dictOfVectorOfFieldsElements.end() )
                        _dictOfVectorOfFieldsElements[nomSymb] = VectorOfFieldsElements(
                            numberOfSerialNum, FieldOnElementsDoublePtr( nullptr ) );
                    else if ( curIter2->second.size() != numberOfSerialNum ) {
                        curIter2->second.resize( numberOfSerialNum,
                                                 FieldOnElementsDoublePtr( nullptr ) );
                    }

                    ASTERINTEGER test2 = _dictOfVectorOfFieldsElements[nomSymb][rank].use_count();
                    if ( test2 == 0 ) {
                        if ( curMesh == nullptr )
                            throw std::runtime_error(
                                "No mesh, impossible to build FieldOnElements" );
                        FieldOnElementsDoublePtr result =
                            _fieldBuidler.buildFieldOnElements< double >( name, curMesh );
                        ( new FieldOnElementsDoubleInstance( name ) );
                        _dictOfVectorOfFieldsElements[nomSymb][rank] = result;
                    }
                }
            }
        }
        ++cmpt;
    }

    return true;
};
