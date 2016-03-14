#ifndef FAILURECONVERGENCEMANAGER_H_
#define FAILURECONVERGENCEMANAGER_H_

/**
 * @file FailureConvergenceManager.h
 * @brief Fichier entete de la classe FailureConvergenceManager
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"

#include "MemoryManager/JeveuxVector.h"
#include "Utilities/GenericParameter.h"
#include "Loads/PhysicalQuantity.h"

enum ActionType { StopOnErrorType, SubstepingOnErrorType,
                  SubstepingOnContactType, AddIterationOnErrorType, PilotageErrorType,
                  ChangePenalisationOnErrorType, ContinueOnErrorType, NoActionType };

const int nbActions = 8; 
extern const char* ActionNames[nbActions];

enum ConnvergenceErrorType { ConvergenceErrorType, ResidualDivergenceErrorType,
                             IncrementOverboundErrorType, ContactDetectionErrorType,
                             InterpenetrationErrorType, InstabilityErrorType, NoErrorType };

const int nbErrors = 7; 
extern const char* ErrorNames[nbErrors];

class GenericActionInstance
{
private:
    GenParam         _actionName;
    const ActionType _type;

protected:
    ListGenParam     _listParam;

public:
    GenericActionInstance( ActionType type ): _actionName( "ACTION", std::string( ActionNames[ type ] ) ),
                                              _type( type )
    {
        _listParam.push_back( &_actionName );
    };

    GenericActionInstance(): _actionName( "ACTION",
                                          std::string( ActionNames[ NoActionType ], true ) ),
                             _type( NoActionType )
    {};

    ListGenParam& getListOfParameters()
    {
        return _listParam;
    };

    const ActionType& getType() const
    {
        return _type;
    };
};

class StopOnErrorInstance: public GenericActionInstance
{
public:
    StopOnErrorInstance(): GenericActionInstance( StopOnErrorType )
    {};
};

class ContinueOnErrorInstance: public GenericActionInstance
{
public:
    ContinueOnErrorInstance(): GenericActionInstance( ContinueOnErrorType )
    {};
};

class GenericSubstepingOnErrorInstance: public GenericActionInstance
{
private:
    GenParam _isAuto;
    GenParam _step;
    GenParam _level;
    GenParam _minimumStep;

protected:
    /**
     * @todo SUBD_METHODE devrait être aussi ailleurs
     */
    GenericSubstepingOnErrorInstance( ActionType type ): GenericActionInstance( type ),
                                                         _isAuto( "SUBD_METHODE", std::string( "MANUEL" ) ),
                                                         _step( "SUBD_PAS", 4. ),
                                                         _level( "SUBD_NIVEAU", 3 ),
                                                         _minimumStep( "SUBD_PAS_MINI", 0. )
    {
        _listParam.push_back( &_isAuto );
        _listParam.push_back( &_step );
        _listParam.push_back( &_level );
        _listParam.push_back( &_minimumStep );
    };

public:
    /**
     * @brief Constructeur
     */
    GenericSubstepingOnErrorInstance(): GenericSubstepingOnErrorInstance( NoActionType )
    {};

    ~GenericSubstepingOnErrorInstance()
    {};

    void setAutomatic( const bool& isAuto )
    {
        if ( isAuto )
        {
            _isAuto = "AUTO";
            _step.setIsSet( false );
            _level.setIsSet( false );
        }
        else
        {
            _isAuto = "MANUEL";
            _step.setValueIfUnset( 4. );
            _level.setValueIfUnset( 3 );
        }
    };

    void setLevel( const int& level )
    {
        _level = level;
    };

    void setMinimumStep( const double& minimumStep )
    {
        _minimumStep = minimumStep;
    };

    void setStep( const double& step )
    {
        _step = step;
    };
};

class SubstepingOnErrorInstance: public GenericSubstepingOnErrorInstance
{
protected:
    /**
     * @todo SUBD_METHODE devrait être aussi ailleurs
     */
    SubstepingOnErrorInstance( ActionType type ): GenericSubstepingOnErrorInstance( type )
    {};

public:
    /**
     * @brief Constructeur
     */
    SubstepingOnErrorInstance(): SubstepingOnErrorInstance( SubstepingOnErrorType )
    {};
};

class AddIterationOnErrorInstance: public GenericSubstepingOnErrorInstance
{
private:
    GenParam _pcent;

public:
    AddIterationOnErrorInstance(): GenericSubstepingOnErrorInstance( AddIterationOnErrorType ),
                                   _pcent( "PCENT_ITER_PLUS", 50. )
    {
        _listParam.push_back( &_pcent );
    };

    ~AddIterationOnErrorInstance()
    {};

    void setPourcentageOfAddedIteration( const double& pcent )
    {
        _pcent = pcent;
    };
};

class SubstepingOnContactInstance: public GenericActionInstance
{
private:
    GenParam _isAuto;
    GenParam _step;
    GenParam _level;
    GenParam _minimumStep;
    GenParam _timeStepSubstep;
    GenParam _substepDuration;

public:
    /**
     * @brief Constructeur
     */
    SubstepingOnContactInstance(): GenericActionInstance( SubstepingOnContactType ),
                                   _isAuto( "SUBD_METHODE", std::string( "AUTO" ) ),
                                   _step( "SUBD_PAS" ),
                                   _level( "SUBD_NIVEAU" ),
                                   _minimumStep( "SUBD_PAS_MINI" ),
                                   _timeStepSubstep( "SUBD_INST", 0., true ),
                                   _substepDuration( "SUBD_DUREE", 0., true )
    {
        std::cout << "Ici3" << std::endl;
        _listParam.push_back( &_isAuto );
        _listParam.push_back( &_step );
        _listParam.push_back( &_level );
        _listParam.push_back( &_minimumStep );
        _listParam.push_back( &_timeStepSubstep );
        _listParam.push_back( &_substepDuration );
    };

    ~SubstepingOnContactInstance()
    {};

    void setAutomatic( const bool& isAuto )
    {
        if ( isAuto )
        {
            _isAuto = "AUTO";

            _step.setIsSet( false );
            _level.setIsSet( false );
            _minimumStep.setIsSet( false );

            _timeStepSubstep.setMandatory( true );
            _substepDuration.setMandatory( true );
        }
        else
        {
            _isAuto = "MANUEL";

            _step.setValueIfUnset( 4. );
            _level.setValueIfUnset( 3 );
            _minimumStep.setValueIfUnset( 0. );

            _timeStepSubstep.setMandatory( false );
            _timeStepSubstep.setIsSet( false );
            _substepDuration.setMandatory( false );
            _substepDuration.setIsSet( false );
        }
    };

    void setSubstepDuration( const double& duration )
    {
        _substepDuration = duration;
    };

    void setTimeStepSubstep( const double& time )
    {
        _timeStepSubstep = time;
    };
};

class PilotageErrorInstance: public GenericSubstepingOnErrorInstance
{
public:
    PilotageErrorInstance(): GenericSubstepingOnErrorInstance( PilotageErrorType )
    {};
};

class ChangePenalisationOnErrorInstance: public GenericActionInstance
{
private:
    GenParam _coefMax;

public:
    ChangePenalisationOnErrorInstance(): GenericActionInstance( ChangePenalisationOnErrorType ),
                                         _coefMax( "COEF_MAXI", 1e12 )
    {
        _listParam.push_back( &_coefMax );
    };

    ~ChangePenalisationOnErrorInstance()
    {};

    void setMaximumPenalisationCoefficient( const double& coef )
    {
        _coefMax = coef;
    };
};

/** @typedef Pointeur intelligent vers un GenericActionInstance */
typedef boost::shared_ptr< GenericActionInstance > GenericActionPtr;

/** @typedef Pointeur intelligent vers un StopOnErrorInstance */
typedef boost::shared_ptr< StopOnErrorInstance > StopOnErrorPtr;
/** @typedef Pointeur intelligent vers un SubstepingOnErrorInstance */
typedef boost::shared_ptr< GenericSubstepingOnErrorInstance > GenericSubstepingOnErrorPtr;
/** @typedef Pointeur intelligent vers un SubstepingOnErrorInstance */
typedef boost::shared_ptr< SubstepingOnErrorInstance > SubstepingOnErrorPtr;
/** @typedef Pointeur intelligent vers un SubstepingOnContactInstance */
typedef boost::shared_ptr< SubstepingOnContactInstance > SubstepingOnContactPtr;
/** @typedef Pointeur intelligent vers un AddIterationOnErrorInstance */
typedef boost::shared_ptr< AddIterationOnErrorInstance > AddIterationOnErrorPtr;
/** @typedef Pointeur intelligent vers un PilotageErrorInstance */
typedef boost::shared_ptr< PilotageErrorInstance > PilotageErrorPtr;
/** @typedef Pointeur intelligent vers un ChangePenalisationOnErrorInstance */
typedef boost::shared_ptr< ChangePenalisationOnErrorInstance > ChangePenalisationOnErrorPtr;
/** @typedef Pointeur intelligent vers un ContinueOnErrorInstance */
typedef boost::shared_ptr< ContinueOnErrorInstance > ContinueOnErrorPtr;


/**
 * @class GenericConvergenceErrorInstance
 * @brief Cette classe définit une erreur générique de convergence dont
 *        les autres doivent hériter
 * @author Nicolas Sellenet
 */
class GenericConvergenceErrorInstance
{
private:
    GenericActionPtr _actionOnError;

protected:
    GenParam         _eventName;
    ListGenParam     _listSyntaxParam;

public:
    /**
     * @brief Constructeur
     */
    GenericConvergenceErrorInstance( ConnvergenceErrorType type ): 
                _eventName( "EVENEMENT", std::string( ErrorNames[ type ] ), true )
    {
        _listSyntaxParam.push_back( &_eventName );
    };

    /**
     * @brief Constructeur
     */
    GenericConvergenceErrorInstance(): _eventName( "EVENEMENT", NoErrorType, true )
    {};

    ~GenericConvergenceErrorInstance()
    {};

private:
    virtual void checkAllowedAction( const GenericActionPtr& action ) = 0;

public:
    /**
     * @brief Fonction permettant de récupérer l'action à réaliser en cas d'erreur
     * @return action à réaliser
     */
    const GenericActionPtr& getAction() const
    {
        return _actionOnError;
    };

    ListGenParam& getListOfParameters()
    {
        return _listSyntaxParam;
    };

    /**
     * @brief Fonction permettant de savoir si l'action en erreur a été définie
     * @return true si l'action a été fixée
     */
    bool isActionSet()
    {
        if ( ! _actionOnError ) return false;
        return true;
    };

    /**
     * @brief Fonction permettant de preciser l'action à réaliser en cas d'erreur
     * @param action action à réaliser
     */
    void setAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        _actionOnError = action;
        checkAllowedAction( action );
    };
};

/**
 * @class ConvergenceErrorInstance
 * @brief 
 * @author Nicolas Sellenet
 */
class ConvergenceErrorInstance: public GenericConvergenceErrorInstance
{
private:
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionType& type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnErrorType &&\
             type != AddIterationOnErrorType && type != PilotageErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /**
     * @brief Constructeur
     */
    ConvergenceErrorInstance(): GenericConvergenceErrorInstance( ConvergenceErrorType )
    {};

    ~ConvergenceErrorInstance()
    {};
};

/**
 * @class ResidualDivergenceErrorInstance
 * @brief 
 * @author Nicolas Sellenet
 */
class ResidualDivergenceErrorInstance: public GenericConvergenceErrorInstance
{
private:
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionType& type = action->getType();
        if ( type != SubstepingOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /**
     * @brief Constructeur
     */
    ResidualDivergenceErrorInstance(): GenericConvergenceErrorInstance( ResidualDivergenceErrorType )
    {};

    ~ResidualDivergenceErrorInstance()
    {};
};

/**
 * @class IncrementOverboundErrorInstance
 * @brief 
 * @author Nicolas Sellenet
 */
class IncrementOverboundErrorInstance: public GenericConvergenceErrorInstance
{
private:
    GenParam _value;
    GenParam _fieldName;
    GenParam _component;

    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionType& type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /**
     * @brief Constructeur
     */
    IncrementOverboundErrorInstance(): GenericConvergenceErrorInstance( IncrementOverboundErrorType ),
                                       _value( "VALE_REF", true ),
                                       _fieldName( "NOM_CHAM", "", true ),
                                       _component( "NOM_CMP", true )
    {
        _listSyntaxParam.push_back( &_value );
        _listSyntaxParam.push_back( &_fieldName );
        _listSyntaxParam.push_back( &_component );
    };

    ~IncrementOverboundErrorInstance()
    {};

    void setValueToInspect( const double& value, const std::string& fieldName,
                            const PhysicalQuantityComponent& component )
    {
        _value = value;
        _fieldName.setValue( fieldName );
        _component = ComponentNames[ component ];
    };
};

/**
 * @class ContactDetectionErrorInstance
 * @brief 
 * @author Nicolas Sellenet
 */
class ContactDetectionErrorInstance: public GenericConvergenceErrorInstance
{
private:
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionType& type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnContactType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /**
     * @brief Constructeur
     */
    ContactDetectionErrorInstance(): GenericConvergenceErrorInstance( ContactDetectionErrorType )
    {};

    ~ContactDetectionErrorInstance()
    {};
};

/**
 * @class InterpenetrationErrorInstance
 * @brief 
 * @author Nicolas Sellenet
 * @todo ajouter les mots-clés manquants
 */
class InterpenetrationErrorInstance: public GenericConvergenceErrorInstance
{
private:
    GenParam _maxPenetration;

    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionType& type = action->getType();
        if ( type != StopOnErrorType && type != ChangePenalisationOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /**
     * @brief Constructeur
     */
    InterpenetrationErrorInstance(): GenericConvergenceErrorInstance( InterpenetrationErrorType ),
                                     _maxPenetration( "PENE_MAXI", true )
    {
        _listSyntaxParam.push_back( &_maxPenetration );
    };

    ~InterpenetrationErrorInstance()
    {};

    void setMaximalPenetration( const double& value )
    {
        _maxPenetration = value;
    };
};

/**
 * @class InstabilityErrorInstance
 * @brief 
 * @author Nicolas Sellenet
 */
class InstabilityErrorInstance: public GenericConvergenceErrorInstance
{
private:
    void checkAllowedAction( const GenericActionPtr& action ) throw ( std::runtime_error )
    {
        const ActionType& type = action->getType();
        if ( type != StopOnErrorType && type != ContinueOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

public:
    /**
     * @brief Constructeur
     */
    InstabilityErrorInstance(): GenericConvergenceErrorInstance( InstabilityErrorType )
    {};

    ~InstabilityErrorInstance()
    {};
};


/** @typedef Pointeur intelligent vers un GenericConvergenceErrorInstance */
typedef boost::shared_ptr< GenericConvergenceErrorInstance > GenericConvergenceErrorPtr;
/** @typedef Pointeur intelligent vers un ConvergenceErrorInstance */
typedef boost::shared_ptr< ConvergenceErrorInstance > ConvergenceErrorPtr;
/** @typedef Pointeur intelligent vers un ResidualDivergenceErrorInstance */
typedef boost::shared_ptr< ResidualDivergenceErrorInstance > ResidualDivergenceErrorPtr;
/** @typedef Pointeur intelligent vers un IncrementOverboundErrorInstance */
typedef boost::shared_ptr< IncrementOverboundErrorInstance > IncrementOverboundErrorPtr;
/** @typedef Pointeur intelligent vers un ContactDetectionErrorInstance */
typedef boost::shared_ptr< ContactDetectionErrorInstance > ContactDetectionErrorPtr;
/** @typedef Pointeur intelligent vers un InterpenetrationErrorInstance */
typedef boost::shared_ptr< InterpenetrationErrorInstance > InterpenetrationErrorPtr;
/** @typedef Pointeur intelligent vers un InstabilityErrorInstance */
typedef boost::shared_ptr< InstabilityErrorInstance > InstabilityErrorPtr;


/** @typedef std::list de GenericConvergenceErrorPtr */
typedef std::list< GenericConvergenceErrorPtr > ListConvError;
/** @typedef Iterateur sur une std::list de GenericConvergenceErrorPtr */
typedef ListConvError::iterator ListConvErrorIter;
/** @typedef Iterateur constant sur une std::list de GenericConvergenceErrorPtr */
typedef ListConvError::const_iterator ListConvErrorCIter;

#endif /* FAILURECONVERGENCEMANAGER_H_ */
