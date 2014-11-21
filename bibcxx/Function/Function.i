/*
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

/* person_in_charge: mathieu.courtois@edf.fr */

%module code_aster
%include "std_string.i"
%include "std_vector.i"

%{
#include "Function/Function.h"
%}
%template( VectorDouble ) std::vector< double >;


class Function
{
    public:
        Function();
        ~Function();
};

%extend Function
{
    void setParameterName( std::string name )
    {
        return (*$self)->setParameterName( name );
    }

    void setResultName( std::string name )
    {
        return (*$self)->setResultName( name );
    }

    void setValues( std::vector< double > absc, std::vector< double > ord )
    {
        return (*$self)->setValues( absc, ord );
    }

    bool build()
    {
        return (*$self)->build();
    }

    void debugPrint( const int logicalUnit )
    {
        return (*$self)->debugPrint( logicalUnit );
    }
}
