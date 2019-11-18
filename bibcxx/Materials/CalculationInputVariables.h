#ifndef CALCULATIONINPUTVARIABLES_H_
#define CALCULATIONINPUTVARIABLES_H_

/**
 * @file CalculationInputVariables.h
 * @brief Fichier entete de la classe CalculationInputVariables
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
#include "aster_fort.h"
#include "Materials/MaterialOnMesh.h"
#include "Materials/CodedMaterial.h"
#include "Modeling/Model.h"
#include "Discretization/ElementaryCharacteristics.h"
#include "DataFields/FieldOnElements.h"
#include "DataFields/FieldOnNodes.h"
#include "DataFields/PCFieldOnMesh.h"
#include "DataStructures/DataStructure.h"
#include "Discretization/DOFNumbering.h"

/**
 * @class CalculationInputVariablesInstance
 * @brief Calculation Input Variables
 * @author Nicolas Sellenet
 */
class CalculationInputVariablesInstance : public DataStructure {
  private:
    ModelPtr _model;
    MaterialOnMeshPtr _mater;
    CodedMaterialPtr _codMater;
    ElementaryCharacteristicsPtr _elemCara;
    FieldOnElementsDoublePtr _varRef;
    FieldOnElementsDoublePtr _varInst;
    PCFieldOnMeshDoublePtr _timeValue;
    double _currentTime;
    bool _pTot;
    bool _hydr;
    bool _sech;
    bool _temp;

  public:
    /**
     * @typedef CalculationInputVariablesPtr
     * @brief Pointeur intelligent vers un CalculationInputVariables
     */
    typedef boost::shared_ptr< CalculationInputVariablesInstance > CalculationInputVariablesPtr;

    /**
     * @brief Constructeur
     */
    CalculationInputVariablesInstance( const ModelPtr &model, const MaterialOnMeshPtr &mater,
                                       const ElementaryCharacteristicsPtr &cara,
                                       const CodedMaterialPtr &codMater );

    /**
     * @brief Destructeur
     */
    ~CalculationInputVariablesInstance() { return; };

    /**
     * @brief Compute Input Variables at a given time
     */
    void compute( const double &time );

    /**
     * @brief Compute Loads after computing of input variables
     */
    FieldOnNodesDoublePtr computeMechanicalLoads( const BaseDOFNumberingPtr &dofNUM );

    bool existsMechanicalLoads() { return _pTot || _hydr || _sech || _temp; };
};

/**
 * @typedef CalculationInputVariablesPtr
 * @brief Pointeur intelligent vers un CalculationInputVariablesInstance
 */
typedef boost::shared_ptr< CalculationInputVariablesInstance > CalculationInputVariablesPtr;

#endif /* CALCULATIONINPUTVARIABLES_H_ */
