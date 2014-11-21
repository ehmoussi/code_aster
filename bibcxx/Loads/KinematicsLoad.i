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

%module code_aster
%{
#include "Loads/KinematicsLoad.h"
%}

%include "Loads/PhysicalQuantity.h"

class KinematicsLoad
{
    public:
        KinematicsLoad();
        ~KinematicsLoad();
};

%extend KinematicsLoad
{
    void setSupportModel( Model& currentModel )
    {
        return (*$self)->setSupportModel( currentModel );
    }

    bool addImposedMechanicalDOFOnElements( AsterCoordinates coordinate,
                                            double value, char* nameOfGroup )
    {
        return (*$self)->addImposedMechanicalDOFOnElements( coordinate, value, nameOfGroup );
    }

    bool addImposedMechanicalDOFOnNodes( AsterCoordinates coordinate,
                                         double value, char* nameOfGroup )
    {
        return (*$self)->addImposedMechanicalDOFOnNodes( coordinate, value, nameOfGroup );
    };

    bool addImposedThermalDOFOnElements( AsterCoordinates coordinate,
                                         double value, char* nameOfGroup )
    {
        return (*$self)->addImposedThermalDOFOnElements( coordinate, value, nameOfGroup );
    };

    bool addImposedThermalDOFOnNodes( AsterCoordinates coordinate,
                                      double value, char* nameOfGroup )
    {
        return (*$self)->addImposedThermalDOFOnNodes( coordinate, value, nameOfGroup );
    };

    bool build()
    {
        return (*$self)->build();
    }
}
