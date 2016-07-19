/**
 * @file StructureInterface.cxx
 * @brief
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include "LinearAlgebra/StructureInterface.h"

const std::vector< InterfaceTypeEnum > allInterfaceType = { MacNeal, CraigBampton,
                                                            HarmonicalCraigBampton,
                                                            NoInterfaceType };
const std::vector< std::string > allInterfaceTypeNames = { "MNEAL", "CRAIGB",
                                                           "CB_HARMO", "AUCUN" };

bool StructureInterfaceInstance::build() throw( std::runtime_error )
{
    CommandSyntaxCython cmdSt( "DEFI_INTERF_DYNA" );
    cmdSt.setResult( getName(), "INTERF_DYNA_CLAS" );

    CapyConvertibleSyntax syntax;
    syntax.setSimpleKeywordValues( _container );
    for( const auto& iter : _interfDefs )
        syntax.addCapyConvertibleContainer( iter._container );

    cmdSt.define( syntax );

    // Maintenant que le fichier de commande est pret, on appelle OP0030
    try
    {
        INTEGER op = 98;
        CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
    _isEmpty = false;
    return true;
};
