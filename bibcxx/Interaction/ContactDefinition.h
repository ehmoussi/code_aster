#ifndef CONTACTDEFINITION_H_
#define CONTACTDEFINITION_H_

/**
 * @file ContactDefinition.h
 * @brief Fichier entete de la class ContactDefinition
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

#include "Utilities/CapyConvertibleValue.h"

#include "Modeling/Model.h"

/**
 * @enum ContactFormulationEnum
 * @brief Tous les types de contact disponibles
 * @author Nicolas Sellenet
 */
enum ContactFormulationEnum { Discretized, Continuous, Xfem, UnilateralConnexion };
extern const std::vector< ContactFormulationEnum > allContactFormulation;
extern const std::vector< std::string > allContactFormulationNames;

/**
 * @enum FrictionEnum
 * @brief Tous les types de frottement disponibles
 * @author Nicolas Sellenet
 */
enum FrictionEnum { Coulomb, WithoutFriction };
extern const std::vector< FrictionEnum > allFrictionParameters;
extern const std::vector< std::string > allFrictionParametersNames;

/**
 * @enum GeometricResolutionAlgorithmEnum
 * @brief Tous les algorithmes de résolution du contact disponibles
 * @author Nicolas Sellenet
 */
enum GeometricResolutionAlgorithmEnum { FixPoint, Newton };
extern const std::vector< GeometricResolutionAlgorithmEnum > allGeometricResolutionAlgorithm;
extern const std::vector< std::string > allGeometricResolutionAlgorithmNames;

/**
 * @enum GeometricUpdateEnum
 * @brief Tous les types de mise à jour de la géométrie disponibles
 * @author Nicolas Sellenet
 */
enum GeometricUpdateEnum { Auto, Controlled, WithoutGeometricUpdate };
extern const std::vector< GeometricUpdateEnum > allGeometricUpdate;
extern const std::vector< std::string > allGeometricUpdateNames;

/**
 * @enum ContactPrecondEnum
 * @brief Tous les préconditionneurs disponibles
 * @author Nicolas Sellenet
 */
enum ContactPrecondEnum { Dirichlet, WithoutPrecond };
extern const std::vector< ContactPrecondEnum > allContactPrecond;
extern const std::vector< std::string > allContactPrecondNames;

/**
 * @class ContactDefinition
 * @brief Classe template permettant de définir du contact
 * @tparam formulation Formulation du contact
 * @author Nicolas Sellenet
 */
template< ContactFormulationEnum formulation >
class ContactDefinition
{
private:
    /** @brief sd_model */
    ModelPtr                         _model;
    /** @brief Formulation du contact */
    ContactFormulationEnum           _formulation;
    /** @brief Type de frottement */
    FrictionEnum                     _friction;
    /** @brief Résolution géométrique */
    GeometricResolutionAlgorithmEnum _algoResoGeom;
    /** @brief Réactualisation géométrique */
    GeometricUpdateEnum              _reacGeom;
    /** @brief Nombre max d'itération géométrique */
    int                              _nbMaxGeomIter;
    /** @brief Nombre d'itération géométrique */
    int                              _nbGeomIter;
    /** @brief Résidu géométrique */
    double                           _geomResidual;
    /** @brief Algorithme du contact */
    GeometricResolutionAlgorithmEnum _algoContact;
    /** @brief Paramètre ITER_CONT_MULT */
    int                              _iterContMult;
    /** @brief Paramètre ITER_CONT_TYPE */
    int                              _iterContType;
    /** @brief Paramètre ITER_CONT_MAXI */
    int                              _iterContMaxi;
    /** @brief Algorithme de résolution du frottement */
    GeometricResolutionAlgorithmEnum _frictionAlgo;
    /** @brief Nombre d'itération max pour le frottement */
    int                              _iterFrotMaxi;
    /** @brief Résidu pour le frottement */
    double                           _resiFrot;
    /** @brief Coefficient d'adaptation */
    bool                             _adaptCoef;
    /** @brief Stop sur détection de singularité */
    bool                             _stopSingular;
    /** @brief Nombre de résolution */
    int                              _nbResol;
    /** @brief Résidu absolu */
    double                           _resiAbso;
    /** @brief Nombre max d'itération du GCP */
    int                              _iterGcpMaxi;
    /** @brief Recherche linéraire */
    bool                             _rechLin;
    /** @brief Type du préconditionneur */
    ContactPrecondEnum               _preCond;
    /** @brief Paramètre de déclenchement du préconditionneur */
    double                           _coefResi;
    /** @brief Nombre max d'itération du préconditionneur */
    int                              _iterPreMaxi;

    /** @brief Comportement en cas de détection d'interpénétration */
    bool                             _stopOnInterpenetrationDetection;
    /** @brief Lissage des normales */
    bool                             _normsSmooth;
    /** @brief Vérification des normale */
    bool                             _normsVerification;

    /** @brief Conteneur des mots-clés avec traduction */
    CapyConvertibleContainer _toCapyConverter;

    /**
     * @brief Ajout de mots-clés généraux
     */
    bool addContactDefinition()
    {
        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                                      ( false, "STOP_INTERP", _stopOnInterpenetrationDetection,
                                                        { true, false }, { "OUI", "NON" } ) );
        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                                      ( false, "LISSAGE", _normsSmooth,
                                                        { true, false }, { "OUI", "NON" } ) );
        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                                      ( false, "VERI_NORM", _normsVerification,
                                                        { true, false }, { "OUI", "NON" } ) );

        if( formulation == Discretized )
        {
            _stopSingular = true;
            _toCapyConverter.add( new CapyConvertibleValue< bool >
                                                            ( false, "STOP_SINGULIER", _stopSingular,
                                                              { true, false }, { "OUI", "NON" }, true ) );
            _nbResol = 10;
            _toCapyConverter.add( new CapyConvertibleValue< int >
                                                            ( false, "NB_RESOL", _nbResol, true ) );
            _resiAbso = -1.0;
            _toCapyConverter.add( new CapyConvertibleValue< double >
                                                            ( false, "RESI_ABSO", _resiAbso, false ) );
            _iterGcpMaxi = 0;
            _toCapyConverter.add( new CapyConvertibleValue< int >
                                                            ( false, "ITER_GCP_MAXI", _iterGcpMaxi, true ) );
            _rechLin = true;
            _toCapyConverter.add( new CapyConvertibleValue< bool >
                                                            ( false, "RECH_LINEAIRE", _rechLin,
                                                              { true, false },
                                                              { "ADMISSIBLE", "NON_ADMISSIBLE" }, true ) );
            _preCond = WithoutPrecond;
            _toCapyConverter.add( new CapyConvertibleValue< ContactPrecondEnum >
                                                            ( false, "PRE_COND", _preCond,
                                                              allContactPrecond,
                                                              allContactPrecondNames, true ) );
            _coefResi = -1.0;
            _toCapyConverter.add( new CapyConvertibleValue< double >
                                                            ( false, "COEF_RESI", _coefResi, false ) );
            _iterPreMaxi = 0;
            _toCapyConverter.add( new CapyConvertibleValue< int >
                                                            ( false, "ITER_PRE_MAXI", _iterPreMaxi, false ) );
        }

        return true;
    };

    /**
     * @brief Ajout de mots-clés pour la gestion de la boucle de géométrie
     */
    bool addGeometricParameter()
    {
        _algoResoGeom = FixPoint;
        _toCapyConverter.add( new CapyConvertibleValue< GeometricResolutionAlgorithmEnum >
                                                      ( false, "ALGO_RESO_GEOM",
                                                        _algoResoGeom, allGeometricResolutionAlgorithm,
                                                        allGeometricResolutionAlgorithmNames ) );
        _reacGeom = Auto;
        _toCapyConverter.add( new CapyConvertibleValue< GeometricUpdateEnum >
                                                      ( false, "REAC_GEOM", 
                                                        _reacGeom,
                                                        allGeometricUpdate, allGeometricUpdateNames ) );
        if ( formulation != Xfem )
        {
            _nbMaxGeomIter = 10;
            _toCapyConverter.add( new CapyConvertibleValue< int >
                                                        ( false, "ITER_GEOM_MAXI", _nbMaxGeomIter ) );
            _geomResidual = 0.01;
            _toCapyConverter.add( new CapyConvertibleValue< double >
                                                        ( false, "RESI_GEOM", _geomResidual ) );
        }
        return true;
    };

    /**
     * @brief Ajout de mots-clés pour la gestion de la boucle de contact
     */
    bool addContactLoopParameter()
    {
        _iterContMult = 4;
        _toCapyConverter.add( new CapyConvertibleValue< int >( false, "ITER_CONT_MULT",
                                                               _iterContMult, false ) );
        _algoContact = Newton;
        _toCapyConverter.add( new CapyConvertibleValue< GeometricResolutionAlgorithmEnum >
                                                        ( false, "ALGO_RESO_CONT", _algoContact,
                                                          allGeometricResolutionAlgorithm,
                                                          allGeometricResolutionAlgorithmNames,
                                                          false ) );
        _iterContType = 1;
        _toCapyConverter.add( new CapyConvertibleValue< int, std::string >
                                                    ( false, "ITER_CONT_TYPE", _iterContType,
                                                      {0, 1}, {"MULT", "MAXI"}, false ) );
        _iterContMaxi = 30;
        _toCapyConverter.add( new CapyConvertibleValue< int >
                                                    ( false, "ITER_GEOM_MAXI", _iterContMaxi, false ) );
        if ( formulation == Discretized )
        {
            _toCapyConverter[ "ITER_CONT_MULT" ]->enable();
        }
        else if ( formulation == Continuous )
        {
            _toCapyConverter[ "ALGO_RESO_CONT" ]->enable();
        }
        else if ( formulation == Xfem )
        {
            _toCapyConverter[ "ITER_CONT_TYPE" ]->enable();
            _toCapyConverter[ "ITER_GEOM_MAXI" ]->enable();
        }
        return true;
    };

    /**
     * @brief Ajout de mots-clés pour la gestion de la boucle de frottement
     */
    bool addFrictionLoopParameter()
    {
        _frictionAlgo = Newton;
        _toCapyConverter.add( new CapyConvertibleValue< GeometricResolutionAlgorithmEnum >
                                                        ( false, "ALGO_RESO_FROT", _frictionAlgo,
                                                          allGeometricResolutionAlgorithm,
                                                          allGeometricResolutionAlgorithmNames,
                                                          false ) );
        _iterFrotMaxi = 10;
        _toCapyConverter.add( new CapyConvertibleValue< int >
                                                    ( false, "ITER_FROT_MAXI", _iterFrotMaxi, false ) );
        _resiFrot = 0.0001;
        _toCapyConverter.add( new CapyConvertibleValue< double >
                                                    ( false, "RESI_FROT", _resiFrot, false ) );
        _adaptCoef = false;
        _toCapyConverter.add( new CapyConvertibleValue< bool >
                                                      ( false, "ADAPT_COEF", _normsVerification,
                                                        { true, false }, { "OUI", "NON" }, false ) );
        return true;
    };

public:
    /**
     * @brief Constructeur
     */
    ContactDefinition(): _formulation( formulation ),
                         _friction( WithoutFriction )
    {
        _toCapyConverter.add( new CapyConvertibleValue< ContactFormulationEnum >
                                                      ( true, "FORMULATION", 
                                                        _formulation, allContactFormulation,
                                                        allContactFormulationNames ) );
        _toCapyConverter.add( new CapyConvertibleValue< FrictionEnum >
                                                      ( true, "FROTTEMENT", 
                                                        _friction, allFrictionParameters,
                                                        allFrictionParametersNames ) );
        _toCapyConverter.add( new CapyConvertibleValue< DataStructurePtr >
                                                      ( true, "MODELE", (DataStructurePtr&)_model ) );

        if ( formulation == Continuous || formulation == Discretized )
            addContactDefinition();

        if ( formulation == Continuous || formulation == Discretized || formulation == Xfem )
        {
            addGeometricParameter();
            addContactLoopParameter();
        }
    };

public:
    /**
     * @brief Activer le frottement
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Xfem, void>::type
    enableFriction() throw( std::runtime_error )
    {
        _friction = true;
        _toCapyConverter[ "RESI_FROT" ]->enable();
        if ( formulation == Continuous )
        {
            _toCapyConverter[ "ALGO_RESO_FROT" ]->enable();
            if ( _frictionAlgo == Newton )
                _toCapyConverter[ "ADAPT_COEF" ]->enable();
            else
                _toCapyConverter[ "ITER_FROT_MAXI" ]->enable();
        }
        else if( formulation == Xfem )
            _toCapyConverter[ "ITER_FROT_MAXI" ]->enable();
    };

    /**
     * @brief Ajout du modèle
     * @param model Pointeur vers un ModelInstance
     */
    void setModel( ModelPtr& model )
    {
        _model = model;
    };

    /**
     * @brief Choix de l'algorithme de résolution géométrique
     * @param curAlgo algorithme choisi
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized || form == Xfem, void>::type
    setGeometricResolutionAlgorithm( GeometricResolutionAlgorithmEnum curAlgo ) throw( std::runtime_error )
    {
        if ( curAlgo == Newton && formulation != Continuous )
            throw std::runtime_error( "The Newton algorithm only allowed with the continuous contact" );
        _algoResoGeom = curAlgo;
        if ( curAlgo == Newton )
        {
            _toCapyConverter.remove( "REAC_GEOM" );
            _toCapyConverter.remove( "ITER_GEOM_MAXI" );
            _toCapyConverter.remove( "NB_ITER_GEOM" );
            _geomResidual = 0.000001;
        }
    };

    /**
     * @brief Choix de la méthode de mise à jour de la géométrie
     * @param curUp méthode choisie
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized || form == Xfem, void>::type
    setGeometricUpdate( GeometricUpdateEnum curUp ) throw( std::runtime_error )
    {
        _reacGeom = curUp;
        if ( _algoResoGeom != FixPoint )
            throw std::runtime_error( "Geometric update only available with fix point method" );
        if ( curUp == Controlled )
        {
            _toCapyConverter.remove( "ITER_GEOM_MAXI" );
            _toCapyConverter.remove( "RESI_GEOM" );
            _nbGeomIter = 2;
            _toCapyConverter.add( new CapyConvertibleValue< int >
                                                        ( false, "NB_ITER_GEOM", _nbGeomIter ) );
        }
        else if( curUp == WithoutGeometricUpdate )
        {
            _toCapyConverter.remove( "ITER_GEOM_MAXI" );
            _toCapyConverter.remove( "RESI_GEOM" );
            _toCapyConverter.remove( "NB_ITER_GEOM" );
        }
        else if( curUp == Auto )
        {
            _toCapyConverter.remove( "REAC_GEOM" );
            _nbMaxGeomIter = 10;
            _toCapyConverter.add( new CapyConvertibleValue< int >
                                                        ( false, "ITER_GEOM_MAXI", _nbMaxGeomIter ) );
            _geomResidual = 0.01;
            _toCapyConverter.add( new CapyConvertibleValue< double >
                                                        ( false, "RESI_GEOM", _geomResidual ) );
        }
    };

    /**
     * @brief Fixer le nombre maximum d'itération géométrique
     * @param value méthode choisie
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized || form == Xfem, void>::type
    setMaximumNumberOfGeometricIteration( int value ) throw( std::runtime_error )
    {
        if ( _reacGeom != Auto )
            throw std::runtime_error( "Only available with automatic geometric update" );
        _nbMaxGeomIter = value;
    };

    /**
     * @brief Fixer le résidu géométrique
     * @param value valeur du résidu
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized || form == Xfem, void>::type
    setGeometricResidual( double value ) throw( std::runtime_error )
    {
        if ( _reacGeom != Auto )
            throw std::runtime_error( "Only available with automatic geometric update" );
        _geomResidual = value;
    };

    /**
     * @brief Fixer le nombre d'itération géométrique
     * @param value valeur du nombre d'itération
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized || form == Xfem, void>::type
    setNumberOfGeometricIteration( int value ) throw( std::runtime_error )
    {
        if ( _reacGeom != Controlled )
            throw std::runtime_error( "Only available with controlled geometric update" );
        _stopOnInterpenetrationDetection = value;
    };

    /**
     * @brief Activer ou desactiver le lissage des normales
     * @param curBool booleen d'activation
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized, void>::type
    setNormsSmooth( bool curBool )
    {
        _normsSmooth = curBool;
    };

    /**
     * @brief Activer ou desactiver le vérification des normales
     * @param curBool booleen d'activation
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized, void>::type
    setNormsVerification( bool curBool )
    {
        _normsSmooth = curBool;
    };

    /**
     * @brief Fixer le comportement en cas de détection d'interpénétration
     * @param curBool booleen d'activation
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Discretized, void>::type
    setStopOnInterpenetrationDetection( bool curBool )
    {
        _stopOnInterpenetrationDetection = curBool;
    };

    /**
     * @brief Choisir l'algorithme de contact
     * @param algo algorithme
     * @param mode mode absolu (1) ou relatif (0) pour le nombre max d'itération de contact
     * @param coef valeur absolue ou relative pour le nombre max d'itération de contact
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous, void>::type
    setContactAlgorithm( GeometricResolutionAlgorithmEnum algo, int mode, int coef )
        throw( std::runtime_error )
    {
        _algoContact = algo;
        if ( mode != 0 && mode != 1 )
            throw std::runtime_error( "Mode must be a integer between 0 and 1" );
        if ( _algoContact == FixPoint )
        {
            _iterContType = mode;
            _toCapyConverter[ "ITER_CONT_TYPE" ]->enable();
            if ( mode == 0 )
            {
                _iterContMult = coef;
                _toCapyConverter[ "ITER_CONT_MULT" ]->enable();
                _toCapyConverter[ "ITER_CONT_MAXI" ]->disable();
            }
            else
            {
                _iterContMaxi = coef;
                _toCapyConverter[ "ITER_CONT_MAXI" ]->enable();
                _toCapyConverter[ "ITER_CONT_MULT" ]->disable();
            }
        }
    };

    /**
     * @brief Choisir le nombre relatif pour le nombre max d'itération de contact
     * @param coef valeur du paramètre
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    setContactAlgorithm( int coef )
        throw( std::runtime_error )
    {
        _iterContMult = coef;
    };

    /**
     * @brief Choisir l'algorithme de contact
     * @param mode mode absolu (1) ou relatif (0) pour le nombre max d'itération de contact
     * @param coef valeur absolue ou relative pour le nombre max d'itération de contact
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Xfem, void>::type
    setContactAlgorithm( int mode, int coef )
        throw( std::runtime_error )
    {
        if ( mode != 0 && mode != 1 )
            throw std::runtime_error( "Mode must be a integer between 0 and 1" );
        _iterContType = mode;
        if ( mode == 0 )
        {
            _iterContMult = coef;
            _toCapyConverter[ "ITER_CONT_MULT" ]->enable();
            _toCapyConverter[ "ITER_CONT_MAXI" ]->disable();
        }
        else
        {
            _iterContMaxi = coef;
            _toCapyConverter[ "ITER_CONT_MAXI" ]->enable();
            _toCapyConverter[ "ITER_CONT_MULT" ]->disable();
        }
    };

    /**
     * @brief Choisir l'algorithme de frottement
     * @param algo algorithme choisi
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous, void>::type
    setFrictionAlgorithm( GeometricResolutionAlgorithmEnum algo )
        throw( std::runtime_error )
    {
        _frictionAlgo = algo;
        if ( _frictionAlgo == FixPoint )
        {
            _toCapyConverter[ "ITER_FROT_MAXI" ]->enable();
            _toCapyConverter[ "RESI_FROT" ]->enable();
            _toCapyConverter[ "ADAPT_COEF" ]->disable();
        }
        else
        {
            _toCapyConverter[ "ITER_FROT_MAXI" ]->disable();
            _toCapyConverter[ "RESI_FROT" ]->enable();
            _toCapyConverter[ "ADAPT_COEF" ]->enable();
        }
    };

    /**
     * @brief Fixer le résidu de frottement
     * @param value valeur du résidu
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Xfem, void>::type
    setFrictionResidual( double value )
    {
        _resiFrot = value;
    };

    /**
     * @brief Fixer le nombre d'itération de frottement
     * @param value valeur du nombre d'itération
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Continuous || form == Xfem, void>::type
    setNumberOfFrictionIteration( int value ) throw( std::runtime_error )
    {
        if ( formulation == Continuous && _frictionAlgo != FixPoint )
            throw std::runtime_error( "Number of friction iteration only available with fix point algorithm" );
        _iterFrotMaxi = value;
    };

    /**
     * @brief Activer la détection de singularité de la matrice de contact
     * @param value booleen (true : activé)
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    enableContactMatrixSingularityDetection( bool value )
    {
        _stopSingular = value;
    };

    /**
     * @brief Fixer le nombre de résolution simultanée pour la construction complément de Schur
     * @param value valeur du nombre de résolution
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    numberOfSolversForSchurComplement( int value )
    {
        _nbResol = value;
    };

    /**
     * @brief Fixer le résidu pour le GCP
     * @param value valeur du résidu
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    setResidualForGcp( double value )
    {
        _resiAbso = value;
    };

    /**
     * @brief Autoriser de sortir des bornes admissibles lors de la recherche liénaire
     * @param value true si la sortie est autorisée
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    allowOutOfBoundLinearSearch( bool value )
    {
        _rechLin = value;
    };

    /**
     * @brief Choisir le préconditionneur pour le contact
     * @param value préconditionneur choisi
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    setPreconditioning( ContactPrecondEnum value )
    {
        _preCond = value;
        if ( _preCond == Dirichlet )
        {
            _toCapyConverter[ "COEF_RESI" ]->enable();
            _toCapyConverter[ "ITER_PRE_MAXI" ]->enable();
        }
        else
        {
            _toCapyConverter[ "COEF_RESI" ]->disable();
            _toCapyConverter[ "ITER_PRE_MAXI" ]->disable();
        }
    };

    /**
     * @brief Choisir le seuil d'activation du préconditionneur
     * @param value seuil
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    setThresholdOfPreconditioningActivation( double value ) throw( std::runtime_error )
    {
        _coefResi = value;
        if ( _preCond !=  Dirichlet )
            throw std::runtime_error( "Only available with Dirichlet preconditioning" );
    };

    /**
     * @brief Choisir le nombre max d'itération du préconditionneur
     * @param value nombre d'itération
     */
    template< ContactFormulationEnum form = formulation >
    typename std::enable_if< form == Discretized, void>::type
    setMaximumNumberOfPreconditioningIteration( int value ) throw( std::runtime_error )
    {
        _iterPreMaxi = value;
        if ( _preCond !=  Dirichlet )
            throw std::runtime_error( "Only available with Dirichlet preconditioning" );
    };
};

class ContinuousContactDefinition: public ContactDefinition< Continuous >
{
private:

public:
    ContinuousContactDefinition(): ContactDefinition< Continuous >()
    {};
};

class DiscretizedContactDefinition: public ContactDefinition< Discretized >
{
private:

public:
    DiscretizedContactDefinition(): ContactDefinition< Discretized >()
    {};
};

#endif /* CONTACTDEFINITION_H_ */
