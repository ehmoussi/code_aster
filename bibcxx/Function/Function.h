#ifndef FUNCTION_H_
#define FUNCTION_H_

/* person_in_charge: mathieu.courtois@edf.fr */
#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>

#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"


typedef std::vector< double > VectorDouble;

/**
* class FunctionInstance
*   Create a datastructure for a function with real values
* @author Mathieu Courtois
*/
class FunctionInstance: public DataStructure
{
    private:
        // Nom Jeveux de la SD
        const std::string  _jeveuxName;
        // Vecteur Jeveux '.PROL'
        JeveuxVectorChar16 _property;
        // Vecteur Jeveux '.VALE'
        JeveuxVectorDouble _value;

        // Parameter name
        std::string _parameterName;
        // Result name
        std::string _resultName;
        // Abscissa
        VectorDouble _absc;
        // Ordinates
        VectorDouble _ord;

    public:
        /**
        * Constructeur
        */
        FunctionInstance();

        /**
        * @brief Definition of the name of the parameter (abscissa)
        * @param name name of the parameter
        * @type  name string
        */
        void setParameterName( const std::string name )
        {
            _parameterName = name;
        }

        /**
        * @brief Definition of the name of the result (ordinate)
        * @param name name of the result
        * @type  name string
        */
        void setResultName( const std::string name )
        {
            _resultName = name;
        }

        /**
        * @brief Assign the values of the function
        * @param absc values of the abscissa
        * @type  absc vector of double
        * @param ord values of the ordinates
        * @type  ord vector of double
        */
        void setValues( const VectorDouble &absc, const VectorDouble &ord );

        /**
        * Build Jeveux objects of the function
        * @return true if the creation is ok
        */
        bool build();

};

/**
* @typedef FunctionPtr
* @brief  Pointer to a FunctionInstance
* @author Mathieu Courtois
*/
typedef boost::shared_ptr< FunctionInstance > FunctionPtr;

#endif /* FUNCTION_H_ */
