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
%}

/* person_in_charge: nicolas.sellenet at edf.fr */

/* ATTENTION Pour ne pas renvoyer un pointeur C++ opaque apres des &get**, il ne faut pas preciser
le type du template : FieldOnNodes< double > &getCoordinates() au lieu de FieldOnNodesDouble &getCoordinates()*/

%include "exception.i"
%exception {
    try {
        $action
    }
    catch (string error) {
        SWIG_exception(SWIG_RuntimeError, error.c_str());
    }
    catch (exception* e) {
        SWIG_exception(SWIG_RuntimeError, e->what());
    }
    catch (...) {
        SWIG_exception(SWIG_RuntimeError, "Problem");
    }
}

%include "DataFields/FieldOnNodes.i"
%include "Loads/MechanicalLoad.i"
%include "Loads/KinematicsLoad.i"
%include "Mesh/Mesh.i"
%include "Modelisations/Model.i"
%include "Materials/Material.i"
%include "Materials/MaterialOnMesh.i"
%include "Results/ResultsContainer.i"
%include "LinearAlgebra/ElementaryMatrix.i"
%include "LinearAlgebra/ElementaryVector.i"
%include "LinearAlgebra/DOFNumbering.i"
%include "LinearAlgebra/LinearSolver.i"
%include "LinearAlgebra/AssemblyMatrix.i"
%include "Function/Function.i"
%include "Solvers/StaticMechanicalSolver.i"

%include "RunManager/CataBuilder.i"

void asterInitialization(int imode);

void asterFinalization();

// Automatically call `asterInitialization()` at import
%pythoncode %{
    mode = 0
    try:
        from aster_init_options import options
    except ImportError:
        options = ['']
    if 'CATAELEM' in options:
        mode = 1
    _code_aster.asterInitialization(mode)
    import atexit
    atexit.register( _code_aster.asterFinalization)
%}
