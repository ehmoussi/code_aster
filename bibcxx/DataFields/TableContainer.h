#ifndef TABLECONTAINER_H_
#define TABLECONTAINER_H_

/**
 * @file TableContainer.h
 * @brief Fichier entete de la classe TableContainer
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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

#include <string>

#include "astercxx.h"
#include "aster_fort.h"

#include "MemoryManager/JeveuxVector.h"
#include "DataFields/Table.h"

#include "LinearAlgebra/GeneralizedAssemblyMatrix.h"
#include "LinearAlgebra/ElementaryMatrix.h"
#include "LinearAlgebra/ElementaryVector.h"
#include "DataFields/GenericDataField.h"
#include "DataFields/FieldOnNodes.h"
#include "DataFields/PCFieldOnMesh.h"
#include "DataFields/FieldOnElements.h"
#include "Results/MechanicalModeContainer.h"
#include "Functions/Function.h"
#include "Functions/Surface.h"
#include <map>

/**
 * @typedef TableContainerInstance
 * @brief Definition of TableContainerInstance (table_container)
 */
class TableContainerInstance : public TableInstance
{
  private:
    JeveuxVectorChar16 _objectName;
    JeveuxVectorChar16 _objectType;
    JeveuxVectorChar24 _dsName;
    std::vector< JeveuxVectorLong > _vecOfSizes;
    std::vector< JeveuxVectorLong > _others;

    std::map< std::string, GeneralizedAssemblyMatrixDoublePtr > _mapGAMD;
    std::map< std::string, ElementaryMatrixDisplacementDoublePtr > _mapEMDD;
    std::map< std::string, ElementaryMatrixTemperatureDoublePtr > _mapEMTD;
    std::map< std::string, ElementaryVectorDisplacementDoublePtr > _mapEVDD;
    std::map< std::string, ElementaryVectorTemperatureDoublePtr > _mapEVTD;
    std::map< std::string, GenericDataFieldPtr > _mapGDF;
    std::map< std::string, FieldOnNodesDoublePtr > _mapFOND;
    std::map< std::string, PCFieldOnMeshDoublePtr > _mapPCFOMD;
    std::map< std::string, FieldOnElementsDoublePtr > _mapFOED;
    std::map< std::string, MechanicalModeContainerPtr > _mapMMC;
    std::map< std::string, TablePtr > _mapT;
    std::map< std::string, FunctionPtr > _mapF;
    std::map< std::string, FunctionComplexPtr > _mapFC;
    std::map< std::string, SurfacePtr > _mapS;

  public:
    /**
    * @typedef TableContainerPtr
    * @brief Definition of a smart pointer to a TableContainerInstance
    */
    typedef boost::shared_ptr< TableContainerInstance > TableContainerPtr;

    /**
    * @brief Constructeur
    * @param name Nom Jeveux du champ aux noeuds
    */
    TableContainerInstance( const std::string &name ):
        TableInstance( name, "TABLE_CONTAINER" )
    {};

    /**
     * @brief Constructeur
     */
    TableContainerInstance():
        TableContainerInstance( ResultNaming::getNewResultName() )
    {};

    /**
     * @brief Get ElementaryMatrixDisplacementDouble stored in TableContainer
     * @param name key used to find object
     */
    ElementaryMatrixDisplacementDoublePtr getElementaryMatrixDisplacementDouble
        ( const std::string& name );

    /**
     * @brief Get ElementaryMatrixTemperatureDouble stored in TableContainer
     * @param name key used to find object
     */
    ElementaryMatrixTemperatureDoublePtr getElementaryMatrixTemperatureDouble( const std::string& );

    /**
     * @brief Get ElementaryVectorDisplacementDouble stored in TableContainer
     * @param name key used to find object
     */
    ElementaryVectorDisplacementDoublePtr getElementaryVectorDisplacementDouble
        ( const std::string& );

    /**
     * @brief Get ElementaryVectorTemperatureDouble stored in TableContainer
     * @param name key used to find object
     */
    ElementaryVectorTemperatureDoublePtr getElementaryVectorTemperatureDouble( const std::string& );

    /**
     * @brief Get FieldOnElementsDouble stored in TableContainer
     * @param name key used to find object
     */
    FieldOnElementsDoublePtr getFieldOnElementsDouble( const std::string& );

    /**
     * @brief Get FieldOnNodesDouble stored in TableContainer
     * @param name key used to find object
     */
    FieldOnNodesDoublePtr getFieldOnNodesDouble( const std::string& );

    /**
     * @brief Get Function stored in TableContainer
     * @param name key used to find object
     */
    FunctionPtr getFunction( const std::string& );

    /**
     * @brief Get FunctionComplex stored in TableContainer
     * @param name key used to find object
     */
    FunctionComplexPtr getFunctionComplex( const std::string& );

    /**
     * @brief Get generalized assembly matrix stored in TableContainer
     * @param name key used to find object
     */
    GeneralizedAssemblyMatrixDoublePtr getGeneralizedAssemblyMatrix( const std::string& );

    /**
     * @brief Get GenericDataField stored in TableContainer
     * @param name key used to find object
     */
    GenericDataFieldPtr getGenericDataField( const std::string& );

    /**
     * @brief Get MechanicalModeContainer stored in TableContainer
     * @param name key used to find object
     */
    MechanicalModeContainerPtr getMechanicalModeContainer( const std::string& );

    /**
     * @brief Get PCFieldOnMeshDouble stored in TableContainer
     * @param name key used to find object
     */
    PCFieldOnMeshDoublePtr getPCFieldOnMeshDouble( const std::string& );

    /**
     * @brief Get Surface stored in TableContainer
     * @param name key used to find object
     */
    SurfacePtr getSurface( const std::string& );

    /**
     * @brief Get Table stored in TableContainer
     * @param name key used to find object
     */
    TablePtr getTable( const std::string& );

    /**
     * @brief Update the table
     * @todo add the case of PCFieldOnMesh
     */
    bool update();
};

#endif /* TABLECONTAINER_H_ */
