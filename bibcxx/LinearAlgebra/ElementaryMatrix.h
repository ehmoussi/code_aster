#ifndef ELEMENTARYMATRIX_H_
#define ELEMENTARYMATRIX_H_

/**
 * @file ElementaryMatrix.h
 * @brief Fichier entete de la classe ElementaryMatrix
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
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"
#include "Loads/MechanicalLoad.h"
#include "DataFields/ElementaryTerm.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Loads/PhysicalQuantity.h"

/**
 * @class BaseElementaryMatrixClass
 * @brief Class definissant une sd_matr_elem
 * @author Nicolas Sellenet
 */
class BaseElementaryMatrixClass : public DataStructure
{
protected:
    /** @brief Objet Jeveux '.RERR' */
    JeveuxVectorChar24 _description;
    /** @brief Objet Jeveux '.RELR' */
    JeveuxVectorChar24 _listOfElementaryTerms;
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
    BaseElementaryMatrixClass( const std::string name,
                                  const JeveuxMemory memType = Permanent,
                                  const std::string type = "MATR_ELEM" ):
        DataStructure( name, 19, type, memType ),
        _description( JeveuxVectorChar24( getName() + ".RERR" ) ),
        _listOfElementaryTerms( JeveuxVectorChar24( getName() + ".RELR" ) ),
        _isEmpty( true ),
        _model( nullptr ), _materOnMesh( nullptr )
    {};

    /**
     * @brief Constructor
     */
    BaseElementaryMatrixClass( const JeveuxMemory memType = Permanent,
                                  const std::string type = "MATR_ELEM" ):
        BaseElementaryMatrixClass( ResultNaming::getNewResultName(), memType, type )
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

typedef boost::shared_ptr< BaseElementaryMatrixClass > BaseElementaryMatrixPtr;

/**
 * @class ElementaryMatrixClass
 * @brief Class definissant une sd_matr_elem template
 * @author Nicolas Sellenet
 */
template < class ValueType, PhysicalQuantityEnum PhysicalQuantity >
class ElementaryMatrixClass : public BaseElementaryMatrixClass
{
  private:
    /** @brief Vectors of RESUELEM */
    std::vector< ElementaryTermDoublePtr > _realVector;
    std::vector< ElementaryTermComplexPtr > _complexVector;

  public:
    /**
     * @typedef ElementaryMatrixPtr
     * @brief Pointeur intelligent vers un ElementaryMatrix
     */
    typedef boost::shared_ptr< ElementaryMatrixClass< ValueType, PhysicalQuantity > >
        ElementaryMatrixPtr;

    /**
     * @brief Constructor with a name
     */
    ElementaryMatrixClass( const std::string name,  const JeveuxMemory memType = Permanent ):
        BaseElementaryMatrixClass( name, memType,
            "MATR_ELEM_" + std::string( PhysicalQuantityNames[PhysicalQuantity] ) +
            ( typeid( ValueType ) == typeid(double)? "_R" : "_C" ) )
    {};

    /**
     * @brief Constructor
     */
    ElementaryMatrixClass( const JeveuxMemory memType = Permanent ):
        ElementaryMatrixClass( ResultNaming::getNewResultName(), memType )
    {};

    /**
     * @brief function to update ElementaryTermClass
     */
    bool update() {
        _listOfElementaryTerms->updateValuePointer();
        _realVector.clear();
        for ( int pos = 0; pos < _listOfElementaryTerms->size(); ++pos ) {
            const std::string name = ( *_listOfElementaryTerms )[pos].toString();
            if ( trim( name ) != "" ) {
                ElementaryTermDoublePtr toPush( new ElementaryTermClass< double >( name ) );
                _realVector.push_back( toPush );
            }
        }
        return true;
    };

    friend class DiscreteProblemClass;
};

/** @typedef Definition d'une matrice élémentaire de double */
template class ElementaryMatrixClass< double, Displacement >;
typedef ElementaryMatrixClass< double, Displacement > ElementaryMatrixDisplacementDoubleClass;

/** @typedef Definition d'une matrice élémentaire de complexe */
template class ElementaryMatrixClass< DoubleComplex, Displacement >;
typedef ElementaryMatrixClass< DoubleComplex,
                                  Displacement > ElementaryMatrixDisplacementComplexClass;

/** @typedef Definition d'une matrice élémentaire de double temperature */
template class ElementaryMatrixClass< double, Temperature >;
typedef ElementaryMatrixClass< double,
                                  Temperature > ElementaryMatrixTemperatureDoubleClass;

/** @typedef Definition d'une matrice élémentaire de DoubleComplex pression */
template class ElementaryMatrixClass< DoubleComplex, Pressure >;
typedef ElementaryMatrixClass< DoubleComplex,
                                  Pressure > ElementaryMatrixPressureComplexClass;

typedef boost::shared_ptr< ElementaryMatrixDisplacementDoubleClass >
    ElementaryMatrixDisplacementDoublePtr;
typedef boost::shared_ptr< ElementaryMatrixDisplacementComplexClass >
    ElementaryMatrixDisplacementComplexPtr;
typedef boost::shared_ptr< ElementaryMatrixTemperatureDoubleClass >
    ElementaryMatrixTemperatureDoublePtr;
typedef boost::shared_ptr< ElementaryMatrixPressureComplexClass >
    ElementaryMatrixPressureComplexPtr;

#endif /* ELEMENTARYMATRIX_H_ */
