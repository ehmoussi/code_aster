%module libAster
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
%include "userobject/AsterMesh.i"
%include "userobject/AsterModel.i"

void startJeveux();
