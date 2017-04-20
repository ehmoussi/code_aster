#ifndef FORWARDLINEARSOLVER_H_
#define FORWARDLINEARSOLVER_H_

/**
 * @file ForwardLinearSolver.h
 * @brief Fichier entete de la classe ForwardLinearSolver
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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

/**
 * @brief Forward declaration de LinearSolverInstance pour éviter la référence circulaire
 * @todo A SUPPRIMER
 */
class LinearSolverInstance;
typedef boost::shared_ptr< LinearSolverInstance > LinearSolverPtr;

/**
 * @class ForwardLinearSolverPtr
 * @brief Classe enveloppe de LinearSolverPtr utile uniquement pour AssemblyMatrixInstance
 * @author Nicolas Sellenet
 */
class ForwardLinearSolverPtr
{
    private:
        /** @brief Pointeur intelligent vers une LinearSolverInstance */
        LinearSolverPtr _curLinSolv;

    public:
        /**
         * @brief Constructeur
         */
        ForwardLinearSolverPtr()
        {};

        /**
         * @brief Constructeur à partir d'un LinearSolverPtr
         * @param curTmp objet LinearSolverPtr
         */
        ForwardLinearSolverPtr( const LinearSolverPtr& curTmp ): _curLinSolv( curTmp )
        {};

        /**
         * @brief Methode permettant de savoir si les matrices elementaires sont vides
         * @return true le LinearSolverInstance ou le pointeur sont vides
         */
        bool isEmpty() const;

        /**
         * @brief Methode permettant de récupérer le nom de la LinearSolverInstance
         * @return std::string contenant le nom
         */
        std::string getName() const;

        bool operator!() const
        {
            return ! _curLinSolv;
        };

        LinearSolverInstance& operator->()
        {
            return *_curLinSolv;
        };
};

#endif /* FORWARDLINEARSOLVER_H_ */
