#ifndef XFEMCRACK_H_
#define XFEMCRACK_H_

/**
 * @file XfemCrack.h
 * @brief Fichier entete de la classe XfemCrack
 * @author Nicolas Tardieu
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

/* person_in_charge: nicolas.tardieu at edf.fr */

#include "astercxx.h"
#include "DataFields/FieldOnNodes.h"
#include "DataStructure/DataStructure.h"
#include "Mesh/Mesh.h"
#include "Function/Function.h"
#include "Modeling/CrackShape.h"


/**
 * @class XfemCrackInstance
 * @brief generates a data structure identical to DEFI_FISS_XFEM
 * @author Nicolas Tardieu
 */
class XfemCrackInstance: public DataStructure
{
public:
    /**
         * @brief kind of forward declaration
         */
    typedef boost::shared_ptr< XfemCrackInstance > XfemCrackPtr;

private:
    /** @typedef Definition of a smart pointer on VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

    /** @brief Name of the JEVEUX Data Structure */
    const std::string           _jeveuxName;
    /** @brief Mesh supporting the crack */
    MeshPtr                     _supportMesh;
    /** @brief Mesh of the auxiliary grid */
    MeshPtr                     _auxiliaryGrid;
    /** @brief Mesh of the previous auxiliary grid */
    XfemCrackPtr                _existingCrackWithGrid;
    /** @brief Type de discontinuité */
    std::string                 _discontinuityType;
    /** @brief MeshEntity defining the lips of the crack */
    std::vector< std::string >  _crackLipsEntity;
    /** @brief MeshEntity defining the tip of the crack */
    std::vector< std::string >  _crackTipEntity;
    /** @brief Function defining the normal level set */
    FunctionPtr                 _normalLevelSetFunction;
    /** @brief Function defining the tangential level set */
    FunctionPtr                 _tangentialLevelSetFunction;
    /** @brief Crack Shape */
    CrackShapePtr               _crackShape;
    /** @brief List of group of elements that define the crack tip in case of propagation in the cohesive case */
    std::vector< std::string >  _cohesiveCrackTipForPropagation;
    /** @brief Field defining the normal level set */
    FieldOnNodesDoublePtr       _normalLevelSetField;
    /** @brief Field defining the tangential level set */
    FieldOnNodesDoublePtr       _tangentialLevelSetField;
    /** @brief MeshEntity defining the enriched elements */
    std::vector< std::string >  _enrichedElements;
    /** @brief Name of the discontinuous field */
    std::string                 _discontinuousField;
    /** @brief Type of the enrichment */
    std::string                 _enrichmentType;
    /** @brief Radius of th enriched zone */
    double                      _enrichmentRadiusZone;
    /** @brief Number of enriched elements layers */
    int                         _enrichedLayersNumber;
    /** @brief List of juncting cracks */
    std::vector< XfemCrackPtr > _junctingCracks;
    /** @brief Point to define juncting cracks */
    std::vector< double >       _pointForJunctingCracks;


    /** @brief Nodal Field named '.GRLTNO' */
    FieldOnNodesDoublePtr  _tangentialLevelSetGradient;
    /** @brief Nodal Field  named '.GRLNNO' */
    FieldOnNodesDoublePtr  _normalLevelSetGradient;
    /** @brief Nodal Field named '.BASLOC' */
    FieldOnNodesDoublePtr  _localBasis;
    /** @brief JeveuxVectorDouble  named '.FONDFISS' */
    JeveuxVectorDouble   _crackTipCoords;
    /** @brief JeveuxVectorDouble  named '.BASEFOND' */
    JeveuxVectorDouble   _crackTipBasis;
    /** @brief JeveuxVectorLong  named '.FONDMULT' */
    JeveuxVectorLong   _crackTipMultiplicity;
    /** @brief JeveuxVectorDouble  named '.CARAFOND' */
    JeveuxVectorDouble   _crackTipCharacteristics;
    /** @brief JeveuxVectorDouble  named '.FOND.TAILLE_R' */
    JeveuxVectorDouble   _elementSize;
    /** @brief JeveuxVectorLong  named '.GROUP_NO_ENRI' */
    JeveuxVectorLong   _enrichedNodes;
    /** @brief JeveuxVectorLong  named '.MAILFISS.CTIP' */
    JeveuxVectorLong   _crackTipElements;
    /** @brief JeveuxVectorLong  named '.MAILFISS.HEAV' */
    JeveuxVectorLong   _heavisideElements;
    /** @brief JeveuxVectorLong  named '.MAILFISS.HECT' */
    JeveuxVectorLong   _crackTipAndHeavisideElements;



public:

    /**
         * @brief Constructeur
         */
    XfemCrackInstance(MeshPtr supportMesh);





    /**
         * @brief Construction du XfemCrackInstance
         * @return Booleen indiquant que la construction s'est bien deroulee
         */
    bool build() throw ( std::runtime_error );


    /**
         * @brief Series of getters and setters that check the syntax rules
         */

    const MeshPtr getSupportMesh() const
    {
        return _supportMesh;
    };

    void setSupportMesh(const MeshPtr &supportMesh)
    {
        _supportMesh = supportMesh;
    }

    MeshPtr getAuxiliaryGrid() const
    {
        return _auxiliaryGrid;
    }

    void setAuxiliaryGrid(const MeshPtr &auxiliaryGrid)
    {
        if (_existingCrackWithGrid) throw std::runtime_error( "Cannot define auxiliary grid with already assigned Crack definition " );
        _auxiliaryGrid = auxiliaryGrid;
    }

    const XfemCrackPtr getExistingCrackWithGrid() const
    {
        return _existingCrackWithGrid;
    }

    void setExistingCrackWithGrid(const XfemCrackPtr &existingCrackWithGrid)
    {
        if (_auxiliaryGrid) throw std::runtime_error( "Cannot define existing Crack definition with already assigned auxiliary grid" );
        _existingCrackWithGrid = existingCrackWithGrid;
    }

    std::string getDiscontinuityType() const
    {
        return _discontinuityType;
    }

    void setDiscontinuityType(const std::string &discontinuityType)
    {
        if (discontinuityType!="Crack" && discontinuityType!="Interface" && discontinuityType!="Cohesive") {
            throw std::runtime_error( "discontinuityType can only be Crack, Interface, Cohesive" );
        } else {_discontinuityType = discontinuityType;
        }
    }

    std::vector< std::string > getCrackLipsEntity() const
    {
        return _crackLipsEntity;
    }

    void setCrackLipsEntity(const std::vector< std::string > &crackLips)
    {
        if (!(_crackShape && _normalLevelSetField && _normalLevelSetFunction)) {
            _crackLipsEntity = crackLips;
        } else {
            throw std::runtime_error( "Only one to be assigned into crackShape, normalLevelSetFunction, crackLips, normalLevelSetField" );
        }
    }

    std::vector< std::string > getCrackTipEntity() const
    {
        return _crackTipEntity;
    }

    void setCrackTipEntity(const std::vector< std::string > &crackTip)
    {
        _crackTipEntity = crackTip;
    }


    std::vector< std::string > getCohesiveCrackTipForPropagation() const
    {
        return _cohesiveCrackTipForPropagation;
    }

    void setCohesiveCrackTipForPropagation(const std::vector< std::string > &crackTipEntity)
    {
        _cohesiveCrackTipForPropagation = crackTipEntity;
    }

    FunctionPtr getNormalLevelSetFunction() const
    {
        return _normalLevelSetFunction;
    }

    void setNormalLevelSetFunction(const FunctionPtr &normalLevelSetFunction)
    {
        if (!(_crackShape && _normalLevelSetField && _crackLipsEntity.size()!=0 )) {
            _normalLevelSetFunction = normalLevelSetFunction;
        } else {
            throw std::runtime_error( "Only one to be assigned into crackShape, normalLevelSetFunction, crackLips, normalLevelSetField" );
        }
    }

    FunctionPtr getTangentialLevelSetFunction() const
    {
        return _tangentialLevelSetFunction;
    }

    void setTangentialLevelSetFunction(const FunctionPtr &tangentialLevelSetFunction)
    {
        _tangentialLevelSetFunction = tangentialLevelSetFunction;
    }

    CrackShapePtr getCrackShape() const
    {
        return _crackShape;
    }

    void setCrackShape(const CrackShapePtr &crackShape)
    {
        if (!(_normalLevelSetFunction && _normalLevelSetField && _crackLipsEntity.size()!=0 )) {
            _crackShape = crackShape;
        } else {
            throw std::runtime_error( "Only one to be assigned into crackShape, normalLevelSetFunction, crackLips, normalLevelSetField" );
        }
    }

    FieldOnNodesDoublePtr getNormalLevelSetField() const
    {
        _normalLevelSetField->updateValuePointers();
        return _normalLevelSetField;
    }

    void setNormalLevelSetField(const FieldOnNodesDoublePtr &normalLevelSetField)
    {
        if (!(_crackShape && _crackLipsEntity.size()!=0 && _normalLevelSetFunction)) {
            _normalLevelSetField = normalLevelSetField;
        } else {
            throw std::runtime_error( "Only one to be assigned into crackShape, normalLevelSetFunction, crackLips, normalLevelSetField" );
        }
    }

    FieldOnNodesDoublePtr getTangentialLevelSetField() const
    {
        _tangentialLevelSetField->updateValuePointers();
        return _tangentialLevelSetField;
    }

    void setTangentialLevelSetField(const FieldOnNodesDoublePtr &tangentialLevelSet)
    {
        _tangentialLevelSetField = tangentialLevelSet;
    }

    std::vector< std::string > getEnrichedElements() const
    {
        return _enrichedElements;
    }

    void setEnrichedElements(const std::vector< std::string > &enrichedElements)
    {
        _enrichedElements = enrichedElements;
    }

    std::string getDiscontinuousField() const
    {
        return _discontinuousField;
    }

    void setDiscontinuousField(const std::string &discontinuousField)
    {
        _discontinuousField = discontinuousField;
    }


    std::string getEnrichmentType() const
    {
        return _enrichmentType;
    }

    void setEnrichmentType(const std::string &enrichmentType)
    {
        _enrichmentType = enrichmentType;
    }

    double getEnrichmentRadiusZone() const
    {
        return _enrichmentRadiusZone;
    }

    void setEnrichmentRadiusZone(double enrichmentRadiusZone)
    {
        _enrichmentRadiusZone = enrichmentRadiusZone;
    }

    long getEnrichedLayersNumber() const
    {
        return _enrichedLayersNumber;
    }

    void setEnrichedLayersNumber(long enrichedLayersNumber)
    {
        _enrichedLayersNumber = enrichedLayersNumber;
    }

    std::vector<XfemCrackPtr> getJunctingCracks() const
    {
        return _junctingCracks;
    }

    void insertJunctingCracks(const XfemCrackPtr &junctingCracks)
    {
        _junctingCracks.push_back(junctingCracks);
    }

    void setPointForJunction(const std::vector<double> point)
    {
        _pointForJunctingCracks = point;
    }
    
    std::string getJeveuxName() const
    {
        return _jeveuxName;
    }
};

/**
 * @typedef MaterialPtr
 * @brief Pointeur intelligent vers un XfemCrackInstance
 */
typedef boost::shared_ptr< XfemCrackInstance > XfemCrackPtr;


#endif /* XFEMCRACK_H_ */

