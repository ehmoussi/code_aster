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
