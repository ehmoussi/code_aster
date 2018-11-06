
#include "astercxx.h"

#ifdef _USE_MPI

#ifndef PARALLELDOFNUMBERING_H_
#define PARALLELDOFNUMBERING_H_

/**
 * @file ParallelDOFNumbering.h
 * @brief Fichier entete de la classe ParallelDOFNumbering
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "Discretization/DOFNumbering.h"

/**
 * @class ParallelDOFNumberingInstance
 * @brief Cette classe decrit un maillage Aster parallèle
 * @author Nicolas Sellenet
 */
class ParallelDOFNumberingInstance : public BaseDOFNumberingInstance {
  private:
  public:
    /**
     * @typedef ParallelDOFNumberingPtr
     * @brief Pointeur intelligent vers un ParallelDOFNumberingInstance
     */
    typedef boost::shared_ptr< ParallelDOFNumberingInstance > ParallelDOFNumberingPtr;

    /**
     * @brief Constructeur
     */
    ParallelDOFNumberingInstance( const JeveuxMemory memType = Permanent )
        : BaseDOFNumberingInstance( "NUME_DDL_P", memType ){};

    /**
     * @brief Constructeur
     * @param name nom souhaité de la sd (utile pour le BaseDOFNumberingInstance d'une sd_resu)
     */
    ParallelDOFNumberingInstance( const std::string name, const JeveuxMemory memType = Permanent )
        : BaseDOFNumberingInstance( name, "NUME_DDL_P", memType ){};

    /**
     * @brief Destructeur
     */
    ~ParallelDOFNumberingInstance() throw( std::runtime_error ) {
#ifdef __DEBUG_GC__
        std::cout << "ParallelDOFNumbering.destr: " << this->getName() << std::endl;
#endif
    };

    /**
     * @brief Methode permettant de savoir si l'objet est parallel
     * @return true
     */
    bool isParallel() { return true; };

    /**
     * @brief Methode permettant de definir les matrices elementaires
     * @param currentMatrix objet ElementaryMatrix
     */
    void setElementaryMatrix( const ElementaryMatrixDisplacementDoublePtr &currentMatrix )
        throw( std::runtime_error )
    {
        if ( !currentMatrix->getSupportModel()->getSupportMesh()->isParallel() )
            throw std::runtime_error( "Support mesh must be parallel" );
        BaseDOFNumberingInstance::setElementaryMatrix( currentMatrix );
    };

    /**
     * @brief Methode permettant de definir les matrices elementaires
     * @param currentMatrix objet ElementaryMatrix
     */
    void setElementaryMatrix( const ElementaryMatrixDisplacementComplexPtr &currentMatrix )
        throw( std::runtime_error )
    {
        if ( !currentMatrix->getSupportModel()->getSupportMesh()->isParallel() )
            throw std::runtime_error( "Support mesh must be parallel" );
        BaseDOFNumberingInstance::setElementaryMatrix( currentMatrix );
    };

    /**
     * @brief Methode permettant de definir les matrices elementaires
     * @param currentMatrix objet ElementaryMatrix
     */
    void setElementaryMatrix( const ElementaryMatrixTemperatureDoublePtr &currentMatrix )
        throw( std::runtime_error )
    {
        if ( !currentMatrix->getSupportModel()->getSupportMesh()->isParallel() )
            throw std::runtime_error( "Support mesh must be parallel" );
        BaseDOFNumberingInstance::setElementaryMatrix( currentMatrix );
    };

    /**
     * @brief Methode permettant de definir les matrices elementaires
     * @param currentMatrix objet ElementaryMatrix
     */
    void setElementaryMatrix( const ElementaryMatrixPressureComplexPtr &currentMatrix )
        throw( std::runtime_error )
    {
        if ( !currentMatrix->getSupportModel()->getSupportMesh()->isParallel() )
            throw std::runtime_error( "Support mesh must be parallel" );
        BaseDOFNumberingInstance::setElementaryMatrix( currentMatrix );
    };

    /**
     * @brief Methode permettant de definir le modele support
     * @param currentModel Model support de la numerotation
     */
    void setSupportModel( const ModelPtr &currentModel ) throw( std::runtime_error ) {
        if ( !currentModel->getSupportMesh()->isParallel() )
            throw std::runtime_error( "Support mesh must be parallel" );
        BaseDOFNumberingInstance::setSupportModel( currentModel );
    };
};

/**
 * @typedef ParallelDOFNumberingPtr
 * @brief Pointeur intelligent vers un ParallelDOFNumberingInstance
 */
typedef boost::shared_ptr< ParallelDOFNumberingInstance > ParallelDOFNumberingPtr;

#endif /* PARALLELDOFNUMBERING_H_ */

#endif /* _USE_MPI */
