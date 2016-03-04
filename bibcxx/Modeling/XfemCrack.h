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

/**
 * @class CrackShape
 * @brief Short class to store the nature of the crack shape
 * @author Nicolas Tardieu
 */
enum Shape { Ellipse, Square, Cylinder, Notch, HalfPlane, Segment, HalfLine, Line };
class CrackShape
{
    private:
        const Shape 		_shape
        double 				_semiMajorAxis;
        double 				_semiMinorAxis;
        double[3] 			_center;
        double[3] 			_vectX;
        double[3] 			_vectY;
        const std::string	_crackSide;
        double				_filletRadius;
        double				_halfLength;
        double[3] 			_endPoint;
        double[3] 			_normal;
        double[3] 			_tangent;
        double[3] 			_startingPoint;
}

/**
 * @class XfemCrackInstance
 * @brief produit une sd identique a celle produite par DEFI_FISS_XFEM
 * @author Nicolas Tardieu
 */
class XfemCrackInstance: public DataStructure
{
    private:

        /** @brief Nom Jeveux de la SD */
        const std::string		_jeveuxName;
        /** @brief Maillage sur lequel repose la modelisation */
        MeshPtr					_supportMesh;
        /** @brief Maillage de la grille auxiliaire */
        MeshPtr					_auxiliaryGrid;
        /** @brief Maillage de la grille auxiliaire */
        MeshPtr					_previousAuxiliaryGrid;
        /** @brief Type de discontinuité */
        const std::string 		_discontinuityType;
        /** @brief MeshEntity defining the lips of the crack */
        MeshEntityPtr 			_crackLips;
        /** @brief MeshEntity defining the tip of the crack */
        MeshEntityPtr 			_crackTip;
        /** @brief Function defining the normal level set */
        FunctionPtr				_normalLevelSetFunction;
        /** @brief Function defining the tangential level set */
        FunctionPtr				_tangentialLevelSetFunction;
        /** @brief Crack Shape */
        CrackShape				_crackShape;
        /** @brief Field defining the normal level set */
        FieldOnNodesDoublePtr	_normalLevelSet;
        /** @brief Field defining the tangential level set */
        FieldOnNodesDoublePtr	_tangentialLevelSet;
        /** @brief MeshEntity defining the enriched elements */
        MeshEntityPtr	_enrichedElements;
        /** @brief Name of the discontinuous field */
        const std::string	_discontinuousField;
        /** @brief Type of the enrichment */
        const std::string	_enrichmentType;
        /** @brief Radius of th enriched zone */
        double	_enrichmentRadiusZone;
        /** @brief Number of enriched elements layers */
        const long	_enrichedLayersNumber;
        /** @brief List of juncting cracks */
        boost::vector< XfemCrackInstance >	_junctingCracks;


        /** @brief Nodal Field  named '.LTNO' */
        FieldOnNodesDoublePtr  _tangentialLevelSet;
        /** @brief Nodal Field  '.LNNO' */
        FieldOnNodesDoublePtr  _normalLevelSet;
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
        XfemCrack();



        /**
         * @brief Construction du MaterialInstance
         *   A partir des GeneralMaterialBehaviourPtr ajoutes par l'utilisateur :
         *   creation de objets Jeveux
         * @return Booleen indiquant que la construction s'est bien deroulee
         * @todo pouvoir compléter un matériau (ajout d'un comportement après build)
         */
        bool build() throw ( std::runtime_error );


        /**
         * @brief Series of getters and setters
         * @todo Define a generic get/set method that cheks the pointers or Add precompilation directives to check them (so that it is done only for the debug run)
         */

        MeshPtr XfemCrackInstance::getSupportMesh() const
        {
            return _supportMesh;
        }

        void XfemCrackInstance::setSupportMesh(const MeshPtr &supportMesh)
        {
            _supportMesh = supportMesh;
        }

        MeshPtr XfemCrackInstance::getAuxiliaryGrid() const
        {
        return _auxiliaryGrid;
        }

        void XfemCrackInstance::setAuxiliaryGrid(const MeshPtr &auxiliaryGrid)
        {
        _auxiliaryGrid = auxiliaryGrid;
        }

        MeshPtr XfemCrackInstance::getPreviousAuxiliaryGrid() const
        {
        return _previousAuxiliaryGrid;
        }

        void XfemCrackInstance::setPreviousAuxiliaryGrid(const MeshPtr &previousAuxiliaryGrid)
        {
        _previousAuxiliaryGrid = previousAuxiliaryGrid;
        }

        std::string XfemCrackInstance::getDiscontinuityType() const
        {
        return _discontinuityType;
        }

        MeshEntityPtr XfemCrackInstance::getCrackLips() const
        {
        return _crackLips;
        }

        void XfemCrackInstance::setCrackLips(const MeshEntityPtr &crackLips)
        {
        _crackLips = crackLips;
        }

        MeshEntityPtr XfemCrackInstance::getCrackTip() const
        {
        return _crackTip;
        }

        void XfemCrackInstance::setCrackTip(const MeshEntityPtr &crackTip)
        {
        _crackTip = crackTip;
        }

        FunctionPtr XfemCrackInstance::getNormalLevelSetFunction() const
        {
        return _normalLevelSetFunction;
        }

        void XfemCrackInstance::setNormalLevelSetFunction(const FunctionPtr &normalLevelSetFunction)
        {
        _normalLevelSetFunction = normalLevelSetFunction;
        }

        FunctionPtr XfemCrackInstance::getTangentialLevelSetFunction() const
        {
        return _tangentialLevelSetFunction;
        }

        void XfemCrackInstance::setTangentialLevelSetFunction(const FunctionPtr &tangentialLevelSetFunction)
        {
        _tangentialLevelSetFunction = tangentialLevelSetFunction;
        }

        CrackShape XfemCrackInstance::crackShape() const
        {
        return _crackShape;
        }

        void XfemCrackInstance::setCrackShape(const CrackShape &crackShape)
        {
        _crackShape = crackShape;
        }

        FieldOnNodesDoublePtr XfemCrackInstance::getNormalLevelSet() const
        {
        return _normalLevelSet;
        }

        void XfemCrackInstance::setNormalLevelSet(const FieldOnNodesDoublePtr &normalLevelSet)
        {
        _normalLevelSet = normalLevelSet;
        }

        FieldOnNodesDoublePtr XfemCrackInstance::getTangentialLevelSet() const
        {
        return _tangentialLevelSet;
        }

        void XfemCrackInstance::setTangentialLevelSet(const FieldOnNodesDoublePtr &tangentialLevelSet)
        {
        _tangentialLevelSet = tangentialLevelSet;
        }

        MeshEntityPtr XfemCrackInstance::getEnrichedElements() const
        {
        return _enrichedElements;
        }

        void XfemCrackInstance::setEnrichedElements(const MeshEntityPtr &enrichedElements)
        {
        _enrichedElements = enrichedElements;
        }

        std::string XfemCrackInstance::getDiscontinuousField() const
        {
        return _discontinuousField;
        }

        std::string XfemCrackInstance::getEnrichmentType() const
        {
        return _enrichmentType;
        }

        double XfemCrackInstance::getEnrichmentRadiusZone() const
        {
        return _enrichmentRadiusZone;
        }

        void XfemCrackInstance::setEnrichmentRadiusZone(double enrichmentRadiusZone)
        {
        _enrichmentRadiusZone = enrichmentRadiusZone;
        }

        long XfemCrackInstance::getEnrichedLayersNumber() const
        {
        return _enrichedLayersNumber;
        }

        boost::vector<XfemCrackInstance> XfemCrackInstance::getJunctingCracks() const
        {
        return _junctingCracks;
        }

        void XfemCrackInstance::setJunctingCracks(const boost::vector<XfemCrackInstance> &junctingCracks)
        {
        _junctingCracks = junctingCracks;
        }
        std::string XfemCrackInstance::getJeveuxName() const
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

