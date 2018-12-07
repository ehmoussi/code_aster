#ifndef CODEDMATERIAL_H_
#define CODEDMATERIAL_H_

/**
 * @file CodedMaterial.h
 * @brief Fichier entete de la classe CodedMaterial
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

#include "astercxx.h"
#include "Materials/MaterialOnMesh.h"
#include "Modeling/Model.h"
#include "DataFields/PCFieldOnMesh.h"

/**
 * @class CodedMaterialInstance
 * @brief Coded material
 * @author Nicolas Sellenet
 */
class CodedMaterialInstance
{
private:
    std::string                       _name;
    std::string                       _type;
    MaterialOnMeshPtr                 _mater;
    ModelPtr                          _model;
    PCFieldOnMeshLongPtr              _field;
    JeveuxVectorChar8                 _grp;
    JeveuxVectorLong                  _nGrp;
    std::vector< JeveuxVectorLong >   _vecOfCodiVectors;
    std::vector< JeveuxVectorDouble > _vecOfR8;
    std::vector< JeveuxVectorLong >   _vecOfIa;

public:
    /**
     * @typedef CodedMaterialPtr
     * @brief Pointeur intelligent vers un CodedMaterial
     */
    typedef boost::shared_ptr< CodedMaterialInstance > CodedMaterialPtr;

    /**
     * @brief Constructeur
     */
    CodedMaterialInstance( const MaterialOnMeshPtr& mater, const ModelPtr& model );

    /**
     * @brief Destructeur
     */
    ~CodedMaterialInstance()
    {
        return;
    };

    /**
     * @brief Function to allocate the coded material
     * @return return false if coded material already exists
     */
    bool allocate( bool force = false );

    /**
     * @brief Function to know if elastic properties depend of a function
     */
    bool constant() const;

    /**
     * @brief Get the .MATE_CODE
     */
    PCFieldOnMeshLongPtr getCodedMaterialField() const
    {
        _field->updateValuePointers();
        return _field;
    };

    /**
     * @brief Function membre getName
     * @return une chaine contenant le nom de la sd
     */
    const std::string& getName() const
    {
        return _name;
    };

    /**
     * @brief Function membre getType
     * @return le type de la sd
     */
    const std::string getType() const
    {
        return _type;
    };
};

/**
 * @typedef CodedMaterialPtr
 * @brief Pointeur intelligent vers un CodedMaterialInstance
 */
typedef boost::shared_ptr< CodedMaterialInstance > CodedMaterialPtr;


#endif /* CODEDMATERIAL_H_ */
