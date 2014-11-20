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
%include "Materials/AllocatedMaterial.i"
%include "Results/ResultsContainer.i"
%include "LinearAlgebra/ElementaryMatrix.i"
%include "LinearAlgebra/ElementaryVector.i"
%include "LinearAlgebra/DOFNumbering.i"
%include "LinearAlgebra/LinearSolver.i"
%include "LinearAlgebra/AssemblyMatrix.i"
%include "Function/Function.i"

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
