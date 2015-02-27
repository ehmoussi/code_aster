#ifndef FORWARDDOFNUMBERING_H_
#define FORWARDDOFNUMBERING_H_

/**
 * @file ForwardDOFNumbering.h
 * @brief Fichier entete de la classe ForwardDOFNumbering
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
 * @brief Forward decalaration de DOFNumberingInstance pour éviter la référence circulaire
 */
class DOFNumberingInstance;
typedef boost::shared_ptr< DOFNumberingInstance > DOFNumberingPtr;

/**
 * @class ForwardDOFNumberingPtr
 * @brief Classe enveloppe de DOFNumberingPtr utile uniquement pour AssemblyMatrixInstance
 * @author Nicolas Sellenet
 */
class ForwardDOFNumberingPtr
{
    private:
        /** @brief Pointeur intelligent vers une DOFNumberingInstance */
        DOFNumberingPtr _curDOFNum;

    public:
        /**
         * @brief Constructeur
         */
        ForwardDOFNumberingPtr()
        {};

        /**
         * @brief Constructeur à partir d'un DOFNumberingPtr
         * @param curTmp objet DOFNumberingPtr
         */
        ForwardDOFNumberingPtr( const DOFNumberingPtr& curTmp ): _curDOFNum( curTmp )
        {};

        /**
         * @brief Methode permettant de savoir si les matrices elementaires sont vides
         * @return true le DOFNumberingInstance ou le pointeur sont vides
         */
        bool isEmpty() const;

        /**
         * @brief Methode permettant de récupérer le nom de la DOFNumberingInstance
         * @return std::string contenant le nom
         */
        std::string getName() const;
};

#endif /* FORWARDDOFNUMBERING_H_ */
