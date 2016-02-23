#ifndef TIMESTEPPER_H_
#define TIMESTEPPER_H_

/**
 * @file TimeStepper.h
 * @brief Fichier entete de la classe TimeStepper
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "MemoryManager/JeveuxVector.h"
#include "DataStructure/DataStructure.h"
#include "Algorithms/GenericStepper.h"

typedef std::vector< double > VectorDouble;
typedef VectorDouble::const_iterator VectorDoubleCIter;

/**
 * @class TimeStepperInstance
 * @brief Cette classe permet de definir une liste d'instants
 * @author Nicolas Sellenet
 */
class TimeStepperInstance: public DataStructure, public GenericStepper
{
    private:
        /** @brief Liste des instants */
        JeveuxVectorDouble _values;

    public:
        /**
         * @brief Constructeur
         */
        TimeStepperInstance( JeveuxMemory memType = Permanent ):
            DataStructure( "LIST_INST", memType ),
            _values( getName() + ".LIST" )
        {
            VectorDouble tmp( 1, 0. );
            setValues( tmp );
        };

        /**
         * @brief Destructeur
         */
        ~TimeStepperInstance()
        {};

        struct const_iterator
        {
            double* position;

            inline const_iterator(): position( NULL )
            {};

            inline const_iterator( double* memoryPosition ): position( memoryPosition )
            {};

            inline const_iterator( const const_iterator& iter ): position( iter.position )
            {};

            inline const_iterator& operator=( const const_iterator& testIter )
            {
                position = testIter.position;
                return *this;
            };

            inline const_iterator& operator++()
            {
                ++position;
                return *this;
            };

            inline bool operator==( const const_iterator& testIter ) const
            {
                if ( testIter.position != position ) return false;
                return true;
            };

            inline bool operator!=( const const_iterator& testIter ) const
            {
                if ( testIter.position != position ) return true;
                return false;
            };

            inline const double& operator->() const
            {
                return *position;
            };

            inline const double& operator*() const
            {
                return *position;
            };
        };

        /**
         * @brief 
         * @return 
         */
        const_iterator begin() const
        {
            return const_iterator( &( *_values )[0] );
        };

        /**
         * @brief 
         * @return 
         */
        const_iterator end() const
        {
//             return const_iterator( &( *_values )[ _values->size() - 1 ] );
            return const_iterator( &( *_values )[ _values->size() ] );
        };

        /**
         * @brief Fonction permettant de fixer la liste de pas de temps
         * @param values Liste des valeurs
         */
        bool setValues( const VectorDouble& values ) throw ( std::runtime_error );

        /**
         * @brief Fonction permettant de connaître le nombre de pas de temps
         * @return nombre de pas de temps
         */
        bool size() const
        {
            return _values->size();
        };
};


/**
 * @typedef TimeStepperPtr
 * @brief Pointeur intelligent vers un TimeStepper
 */
typedef boost::shared_ptr< TimeStepperInstance > TimeStepperPtr;

#endif /* TIMESTEPPER_H_ */
