#ifndef XFEMCONTACTZONE_H_
#define XFEMCONTACTZONE_H_

/**
 * @file XfemContactZone.h
 * @brief Fichier entete de la class XfemContactZone
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

#include "Mesh/Mesh.h"
#include "Utilities/CapyConvertibleValue.h"

#include "Interactions/ContactZone.h"
#include "Modeling/XfemCrack.h"

/**
 * @enum LagrangeAlgorithmEnum
 * @brief Tous les types de contact disponibles
 * @author Nicolas Sellenet
 */
enum LagrangeAlgorithmEnum { AutomaticLagrangeAlgorithm, NoLagrangeAlgorithm,
                             V1LagrangeAlgorithm, V2LagrangeAlgorithm, V3LagrangeAlgorithm };
extern const std::vector< LagrangeAlgorithmEnum > allLagrangeAlgorithm;
extern const std::vector< std::string > allLagrangeAlgorithmNames;

/**
 * @enum CzmAlgorithmEnum
 * @brief Tous les types de contact disponibles
 * @author Nicolas Sellenet
 */
enum CzmAlgorithmEnum { CzmExpReg, CzmLinReg, CzmTacMix, CzmOuvMix, CzmLinMix };
extern const std::vector< CzmAlgorithmEnum > allCzmAlgorithm;
extern const std::vector< std::string > allCzmAlgorithmNames;

class XfemContactZoneInstance: public GenericContactZoneInstance
{
private:
    XfemCrackPtr             _crack;
    double                   _toleProjExt;
    IntegrationAlgorithmEnum _integration;
    int                      _ordreInt;
    LagrangeAlgorithmEnum    _algoLagr;
    ContactAlgorithmEnum     _algoCont;
    bool                     _contactInit;
    bool                     _glissiere;
    double                   _coefCont;
    double                   _coefPenaCont;
    CzmAlgorithmEnum         _relation;
    double                   _coulomb;
    double                   _seuilInit;
    FrictionAlgorithmEnum    _algoFrot;
    double                   _coefFrot;
    double                   _coefPenaFrot;

public:
    XfemContactZoneInstance(): _toleProjExt( 0.5 ),
                           _integration( GaussIntegration ),
                           _ordreInt( 6 ),
                           _algoLagr( AutomaticLagrangeAlgorithm ),
                           _algoCont( StandardContact ),
                           _contactInit( false ),
                           _glissiere( false ),
                           _coefCont( 100. ),
                           _seuilInit( 0. )
    {
        _toCapyConverter.add( new CapyConvertibleValue< XfemCrackPtr >
                                    ( true, "FISS_MAIT", _crack, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "TOLE_PROJ_EXT", _toleProjExt, true ) );

        _toCapyConverter.add( new CapyConvertibleValue< IntegrationAlgorithmEnum >
                                    ( false, "INTEGRATION", _integration, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< int >
                                    ( false, "ORDRE_INT", _ordreInt, true ) );

        _toCapyConverter.add( new CapyConvertibleValue< LagrangeAlgorithmEnum >
                                    ( false, "ALGO_LAGR", _algoLagr, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< ContactAlgorithmEnum >
                                    ( false, "ALGO_CONT", _algoCont, true ) );

        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                    ( false, "CONTACT_INIT", _contactInit,
                                      { true, false }, { "OUI", "NON" }, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                    ( false, "GLISSIERE", _glissiere,
                                      { true, false }, { "OUI", "NON" }, true ) );

        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "COEF_CONT", _coefCont, true ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "COEF_PENA_CONT", _coefPenaCont, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< CzmAlgorithmEnum >
                                    ( false, "RELATION", _relation, false ) );

        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "COULOMB", _coulomb, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "SEUIL_INIT", _seuilInit, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< FrictionAlgorithmEnum >
                                    ( false, "ALGO_FROT", _algoFrot,
                                      allFrictionAlgorithm, allFrictionAlgorithmNames,false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "COEF_FROT", _coefFrot, false ) );
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                    ( false, "COEF_PENA_FROT", _coefPenaFrot, false ) );
    };

    void addFriction( const FrictionAlgorithmEnum& algoFrot, const double& coulomb,
                      const double& seuilInit, const double& coefFrot )
    {
        _algoFrot = algoFrot;
        _coulomb = coulomb;
        _seuilInit = seuilInit;
        _toCapyConverter[ "COULOMB" ]->enable();
        _toCapyConverter[ "COULOMB" ]->setMandatory( true );
        _toCapyConverter[ "SEUIL_INIT" ]->enable();
        _toCapyConverter[ "ALGO_FROT" ]->enable();
        if( algoFrot == StandardFriction )
        {
            _toCapyConverter[ "COEF_FROT" ]->enable();
            _coefFrot = coefFrot;
        }
        else
        {
            _toCapyConverter[ "COEF_PENA_FROT" ]->enable();
            _toCapyConverter[ "COEF_PENA_FROT" ]->setMandatory( true );
            _coefPenaFrot = coefFrot;
        }
    };

    void disableSlidingContact()
    {
        _glissiere = false;
    };

    void enableSlidingContact()
    {
        _glissiere = true;
    };

    void setContactAlgorithm( const ContactAlgorithmEnum& cont )
        throw ( std::runtime_error )
    {
        if( cont != StandardContact && cont != PenalizationContact &&
            cont != CzmContact )
            throw std::runtime_error( "This Contact algorithm is not available in Xfem contact" );
        _algoCont = cont;

        if( _algoCont != CzmContact )
        {
            _toCapyConverter[ "CONTACT_INIT" ]->enable();
            _toCapyConverter[ "GLISSIERE" ]->enable();
        }

        if( _algoCont == StandardContact )
        {
            _toCapyConverter[ "COEF_CONT" ]->enable();
            _toCapyConverter[ "COEF_PENA_CONT" ]->disable();
        }
        else if( _algoCont == PenalizationContact )
        {
            _toCapyConverter[ "COEF_CONT" ]->disable();
            _toCapyConverter[ "COEF_PENA_CONT" ]->enable();
            _toCapyConverter[ "COEF_PENA_CONT" ]->setMandatory( true );
        }
    };

    void setContactParameter( const double& value )
    {
        if( _algoCont == StandardContact )
            _coefCont = value;
        else if( _algoCont == PenalizationContact )
            _coefPenaCont = value;
    };

    void setInitialContact( const bool& contactInit )
    {
        _contactInit = contactInit;
    };

    void setLagrangeAlgorithm( const LagrangeAlgorithmEnum& lagr )
    {
        _algoLagr = lagr;
    };

    void setIntegrationAlgorithm( const IntegrationAlgorithmEnum& integr,
                                  const int& ordre = -1 )
        throw ( std::runtime_error )
    {
        if( ordre != -1 && ( integr == AutomaticIntegration || integr == NodesIntegration ) )
            throw std::runtime_error( "Integration ordre not available with AutomaticIntegration" );
        _integration = integr;
        if( _integration == GaussIntegration )
        {
            if( ordre == -1 )
                _ordreInt = 6;
            else
                _ordreInt = ordre;
            if( _ordreInt < 1 || _ordreInt > 6 )
                throw std::runtime_error( "Integration ordre out of bound (must be in [1, 6])" );
            _toCapyConverter[ "ORDRE_INT" ]->enable();
        }
        else if( _integration == SimpsonIntegration )
        {
            if( ordre == -1 )
                _ordreInt = 1;
            else
                _ordreInt = ordre;
            if( _ordreInt < 1 || _ordreInt > 4 )
                throw std::runtime_error( "Integration ordre out of bound (must be in [1, 6])" );
            _toCapyConverter[ "ORDRE_INT" ]->enable();
        }
        else if( _integration == NewtonCotesIntegration )
        {
            if( ordre == -1 )
                _ordreInt = 3;
            else
                _ordreInt = ordre;
            if( _ordreInt < 3 || _ordreInt > 8 )
                throw std::runtime_error( "Integration ordre out of bound (must be in [1, 6])" );
            _toCapyConverter[ "ORDRE_INT" ]->enable();
        }
    };

    void setPairingMismatchProjectionTolerance( const double& value )
    {
        _toleProjExt = value;
    };

    void setXfemCrack( const XfemCrackPtr& crack )
    {
        _crack = crack;
    };
};

typedef boost::shared_ptr< XfemContactZoneInstance > XfemContactZonePtr;

#endif /* XFEMCONTACTZONE_H_ */
