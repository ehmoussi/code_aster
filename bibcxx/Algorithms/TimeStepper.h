#ifndef TIMESTEPPER_H_
#define TIMESTEPPER_H_

/**
 * @file TimeStepper.h
 * @brief Fichier entete de la classe TimeStepper
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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
#include "astercxx.h"

#include "MemoryManager/JeveuxVector.h"
#include "DataStructures/DataStructure.h"
#include "Algorithms/GenericStepper.h"

typedef VectorReal::const_iterator VectorRealCIter;

/**
 * @class TimeStepperClass
 * @brief Cette classe permet de definir une liste d'instants
 * @author Nicolas Sellenet
 */
class TimeStepperClass : public DataStructure, public GenericStepper {
  private:
    /** @brief Liste des instants */
    JeveuxVectorReal _values;

  public:
    /**
     * @typedef TimeStepperPtr
     * @brief Pointeur intelligent vers un TimeStepper
     */
    typedef boost::shared_ptr< TimeStepperClass > TimeStepperPtr;

    /**
     * @brief Constructeur
     */
    TimeStepperClass( const std::string name, const JeveuxMemory memType = Permanent )
        : DataStructure( name, 8, "LIST_INST", memType ), _values( getName() + ".LIST" ){};

    /**
     * @brief Constructeur
     */
    TimeStepperClass( JeveuxMemory memType = Permanent )
        : TimeStepperClass( DataStructureNaming::getNewName( memType, 8 ), memType ){};

    /**
     * @brief Destructeur
     */
    ~TimeStepperClass(){};

    struct const_iterator {
        double *position;
        int rank;

        inline const_iterator() : position( NULL ), rank( 1 ){};

        inline const_iterator( double *memoryPosition, int curRank )
            : position( memoryPosition ), rank( curRank ){};

        inline const_iterator( const const_iterator &iter )
            : position( iter.position ), rank( iter.rank ){};

        inline const_iterator &operator=( const const_iterator &testIter ) {
            position = testIter.position;
            rank = testIter.rank;
            return *this;
        };

        inline const_iterator &operator++() {
            ++position;
            ++rank;
            return *this;
        };

        inline bool operator==( const const_iterator &testIter ) const {
            if ( testIter.position != position )
                return false;
            return true;
        };

        inline bool operator!=( const const_iterator &testIter ) const {
            if ( testIter.position != position )
                return true;
            return false;
        };

        inline const double &operator->() const { return *position; };

        inline const double &operator*() const { return *position; };
    };

    /**
     * @brief
     * @return
     */
    const_iterator begin() const { return const_iterator( &( *_values )[0], 1 ); };

    /**
     * @brief
     * @return
     */
    const_iterator end() const {
        //             return const_iterator( &( *_values )[ _values->size() - 1 ] );
        return const_iterator( &( *_values )[_values->size()], _values->size() );
    };

    /**
     * @brief Fonction permettant de mettre a jour le stepper
     * @return true si tout s'est bien passé
     */
    bool operator=( const VectorReal &vecReal ) {
        return setValues( vecReal );
    };

    /**
     * @brief Fonction permettant de fixer la liste de pas de temps
     * @param values Liste des valeurs
     */
    bool setValues( const VectorReal &values ) ;

    /**
     * @brief Fonction permettant de connaître le nombre de pas de temps
     * @return nombre de pas de temps
     */
    ASTERINTEGER size() const { return _values->size(); };

    /**
     * @brief Fonction permettant de mettre a jour le stepper
     * @return true si tout s'est bien passé
     */
    bool update() const { return _values->updateValuePointer(); };
};

/**
 * @typedef TimeStepperPtr
 * @brief Pointeur intelligent vers un TimeStepper
 */
typedef boost::shared_ptr< TimeStepperClass > TimeStepperPtr;

#endif /* TIMESTEPPER_H_ */
