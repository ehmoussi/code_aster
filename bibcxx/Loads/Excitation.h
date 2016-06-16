#ifndef EXCITATION_H_
#define EXCITATION_H_

/**
 * @file Excitation.h
 * @brief Header file of Excitation class 
 *        This class allows to define a source term for a nonlinear analysis 
 * @author Natacha Béreux 
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

#include <stdexcept>
#include <list>
#include <vector>
#include <string>

#include "astercxx.h"
#include "Function/Function.h"
#include "Loads/MechanicalLoad.h"
#include "Loads/KinematicsLoad.h"
#include "Utilities/CapyConvertibleValue.h"

/**
 * @enum ExcitationEnum 
 * @brief Every kind of source terms : "standard" means "set on the reference geometry and not driven"       
 */
enum ExcitationEnum { StandardExcitation, DrivenExcitation, OnUpdatedGeometryExcitation, IncrementalDirichletExcitation };
extern const std::vector<ExcitationEnum> allExcitation;
extern const std::vector<std::string> allExcitationNames;

/**
 * @class ExcitationInstance
 * @brief It is a source term used in a nonlinear static analysis
 * @author Natacha Béreux 
 */
class ExcitationInstance
{
private:
    ExcitationEnum _typeExcit; 
    KinematicsLoadPtr        _kinematicLoad;
    GenericMechanicalLoadPtr _mecaLoad; 
    FunctionPtr              _multFunction; 
    CapyConvertibleContainer _toCapyConverter;

public:
   
    ExcitationInstance( ExcitationEnum typeExcit= StandardExcitation ):
        _typeExcit( typeExcit )
    {
        _toCapyConverter.add( new CapyConvertibleValue< KinematicsLoadPtr > 
                                                      (true, "CHARGE", _kinematicLoad, 
                                                       false ) );
        _toCapyConverter.add( new CapyConvertibleValue< FunctionPtr > 
                                                      (false, "FONC_MULT", _multFunction, 
                                                       false ) );
        _toCapyConverter.add( new CapyConvertibleValue< ExcitationEnum >
                                                      ( true, "TYPE_CHARGE", _typeExcit,
                                                        allExcitation, allExcitationNames,
                                                        true ) );
    };
    /** @function setKinematicLoad
     * @brief sets the kinematicLoad attribut 
    */
    void setKinematicLoad( KinematicsLoadPtr kineLoad )
    {
        _kinematicLoad = kineLoad;
        _toCapyConverter[ "CHARGE" ]->enable();
    };
    /** @function setMechanicalLoad
     * @brief sets the mecaLoad attribut 
    */   
    void setMechanicalLoad( GenericMechanicalLoadPtr mecaLoad )
    {
        _mecaLoad = mecaLoad;
        _toCapyConverter[ "CHARGE" ]->enable();
    };
    /** @function setMultiplicativeFunction
     * @brief sets the setMultiplicativeFunction 
     *        which defines how the load evolves.  
    */   
    void setMultiplicativeFunction( FunctionPtr f ) 
    {
        _multFunction = f;
         _toCapyConverter[ "FONC_MULT" ]->enable();
    };
    /** @function getCapyConvertibleContainer
     * @brief returns aster keywords   
    */   
    const CapyConvertibleContainer& getCapyConvertibleContainer() const
    {
        return _toCapyConverter;
    };
};

/**
 * @typedef 
 * @brief Pointeur intelligent vers une excitation 
 */
typedef boost::shared_ptr< ExcitationInstance > ExcitationPtr;

#endif /*EXCITATION_H_ */
