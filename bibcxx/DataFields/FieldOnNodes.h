#ifndef FIELDONNODES_H_
#define FIELDONNODES_H_

/**
 * @file FieldOnNodes.h
 * @brief Fichier entete de la classe FieldOnNodes
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

#include <string>
#include <assert.h>

#include "astercxx.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxVector.h"
#include "DataStructure/DataStructure.h"

/**
 * @class FieldOnNodesInstance
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Nicolas Sellenet
 */
template< class ValueType >
class FieldOnNodesInstance: public DataStructure
{
    private:
        /** @brief Vecteur Jeveux '.DESC' */
        JeveuxVectorLong        _descriptor;
        /** @brief Vecteur Jeveux '.REFE' */
        JeveuxVectorChar24      _reference;
        /** @brief Vecteur Jeveux '.VALE' */
        JeveuxVector<ValueType> _valuesList;

    public:
        /**
         * @brief Constructeur
         * @param name Nom Jeveux du champ aux noeuds
         */
        FieldOnNodesInstance( std::string name ):
                        DataStructure( name, "CHAM_NO" ),
                        _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
                        _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
                        _valuesList( JeveuxVector< ValueType >( getName() + ".VALE" ) )
        {
            assert(name.size() == 19);
        };

        ~FieldOnNodesInstance()
        {
#ifdef __DEBUG_GC__
            std::cout << "FieldOnNodes.destr: " << this->getName() << std::endl;
#endif
        }

        /**
         * @brief Surcharge de l'operateur []
         * @param i Indice dans le tableau Jeveux
         * @return la valeur du tableau Jeveux a la position i
         */
        const ValueType &operator[](int i) const
        {
            return _valuesList->operator[](i);
        };

        /**
         * @brief Mise a jour des pointeurs Jeveux
         * @return renvoit true si la mise a jour s'est bien deroulee, false sinon
         */
        bool updateValuePointers()
        {
            bool retour = _descriptor->updateValuePointer();
            retour = ( retour && _reference->updateValuePointer() );
            retour = ( retour && _valuesList->updateValuePointer() );
            return retour;
        };
};


/** @typedef FieldOnNodesInstanceDouble Instance d'une carte de double */
typedef FieldOnNodesInstance< double > FieldOnNodesInstanceDouble;

/**
 * @typedef FieldOnNodesPtrDouble
 * @brief Definition d'un champ aux noeuds de double
 */
typedef boost::shared_ptr< FieldOnNodesInstanceDouble > FieldOnNodesPtrDouble;

#endif /* FIELDONNODES_H_ */
