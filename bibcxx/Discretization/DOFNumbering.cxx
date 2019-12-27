/**
 * @file DOFNumbering.cxx
 * @brief Implementation de DOFNumbering
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include <stdexcept>
#include "astercxx.h"

#include "Discretization/DOFNumbering.h"
#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

FieldOnNodesDescriptionInstance::FieldOnNodesDescriptionInstance( const JeveuxMemory memType )
    : DataStructure( ResultNaming::getNewResultName(), 19, "PROF_CHNO", memType ),
      _componentsOnNodes( getName() + ".PRNO" ), _namesOfGroupOfElements( getName() + ".LILI" ),
      _indexationVector( getName() + ".NUEQ" ),
      _nodeAndComponentsNumberFromDOF( getName() + ".DEEQ" ){};

FieldOnNodesDescriptionInstance::FieldOnNodesDescriptionInstance( const std::string name,
                                                                  const JeveuxMemory memType )
    : DataStructure( name, 19, "PROF_CHNO", memType ), _componentsOnNodes( getName() + ".PRNO" ),
      _namesOfGroupOfElements( getName() + ".LILI" ), _indexationVector( getName() + ".NUEQ" ),
      _nodeAndComponentsNumberFromDOF( getName() + ".DEEQ" ){};

BaseDOFNumberingInstance::BaseDOFNumberingInstance( const std::string &type,
                                                    const JeveuxMemory memType )
    : DataStructure( ResultNaming::getNewResultName(), 14, type, memType ),
      _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + ".NSLV" ) ),
      _globalNumbering( new GlobalEquationNumberingInstance( getName() + ".NUME" ) ),
      _dofDescription( new FieldOnNodesDescriptionInstance( getName() + ".NUME" ) ),
      _localNumbering( new LocalEquationNumberingInstance( getName() + ".NUML" ) ),
      _model( ModelPtr( nullptr ) ),
      _listOfLoads( new ListOfLoadsInstance() ),
      _smos( new MorseStorageInstance( getName() + ".SMOS" ) ),
      _slcs( new LigneDeCielInstance( getName() + ".SLCS" ) ),
      _mltf( new MultFrontGarbageInstance( getName() + ".MLTF" ) ), _isEmpty( true ){};

BaseDOFNumberingInstance::BaseDOFNumberingInstance( const std::string name, const std::string &type,
                                                    const JeveuxMemory memType )
    : DataStructure( name, 14, type, memType ),
      _nameOfSolverDataStructure( JeveuxVectorChar24( getName() + ".NSLV" ) ),
      _globalNumbering( new GlobalEquationNumberingInstance( getName() + ".NUME" ) ),
      _dofDescription( new FieldOnNodesDescriptionInstance( getName() + ".NUME" ) ),
      _localNumbering( new LocalEquationNumberingInstance( getName() + ".NUML" ) ),
      _model( ModelPtr( nullptr ) ),
      _listOfLoads( new ListOfLoadsInstance() ),
      _smos( new MorseStorageInstance( getName() + ".SMOS" ) ),
      _slcs( new LigneDeCielInstance( getName() + ".SLCS" ) ),
      _mltf( new MultFrontGarbageInstance( getName() + ".MLTF" ) ), _isEmpty( true ){};

bool BaseDOFNumberingInstance::computeNumbering()
{
    if ( _model )
    {
        if ( _model->isEmpty() )
            throw std::runtime_error( "Model is empty" );

        _listOfLoads->build();
        JeveuxVectorChar24 jvListOfLoads = _listOfLoads->getListVector();
        jvListOfLoads->updateValuePointer();
        ASTERINTEGER nbLoad = jvListOfLoads->size();

        const std::string base( "VG" );
        const std::string null( " " );
        CALLO_NUMERO_WRAP( getName(), base, null, null, _model->getName(),
                           _listOfLoads->getName() );
    }
    else if ( _matrix.size() != 0 )
    {
        CommandSyntax cmdSt( "NUME_DDL" );
        cmdSt.setResult( getName(), getType() );

        SyntaxMapContainer dict;

        VectorString names;
        for( const auto& mat : _matrix )
            names.push_back( boost::apply_visitor( ElementaryMatrixGetName(), mat ) );
        dict.container["MATR_RIGI"] = names;

        cmdSt.define( dict );

        // Maintenant que le fichier de commande est pret, on appelle OP0011
        ASTERINTEGER op = 11;
        CALL_EXECOP( &op );
    }
    else
        throw std::runtime_error( "No matrix or model defined" );
    _isEmpty = false;

    return true;
};
