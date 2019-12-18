#ifndef ELEMENTARYMATRIX_H_
#define ELEMENTARYMATRIX_H_

/**
 * @file ElementaryMatrix.h
 * @brief Fichier entete de la classe ElementaryMatrix
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"
#include "Loads/MechanicalLoad.h"
#include "DataFields/ElementaryResult.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Loads/PhysicalQuantity.h"

/**
 * @class BaseElementaryMatrixInstance
 * @brief Class definissant une sd_matr_elem
 * @author Nicolas Sellenet
 */
class BaseElementaryMatrixInstance : public DataStructure
{
protected:
    /** @brief Objet Jeveux '.RERR' */
    JeveuxVectorChar24 _description;
    /** @brief Objet Jeveux '.RELR' */
    JeveuxVectorChar24 _listOfElementaryResults;
    /** @brief Booleen indiquant si la sd est vide */
    bool _isEmpty;
    /** @brief Modele */
    ModelPtr _model;
    /** @brief MaterialOnMesh */
    MaterialOnMeshPtr _materOnMesh;
    /** @brief Vectors of FiniteElementDescriptor */
    std::vector< FiniteElementDescriptorPtr > _FEDVector;
    std::set< std::string > _FEDNames;

    /**
     * @brief Constructor with a name
     */
    BaseElementaryMatrixInstance( const std::string name,
                                  const JeveuxMemory memType = Permanent,
                                  const std::string type = "MATR_ELEM" ):
        DataStructure( name, 19, type, memType ),
        _description( JeveuxVectorChar24( getName() + ".RERR" ) ),
        _listOfElementaryResults( JeveuxVectorChar24( getName() + ".RELR" ) ),
        _isEmpty( true ),
        _model( nullptr ), _materOnMesh( nullptr )
    {};

    /**
     * @brief Constructor
     */
    BaseElementaryMatrixInstance( const JeveuxMemory memType = Permanent,
                                  const std::string type = "MATR_ELEM" ):
        BaseElementaryMatrixInstance( ResultNaming::getNewResultName(), memType, type )
    {};


public:
    /**
     * @brief Add a FiniteElementDescriptor to elementary matrix
     * @param FiniteElementDescriptorPtr FiniteElementDescriptor
     */
    bool addFiniteElementDescriptor( const FiniteElementDescriptorPtr &curFED ) {
        const auto name = trim( curFED->getName() );
        if ( _FEDNames.find( name ) == _FEDNames.end() ) {
            _FEDVector.push_back( _model->getFiniteElementDescriptor() );
            _FEDNames.insert( name );
            return true;
        }
        return false;
    };

    /**
     * @brief Get all FiniteElementDescriptors
     * @return vector of all FiniteElementDescriptors
     */
    std::vector< FiniteElementDescriptorPtr > getFiniteElementDescriptors() { return _FEDVector; };

    /**
     * @brief Get the MaterialOnMesh
     */
    MaterialOnMeshPtr getMaterialOnMesh() const {
        if ( _materOnMesh == nullptr )
            throw std::runtime_error( "MaterialOnMesh is not set" );
        return _materOnMesh;
    };

    /**
     * @brief Obtenir le modèle de l'étude
     */
    ModelPtr getModel() const { return _model; };

    /**
     * @brief Methode permettant de savoir si les matrices elementaires sont vides
     * @return true si les matrices elementaires sont vides
     */
    bool isEmpty() { return _isEmpty; };

    /**
     * @brief Methode permettant de changer l'état de remplissage
     * @param bEmpty booleen permettant de dire que l'objet est vide ou pas
     */
    void setEmpty( bool bEmpty ) { _isEmpty = bEmpty; };

    /**
     * @brief Set the MaterialOnMesh
     * @param currentMater MaterialOnMesh
     */
    void setMaterialOnMesh( const MaterialOnMeshPtr &currentMater ) {
        _materOnMesh = currentMater;
    };

    /**
     * @brief Methode permettant de definir le modele
     * @param currentModel Modele de la numerotation
     */
    void setModel( const ModelPtr &currentModel ) {
        _model = currentModel;
        auto curFED = _model->getFiniteElementDescriptor();
        const auto name = trim( curFED->getName() );
        if ( _FEDNames.find( name ) == _FEDNames.end() ) {
            _FEDVector.push_back( _model->getFiniteElementDescriptor() );
            _FEDNames.insert( name );
        }
    };
};

typedef boost::shared_ptr< BaseElementaryMatrixInstance > BaseElementaryMatrixPtr;

/**
 * @class ElementaryMatrixInstance
 * @brief Class definissant une sd_matr_elem template
 * @author Nicolas Sellenet
 */
template < class ValueType, PhysicalQuantityEnum PhysicalQuantity >
class ElementaryMatrixInstance : public BaseElementaryMatrixInstance
{
  private:
    /** @brief Vectors of RESUELEM */
    std::vector< ElementaryResultDoublePtr > _realVector;
    std::vector< ElementaryResultComplexPtr > _complexVector;

  public:
    /**
     * @typedef ElementaryMatrixPtr
     * @brief Pointeur intelligent vers un ElementaryMatrix
     */
    typedef boost::shared_ptr< ElementaryMatrixInstance< ValueType, PhysicalQuantity > >
        ElementaryMatrixPtr;

    /**
     * @brief Constructor with a name
     */
    ElementaryMatrixInstance( const std::string name,  const JeveuxMemory memType = Permanent ):
        BaseElementaryMatrixInstance( name, memType,
            "MATR_ELEM_" + std::string( PhysicalQuantityNames[PhysicalQuantity] ) +
            ( typeid( ValueType ) == typeid(double)? "_R" : "_C" ) )
    {};

    /**
     * @brief Constructor
     */
    ElementaryMatrixInstance( const JeveuxMemory memType = Permanent ):
        ElementaryMatrixInstance( ResultNaming::getNewResultName(), memType )
    {};

    /**
     * @brief function to update ElementaryResultInstance
     */
    bool update() {
        _listOfElementaryResults->updateValuePointer();
        _realVector.clear();
        for ( int pos = 0; pos < _listOfElementaryResults->size(); ++pos ) {
            const std::string name = ( *_listOfElementaryResults )[pos].toString();
            if ( trim( name ) != "" ) {
                ElementaryResultDoublePtr toPush( new ElementaryResultInstance< double >( name ) );
                _realVector.push_back( toPush );
            }
        }
        return true;
    };

    friend class DiscreteProblemInstance;
};

/** @typedef Definition d'une matrice élémentaire de double */
template class ElementaryMatrixInstance< double, Displacement >;
typedef ElementaryMatrixInstance< double, Displacement > ElementaryMatrixDisplacementDoubleInstance;

/** @typedef Definition d'une matrice élémentaire de complexe */
template class ElementaryMatrixInstance< DoubleComplex, Displacement >;
typedef ElementaryMatrixInstance< DoubleComplex,
                                  Displacement > ElementaryMatrixDisplacementComplexInstance;

/** @typedef Definition d'une matrice élémentaire de double temperature */
template class ElementaryMatrixInstance< double, Temperature >;
typedef ElementaryMatrixInstance< double,
                                  Temperature > ElementaryMatrixTemperatureDoubleInstance;

/** @typedef Definition d'une matrice élémentaire de DoubleComplex pression */
template class ElementaryMatrixInstance< DoubleComplex, Pressure >;
typedef ElementaryMatrixInstance< DoubleComplex,
                                  Pressure > ElementaryMatrixPressureComplexInstance;

typedef boost::shared_ptr< ElementaryMatrixDisplacementDoubleInstance >
    ElementaryMatrixDisplacementDoublePtr;
typedef boost::shared_ptr< ElementaryMatrixDisplacementComplexInstance >
    ElementaryMatrixDisplacementComplexPtr;
typedef boost::shared_ptr< ElementaryMatrixTemperatureDoubleInstance >
    ElementaryMatrixTemperatureDoublePtr;
typedef boost::shared_ptr< ElementaryMatrixPressureComplexInstance >
    ElementaryMatrixPressureComplexPtr;

#endif /* ELEMENTARYMATRIX_H_ */
