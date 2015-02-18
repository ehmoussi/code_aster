/**
 * @file MechanicalLoad.cxx
 * @brief Implementation de MechanicalLoad
 * @author Natacha Bereux
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

#include <stdexcept>
#include <typeinfo>
#include "astercxx.h"

#include "Loads/MechanicalLoad.h"
#include <typeinfo>

MechanicalLoadInstance::MechanicalLoadInstance():
                                DataStructure( getNewResultObjectName(), "CHAR_MECA" ),
                                _jeveuxName( getName() ),
                                _kinematicLoad( PCFieldOnMeshPtrDouble(
                                    new PCFieldOnMeshInstanceDouble( std::string(_jeveuxName+".CHME.CIMPO") ) ) ),
                                _pressure( PCFieldOnMeshPtrDouble(
                                    new PCFieldOnMeshInstanceDouble( std::string(_jeveuxName+".CHME.PRESS") ) ) ),
                                _supportModel( ModelPtr() )
{};

bool MechanicalLoadInstance::build() throw ( std::runtime_error )
{
// Maintenant que le fichier de commande est pret, on appelle OP0007
    try
    {
       INTEGER op = 7;
       CALL_EXECOP( &op );
    }
    catch( ... )
    {
        throw;
    }
// Connection à la mémoire Jeveux : todo
  return true; 
};
