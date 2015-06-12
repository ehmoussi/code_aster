#ifndef DOFNUMBERING_H_
#define DOFNUMBERING_H_

/**
 * @file DOFNumbering.h
 * @brief Fichier entete de la classe DOFNumbering
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

#include <stdexcept>
#include "astercxx.h"
#include <string>

#include "DataStructure/DataStructure.h"
#include "LinearAlgebra/LinearSolver.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/KinematicsLoad.h"
#include "Loads/ListOfLoads.h"

/**
 * @class DOFNumberingInstance
 * @brief Class definissant un nume_ddl
 *        Cette classe est volontairement succinte car on n'en connait pas encore l'usage
 * @author Nicolas Sellenet
 */
class DOFNumberingInstance: public DataStructure
{
    private:
        // !!! Classe succinte car on ne sait pas comment elle sera utiliser !!!
        /** @brief Objet Jeveux '.NSLV' */
        JeveuxVectorChar24       _nameOfSolverDataStructure;
        /** @brief Modele support */
        ModelPtr                 _supportModel;
        /** @brief Matrices elementaires */
        ElementaryMatrixPtr      _supportMatrix;
        /** @brief Chargements */
        ListOfLoadsPtr           _listOfLoads;
        /** @brief Solveur lineaire */
        LinearSolverPtr          _linearSolver;
        /** @brief Booleen permettant de preciser sur la sd est vide */
        bool                     _isEmpty;

    public:
        /**
         * @brief Constructeur
         */
        DOFNumberingInstance();

        /**
         * @brief Constructeur
         * @param name nom souhaité de la sd (utile pour le DOFNumberingInstance d'une sd_resu)
         */
        DOFNumberingInstance( const std::string name );

        /**
         * @brief Destructeur
         */
        ~DOFNumberingInstance()
        {
#ifdef __DEBUG_GC__
            std::cout << "DOFNumberingInstance.destr: " << this->getName() << std::endl;
#endif
        };

        /**
         * @brief Function d'ajout d'une charge cinematique
         * @param currentLoad charge a ajouter a la sd
         */
        void addKinematicsLoad( const KinematicsLoadPtr& currentLoad )
        {
            _listOfLoads->addKinematicsLoad( currentLoad );
        };

        /**
         * @brief Function d'ajout d'une charge mecanique
         * @param currentLoad charge a ajouter a la sd
         */
        void addMechanicalLoad( const GenericMechanicalLoadPtr& currentLoad )
        {
            _listOfLoads->addMechanicalLoad( currentLoad );
        };

        /**
         * @brief Determination de la numerotation
         */
        bool computeNumerotation() throw ( std::runtime_error );

        /**
         * @brief Methode permettant d'obtenir le solveur
         * @return _linearSolver
         */
        LinearSolverPtr getLinearSolver()
        {
            return _linearSolver;
        };

        /**
         * @brief Methode permettant de savoir si la numerotation est vide
         * @return true si la numerotation est vide
         */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
         * @brief Methode permettant de definir les matrices elementaires
         * @param currentMatrix objet ElementaryMatrix
         */
        void setElementaryMatrix( const ElementaryMatrixPtr& currentMatrix ) throw ( std::runtime_error )
        {
            if ( _supportModel )
                throw std::runtime_error( "It is not allowed to defined Model and ElementaryMatrix together" );
            _supportMatrix = currentMatrix;
        };

        /**
         * @brief Methode permettant de definir le solveur
         * @param currentModel Model support de la numerotation
         */
        void setLinearSolver( const LinearSolverPtr& currentSolver ) throw ( std::runtime_error )
        {
            if ( ! _isEmpty )
                throw std::runtime_error( "It is too late to set the linear solver" );
            _linearSolver = currentSolver;
        };

        /**
         * @brief Methode permettant de definir le modele support
         * @param currentModel Model support de la numerotation
         */
        void setSupportModel( const ModelPtr& currentModel ) throw ( std::runtime_error )
        {
            if ( ! _supportMatrix.use_count() == 0 )
                throw std::runtime_error( "It is not allowed to defined Model and ElementaryMatrix together" );
            _supportModel = currentModel;
        };
};

/**
 * @typedef DOFNumberingPtr
 * @brief Enveloppe d'un pointeur intelligent vers un DOFNumberingInstance
 * @author Nicolas Sellenet
 */
typedef boost::shared_ptr< DOFNumberingInstance > DOFNumberingPtr;

#endif /* DOFNUMBERING_H_ */
