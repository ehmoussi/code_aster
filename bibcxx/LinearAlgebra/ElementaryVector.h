#ifndef ELEMENTARYVECTOR_H_
#define ELEMENTARYVECTOR_H_

/**
 * @file ElementaryVector.h
 * @brief Fichier entete de la classe ElementaryVector
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

#include "astercxx.h"
#include "DataStructure/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Materials/MaterialOnMesh.h"
#include "Loads/MechanicalLoad.h"
#include "DataFields/FieldOnNodes.h"
#include "LinearAlgebra/DOFNumbering.h"

/**
 * @class ElementaryVectorInstance
 * @brief Class definissant une sd_vect_elem
 * @author Nicolas Sellenet
 */
class ElementaryVectorInstance: public DataStructure
{
    private:
        /** @todo  */
        typedef int MechanicalLoad;
        /** @typedef std::list de MechanicalLoad */
        typedef std::list< MechanicalLoad > ListMechanicalLoad;
        /** @typedef Iterateur sur une std::list de MechanicalLoad */
        typedef ListMechanicalLoad::iterator ListMechanicalLoadIter;

        /** @brief Objet Jeveux '.RERR' */
        JeveuxVectorChar24     _description;
        /** @brief Objet Jeveux '.RELR' */
        JeveuxVectorChar24     _listOfElementaryResults;
        /** @brief Booleen indiquant si la sd est vide */
        bool                   _isEmpty;
        /** @brief Champ de materiau a utiliser */
        MaterialOnMeshPtr      _materialOnMesh;

        /** @brief Charges ajoutees aux vecteurs elementaires */
        std::list< GenericMechanicalLoadPtr > _listOfMechanicalLoad;

    public:
        /**
         * @brief Constructeur
         */
        ElementaryVectorInstance();

        /**
         * @brief Destructeur
         */
        ~ElementaryVectorInstance()
        {
#ifdef __DEBUG_GC__
            std::cout << "ElementaryVectorInstance.destr: " << this->getName() << std::endl;
#endif
        };

        /**
         * @brief Ajouter une charge mecanique
         * @param currentLoad objet MechanicalLoad
         */
        void addMechanicalLoad( const GenericMechanicalLoadPtr currentLoad )
        {
            _listOfMechanicalLoad.push_back( currentLoad );
        };

        /**
         * @brief Assembler les vecteurs elementaires en se fondant sur currentNumerotation
         * @param currentNumerotation objet DOFNumbering
         */
        FieldOnNodesPtrDouble assembleVector( const DOFNumbering& currentNumerotation ) throw ( std::runtime_error );

        /**
         * @brief Calcul des matrices elementaires pour l'option CHAR_MECA
         */
        bool computeMechanicalLoads() throw ( std::runtime_error );

        /**
         * @brief Methode permettant de savoir si les matrices elementaires sont vides
         * @return true si les matrices elementaires sont vides
         */
        bool isEmpty()
        {
            return _isEmpty;
        };

        /**
         * @brief Methode permettant de definir le champ de materiau
         * @param currentMaterial objet MaterialOnMeshPtr
         */
        void setMaterialOnMesh( const MaterialOnMeshPtr& currentMaterial )
        {
            _materialOnMesh = currentMaterial;
        };
};

/**
 * @typedef ElementaryVectorPtr
 * @brief Pointeur intelligent vers un ElementaryVectorInstance
 */
typedef boost::shared_ptr< ElementaryVectorInstance > ElementaryVectorPtr;

#endif /* ELEMENTARYVECTOR_H_ */
