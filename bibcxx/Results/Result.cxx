/**
 * @file Result.cxx
 * @brief Implementation de Result
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

#include "Results/Result.h"
#include "PythonBindings/LogicalUnitManager.h"
#include "Supervis/CommandSyntax.h"
#include "Utilities/Tools.h"

void
ResultClass::addElementaryCharacteristics( const ElementaryCharacteristicsPtr &cara,
                                                        int rank ) {
    if( !cara )
        throw std::runtime_error( "ElementaryCharacteristics is empty" );
    _mapElemCara[rank] = cara;
    ASTERINTEGER rang = rank;
    std::string type( "CARAELEM" );
    CALLO_RSADPA_ZK8_WRAP( getName(), &rang, cara->getName(), type );
};

void ResultClass::addListOfLoads( const ListOfLoadsPtr &load,
                                               int rank ) {
    _mapLoads[rank] = load;
    ASTERINTEGER rang = rank;
    std::string type( "EXCIT" );
    CALLO_RSADPA_ZK24_WRAP( getName(), &rang, load->getName(), type );
};

void ResultClass::addMaterialField( const MaterialFieldPtr &mater,
                                                  int rank ) {
    if( !mater )
        throw std::runtime_error( "MaterialField is empty" );
    _mapMaterial[rank] = mater;
    ASTERINTEGER rang = rank;
    std::string type( "CHAMPMAT" );
    CALLO_RSADPA_ZK8_WRAP( getName(), &rang, mater->getName(), type );
};

void ResultClass::addModel( const ModelPtr &model,
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

void ResultClass::addTimeValue( double value, int rank ) {
    ASTERINTEGER rang = rank;
    std::string type( "INST" );
    CALLO_RSADPA_ZR_WRAP( getName(), &rang, &value, type );
};

bool ResultClass::allocate( int nbRanks ) {
    std::string base( JeveuxMemoryTypesNames[getMemoryType()] );
    ASTERINTEGER nbordr = nbRanks;
    CALLO_RSCRSD( base, getName(), getType(), &nbordr );
    _nbRanks = nbRanks;
    return true;
};

void ResultClass::appendElementaryCharacteristicsOnAllRanks
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

void ResultClass::appendMaterialFieldOnAllRanks( const MaterialFieldPtr &mater ) {
    _serialNumber->updateValuePointer();
    ASTERINTEGER nbRanks = _serialNumber->usedSize();
    for ( int rank = 0; rank < nbRanks; ++rank ) {
        const ASTERINTEGER iordr = ( *_serialNumber )[rank];
        if ( _mapMaterial.find( iordr ) == _mapMaterial.end() )
            addMaterialField( mater, iordr );
    }
};

void ResultClass::appendModelOnAllRanks( const ModelPtr &model ) {
    _serialNumber->updateValuePointer();
    ASTERINTEGER nbRanks = _serialNumber->usedSize();
    for ( int rank = 0; rank < nbRanks; ++rank ) {
        const ASTERINTEGER iordr = ( *_serialNumber )[rank];
        if ( _mapModel.find( iordr ) == _mapModel.end() )
            addModel( model, iordr );
    }
};

BaseDOFNumberingPtr ResultClass::getEmptyDOFNumbering() {
    std::string resuName( getName() );
    std::string name( "12345678.00000          " );
    ASTERINTEGER a = 10, b = 14;
    CALLO_GNOMSD( resuName, name, &a, &b );
    DOFNumberingPtr retour( new DOFNumberingClass( name.substr( 0, 14 ) ) );
    _listOfDOFNum.push_back( retour );
    return retour;
};

FieldOnNodesRealPtr
ResultClass::getEmptyFieldOnNodesReal( const std::string name,
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
    FieldOnNodesRealPtr result( new FieldOnNodesRealClass( bis ) );

    auto curIter = _dictOfVectorOfFieldsNodes.find( name );
    if ( curIter == _dictOfVectorOfFieldsNodes.end() ) {
        _dictOfVectorOfFieldsNodes[name] = VectorOfFieldsNodes( _nbRanks );
    }
    _dictOfVectorOfFieldsNodes[name][rank - 1] = result;
    return result;
};

#ifdef _USE_MPI
BaseDOFNumberingPtr ResultClass::getEmptyParallelDOFNumbering() {
    std::string resuName( getName() );
    std::string name( "12345678.00000          " );
    ASTERINTEGER a = 10, b = 14;
    CALLO_GNOMSD( resuName, name, &a, &b );
    ParallelDOFNumberingPtr retour( new ParallelDOFNumberingClass( name.substr( 0, 14 ) ) );
    _listOfDOFNum.push_back( retour );
    return retour;
};
#endif /* _USE_MPI */

ElementaryCharacteristicsPtr ResultClass::getElementaryCharacteristics() {
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
ResultClass::getElementaryCharacteristics( int rank ) {
    auto curIter = _mapElemCara.find( rank );
    if ( curIter == _mapElemCara.end() )
        throw std::runtime_error( "Rank not found" );
    return ( *curIter ).second;
};

ListOfLoadsPtr ResultClass::getListOfLoads( int rank ) {
    auto curIter = _mapLoads.find( rank );
    if ( curIter == _mapLoads.end() )
        throw std::runtime_error( "Rank not found" );
    return ( *curIter ).second;
};

MaterialFieldPtr ResultClass::getMaterialField() {
    std::string name( "" );
    MaterialFieldPtr toReturn( nullptr );
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

MaterialFieldPtr
ResultClass::getMaterialField( int rank ) {
    auto curIter = _mapMaterial.find( rank );
    if ( curIter == _mapMaterial.end() )
        throw std::runtime_error( "Rank not found" );
    return ( *curIter ).second;
};

BaseMeshPtr ResultClass::getMesh()
{
    if( _mesh != nullptr )
        return _mesh;
    const auto model = getModel();
    if( model != nullptr )
        return model->getMesh();
    return nullptr;
};

ModelPtr ResultClass::getModel() {
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

ModelPtr ResultClass::getModel( int rank )
{
    auto curIter = _mapModel.find( rank );
    if ( curIter == _mapModel.end() )
        throw std::runtime_error( "Rank not found" );
    return ( *curIter ).second;
};

int ResultClass::getNumberOfRanks() const
{
    return _serialNumber->usedSize();
};

VectorLong ResultClass::getRanks() const
{
    VectorLong v;
    _serialNumber->updateValuePointer();
    for ( int j = 0; j < _serialNumber->usedSize(); ++j ) {
        v.push_back( ( *_serialNumber )[j] );
    }
    return v;
};

FieldOnCellsRealPtr ResultClass::getRealFieldOnCells( const std::string name,
                                                                           const int rank ) const
{
    if ( rank > _nbRanks || rank <= 0 )
        throw std::runtime_error( "Order number out of range" );

    auto curIter = _dictOfVectorOfFieldsCells.find( trim( name ) );
    if ( curIter == _dictOfVectorOfFieldsCells.end() )
        throw std::runtime_error( "Field " + name + " unknown in the results container" );

    FieldOnCellsRealPtr toReturn = curIter->second[rank - 1];
    return toReturn;
};

FieldOnNodesRealPtr ResultClass::getRealFieldOnNodes( const std::string name,
                                                                     const int rank ) const
{
    if ( rank > _nbRanks || rank <= 0 )
        throw std::runtime_error( "Order number out of range" );

    auto curIter = _dictOfVectorOfFieldsNodes.find( trim( name ) );
    if ( curIter == _dictOfVectorOfFieldsNodes.end() )
        throw std::runtime_error( "Field " + name + " unknown in the results container" );

    FieldOnNodesRealPtr toReturn = curIter->second[rank - 1];
    return toReturn;
};

void ResultClass::listFields() const
{
    std::cout << "Content of DataStructure : ";
    for ( auto curIter : _dictOfVectorOfFieldsNodes ) {
        std::cout << curIter.first << " - ";
    }
    for ( auto curIter : _dictOfVectorOfFieldsCells ) {
        std::cout << curIter.first << " - ";
    }
    std::cout << std::endl;
};

bool ResultClass::printMedFile( const std::string fileName ) const
{
    LogicalUnitFile a( fileName, Binary, New );
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

bool ResultClass::update()
{
    _serialNumber->updateValuePointer();
    auto boolRet = _namesOfFields->buildFromJeveux( true );
    const auto numberOfSerialNum = _serialNumber->usedSize();
    _nbRanks = numberOfSerialNum;
    BaseMeshPtr curMesh( nullptr );
    const ASTERINTEGER iordr = ( *_serialNumber )[_nbRanks - 1];
    if ( _mapModel.find( iordr ) != _mapModel.end() )
        curMesh = _mapModel[iordr]->getMesh();
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

                CALLO_DISMOI( questi, name, typeco, &repi, repk, arret, &ier );
                const std::string resu( trim( repk.toString() ) );

                if ( resu == "NOEU" ) {
                    const auto &curIter2 = _dictOfVectorOfFieldsNodes.find( nomSymb );
                    if ( curIter2 == _dictOfVectorOfFieldsNodes.end() )
                        _dictOfVectorOfFieldsNodes[nomSymb] = VectorOfFieldsNodes(
                            numberOfSerialNum, FieldOnNodesRealPtr( nullptr ) );
                    else if ( curIter2->second.size() != numberOfSerialNum ) {
                        curIter2->second.resize( numberOfSerialNum,
                                                 FieldOnNodesRealPtr( nullptr ) );
                    }

                    ASTERINTEGER test2 = _dictOfVectorOfFieldsNodes[nomSymb][rank].use_count();
                    if ( test2 == 0 ) {
                        FieldOnNodesRealPtr result =
                            _fieldBuidler.buildFieldOnNodes< double >( name );
                        _dictOfVectorOfFieldsNodes[nomSymb][rank] = result;
                    }
                } else if ( resu == "ELEM" || resu == "ELNO" || resu == "ELGA" ) {
                    const auto &curIter2 = _dictOfVectorOfFieldsCells.find( nomSymb );
                    if ( curIter2 == _dictOfVectorOfFieldsCells.end() )
                        _dictOfVectorOfFieldsCells[nomSymb] = VectorOfFieldsCells(
                            numberOfSerialNum, FieldOnCellsRealPtr( nullptr ) );
                    else if ( curIter2->second.size() != numberOfSerialNum ) {
                        curIter2->second.resize( numberOfSerialNum,
                                                 FieldOnCellsRealPtr( nullptr ) );
                    }

                    ASTERINTEGER test2 = _dictOfVectorOfFieldsCells[nomSymb][rank].use_count();
                    if ( test2 == 0 ) {
                        if ( curMesh == nullptr )
                            throw std::runtime_error(
                                "No mesh, impossible to build FieldOnCells" );
                        FieldOnCellsRealPtr result =
                            _fieldBuidler.buildFieldOnCells< double >( name, curMesh );
                        ( new FieldOnCellsRealClass( name ) );
                        _dictOfVectorOfFieldsCells[nomSymb][rank] = result;
                    }
                }
            }
        }
        ++cmpt;
    }

    return true;
};
