#ifndef CODEDMATERIAL_H_
#define CODEDMATERIAL_H_

/**
 * @file CodedMaterial.h
 * @brief Fichier entete de la classe CodedMaterial
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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
#include "DataStructures/DataStructure.h"
#include "Materials/MaterialOnMesh.h"
#include "Modeling/Model.h"
#include "DataFields/PCFieldOnMesh.h"

/**
 * @class CodedMaterialInstance
 * @brief Coded material
 * @author Nicolas Sellenet
 */
class CodedMaterialInstance: public DataStructure
{
private:
    MaterialOnMeshPtr    _mater;
    ModelPtr             _model;
    PCFieldOnMeshLongPtr _field;

public:
    /**
     * @typedef CodedMaterialPtr
     * @brief Pointeur intelligent vers un CodedMaterial
     */
    typedef boost::shared_ptr< CodedMaterialInstance > CodedMaterialPtr;

    /**
     * @brief Constructeur
     */
    CodedMaterialInstance( const MaterialOnMeshPtr& mater, const ModelPtr& model ):
        DataStructure( "MATER_CODE", Temporary, 8 ),
        _mater( mater ),
        _model( model ),
        _field( new PCFieldOnMeshLongInstance( getName() + ".MATE_CODE",
                                               _model->getSupportMesh(),
                                               Temporary ) )
    {
        std::string blanc( 24, ' ' );
        std::string materName = _mater->getName();
        materName.resize(24, ' ');
        std::string mate = blanc;
        long thm = 0;
        if( model->existsThm() ) thm = 1;
        CALLO_RCMFMC_WRAP( materName, mate, &thm, getName() );
    };

    /**
     * @brief Function to know if elastic properties depend of a function
     */
    bool constant() const;

    /**
     * @brief Get the .MATE_CODE
     */
    PCFieldOnMeshLongPtr getCodedMaterialField() const
    {
        return _field;
    };
};

/**
 * @typedef CodedMaterialPtr
 * @brief Pointeur intelligent vers un CodedMaterialInstance
 */
typedef boost::shared_ptr< CodedMaterialInstance > CodedMaterialPtr;


#endif /* CODEDMATERIAL_H_ */
