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
    typedef std::list< GenericMechanicalLoadPtr > ListMecaLoad;
    /** @typedef Iterateur sur une std::list de MechanicalLoad */
    typedef ListMecaLoad::iterator ListMecaLoadIter;

    /** @brief Objet Jeveux '.RERR' */
    JeveuxVectorChar24 _description;
    /** @brief Objet Jeveux '.RELR' */
    JeveuxVectorChar24 _listOfElementaryResults;
    /** @brief Booleen indiquant si la sd est vide */
    bool               _isEmpty;

public:
    /**
     * @brief Constructeur
     */
    ElementaryMatrixInstance( const JeveuxMemory memType = Permanent );

    /**
     * @brief Constructeur
     */
    ElementaryMatrixInstance( std::string type, const JeveuxMemory memType = Permanent );

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
     * @brief Methode permettant de savoir si les matrices elementaires sont vides
     * @return true si les matrices elementaires sont vides
     */
    bool isEmpty()
    {
        return _isEmpty;
    };

    /**
     * @brief Methode permettant de changer l'état de remplissage
     * @param bEmpty booleen permettant de dire que l'objet est vide ou pas
     */
    void setEmpty( bool bEmpty )
    {
        _isEmpty = bEmpty;
    };

    friend class DiscreteProblemInstance;
};

/**
 * @typedef ElementaryMatrixPtr
 * @brief Pointeur intelligent vers un ElementaryMatrixInstance
 */
typedef boost::shared_ptr< ElementaryMatrixInstance > ElementaryMatrixPtr;

#endif /* ELEMENTARYMATRIX_H_ */
