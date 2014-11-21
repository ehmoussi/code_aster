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
#include "Mesh/Mesh.h"
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

%include "MemoryManager/JeveuxCollection.i"
%include "DataFields/FieldOnNodes.i"

class MeshInstance
{
    public:
        MeshInstance();

        const FieldOnNodesDouble getCoordinates() const;
        bool readMEDFile(char*);
};

class Mesh
{
    public:
        Mesh();
        ~Mesh();
};

%extend Mesh
{
    void debugPrint(const int logicalUnit)
    {
        return (*$self)->debugPrint( logicalUnit );
    }

    const FieldOnNodes< double > getCoordinates()
    {
        return (*$self)->getCoordinates();
    }

    bool readMEDFile(char* name)
    {
        return (*$self)->readMEDFile(name);
    }
}
