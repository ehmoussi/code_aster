/**
 * @file ThermalLoad.cxx
 * @brief Implementation de ThermalLoad
 * @author Jean-Pierre Lefebvre
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
#include <typeinfo>
#include "astercxx.h"

#include "Loads/ThermalLoad.h"
#include "Supervis/ResultNaming.h"

bool ThermalLoadInstance::build() {
    CapyConvertibleSyntax syntax;
    //    syntax.setSimpleKeywordValues( _toCapyConverter );

    CapyConvertibleFactorKeyword echangeFKW( "ECHANGE" );
    //    for( auto curIter : _exchange )
    //    {
    //        CapyConvertibleContainer toAdd = (*curIter)->getCapyConvertibleContainer();
    //        echangeFKW.addContainer( toAdd );
    //    }
    syntax.addFactorKeywordValues( echangeFKW );

    SyntaxMapContainer test = syntax.toSyntaxMapContainer();
    //    cmdSt.define( test );


    // Maintenant que le fichier de commande est pret, on appelle OP0034


    try {
        ASTERINTEGER op = 34;
        CALL_EXECOP( &op );
    } catch ( ... ) {
        throw;
    }
    _isEmpty = false;
    return true;
};
