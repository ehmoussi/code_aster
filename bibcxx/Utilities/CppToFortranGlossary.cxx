/**
 * @file CppToFortranGlossary.cxx
 * @brief Création du glossaire permettant de passer du Fortran au C++
 * @author Nicolas Sellenet
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

#include "Utilities/CppToFortranGlossary.h"

Glossary::Glossary()
{
    for( int i = 0; i < nbPhysics; ++i )
    {
        const std::string curName( PhysicNames[i] );
        _strToInt[ curName ] = i;
    }

    for( int i = 0; i < nbModelings; ++i )
    {
        const std::string curName( ModelingNames[i] );
        _strToInt[ curName ] = i;
    }

    for( int i = 0; i < nbComponent; ++i )
    {
        const std::string curName( ComponentNames[i] );
        _strToInt[ curName ] = i;
    }
};

Glossary fortranGlossary;

Glossary* getGlossary()
{
    return &fortranGlossary;
};
