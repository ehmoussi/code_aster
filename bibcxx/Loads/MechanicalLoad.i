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
#include "Loads/MechanicalLoad.h"
%}

%include "Modeling/Model.i"

class MechanicalLoad
{
    public:
        MechanicalLoad();
        ~MechanicalLoad();
};

%extend MechanicalLoad
{
    bool setSupportModel(ModelPtr& currentModel)
    {
        return (*$self)->setSupportModel(currentModel);
    }

    bool setDisplacementOnNodes(char* doFName, double doFValue, char* nameOfGroup)
    {
        return (*$self)->setDisplacementOnNodes(doFName, doFValue, nameOfGroup);
    }
    bool setDisplacementOnElements(char* doFName, double doFValue, char* nameOfGroup)
    {
        return (*$self)->setDisplacementOnElements(doFName, doFValue, nameOfGroup);
    }
    bool setPressureOnElements(double doFValue, char* nameOfGroup)
    {
        return (*$self)->setPressureOnElements(doFValue, nameOfGroup);
    }
    bool setPressureOnNodes(double doFValue, char* nameOfGroup)
    {
        return (*$self)->setPressureOnNodes(doFValue, nameOfGroup);
    }
    bool setDistributedPressureOnElements(double doFValue, char* nameOfGroup)
    {
        return (*$self)->setDistributedPressureOnElements(doFValue, nameOfGroup);
    bool build()
    {
        return (*$self)->build();
    }
}
