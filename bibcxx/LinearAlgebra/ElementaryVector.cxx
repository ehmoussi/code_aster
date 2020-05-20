/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

/**
 * @file ElementaryVector.cxx
 * @brief Implementation de ElementaryVector
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
 *   GNU GeneralF Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <stdexcept>

#include "astercxx.h"

#include "aster_fort_calcul.h"
#include "LinearAlgebra/ElementaryVector.h"
#include "Supervis/CommandSyntax.h"

FieldOnNodesRealPtr
ElementaryVectorClass::assembleVector( const BaseDOFNumberingPtr &currentNumerotation,
                                          const double &time,
                                          const JeveuxMemory memType ) {
    if ( _isEmpty )
        throw std::runtime_error( "The ElementaryVector is empty" );

    if ( ( !currentNumerotation ) || currentNumerotation->isEmpty() )
        throw std::runtime_error( "Numerotation is empty" );

    FieldOnNodesRealPtr vectTmp( new FieldOnNodesRealClass( Permanent ) );
    std::string name( " " );
    name.resize( 24, ' ' );

    /* Le bloc qui suit sert à appeler CORICH car ASASVE et ASCOVA attendent un objet
       qui est construit par CORICH (tableau de correspondance resuelem <-> charge) */
    // Il n'est pas nécessaire de faire le ménage c'est ASCOVA qui s'en occupe
    _listOfLoads->build();
    CommandSyntax cmdSt( "ASSE_VECT_ELEM" );
    cmdSt.setResult( getName(), getType() );
    SyntaxMapContainer dict;
    dict.container["OPTION"] = "CHAR_MECA";
    cmdSt.define( dict );
    if ( !_corichRept->exists() ) {
        _listOfElementaryTerms->updateValuePointer();
        for ( ASTERINTEGER i = 1; i <= _listOfLoads->getListOfMechanicalLoads().size(); ++i ) {
            std::string detr( "E" );
            std::string vectElem( ( *_listOfElementaryTerms )[i - 1].c_str() );
            vectElem.resize( 24, ' ' );
            ASTERINTEGER in;
            CALLO_CORICH( detr, vectElem, &i, &in );
        }
    }
    /**/

    std::string typres( "R" );
    CALLO_ASASVE( getName(), currentNumerotation->getName(), typres, name );

    std::string detr( "D" );
    std::string fomult( " " );
    const JeveuxVectorChar24 lOF = _listOfLoads->getListOfFunctions();
    if ( !lOF.isEmpty() )
        fomult = lOF->getName();
    std::string param( "INST" );

    JeveuxVectorChar24 vectTmp2( name );
    vectTmp2->updateValuePointer();
    std::string name2( ( *vectTmp2 )[0].toString(), 0, 19 );
    FieldOnNodesRealPtr vectTmp3( new FieldOnNodesRealClass( name2 ) );
    vectTmp->allocateFrom( *vectTmp3 );

    CALLO_ASCOVA( detr, name, fomult, param, &time, typres, vectTmp->getName() );

    return vectTmp;
};
