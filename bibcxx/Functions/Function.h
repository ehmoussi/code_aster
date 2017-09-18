#ifndef FUNCTION_H_
#define FUNCTION_H_

/* person_in_charge: mathieu.courtois@edf.fr */
#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>

#include "DataStructures/DataStructure.h"
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
        JeveuxVectorChar24 _property;
        // Vecteur Jeveux '.VALE'
        JeveuxVectorDouble _value;

        void propertyAllocate()
        {
            // Create Jeveux vector ".PROL"
            _property->allocate( Permanent, 6 );
            (*_property)[0] = "FONCTION";
            (*_property)[1] = "LIN LIN";
            (*_property)[2] = "";
            (*_property)[3] = "TOUTRESU";
            (*_property)[4] = "EE";
            (*_property)[5] = _jeveuxName;
        };

    public:
        /**
         * @typedef FunctionPtr
         * @brief Pointeur intelligent vers un Function
         */
        typedef boost::shared_ptr< FunctionInstance > FunctionPtr;

        /**
         * @brief Constructeur
         */
        static FunctionPtr create()
        {
            return FunctionPtr( new FunctionInstance );
        };

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
            if( !_property->isAllocated() )
                propertyAllocate();
            (*_property)[2] = name.c_str();
        }

        /**
        * @brief Definition of the name of the result (ordinate)
        * @param name name of the result
        * @type  name string
        */
        void setResultName( const std::string name )
        {
            if( !_property->isAllocated() )
                propertyAllocate();
            (*_property)[3] = name.c_str();
        }

        /**
        * @brief Definition of the type of interpolation
        * @param interpolation type of interpolation
        * @type  interpolation string
        * @todo checking
        */
        void setInterpolation( const std::string type ) throw ( std::runtime_error );

        /**
        * @brief Definition of the type of extrapolation
        * @param extrapolation type of extrapolation
        * @type  extrapolation string
        * @todo checking
        */
        void setExtrapolation( const std::string type ) throw ( std::runtime_error );

        /**
        * @brief Assign the values of the function
        * @param absc values of the abscissa
        * @type  absc vector of double
        * @param ord values of the ordinates
        * @type  ord vector of double
        */
        void setValues( const VectorDouble &absc, const VectorDouble &ord ) throw ( std::runtime_error );

        /**
        * @brief Return the values of the function as an unidimensional vector
        */
        std::vector<double> getValues() const
        {
            _value->updateValuePointer();
            const double* ptr = getDataPtr();
            std::vector<double> vect( ptr, ptr + _value->size() );
            return vect;
        }

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
            _property->updateValuePointer();
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
