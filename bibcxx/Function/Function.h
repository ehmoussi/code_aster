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
        /** @todo remettre le const */
        std::string  _jeveuxName;
        // Vecteur Jeveux '.PROL'
        JeveuxVectorChar16 _property;
        // Vecteur Jeveux '.VALE'
        JeveuxVectorDouble _value;

    public:
        /**
        * Constructeur
        */
        FunctionInstance();

        FunctionInstance( const std::string jeveuxName );

        /**
        * @brief Definition of the name of the parameter (abscissa)
        * @param name name of the parameter
        * @type  name string
        */
        void setParameterName( const std::string name )
        {
            (*_property)[2] = name.c_str();
        }

        /**
        * @brief Definition of the name of the result (ordinate)
        * @param name name of the result
        * @type  name string
        */
        void setResultName( const std::string name )
        {
            (*_property)[3] = name.c_str();
        }

        /**
        * @brief Definition of the type of interpolation
        * @param interpolation type of interpolation
        * @type  interpolation string
        * @todo checking
        */
        void setInterpolation( const std::string type )
        {
            (*_property)[1] = type.c_str();
        }

        /**
        * @brief Definition of the type of extrapolation
        * @param extrapolation type of extrapolation
        * @type  extrapolation string
        * @todo checking
        */
        void setExtrapolation( const std::string type )
        {
            (*_property)[4] = type.c_str();
        }

        /**
        * @brief Assign the values of the function
        * @param absc values of the abscissa
        * @type  absc vector of double
        * @param ord values of the ordinates
        * @type  ord vector of double
        */
        void setValues( const VectorDouble &absc, const VectorDouble &ord ) throw ( std::runtime_error );

        /**
        * @brief Return a pointer to the vector of data
        */
        const double* getDataPtr() const
        {
            return _value->getDataPtr();
        }

        /**
        * @brief Return the number of points of the function
        */
        long size() const
        {
            return _value->size() / 2;
        }

        /**
        * @brief Return the properties of the function
        * @return vector of strings
        */
        std::vector< std::string > getProperties() const
        {
            std::vector< std::string > prop;
            for ( int i = 0; i < 6; ++i )
            {
                prop.push_back( (*_property)[i].rstrip() );
            }
            return prop;
        }

        /**
         * @brief Update the pointers to the Jeveux objects
         * @return Return true if ok
         */
        bool build( )
        {
            return _property->updateValuePointer() && _value->updateValuePointer();
        }

};

/**
* @typedef FunctionPtr
* @brief  Pointer to a FunctionInstance
* @author Mathieu Courtois
*/
typedef boost::shared_ptr< FunctionInstance > FunctionPtr;

#endif /* FUNCTION_H_ */
