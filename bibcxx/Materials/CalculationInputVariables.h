#ifndef CALCULATIONINPUTVARIABLES_H_
#define CALCULATIONINPUTVARIABLES_H_

/**
 * @file CalculationInputVariables.h
 * @brief Fichier entete de la classe CalculationInputVariables
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
#include "Materials/MaterialOnMesh.h"
#include "Modeling/Model.h"
#include "Discretization/ElementaryCharacteristics.h"
#include "DataFields/FieldOnElements.h"
#include "DataFields/PCFieldOnMesh.h"
#include "DataStructures/DataStructure.h"

/**
 * @class CalculationInputVariablesInstance
 * @brief Calculation Input Variables
 * @author Nicolas Sellenet
 */
class CalculationInputVariablesInstance: public DataStructure
{
private:
    ModelPtr                     _model;
    MaterialOnMeshPtr            _mater;
    ElementaryCharacteristicsPtr _elemCara;
    FieldOnElementsDoublePtr     _varRef;
    FieldOnElementsDoublePtr     _varInst;
    PCFieldOnMeshDoublePtr       _timeValue;
    double                       _currentTime;
    bool                         _pTot;
    bool                         _hydr;
    bool                         _sech;
    bool                         _temp;

public:
    /**
     * @typedef CalculationInputVariablesPtr
     * @brief Pointeur intelligent vers un CalculationInputVariables
     */
    typedef boost::shared_ptr< CalculationInputVariablesInstance > CalculationInputVariablesPtr;

    /**
     * @brief Constructeur
     */
    CalculationInputVariablesInstance( const ModelPtr& model, const MaterialOnMeshPtr& mater,
                                       const ElementaryCharacteristicsPtr& cara ):
        DataStructure( "VARI_COM", Permanent, 14 ),
        _model( model ),
        _mater( mater ),
        _elemCara( cara ),
        _varRef( new FieldOnElementsDoubleInstance( _model->getName() + ".CHVCREF" ) ),
        _varInst( new FieldOnElementsDoubleInstance( getName() + ".TOUT" ) ),
        _timeValue( new PCFieldOnMeshDoubleInstance( getName() + ".INST",
                                                     _model->getSupportMesh() ) ),
        _currentTime( -1.0 ),
        _pTot( _mater->existsCalculationInputVariable( "PTOT" ) ),
        _hydr( _mater->existsCalculationInputVariable( "HYDR" ) ),
        _sech( _mater->existsCalculationInputVariable( "SECH" ) ),
        _temp( _mater->existsCalculationInputVariable( "TEMP" ) )
    {
        std::string modName( _model->getName(), 0, 8 ), matName( _mater->getName(), 0, 8 );
        std::string carName( ' ', 8 );
        if ( _elemCara != nullptr )
            carName = std::string( _elemCara->getName(), 0, 8 );
        CALLO_VRCREF( modName, matName, carName, _varRef->getName() );
    };

    /**
     * @brief Destructeur
     */
    ~CalculationInputVariablesInstance()
    {
        return;
    };

    /**
     * @brief Compute Input Variables at a given time
     */
    void compute( const double& time )
    {
        _currentTime = time;
        _varInst->deallocate();
        _timeValue->deallocate();

        std::string modName( _model->getName(), 0, 8 ), matName( _mater->getName(), 0, 8 );
        std::string carName( _elemCara->getName(), 0, 8 );
        std::string out( ' ', 2 );
        CALLO_VRCINS_WRAP( modName, matName, carName, &time, _varInst->getName(), out );

        std::string comp( "INST_R" );
        _timeValue->allocate( Permanent, comp );
        PCFieldZone a( _model->getSupportMesh() );
        PCFieldValues< double > b( {"INST"}, {time} );
        _timeValue->setValueOnZone( a, b );
    };
};

/**
 * @typedef CalculationInputVariablesPtr
 * @brief Pointeur intelligent vers un CalculationInputVariablesInstance
 */
typedef boost::shared_ptr< CalculationInputVariablesInstance > CalculationInputVariablesPtr;


#endif /* CALCULATIONINPUTVARIABLES_H_ */
