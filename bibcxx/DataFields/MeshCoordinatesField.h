#ifndef MESHCOORDINATESFIELD_H_
#define MESHCOORDINATESFIELD_H_

/**
 * @file MeshCoordinatesField.h
 * @brief Fichier entete de la classe MeshCoordinatesField
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
 *
 *   This file is part of Code_Aster.
 *
 *   Code_Aster is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
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

#include "MemoryManager/JeveuxVector.h"
#include "DataStructures/DataStructure.h"

/** @brief Forward declaration of FieldOnNodesClass */
template < class ValueType > class FieldOnNodesClass;

typedef FieldOnNodesClass< double > FieldOnNodesRealClass;

/**
 * @class MeshCoordinatesFieldClass
 * @brief Cette classe template permet de definir un champ aux noeuds Aster
 * @author Nicolas Sellenet
 */
class MeshCoordinatesFieldClass : public DataStructure {
  private:
    /** @brief Vecteur Jeveux '.DESC' */
    JeveuxVectorLong _descriptor;
    /** @brief Vecteur Jeveux '.REFE' */
    JeveuxVectorChar24 _reference;
    /** @brief Vecteur Jeveux '.VALE' */
    JeveuxVectorReal _valuesList;

    friend FieldOnNodesRealClass;

  public:
    /**
     * @typedef MeshCoordinatesFieldPtr
     * @brief Pointeur intelligent vers un MeshCoordinatesField
     */
    typedef boost::shared_ptr< MeshCoordinatesFieldClass > MeshCoordinatesFieldPtr;

    /**
     * @brief Constructeur
     * @param name Nom Jeveux du champ aux noeuds
     */
    MeshCoordinatesFieldClass( const std::string &name )
        : DataStructure( name, 19, "CHAM_NO" ),
          _descriptor( JeveuxVectorLong( getName() + ".DESC" ) ),
          _reference( JeveuxVectorChar24( getName() + ".REFE" ) ),
          _valuesList( JeveuxVectorReal( getName() + ".VALE" ) ) {
        assert( name.size() == 19 );
    };

    /**
     * @brief Get _descriptor
     */
    const JeveuxVectorLong getFieldDescriptor() const { return _descriptor; };

    /**
     * @brief Get _reference
     */
    const JeveuxVectorChar24 getFieldReference() const { return _reference; };

    /**
     * @brief Get _valuesList
     */
    const JeveuxVectorReal getFieldValues() const { return _valuesList; };

    /**
     * @brief Surcharge de l'operateur []
     * @param i Indice dans le tableau Jeveux
     * @return la valeur du tableau Jeveux a la position i
     */
    double operator[]( int i ) const { return _valuesList->operator[]( i ); };

    /**
     * @brief Mise a jour des pointeurs Jeveux
     * @return renvoie true si la mise a jour s'est bien deroulee, false sinon
     */
    bool updateValuePointers() const {
        bool retour = _descriptor->updateValuePointer();
        retour = ( retour && _reference->updateValuePointer() );
        retour = ( retour && _valuesList->updateValuePointer() );
        return retour;
    };
};

/**
 * @typedef MeshCoordinatesFieldPtr
 * @brief Definition d'un champ aux noeuds de double
 */
typedef boost::shared_ptr< MeshCoordinatesFieldClass > MeshCoordinatesFieldPtr;

/**
 * @typedef MeshCoordinatesFieldPtr
 * @brief Definition d'un champ aux noeuds de double
 */
typedef boost::shared_ptr< const MeshCoordinatesFieldClass > ConstMeshCoordinatesFieldPtr;

#endif /* MESHCOORDINATESFIELD_H_ */
