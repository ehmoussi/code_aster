
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef PARALLELMECHANICALLOAD_H_
#define PARALLELMECHANICALLOAD_H_

/**
 * @file ParallelMechanicalLoad.h
 * @brief Fichier entete de la classe ParallelMechanicalLoad
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "astercxx.h"
#include "Modeling/Model.h"
#include "Loads/MechanicalLoad.h"

/**
 * @class ParallelMechanicalLoadInstance
 * @brief Classe definissant une charge dualisée parallèle
 * @author Nicolas Sellenet
 */
class ParallelMechanicalLoadInstance: public GenericMechanicalLoadInstance
{
protected:

public:
    /**
     * @brief Constructeur
     */
    ParallelMechanicalLoadInstance( GenericMechanicalLoadPtr& load );

    /**
     * @typedef ParallelMechanicalLoadPtr
     * @brief Pointeur intelligent vers un ParallelMechanicalLoad
     */
    typedef boost::shared_ptr< ParallelMechanicalLoadInstance > ParallelMechanicalLoadPtr;

    /**
     * @brief Constructeur
     */
    static ParallelMechanicalLoadPtr create( GenericMechanicalLoadPtr& load )
    {
        return ParallelMechanicalLoadPtr( new ParallelMechanicalLoadInstance( load ) );
    };
};

/**
 * @typedef ParallelMechanicalLoadPtr
 * @brief Pointeur intelligent vers un ParallelMechanicalLoadInstance
 */
typedef boost::shared_ptr< ParallelMechanicalLoadInstance > ParallelMechanicalLoadPtr;


#endif /* PARALLELMECHANICALLOAD_H_ */

#endif /* _USE_MPI */
