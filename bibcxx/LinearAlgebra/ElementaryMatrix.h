#ifndef ELEMENTARYMATRIX_H_
#define ELEMENTARYMATRIX_H_

/**
 * @file ElementaryMatrix.h
 * @brief Fichier entete de la classe ElementaryMatrix
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
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"
#include "Loads/MechanicalLoad.h"

/**
 * @class ElementaryMatrixInstance
 * @brief Class definissant une sd_matr_elem
 * @author Nicolas Sellenet
 */
class ElementaryMatrixInstance: public DataStructure
{
    private:
        /** @typedef std::list de MechanicalLoad */
        typedef std::list< MechanicalLoad > ListMecaLoad;
        /** @typedef Iterateur sur une std::list de MechanicalLoad */
        typedef ListMecaLoad::iterator ListMecaLoadIter;

        /** @brief Objet Jeveux '.RERR' */
        JeveuxVectorChar24 _description;
        /** @brief Objet Jeveux '.RELR' */
        JeveuxVectorChar24 _listOfElementaryResults;
        /** @brief Booleen indiquant si la sd est vide */
        bool               _isEmpty;
        /** @brief Modele support */
        ModelPtr           _supportModel;
        /** @brief Champ de materiau a utiliser */
        MaterialOnMesh     _material;
        /** @brief Chargements Mecaniques */
        ListMecaLoad       _listOfMechanicalLoads;

    public:
        /**
         * @brief Constructeur
         */
        ElementaryMatrixInstance();

        /**
         * @brief Destructeur
         */
        ~ElementaryMatrixInstance()
        {
#ifdef __DEBUG_GC__
            std::cout << "ElementaryMatrixInstance.destr: " << this->getName() << std::endl;
#endif
        };

        /**
         * @brief Function d'ajout d'une charge mecanique
         * @param currentLoad charge a ajouter a la sd
         */
        void addMechanicalLoad( const MechanicalLoad& currentLoad )
        {
            _listOfMechanicalLoads.push_back( currentLoad );
        };

        /**
         * @brief Calcul des matrices elementaires pour l'option RIGI_MECA
         */
        bool computeMechanicalRigidity() throw ( std::runtime_error );

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

        /**
         * @brief Methode permettant de definir le modele support
         * @param currentModel Model support des matrices elementaires
         */
        void setSupportModel( const ModelPtr& currentModel )
        {
            _supportModel = currentModel;
        };
};

/**
 * @class ElementaryMatrix
 * @brief Enveloppe d'un pointeur intelligent vers un ElementaryMatrixInstance
 * @author Nicolas Sellenet
 */
class ElementaryMatrix
{
    public:
        typedef boost::shared_ptr< ElementaryMatrixInstance > ElementaryMatrixPtr;

    private:
        ElementaryMatrixPtr _elementaryMatrixPtr;

    public:
        ElementaryMatrix(bool initialisation = true): _elementaryMatrixPtr()
        {
            if ( initialisation == true )
                _elementaryMatrixPtr = ElementaryMatrixPtr( new ElementaryMatrixInstance() );
        };

        ~ElementaryMatrix()
        {};

        ElementaryMatrix& operator=(const ElementaryMatrix& tmp)
        {
            _elementaryMatrixPtr = tmp._elementaryMatrixPtr;
            return *this;
        };

        const ElementaryMatrixPtr& operator->() const
        {
            return _elementaryMatrixPtr;
        };

        ElementaryMatrixInstance& operator*(void) const
        {
            return *_elementaryMatrixPtr;
        };

        bool isEmpty() const
        {
            if ( _elementaryMatrixPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* ELEMENTARYMATRIX_H_ */
