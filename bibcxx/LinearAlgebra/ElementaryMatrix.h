#ifndef ELEMENTARYMATRIX_H_
#define ELEMENTARYMATRIX_H_

/**
 * @file ElementaryMatrix.h
 * @brief Fichier entete de la classe ElementaryMatrix
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
#include "DataStructures/DataStructure.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "Materials/MaterialOnMesh.h"
#include "Loads/MechanicalLoad.h"
#include "DataFields/ElementaryResult.h"
#include "Modeling/FiniteElementDescriptor.h"

/**
 * @class ElementaryMatrixInstance
 * @brief Class definissant une sd_matr_elem
 * @author Nicolas Sellenet
 */
class ElementaryMatrixInstance : public DataStructure {
  private:
    /** @typedef std::list de MechanicalLoad */
    typedef std::list< GenericMechanicalLoadPtr > ListMecaLoad;
    /** @typedef Iterateur sur une std::list de MechanicalLoad */
    typedef ListMecaLoad::iterator ListMecaLoadIter;

    /** @brief Objet Jeveux '.RERR' */
    JeveuxVectorChar24 _description;
    /** @brief Objet Jeveux '.RELR' */
    JeveuxVectorChar24 _listOfElementaryResults;
    /** @brief Vectors of RESUELEM */
    std::vector< ElementaryResultDoublePtr > _realVector;
    std::vector< ElementaryResultComplexPtr > _complexVector;
    /** @brief Booleen indiquant si la sd est vide */
    bool _isEmpty;
    /** @brief Modele support */
    ModelPtr _supportModel;
    /** @brief Support MaterialOnMesh */
    MaterialOnMeshPtr _materOnMesh;
    /** @brief Vectors of FiniteElementDescriptor */
    std::vector< FiniteElementDescriptorPtr > _FEDVector;
    std::set< std::string > _FEDNames;

  public:
    /**
     * @typedef ElementaryMatrixPtr
     * @brief Pointeur intelligent vers un ElementaryMatrix
     */
    typedef boost::shared_ptr< ElementaryMatrixInstance > ElementaryMatrixPtr;

    /**
     * @brief Constructeur
     */
    ElementaryMatrixInstance( const std::string name, const std::string type,
                              const JeveuxMemory memType )
        : DataStructure( name, 19, type, memType ),
          _description( JeveuxVectorChar24( getName() + ".RERR" ) ),
          _listOfElementaryResults( JeveuxVectorChar24( getName() + ".RELR" ) ), _isEmpty( true ),
          _supportModel( nullptr ), _materOnMesh( nullptr ){};

    /**
     * @brief Constructeur
     */
    ElementaryMatrixInstance( const std::string name, const std::string type )
        : ElementaryMatrixInstance( name, type, Permanent ){};

    /**
     * @brief Constructeur: 'type' should be the full type
     */
    ElementaryMatrixInstance( std::string type, const JeveuxMemory memType = Permanent )
        : ElementaryMatrixInstance( ResultNaming::getNewResultName(), "MATR_ELEM_" + type,
                                    memType ){};

    /**
     * @brief Constructeur
     */
    ElementaryMatrixInstance( const JeveuxMemory memType = Permanent )
        : ElementaryMatrixInstance( ResultNaming::getNewResultName(), "MATR_ELEM", memType ){};

    /**
     * @brief Destructeur
     */
    ~ElementaryMatrixInstance() {
#ifdef __DEBUG_GC__
        std::cout << "ElementaryMatrixInstance.destr: " << this->getName() << std::endl;
#endif
    };

    /**
     * @brief Add a FiniteElementDescriptor to elementary matrix
     * @param FiniteElementDescriptorPtr support FiniteElementDescriptor
     */
    bool addFiniteElementDescriptor( const FiniteElementDescriptorPtr &curFED ) {
        const auto name = trim( curFED->getName() );
        if ( _FEDNames.find( name ) == _FEDNames.end() ) {
            _FEDVector.push_back( _supportModel->getFiniteElementDescriptor() );
            _FEDNames.insert( name );
            return true;
        }
        return false;
    };

    /**
     * @brief Get all support FiniteElementDescriptors
     * @return vector of all FiniteElementDescriptors
     */
    std::vector< FiniteElementDescriptorPtr > getFiniteElementDescriptors() { return _FEDVector; };

    /**
     * @brief Get the MaterialOnMesh
     */
    MaterialOnMeshPtr getMaterialOnMesh() const throw( std::runtime_error ) {
        if ( _materOnMesh == nullptr )
            throw std::runtime_error( "MaterialOnMesh is not set" );
        return _materOnMesh;
    };

    /**
     * @brief Obtenir le modèle de l'étude
     */
    ModelPtr getSupportModel() const { return _supportModel; };

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
     * @brief Methode permettant de definir le modele support
     * @param currentModel Model support de la numerotation
     */
    void setSupportModel( const ModelPtr &currentModel ) {
        _supportModel = currentModel;
        auto curFED = _supportModel->getFiniteElementDescriptor();
        const auto name = trim( curFED->getName() );
        if ( _FEDNames.find( name ) == _FEDNames.end() ) {
            _FEDVector.push_back( _supportModel->getFiniteElementDescriptor() );
            _FEDNames.insert( name );
        }
    };

    /**
     * @brief function to update ElementaryResultInstance
     */
    bool update() throw( std::runtime_error ) {
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

/**
 * @typedef ElementaryMatrixPtr
 * @brief Pointeur intelligent vers un ElementaryMatrixInstance
 */
typedef boost::shared_ptr< ElementaryMatrixInstance > ElementaryMatrixPtr;

#endif /* ELEMENTARYMATRIX_H_ */
