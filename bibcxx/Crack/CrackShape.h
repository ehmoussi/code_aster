#ifndef CRACKSHAPE_H_
#define CRACKSHAPE_H_

/**
 * @file XfemCrack.h
 * @brief Fichier entete de la classe XfemCrack
 * @author Nicolas Tardieu
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

/* person_in_charge: nicolas.tardieu at edf.fr */

#include "astercxx.h"

/**
 * @class CrackShape
 * @brief Class to store the nature of the crack shape
 * @author Nicolas Tardieu
 */
enum Shape { NoShape, Ellipse, Square, Cylinder, Notch, HalfPlane, Segment, HalfLine, Line };
class CrackShapeClass {
  private:
    Shape _shape;
    double _semiMajorAxis;
    double _semiMinorAxis;
    VectorReal _center;
    VectorReal _vectX;
    VectorReal _vectY;
    std::string _crackSide;
    double _filletRadius;
    double _halfLength;
    VectorReal _endPoint;
    VectorReal _normal;
    VectorReal _tangent;
    VectorReal _startingPoint;

  public:
    /**
     * @typedef CrackShapePtr
     * @brief Pointeur intelligent vers un CrackShapeClass
     */
    typedef boost::shared_ptr< CrackShapeClass > CrackShapePtr;

    /**
     * @brief Constructeur
     */
    CrackShapeClass();

    /**
     * @brief Define the Crack Shape as Ellise
     */
    void setEllipseCrackShape( double semiMajorAxis, double semiMinorAxis,
                               VectorReal center, VectorReal vectX,
                               VectorReal vectY, std::string crackSide = "IN" );

    /**
     * @brief Define the Crack Shape as Square
     */
    void setSquareCrackShape( double semiMajorAxis, double semiMinorAxis, double filletRadius,
                              VectorReal center, VectorReal vectX,
                              VectorReal vectY, std::string crackSide = "IN" );

    /**
     * @brief Define the Crack Shape as Cylinder
     */
    void setCylinderCrackShape( double semiMajorAxis, double semiMinorAxis,
                                VectorReal center, VectorReal vectX,
                                VectorReal vectY );

    /**
     * @brief Define the Crack Shape as Notch
     */
    void setNotchCrackShape( double halfLength, double filletRadius, VectorReal center,
                             VectorReal vectX, VectorReal vectY );

    /**
     * @brief Define the Crack Shape as Half Plane
     */
    void setHalfPlaneCrackShape( VectorReal endPoint, VectorReal normal,
                                 VectorReal tangent );

    /**
     * @brief Define the Crack Shape as Segment
     */
    void setSegmentCrackShape( VectorReal startingPoint,
                               VectorReal endPoint );

    /**
     * @brief Define the Crack Shape as Half Line
     */
    void setHalfLineCrackShape( VectorReal startingPoint,
                                VectorReal tangent );

    /**
     * @brief Define the Crack Shape as Line
     */
    void setLineCrackShape( VectorReal startingPoint, VectorReal tangent );

    Shape getShape() const { return _shape; };

    std::string getShapeName() const;

    double getSemiMajorAxis() const { return _semiMajorAxis; };

    double getSemiMinorAxis() const { return _semiMinorAxis; };

    const VectorReal getCenter() const { return _center; };

    const VectorReal getVectX() const { return _vectX; };
    const VectorReal getVectY() const { return _vectY; };

    std::string getCrackSide() const { return _crackSide; };

    double getFilletRadius() const { return _filletRadius; };

    double getHalfLength() const { return _halfLength; };

    const VectorReal getEndPoint() const { return _endPoint; };

    const VectorReal getNormal() const { return _normal; };

    const VectorReal getTangent() const { return _tangent; };

    const VectorReal getStartingPoint() const { return _startingPoint; };
};

/**
 * @typedef CrackShapePtr
 * @brief Pointeur intelligent vers un CrackShapeClass
 */
typedef boost::shared_ptr< CrackShapeClass > CrackShapePtr;

#endif /* CRACKSHAPE_H_ */
