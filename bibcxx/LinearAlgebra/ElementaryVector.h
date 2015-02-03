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
        /** @typedef std::list de MechanicalLoad */
        typedef list< MechanicalLoad > ListMechanicalLoad;
        /** @typedef Iterateur sur une std::list de MechanicalLoad */
        typedef ListMechanicalLoad::iterator ListMechanicalLoadIter;

        /** @brief Objet Jeveux '.RERR' */
        JeveuxVectorChar24     _description;
        /** @brief Objet Jeveux '.RELR' */
        JeveuxVectorChar24     _listOfElementaryResults;
        /** @brief Booleen indiquant si la sd est vide */
        bool                   _isEmpty;
        /** @brief Champ de materiau a utiliser */
        MaterialOnMesh         _material;
        /** @brief Charges ajoutees aux vecteurs elementaires */
        list< MechanicalLoad > _listOfMechanicalLoad;

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
        void addMechanicalLoad( const MechanicalLoad& currentLoad )
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
         * @param currentMaterial objet MaterialOnMesh
         */
        void setMaterialOnMesh( const MaterialOnMesh& currentMaterial )
        {
            _material = currentMaterial;
        };
};

/**
 * @class ElementaryVector
 * @brief Enveloppe d'un pointeur intelligent vers un ElementaryVectorInstance
 * @author Nicolas Sellenet
 */
class ElementaryVector
{
    public:
        typedef boost::shared_ptr< ElementaryVectorInstance > ElementaryVectorPtr;

    private:
        ElementaryVectorPtr _elementaryVectorPtr;

    public:
        ElementaryVector(bool initialisation = true): _elementaryVectorPtr()
        {
            if ( initialisation == true )
                _elementaryVectorPtr = ElementaryVectorPtr( new ElementaryVectorInstance() );
        };

        ~ElementaryVector()
        {};

        ElementaryVector& operator=(const ElementaryVector& tmp)
        {
            _elementaryVectorPtr = tmp._elementaryVectorPtr;
            return *this;
        };

        const ElementaryVectorPtr& operator->() const
        {
            return _elementaryVectorPtr;
        };

        ElementaryVectorInstance& operator*(void) const
        {
            return *_elementaryVectorPtr;
        };

        bool isEmpty() const
        {
            if ( _elementaryVectorPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* ELEMENTARYVECTOR_H_ */
