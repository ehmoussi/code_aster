%module code_aster
%{
%}

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

%include "userobject/FieldOnNodes.i"
%include "userobject/Mesh.i"
%include "userobject/Model.i"
%include "userobject/Material.i"

%include "command/CataBuilder.i"

%include "debug/DebugPrint.i"

void init(int imode);

// Automatically call `init()` at import
%pythoncode %{
    mode = 0
    try:
        from aster_init_options import options
    except ImportError:
        options = ['']
    if 'CATAELEM' in options:
        mode = 1
    _code_aster.init(mode)
%}
