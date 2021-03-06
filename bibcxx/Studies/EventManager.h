#ifndef EVENTMANAGER_H_
#define EVENTMANAGER_H_

/**
 * @file EventManager.h
 * @brief Fichier entete de la classe EventManager
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

#include "MemoryManager/JeveuxVector.h"
#include "Utilities/GenericParameter.h"
#include "Loads/PhysicalQuantity.h"

/**
 * @enum ActionTypeEnum
 * @brief Types d'action pouvant être entreprises en cas d'erreur de convergence
 * @author Nicolas Sellenet
 */
enum ActionTypeEnum {
    StopOnErrorType,
    SubstepingOnErrorType,
    SubstepingOnContactType,
    AddIterationOnErrorType,
    PilotageErrorType,
    ChangePenalisationOnErrorType,
    ContinueOnErrorType,
    NoActionType
};

const int nbActions = 8;
/**
 * @var ActionNames
 * @brief Nom au sens capy des actions
 */
extern const char *ActionNames[nbActions];

/**
 * @enum EventErrorTypeEnum
 * @brief Types d'action pouvant être détectées dans l'algo de STAT_NON_LINE
 * @author Nicolas Sellenet
 */
enum EventErrorTypeEnum {
    EventErrorType,
    ResidualDivergenceErrorType,
    IncrementOverboundErrorType,
    ContactDetectionErrorType,
    InterpenetrationErrorType,
    InstabilityErrorType,
    NoErrorType
};

const int nbErrors = 7;
/**
 * @var ErrorNames
 * @brief Nom au sens capy des erreurs
 */
extern const char *ErrorNames[nbErrors];

/**
 * @class GenericActionClass
 * @brief Cette classe définit une action générique en cas d'erreur détéctée
 * @author Nicolas Sellenet
 * @todo peut-être passer le type d'action en argument template
 */
class GenericActionClass {
  private:
    /** @brief Nom (capy) de l'action */
    GenParam _actionName;
    /** @brief Type de l'erreur */
    const ActionTypeEnum _type;

  protected:
    /** @brief Liste des paramètres liés à l'action */
    ListGenParam _listParam;

  public:
    /**
     * @brief Constructeur
     * @param type Type de l'action
     */
    GenericActionClass( ActionTypeEnum type )
        : _actionName( "ACTION", std::string( ActionNames[type] ), true ), _type( type ) {
        _listParam.push_back( &_actionName );
    };

    /**
     * @brief Constructeur par défaut
     */
    GenericActionClass()
        : _actionName( "ACTION", std::string( ActionNames[NoActionType] ), true ),
          _type( NoActionType ){};

    /**
     * @brief Récupération de la liste des paramètres de l'action
     * @return Liste constante des paramètres déclarés
     */
    const ListGenParam &getListOfParameters() const { return _listParam; };

    /**
     * @brief Récupération du type d'action
     * @return type ActionTypeEnum de l'action
     */
    const ActionTypeEnum &getType() const { return _type; };
};

/**
 * @class StopOnErrorClass
 * @brief Classe correspondant à l'action "ARRET"
 * @author Nicolas Sellenet
 */
class StopOnErrorClass : public GenericActionClass {
  public:
    /** @brief Constructeur par défaut */
    StopOnErrorClass() : GenericActionClass( StopOnErrorType ){};
};

/**
 * @class ContinueOnErrorClass
 * @brief Classe correspondant à l'action "CONTINUE"
 * @author Nicolas Sellenet
 */
class ContinueOnErrorClass : public GenericActionClass {
  public:
    /** @brief Constructeur par défaut */
    ContinueOnErrorClass() : GenericActionClass( ContinueOnErrorType ){};
};

/**
 * @class GenericSubstepingOnErrorClass
 * @brief Classe correspondant à l'action générique "DECOUPE"
 * @author Nicolas Sellenet
 */
class GenericSubstepingOnErrorClass : public GenericActionClass {
  private:
    /** @brief Paramètre SUBD_METHODE */
    GenParam _isAuto;
    /** @brief Paramètre SUBD_PAS */
    GenParam _step;
    /** @brief Paramètre SUBD_NIVEAU */
    GenParam _level;
    /** @brief Paramètre SUBD_PAS_MINI */
    GenParam _minimumStep;

  protected:
    /**
     * @brief Constructeur appelable depuis les classes filles
     * @param type ActionTypeEnum
     */
    GenericSubstepingOnErrorClass( ActionTypeEnum type )
        : GenericActionClass( type ), _isAuto( "SUBD_METHODE", std::string( "MANUEL" ), false ),
          _step( "SUBD_PAS", (ASTERINTEGER)4, false ),
          _level( "SUBD_NIVEAU", (ASTERINTEGER)3, false ),
          _minimumStep( "SUBD_PAS_MINI", 0., false ) {
        _listParam.push_back( &_isAuto );
        _listParam.push_back( &_step );
        _listParam.push_back( &_level );
        _listParam.push_back( &_minimumStep );
    };

  public:
    /** @brief Constructeur par défaut */
    GenericSubstepingOnErrorClass() : GenericSubstepingOnErrorClass( NoActionType ){};

    ~GenericSubstepingOnErrorClass(){};

    /**
     * @brief Fixer la méthode de découpage du pas de temps
     * @param isAuto true si SUBD_METHODE = "AUTO"
     */
    void setAutomatic( const bool &isAuto ) {
        if ( isAuto ) {
            _isAuto = "AUTO";
            _step.setIsSet( false );
            _level.setIsSet( false );
        } else {
            _isAuto = "MANUEL";
            _step.setValueIfUnset( (ASTERINTEGER)4 );
            _level.setValueIfUnset( (ASTERINTEGER)3 );
        }
    };

    /**
     * @brief Fixer le niveau de sous-découpage
     * @param level niveau
     */
    void setLevel( const ASTERINTEGER &level ) { _level = level; };

    /**
     * @brief Fixer le pas minimum
     * @param minimumStep valeur pour SUBD_PAS_MINI
     */
    void setMinimumStep( const double &minimumStep ) { _minimumStep = minimumStep; };

    /**
     * @brief Fixer le nombre de découpage d'un pas de temps
     */
    void setStep( const ASTERINTEGER &step ) { _step = step; };
};

/**
 * @class SubstepingOnErrorClass
 * @brief Classe correspondant à l'action "DECOUPE"
 * @author Nicolas Sellenet
 */
class SubstepingOnErrorClass : public GenericSubstepingOnErrorClass {
  public:
    /** @brief Constructeur */
    SubstepingOnErrorClass() : GenericSubstepingOnErrorClass( SubstepingOnErrorType ){};
};

/**
 * @class AddIterationOnErrorClass
 * @brief Classe correspondant à l'action générique "ITER_SUPPL"
 * @author Nicolas Sellenet
 */
class AddIterationOnErrorClass : public GenericSubstepingOnErrorClass {
  private:
    /** @brief Paramètre PCENT_ITER_PLUS */
    GenParam _pcent;

  public:
    AddIterationOnErrorClass()
        : GenericSubstepingOnErrorClass( AddIterationOnErrorType ),
          _pcent( "PCENT_ITER_PLUS", 50., false ) {
        _listParam.push_back( &_pcent );
    };

    ~AddIterationOnErrorClass(){};

    /**
     * @brief Fixer PCENT_ITER_PLUS
     * @param pcent double précisant le pourcentage
     */
    void setPourcentageOfAddedIteration( const double &pcent ) { _pcent = pcent; };
};

/**
 * @class SubstepingOnContactClass
 * @brief Classe correspondant à l'action "DECOUPE" en situation de contact
 * @author Nicolas Sellenet
 */
class SubstepingOnContactClass : public GenericActionClass {
  private:
    /** @brief Paramètre SUBD_METHODE */
    GenParam _isAuto;
    /** @brief Paramètre SUBD_PAS */
    GenParam _step;
    /** @brief Paramètre SUBD_NIVEAU */
    GenParam _level;
    /** @brief Paramètre SUBD_PAS_MINI */
    GenParam _minimumStep;
    /** @brief Paramètre SUBD_INST */
    GenParam _timeStepSubstep;
    /** @brief Paramètre SUBD_DUREE */
    GenParam _substepDuration;

  public:
    /** @brief Constructeur */
    SubstepingOnContactClass()
        : GenericActionClass( SubstepingOnContactType ),
          _isAuto( "SUBD_METHODE", std::string( "AUTO" ), false ), _step( "SUBD_PAS", false ),
          _level( "SUBD_NIVEAU", false ), _minimumStep( "SUBD_PAS_MINI", false ),
          _timeStepSubstep( "SUBD_INST", 0., true ), _substepDuration( "SUBD_DUREE", 0., true ) {
        _listParam.push_back( &_isAuto );
        _listParam.push_back( &_step );
        _listParam.push_back( &_level );
        _listParam.push_back( &_minimumStep );
        _listParam.push_back( &_timeStepSubstep );
        _listParam.push_back( &_substepDuration );
    };

    ~SubstepingOnContactClass(){};

    /**
     * @brief Fixer la méthode de découpage du pas de temps
     * @param isAuto true si SUBD_METHODE = "AUTO"
     */
    void setAutomatic( const bool &isAuto ) {
        if ( isAuto ) {
            _isAuto = "AUTO";

            _step.setIsSet( false );
            _level.setIsSet( false );
            _minimumStep.setIsSet( false );

            _timeStepSubstep.setMandatory( true );
            _substepDuration.setMandatory( true );
        } else {
            _isAuto = "MANUEL";

            _step.setValueIfUnset( (ASTERINTEGER)4 );
            _level.setValueIfUnset( (ASTERINTEGER)3 );
            _minimumStep.setValueIfUnset( 0. );

            _timeStepSubstep.setMandatory( false );
            _timeStepSubstep.setIsSet( false );
            _substepDuration.setMandatory( false );
            _substepDuration.setIsSet( false );
        }
    };

    /**
     * @brief Fixer le niveau de sous-découpage
     * @param level niveau
     */
    void setLevel( const ASTERINTEGER &level ) { _level = level; };

    /**
     * @brief Fixer le pas minimum
     * @param minimumStep valeur pour SUBD_PAS_MINI
     */
    void setMinimumStep( const double &minimumStep ) { _minimumStep = minimumStep; };

    /**
     * @brief Fixer le nombre de découpage d'un pas de temps
     */
    void setStep( const ASTERINTEGER &step ) { _step = step; };

    /**
     * @brief Fixer la durée du sous-découage
     * @param duration double contenant la durée
     */
    void setSubstepDuration( const double &duration ) { _substepDuration = duration; };

    /**
     * @brief Fixer l'instant du sous-découpage
     * @param time double contenant l'instant
     */
    void setTimeStepSubstep( const double &time ) { _timeStepSubstep = time; };
};

/**
 * @class PilotageErrorClass
 * @brief Classe correspondant à l'action "AUTRE_PILOTAGE"
 * @author Nicolas Sellenet
 */
class PilotageErrorClass : public GenericSubstepingOnErrorClass {
  public:
    /** @brief Constructeur */
    PilotageErrorClass() : GenericSubstepingOnErrorClass( PilotageErrorType ){};
};

/**
 * @class PilotageErrorClass
 * @brief Classe correspondant à l'action "ADAPT_COEF_PENA"
 * @author Nicolas Sellenet
 */
class ChangePenalisationOnErrorClass : public GenericActionClass {
  private:
    GenParam _coefMax;

  public:
    /** @brief Constructeur */
    ChangePenalisationOnErrorClass()
        : GenericActionClass( ChangePenalisationOnErrorType ),
          _coefMax( "COEF_MAXI", 1e12, false ) {
        _listParam.push_back( &_coefMax );
    };

    ~ChangePenalisationOnErrorClass(){};

    /** @brief Fixer COEF_MAXI */
    void setMaximumPenalisationCoefficient( const double &coef ) { _coefMax = coef; };
};

/** @typedef Pointeur intelligent vers un GenericActionClass */
typedef boost::shared_ptr< GenericActionClass > GenericActionPtr;

/** @typedef Pointeur intelligent vers un StopOnErrorClass */
typedef boost::shared_ptr< StopOnErrorClass > StopOnErrorPtr;
/** @typedef Pointeur intelligent vers un GenericSubstepingOnErrorClass */
typedef boost::shared_ptr< GenericSubstepingOnErrorClass > GenericSubstepingOnErrorPtr;
/** @typedef Pointeur intelligent vers un SubstepingOnErrorClass */
typedef boost::shared_ptr< SubstepingOnErrorClass > SubstepingOnErrorPtr;
/** @typedef Pointeur intelligent vers un SubstepingOnContactClass */
typedef boost::shared_ptr< SubstepingOnContactClass > SubstepingOnContactPtr;
/** @typedef Pointeur intelligent vers un AddIterationOnErrorClass */
typedef boost::shared_ptr< AddIterationOnErrorClass > AddIterationOnErrorPtr;
/** @typedef Pointeur intelligent vers un PilotageErrorClass */
typedef boost::shared_ptr< PilotageErrorClass > PilotageErrorPtr;
/** @typedef Pointeur intelligent vers un ChangePenalisationOnErrorClass */
typedef boost::shared_ptr< ChangePenalisationOnErrorClass > ChangePenalisationOnErrorPtr;
/** @typedef Pointeur intelligent vers un ContinueOnErrorClass */
typedef boost::shared_ptr< ContinueOnErrorClass > ContinueOnErrorPtr;

/**
 * @class GenericEventErrorClass
 * @brief Cette classe définit une erreur générique de convergence dont
 *        les autres doivent hériter
 * @author Nicolas Sellenet
 */
class GenericEventErrorClass {
  private:
    /** @brief Action à réaliser en cas d'erreur */
    GenericActionPtr _actionOnError;

  protected:
    /** @brief Paramètre EVENEMENT */
    GenParam _eventName;
    /** @brief Liste des Paramètres attachés à l'événement */
    ListGenParam _listSyntaxParam;

    /**
     * @brief Constructeur
     * @param type EventErrorTypeEnum décrivant le type de l'erreur
     */
    GenericEventErrorClass( EventErrorTypeEnum type )
        : _eventName( "EVENEMENT", std::string( ErrorNames[type] ), true ) {
        _listSyntaxParam.push_back( &_eventName );
    };

  public:
    /** @brief Constructeur par défaut */
    GenericEventErrorClass()
        : _eventName( "EVENEMENT", std::string( ErrorNames[NoErrorType] ), true ){};

    ~GenericEventErrorClass(){};

  private:
    /**
     * @brief Fonction virtuelle pure permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    virtual void checkAllowedAction( const GenericActionPtr &action ) = 0;

  public:
    /**
     * @brief Fonction permettant de récupérer l'action à réaliser en cas d'erreur
     * @return action à réaliser
     */
    const GenericActionPtr &getAction() const { return _actionOnError; };

    /**
     * @brief Fonction permettant de récupérer la liste des paramètres
     * @return liste des paramètres de l'événement
     */
    const ListGenParam &getListOfParameters() const { return _listSyntaxParam; };

    /**
     * @brief Fonction permettant de savoir si l'action en erreur a été définie
     * @return true si l'action a été fixée
     */
    bool isActionSet() {
        if ( !_actionOnError )
            return false;
        return true;
    };

    /**
     * @brief Fonction permettant de preciser l'action à réaliser en cas d'erreur
     * @param action action à réaliser
     */
    void setAction( const GenericActionPtr &action ) {
        _actionOnError = action;
        checkAllowedAction( action );
    };
};

/**
 * @class EventErrorClass
 * @brief Classe décriant l'événement ERREUR
 * @author Nicolas Sellenet
 */
class EventErrorClass : public GenericEventErrorClass {
  private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr &action ) {
        const ActionTypeEnum &type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnErrorType &&
             type != AddIterationOnErrorType && type != PilotageErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

  public:
    /** @brief Constructeur */
    EventErrorClass() : GenericEventErrorClass( EventErrorType ){};

    ~EventErrorClass(){};
};

/**
 * @class ResidualDivergenceErrorClass
 * @brief Classe décriant l'événement DIVE_RESI
 * @author Nicolas Sellenet
 */
class ResidualDivergenceErrorClass : public GenericEventErrorClass {
  private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr &action ) {
        const ActionTypeEnum &type = action->getType();
        if ( type != SubstepingOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

  public:
    /** @brief Constructeur */
    ResidualDivergenceErrorClass()
        : GenericEventErrorClass( ResidualDivergenceErrorType ){};

    ~ResidualDivergenceErrorClass(){};
};

/**
 * @class IncrementOverboundErrorClass
 * @brief Classe décriant l'événement DELTA_GRANDEUR
 * @author Nicolas Sellenet
 */
class IncrementOverboundErrorClass : public GenericEventErrorClass {
  private:
    /** @brief Paramètre VALE_REF */
    GenParam _value;
    /** @brief Paramètre NOM_CHAM */
    GenParam _fieldName;
    /** @brief Paramètre NOM_CMP */
    GenParam _component;

    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr &action ) {
        const ActionTypeEnum &type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

  public:
    /** @brief Constructeur */
    IncrementOverboundErrorClass()
        : GenericEventErrorClass( IncrementOverboundErrorType ),
          _value( "VALE_REF", true ), _fieldName( "NOM_CHAM", "", true ),
          _component( "NOM_CMP", true ) {
        _listSyntaxParam.push_back( &_value );
        _listSyntaxParam.push_back( &_fieldName );
        _listSyntaxParam.push_back( &_component );
    };

    ~IncrementOverboundErrorClass(){};

    /**
     * @brief Fixer la valeur à vérifier
     * @param value Valeur de l'incrément
     * @param fieldName Nom du champ
     * @param component Nom de la composante
     */
    void setValueToInspect( const double &value, const std::string &fieldName,
                            const PhysicalQuantityComponent &component ) {
        _value = value;
        _fieldName.setValue( fieldName );
        _component = ComponentNames.find( component )->second;
    };
};

/**
 * @class ContactDetectionErrorClass
 * @brief Classe décriant l'événement COLLISION
 * @author Nicolas Sellenet
 */
class ContactDetectionErrorClass : public GenericEventErrorClass {
  private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr &action ) {
        const ActionTypeEnum &type = action->getType();
        if ( type != StopOnErrorType && type != SubstepingOnContactType )
            throw std::runtime_error( "Action not allowed" );
    }

  public:
    /** @brief Constructeur */
    ContactDetectionErrorClass()
        : GenericEventErrorClass( ContactDetectionErrorType ){};

    ~ContactDetectionErrorClass(){};
};

/**
 * @class InterpenetrationErrorClass
 * @brief Classe décriant l'événement INTERPENETRATION
 * @author Nicolas Sellenet
 */
class InterpenetrationErrorClass : public GenericEventErrorClass {
  private:
    /** @brief Paramètre PENE_MAXI */
    GenParam _maxPenetration;

    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr &action ) {
        const ActionTypeEnum &type = action->getType();
        if ( type != StopOnErrorType && type != ChangePenalisationOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

  public:
    /** @brief Constructeur */
    InterpenetrationErrorClass()
        : GenericEventErrorClass( InterpenetrationErrorType ),
          _maxPenetration( "PENE_MAXI", true ) {
        _listSyntaxParam.push_back( &_maxPenetration );
    };

    ~InterpenetrationErrorClass(){};

    /**
     * @brief Fixer la valeur maximale de l'interpénétration
     * @param value Valeur maximale
     */
    void setMaximalPenetration( const double &value ) { _maxPenetration = value; };
};

/**
 * @class InstabilityErrorClass
 * @brief Classe décriant l'événement INSTABILITE
 * @author Nicolas Sellenet
 */
class InstabilityErrorClass : public GenericEventErrorClass {
  private:
    /**
     * @brief Fonction permettant de vérifier qu'une action est bien autorisée
     * @param action Action a tester
     */
    void checkAllowedAction( const GenericActionPtr &action ) {
        const ActionTypeEnum &type = action->getType();
        if ( type != StopOnErrorType && type != ContinueOnErrorType )
            throw std::runtime_error( "Action not allowed" );
    }

  public:
    /**
     * @brief Constructeur
     */
    InstabilityErrorClass() : GenericEventErrorClass( InstabilityErrorType ){};

    ~InstabilityErrorClass(){};
};

/** @typedef Pointeur intelligent vers un GenericEventErrorClass */
typedef boost::shared_ptr< GenericEventErrorClass > GenericEventErrorPtr;
/** @typedef Pointeur intelligent vers un EventErrorClass */
typedef boost::shared_ptr< EventErrorClass > EventErrorPtr;
/** @typedef Pointeur intelligent vers un ResidualDivergenceErrorClass */
typedef boost::shared_ptr< ResidualDivergenceErrorClass > ResidualDivergenceErrorPtr;
/** @typedef Pointeur intelligent vers un IncrementOverboundErrorClass */
typedef boost::shared_ptr< IncrementOverboundErrorClass > IncrementOverboundErrorPtr;
/** @typedef Pointeur intelligent vers un ContactDetectionErrorClass */
typedef boost::shared_ptr< ContactDetectionErrorClass > ContactDetectionErrorPtr;
/** @typedef Pointeur intelligent vers un InterpenetrationErrorClass */
typedef boost::shared_ptr< InterpenetrationErrorClass > InterpenetrationErrorPtr;
/** @typedef Pointeur intelligent vers un InstabilityErrorClass */
typedef boost::shared_ptr< InstabilityErrorClass > InstabilityErrorPtr;

/** @typedef std::list de GenericEventErrorPtr */
typedef std::list< GenericEventErrorPtr > ListConvError;
/** @typedef Iterateur sur une std::list de GenericEventErrorPtr */
typedef ListConvError::iterator ListConvErrorIter;
/** @typedef Iterateur constant sur une std::list de GenericEventErrorPtr */
typedef ListConvError::const_iterator ListConvErrorCIter;

#endif /* EVENTMANAGER_H_ */
