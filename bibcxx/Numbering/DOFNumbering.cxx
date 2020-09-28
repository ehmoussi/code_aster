/**
 * @file DOFNumbering.cxx
 * @brief Implementation de DOFNumbering
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

#include "astercxx.h"
#include <stdexcept>

#include "Numbering/DOFNumbering.h"
#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

FieldOnNodesDescriptionClass::FieldOnNodesDescriptionClass( const JeveuxMemory memType )
    : DataStructure( ResultNaming::getNewResultName(), 19, "PROF_CHNO", memType ),
      _componentsOnNodes( getName() + ".PRNO" ), _namesOfGroupOfCells( getName() + ".LILI" ),
      _indexationVector( getName() + ".NUEQ" ),
      _nodeAndComponentsNumberFromDOF( getName() + ".DEEQ" ){};

FieldOnNodesDescriptionClass::FieldOnNodesDescriptionClass( const std::string name,
                                                            const JeveuxMemory memType )
    : DataStructure( name, 19, "PROF_CHNO", memType ), _componentsOnNodes( getName() + ".PRNO" ),
      _namesOfGroupOfCells( getName() + ".LILI" ), _indexationVector( getName() + ".NUEQ" ),
      _nodeAndComponentsNumberFromDOF( getName() + ".DEEQ" ){};

BaseDOFNumberingClass::BaseDOFNumberingClass( const std::string &type, const JeveuxMemory memType )
    : DataStructure( ResultNaming::getNewResultName(), 14, type, memType ),
      _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + ".NSLV" ) ),
      _globalNumbering( new GlobalEquationNumberingClass( getName() + ".NUME" ) ),
      _dofDescription( new FieldOnNodesDescriptionClass( getName() + ".NUME" ) ),
      _localNumbering( new LocalEquationNumberingClass( getName() + ".NUML" ) ),
      _model( ModelPtr( nullptr ) ), _listOfLoads( new ListOfLoadsClass() ),
      _smos( new MorseStorageClass( getName() + ".SMOS" ) ),
      _slcs( new LigneDeCielClass( getName() + ".SLCS" ) ),
      _mltf( new MultFrontGarbageClass( getName() + ".MLTF" ) ), _isEmpty( true ){};

BaseDOFNumberingClass::BaseDOFNumberingClass( const std::string name, const std::string &type,
                                              const JeveuxMemory memType )
    : DataStructure( name, 14, type, memType ),
      _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + ".NSLV" ) ),
      _globalNumbering( new GlobalEquationNumberingClass( getName() + ".NUME" ) ),
      _dofDescription( new FieldOnNodesDescriptionClass( getName() + ".NUME" ) ),
      _localNumbering( new LocalEquationNumberingClass( getName() + ".NUML" ) ),
      _model( ModelPtr( nullptr ) ), _listOfLoads( new ListOfLoadsClass() ),
      _smos( new MorseStorageClass( getName() + ".SMOS" ) ),
      _slcs( new LigneDeCielClass( getName() + ".SLCS" ) ),
      _mltf( new MultFrontGarbageClass( getName() + ".MLTF" ) ), _isEmpty( true ){};

bool BaseDOFNumberingClass::computeNumbering() {
    if ( _model ) {
        if ( _model->isEmpty() )
            throw std::runtime_error( "Model is empty" );

        _listOfLoads->build();
        JeveuxVectorChar24 jvListOfLoads = _listOfLoads->getListVector();
        jvListOfLoads->updateValuePointer();

        const std::string base( "VG" );
        const std::string null( " " );
        CALLO_NUMERO_WRAP( getName(), base, null, null, _model->getName(),
                           _listOfLoads->getName() );
    } else if ( _matrix.size() != 0 ) {
        CommandSyntax cmdSt( "NUME_DDL" );
        cmdSt.setResult( getName(), getType() );

        SyntaxMapContainer dict;

        VectorString names;
        for ( const auto &mat : _matrix )
            names.push_back( boost::apply_visitor( ElementaryMatrixGetName(), mat ) );
        dict.container["MATR_RIGI"] = names;

        cmdSt.define( dict );

        // Maintenant que le fichier de commande est pret, on appelle OP0011
        ASTERINTEGER op = 11;
        CALL_EXECOP( &op );
    } else
        throw std::runtime_error( "No matrix or model defined" );
    _isEmpty = false;

    return true;
};

bool BaseDOFNumberingClass::useLagrangeMultipliers(){
    const std::string typeco( "NUME_DDL" );
    ASTERINTEGER repi = 0, ier = 0;
    JeveuxChar32 repk( " " );
    const std::string arret( "C" );
    const std::string questi( "EXIS_LAGR" );

    CALLO_DISMOI( questi, getName(), typeco, &repi, repk, arret, &ier );
    auto retour = trim( repk.toString() );
    if ( retour == "OUI" )
        return true;
    return false;

};

VectorLong BaseDOFNumberingClass::getRowsAssociatedToPhysicalDofs(){
    _globalNumbering->_lagrangianInformations->updateValuePointer();
    ASTERINTEGER size = _globalNumbering->_lagrangianInformations->size();
    VectorLong physicalRows;
    ASTERINTEGER physicalIndicator;
    for ( int i = 0; i < size; i++ ) {
        physicalIndicator = (*_globalNumbering->_lagrangianInformations)[i];
        if (physicalIndicator==0)
            physicalRows.push_back( i+1 ); // 1-based index
    }
    return physicalRows;
};

VectorLong BaseDOFNumberingClass::getRowsAssociatedToLagrangeMultipliers(){
    _globalNumbering->_lagrangianInformations->updateValuePointer();
    ASTERINTEGER size = _globalNumbering->_lagrangianInformations->size();
    VectorLong physicalRows;
    ASTERINTEGER physicalIndicator;
    for ( int i = 0; i < size; i++ ) {
        physicalIndicator = (*_globalNumbering->_lagrangianInformations)[i];
        if (physicalIndicator!=0)
            physicalRows.push_back( i+1 ); // 1-based index
    }
    return physicalRows;
};

std::string BaseDOFNumberingClass::getComponentAssociatedToRow(const ASTERINTEGER row){
    if (row<1 or row>getNumberOfDofs())
        throw std::runtime_error("Invalid row index");
    JeveuxChar8 equaType(" ");
    JeveuxChar8 nodeName(" ");
    JeveuxChar8 compoName(" ");
    JeveuxChar8 ligrel(" ");
    CALLO_RGNDAS_WRAP(getName(), &row, equaType, nodeName, compoName, ligrel);
    return compoName.rstrip();
};

ASTERINTEGER BaseDOFNumberingClass::getRowAssociatedToNodeComponent(const ASTERINTEGER node, \
                                                                    const std::string compoName){
    if (node<1 or node>getMesh()->getNumberOfNodes())
        throw std::runtime_error("Invalid node index");
    NamesMapChar8 nodeNameMap = getMesh()->getNameOfNodesMap();
    const std::string nodeName = nodeNameMap->getStringFromIndex( node );
    const std::string objectType("NUME_DDL");
    ASTERINTEGER node2, row;
    CALLO_POSDDL(objectType, getName(), nodeName, compoName, &node2, &row);
    assert(node==node2);
    if (node2==0)
        throw std::runtime_error("No node "+ std::to_string(node2) + " in the mesh");
    if (row==0)
        throw std::runtime_error("Node "+ std::to_string(node2) + \
                                                            " has no "+compoName + " dof");
    return row;
};

ASTERINTEGER BaseDOFNumberingClass::getNodeAssociatedToRow(const ASTERINTEGER row){
    if (row<1 or row>getNumberOfDofs())
        throw std::runtime_error("Invalid row index");
    JeveuxVectorLong descriptor = getFieldOnNodesDescription()->_nodeAndComponentsNumberFromDOF;
    descriptor->updateValuePointer();
    return (*descriptor)[2*row];
};

ASTERINTEGER BaseDOFNumberingClass::getNumberOfDofs(){
    _globalNumbering->_lagrangianInformations->updateValuePointer();
    return _globalNumbering->_lagrangianInformations->size();;
};

bool BaseDOFNumberingClass::useSingleLagrangeMultipliers(){
    const std::string typeco( "NUME_DDL" );
    ASTERINTEGER repi = 0, ier = 0;
    JeveuxChar32 repk( " " );
    const std::string arret( "C" );
    const std::string questi( "SIMP_LAGR" );

    CALLO_DISMOI( questi, getName(), typeco, &repi, repk, arret, &ier );
    auto retour = trim( repk.toString() );
    if ( retour == "OUI" )
        return true;
    return false;
};

std::string BaseDOFNumberingClass::getPhysicalQuantity() {
    _globalNumbering->_informations->updateValuePointer();
    JeveuxChar24 physicalQuantity = ( *_globalNumbering->_informations )[1];
    return physicalQuantity.rstrip();
};

VectorString BaseDOFNumberingClass::getComponents() {
    ASTERINTEGER ncmp, maxCmp = 100, ibid=0;
    char *stringArray;
    VectorString stringVector;
    std::string all("ALL");
    stringArray = MakeTabFStr( 8, maxCmp );
    CALL_NUMEDDL_GET_COMPONENTS( getName().c_str(), all.c_str(), &ibid, &ncmp, \
                                                                stringArray, &maxCmp );
    for ( int k = 0; k < ncmp; k++ ) {
        stringVector.push_back( trim( std::string( stringArray + 8 * k, 8 ) ) );
    }
    FreeStr( stringArray );
    return stringVector;
};

VectorString BaseDOFNumberingClass::getComponentsAssociatedToNode(const ASTERINTEGER node) {
    ASTERINTEGER ncmp, maxCmp = 100;
    char *stringArray;
    VectorString stringVector;
    std::string all("ONE");
    stringArray = MakeTabFStr( 8, maxCmp );
    if (node<1 or node>getMesh()->getNumberOfNodes())
        throw std::runtime_error("Invalid node index");
    CALL_NUMEDDL_GET_COMPONENTS( getName().c_str(), all.c_str(), &node, &ncmp, \
                                                                    stringArray, &maxCmp );
    for ( int k = 0; k < ncmp; k++ ) {
        stringVector.push_back( trim( std::string( stringArray + 8 * k, 8 ) ) );
    }
    FreeStr( stringArray );
    return stringVector;
};
