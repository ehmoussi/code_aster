#ifndef KINEMATICSLOAD_H_
#define KINEMATICSLOAD_H_

/**
 * @file KinematicsLoad.h
 * @brief Fichier entete de la classe KinematicsLoad
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

#include "Functions/Function.h"
#include "Loads/UnitaryLoad.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "astercxx.h"
#include <list>
#include <stdexcept>
#include <string>

/**
 * @class KinematicsLoadClass
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsLoadClass : public DataStructure {
  protected:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

    /** @typedef std::list de RealLoadDisplacement */
    typedef std::list< RealLoadDisplacement > ListRealDisp;
    /** @typedef Iterateur sur ListRealDisp */
    typedef ListRealDisp::iterator ListRealDispIter;

    /** @typedef std::list de RealLoadTemperature */
    typedef std::list< RealLoadTemperature > ListRealTemp;
    typedef std::list< FunctionLoadTemperature > ListFunctionTemp;
    /** @typedef Iterateur sur ListRealTemp */
    typedef ListRealTemp::iterator ListRealTempIter;

    /** @brief Modele */
    ModelPtr _model;
    /** @brief Listes des valeurs imposees DEPL_R et TEMP_R */
    ListRealDisp _listOfRealImposedDisplacement;
    ListRealTemp _listOfRealImposedTemperature;
    ListFunctionTemp _listOfFunctionImposedTemperature;
    JeveuxVectorLong _intParam;
    JeveuxVectorChar8 _charParam;
    JeveuxVectorReal _doubleParam;
    /** @brief La SD est-elle vide ? */
    bool _isEmpty;

    /**
     * @brief Constructeur
     */
    KinematicsLoadClass( const std::string &type );

    /**
     * @brief Constructeur
     */
    KinematicsLoadClass( const std::string &name, const std::string &type );

  public:
    /**
     * @typedef KinematicsLoadPtr
     * @brief Pointeur intelligent vers un KinematicsLoad
     */
    typedef boost::shared_ptr< KinematicsLoadClass > KinematicsLoadPtr;

    /**
     * @brief Construction de la charge (appel a OP0101)
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool build() ;

    /**
     * @brief Definition du modele
     * @param currentModel objet Model sur lequel la charge reposera
     */
    bool setModel( ModelPtr &currentModel ) {
        if ( currentModel->isEmpty() )
            throw std::runtime_error( "Model is empty" );
        _model = currentModel;
        return true;
    };
};

/**
 * @class KinematicsMechanicalLoadClass
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsMechanicalLoadClass : public KinematicsLoadClass {
  public:
    /**
     * @brief Constructeur
     */
    KinematicsMechanicalLoadClass() : KinematicsLoadClass( "_MECA" ){};

    /**
     * @brief Constructeur
     */
    KinematicsMechanicalLoadClass( const std::string name )
        : KinematicsLoadClass( name, "_MECA" ){};

    /**
     * @typedef KinematicsMechanicalLoadPtr
     * @brief Pointeur intelligent vers un KinematicsMechanicalLoad
     */
    typedef boost::shared_ptr< KinematicsMechanicalLoadClass > KinematicsMechanicalLoadPtr;

    /**
     * @brief Ajout d'une valeur mecanique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedMechanicalDOFOnCells(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::string &nameOfGroup ) {
        // On verifie que le pointeur vers le modele ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_model ) || _model->isEmpty() )
            throw std::runtime_error( "The model is empty" );
        if ( !_model->getMesh()->hasGroupOfCells( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );

        MeshEntityPtr meshEnt( new GroupOfCells( nameOfGroup ) );
        RealLoadDisplacement resu( meshEnt, coordinate, value );
        _listOfRealImposedDisplacement.push_back( resu );
        return true;
    };

    /**
     * @brief Ajout d'une valeur mecanique imposee sur un groupe de mailles
     * @param namesOfGroup Noms des groupes sur lequels imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedMechanicalDOFOnCells(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::vector< std::string > &namesOfGroup ) {
        for ( const auto &nameOfGroup : namesOfGroup )
            addImposedMechanicalDOFOnCells( coordinate, value, nameOfGroup );
        return true;
    };

    /**
     * @brief Ajout d'une valeur mecanique imposee sur un groupe de noeuds
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool
    addImposedMechanicalDOFOnNodes( const PhysicalQuantityComponent &coordinate,
                                    const double &value,
                                    const std::string &nameOfGroup ) {
        // On verifie que le pointeur vers le modele ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_model ) || _model->isEmpty() )
            throw std::runtime_error( "The model is empty" );
        if ( !_model->getMesh()->hasGroupOfNodes( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );

        MeshEntityPtr meshEnt( new GroupOfNodes( nameOfGroup ) );
        RealLoadDisplacement resu( meshEnt, coordinate, value );
        _listOfRealImposedDisplacement.push_back( resu );
        return true;
    };

    /**
     * @brief Ajout d'une valeur mecanique imposee sur un groupe de noeuds
     * @param namesOfGroup Noms des groupe sur lequels imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedMechanicalDOFOnNodes(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::vector< std::string > &namesOfGroup ) {
        for ( const auto &nameOfGroup : namesOfGroup )
            addImposedMechanicalDOFOnNodes( coordinate, value, nameOfGroup );
        return true;
    };
};

/**
 * @class KinematicsThermalLoadClass
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsThermalLoadClass : public KinematicsLoadClass {
  public:
    /**
     * @brief Constructeur
     */
    KinematicsThermalLoadClass() : KinematicsLoadClass( "_THER" ){};

    /**
     * @brief Constructeur
     */
    KinematicsThermalLoadClass( const std::string name )
        : KinematicsLoadClass( name, "_THER" ){};

    /**
     * @typedef KinematicsThermalLoadPtr
     * @brief Pointeur intelligent vers un KinematicsThermalLoad
     */
    typedef boost::shared_ptr< KinematicsThermalLoadClass > KinematicsThermalLoadPtr;

    /**
     * @brief Ajout d'une valeur thermique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool
    addImposedThermalDOFOnCells( const PhysicalQuantityComponent &coordinate,
                                    const double &value,
                                    const std::string &nameOfGroup ) {
        // On verifie que le pointeur vers le modele ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_model ) || _model->isEmpty() )
            throw std::runtime_error( "The model is empty" );
        if ( !_model->getMesh()->hasGroupOfCells( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );

        MeshEntityPtr meshEnt( new GroupOfCells( nameOfGroup ) );
        RealLoadTemperature resu( meshEnt, coordinate, value );
        _listOfRealImposedTemperature.push_back( resu );
        return true;
    };

    /**
     * @brief Ajout d'une valeur thermique imposee sur un groupe de mailles
     * @param namesOfGroup Noms des groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedThermalDOFOnCells(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::vector< std::string > &namesOfGroup ) {
        for ( const auto &nameOfGroup : namesOfGroup )
            addImposedThermalDOFOnCells( coordinate, value, nameOfGroup );
        return true;
    };

    /**
     * @brief Ajout d'une valeur thermique imposee sur un groupe de noeuds
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedThermalDOFOnNodes( const PhysicalQuantityComponent &coordinate,
                                      const double &value,
                                      const std::string &nameOfGroup ) {
        // On verifie que le pointeur vers le modele ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_model ) || _model->isEmpty() )
            throw std::runtime_error( "The model is empty" );
        if ( !_model->getMesh()->hasGroupOfNodes( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );

        MeshEntityPtr meshEnt( new GroupOfNodes( nameOfGroup ) );
        RealLoadTemperature resu( meshEnt, coordinate, value );
        _listOfRealImposedTemperature.push_back( resu );
        return true;
    };

    /**
     * @brief Ajout d'une valeur thermique imposee sur un groupe de noeuds
     * @param namesOfGroup Noms des groupes sur lequels imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedThermalDOFOnNodes(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::vector< std::string > &namesOfGroup ) {
        for ( const auto &nameOfGroup : namesOfGroup )
            addImposedThermalDOFOnNodes( coordinate, value, nameOfGroup );
        return true;
    };

    /**
     * @brief Ajout d'une fonction thermique imposee sur un groupe de noeuds
     * @param nameOfGroup Nom du groupe sur lequel imposer la fonction
     * @param FunctionPtr function imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedThermalDOFOnNodes( const PhysicalQuantityComponent &coordinate,
                                      const FunctionPtr &function,
                                      const std::string &nameOfGroup ) {
        // On verifie que le pointeur vers le modele ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_model ) || _model->isEmpty() )
            throw std::runtime_error( "The model is empty" );
        if ( !_model->getMesh()->hasGroupOfNodes( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in mesh" );

        MeshEntityPtr meshEnt( new GroupOfNodes( nameOfGroup ) );
        FunctionLoadTemperature resu( meshEnt, coordinate, function );
        _listOfFunctionImposedTemperature.push_back( resu );
        return true;
    };

    /**
     * @brief Ajout d'une fonction thermique imposee sur un groupe de noeuds
     * @param namesOfGroup Noms des groupes sur lequels imposer la valeur
     * @param FunctionPtr function imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedThermalDOFOnNodes(
        const PhysicalQuantityComponent &coordinate, const FunctionPtr &function,
        const std::vector< std::string > &namesOfGroup ) {
        for ( const auto &nameOfGroup : namesOfGroup )
            addImposedThermalDOFOnNodes( coordinate, function, nameOfGroup );
        return true;
    };
};

/**
 * @class KinematicsAcousticLoadClass
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsAcousticLoadClass : public KinematicsLoadClass {
  public:
    /**
     * @brief Constructeur
     */
    KinematicsAcousticLoadClass() : KinematicsLoadClass( "_ACOU" ){};

    /**
     * @brief Constructeur
     */
    KinematicsAcousticLoadClass( const std::string name )
        : KinematicsLoadClass( name, "_ACOU" ){};

    /**
     * @typedef KinematicsAcousticLoadPtr
     * @brief Pointeur intelligent vers un KinematicsAcousticLoad
     */
    typedef boost::shared_ptr< KinematicsAcousticLoadClass > KinematicsAcousticLoadPtr;

    /**
     * @brief Ajout d'une valeur acoustique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedAcousticDOFOnCells( const std::string &nameOfGroup,
                                          const double &value ) {
        throw std::runtime_error( "Not yet implemented" );
    };

    /**
     * @brief Ajout d'une valeur acoustique imposee sur un groupe de noeuds
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedAcousticDOFOnNodes( const std::string &nameOfGroup,
                                       double value ) {
        throw std::runtime_error( "Not yet implemented" );
    };
};

/**
 * @typedef KinematicsLoad
 * @brief Pointeur intelligent vers un KinematicsLoadClass
 */
typedef boost::shared_ptr< KinematicsLoadClass > KinematicsLoadPtr;

/**
 * @typedef KinematicsMechanicalLoadPtr
 * @brief Pointeur intelligent vers un KinematicsMechanicalLoad
 */
typedef boost::shared_ptr< KinematicsMechanicalLoadClass > KinematicsMechanicalLoadPtr;

/**
 * @typedef KinematicsThermalLoadPtr
 * @brief Pointeur intelligent vers un KinematicsThermalLoad
 */
typedef boost::shared_ptr< KinematicsThermalLoadClass > KinematicsThermalLoadPtr;

/**
 * @typedef KinematicsAcousticLoadPtr
 * @brief Pointeur intelligent vers un KinematicsAcousticLoad
 */
typedef boost::shared_ptr< KinematicsAcousticLoadClass > KinematicsAcousticLoadPtr;

/** @typedef std::list de KinematicsLoad */
typedef std::list< KinematicsLoadPtr > ListKineLoad;
/** @typedef Iterateur sur une std::list de KinematicsLoad */
typedef ListKineLoad::iterator ListKineLoadIter;
/** @typedef Iterateur constant sur une std::list de KinematicsLoad */
typedef ListKineLoad::const_iterator ListKineLoadCIter;

#endif /* KINEMATICSLOAD_H_ */
