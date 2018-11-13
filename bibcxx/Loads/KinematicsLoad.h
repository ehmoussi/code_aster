#ifndef KINEMATICSLOAD_H_
#define KINEMATICSLOAD_H_

/**
 * @file KinematicsLoad.h
 * @brief Fichier entete de la classe KinematicsLoad
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2018  EDF R&D                www.code-aster.org
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

#include "Functions/Function.h"
#include "Loads/UnitaryLoad.h"
#include "MemoryManager/JeveuxVector.h"
#include "Modeling/Model.h"
#include "astercxx.h"
#include <list>
#include <stdexcept>
#include <string>

/**
 * @class KinematicsLoadInstance
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsLoadInstance : public DataStructure {
  protected:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

    /** @typedef std::list de DoubleLoadDisplacement */
    typedef std::list< DoubleLoadDisplacement > ListDoubleDisp;
    /** @typedef Iterateur sur ListDoubleDisp */
    typedef ListDoubleDisp::iterator ListDoubleDispIter;

    /** @typedef std::list de DoubleLoadTemperature */
    typedef std::list< DoubleLoadTemperature > ListDoubleTemp;
    typedef std::list< FunctionLoadTemperature > ListFunctionTemp;
    /** @typedef Iterateur sur ListDoubleTemp */
    typedef ListDoubleTemp::iterator ListDoubleTempIter;

    /** @brief Modele support */
    ModelPtr _supportModel;
    /** @brief Listes des valeurs imposees DEPL_R et TEMP_R */
    ListDoubleDisp _listOfDoubleImposedDisplacement;
    ListDoubleTemp _listOfDoubleImposedTemperature;
    ListFunctionTemp _listOfFunctionImposedTemperature;
    JeveuxVectorLong _intParam;
    JeveuxVectorChar8 _charParam;
    JeveuxVectorDouble _doubleParam;
    /** @brief La SD est-elle vide ? */
    bool _isEmpty;

    /**
     * @brief Constructeur
     */
    KinematicsLoadInstance( const std::string &type );

    /**
     * @brief Constructeur
     */
    KinematicsLoadInstance( const std::string &name, const std::string &type );

  public:
    /**
     * @typedef KinematicsLoadPtr
     * @brief Pointeur intelligent vers un KinematicsLoad
     */
    typedef boost::shared_ptr< KinematicsLoadInstance > KinematicsLoadPtr;

    /**
     * @brief Construction de la charge (appel a OP0101)
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool build() ;

    /**
     * @brief Definition du modele support
     * @param currentModel objet Model sur lequel la charge reposera
     */
    bool setSupportModel( ModelPtr &currentModel ) {
        if ( currentModel->isEmpty() )
            throw std::runtime_error( "Model is empty" );
        _supportModel = currentModel;
        return true;
    };
};

/**
 * @class KinematicsMechanicalLoadInstance
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsMechanicalLoadInstance : public KinematicsLoadInstance {
  public:
    /**
     * @brief Constructeur
     */
    KinematicsMechanicalLoadInstance() : KinematicsLoadInstance( "_MECA" ){};

    /**
     * @brief Constructeur
     */
    KinematicsMechanicalLoadInstance( const std::string name )
        : KinematicsLoadInstance( name, "_MECA" ){};

    /**
     * @typedef KinematicsMechanicalLoadPtr
     * @brief Pointeur intelligent vers un KinematicsMechanicalLoad
     */
    typedef boost::shared_ptr< KinematicsMechanicalLoadInstance > KinematicsMechanicalLoadPtr;

    /**
     * @brief Ajout d'une valeur mecanique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedMechanicalDOFOnElements(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::string &nameOfGroup ) {
        // On verifie que le pointeur vers le modele support ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_supportModel ) || _supportModel->isEmpty() )
            throw std::runtime_error( "The support model is empty" );
        if ( !_supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in support mesh" );

        MeshEntityPtr meshEnt( new GroupOfElements( nameOfGroup ) );
        DoubleLoadDisplacement resu( meshEnt, coordinate, value );
        _listOfDoubleImposedDisplacement.push_back( resu );
        return true;
    };

    /**
     * @brief Ajout d'une valeur mecanique imposee sur un groupe de mailles
     * @param namesOfGroup Noms des groupes sur lequels imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedMechanicalDOFOnElements(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::vector< std::string > &namesOfGroup ) {
        for ( const auto &nameOfGroup : namesOfGroup )
            addImposedMechanicalDOFOnElements( coordinate, value, nameOfGroup );
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
        // On verifie que le pointeur vers le modele support ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_supportModel ) || _supportModel->isEmpty() )
            throw std::runtime_error( "The support model is empty" );
        if ( !_supportModel->getSupportMesh()->hasGroupOfNodes( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in support mesh" );

        MeshEntityPtr meshEnt( new GroupOfNodes( nameOfGroup ) );
        DoubleLoadDisplacement resu( meshEnt, coordinate, value );
        _listOfDoubleImposedDisplacement.push_back( resu );
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
 * @class KinematicsThermalLoadInstance
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsThermalLoadInstance : public KinematicsLoadInstance {
  public:
    /**
     * @brief Constructeur
     */
    KinematicsThermalLoadInstance() : KinematicsLoadInstance( "_THER" ){};

    /**
     * @brief Constructeur
     */
    KinematicsThermalLoadInstance( const std::string name )
        : KinematicsLoadInstance( name, "_THER" ){};

    /**
     * @typedef KinematicsThermalLoadPtr
     * @brief Pointeur intelligent vers un KinematicsThermalLoad
     */
    typedef boost::shared_ptr< KinematicsThermalLoadInstance > KinematicsThermalLoadPtr;

    /**
     * @brief Ajout d'une valeur thermique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool
    addImposedThermalDOFOnElements( const PhysicalQuantityComponent &coordinate,
                                    const double &value,
                                    const std::string &nameOfGroup ) {
        // On verifie que le pointeur vers le modele support ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_supportModel ) || _supportModel->isEmpty() )
            throw std::runtime_error( "The support model is empty" );
        if ( !_supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in support mesh" );

        MeshEntityPtr meshEnt( new GroupOfElements( nameOfGroup ) );
        DoubleLoadTemperature resu( meshEnt, coordinate, value );
        _listOfDoubleImposedTemperature.push_back( resu );
        return true;
    };

    /**
     * @brief Ajout d'une valeur thermique imposee sur un groupe de mailles
     * @param namesOfGroup Noms des groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedThermalDOFOnElements(
        const PhysicalQuantityComponent &coordinate, const double &value,
        const std::vector< std::string > &namesOfGroup ) {
        for ( const auto &nameOfGroup : namesOfGroup )
            addImposedThermalDOFOnElements( coordinate, value, nameOfGroup );
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
        // On verifie que le pointeur vers le modele support ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_supportModel ) || _supportModel->isEmpty() )
            throw std::runtime_error( "The support model is empty" );
        if ( !_supportModel->getSupportMesh()->hasGroupOfNodes( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in support mesh" );

        MeshEntityPtr meshEnt( new GroupOfNodes( nameOfGroup ) );
        DoubleLoadTemperature resu( meshEnt, coordinate, value );
        _listOfDoubleImposedTemperature.push_back( resu );
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
        // On verifie que le pointeur vers le modele support ET que le modele lui-meme
        // ne sont pas vides
        if ( ( !_supportModel ) || _supportModel->isEmpty() )
            throw std::runtime_error( "The support model is empty" );
        if ( !_supportModel->getSupportMesh()->hasGroupOfNodes( nameOfGroup ) )
            throw std::runtime_error( nameOfGroup + " not in support mesh" );

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
 * @class KinematicsAcousticLoadInstance
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsAcousticLoadInstance : public KinematicsLoadInstance {
  public:
    /**
     * @brief Constructeur
     */
    KinematicsAcousticLoadInstance() : KinematicsLoadInstance( "_ACOU" ){};

    /**
     * @brief Constructeur
     */
    KinematicsAcousticLoadInstance( const std::string name )
        : KinematicsLoadInstance( name, "_ACOU" ){};

    /**
     * @typedef KinematicsAcousticLoadPtr
     * @brief Pointeur intelligent vers un KinematicsAcousticLoad
     */
    typedef boost::shared_ptr< KinematicsAcousticLoadInstance > KinematicsAcousticLoadPtr;

    /**
     * @brief Ajout d'une valeur acoustique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addImposedAcousticDOFOnElements( const std::string &nameOfGroup,
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
 * @brief Pointeur intelligent vers un KinematicsLoadInstance
 */
typedef boost::shared_ptr< KinematicsLoadInstance > KinematicsLoadPtr;

/**
 * @typedef KinematicsMechanicalLoadPtr
 * @brief Pointeur intelligent vers un KinematicsMechanicalLoad
 */
typedef boost::shared_ptr< KinematicsMechanicalLoadInstance > KinematicsMechanicalLoadPtr;

/**
 * @typedef KinematicsThermalLoadPtr
 * @brief Pointeur intelligent vers un KinematicsThermalLoad
 */
typedef boost::shared_ptr< KinematicsThermalLoadInstance > KinematicsThermalLoadPtr;

/**
 * @typedef KinematicsAcousticLoadPtr
 * @brief Pointeur intelligent vers un KinematicsAcousticLoad
 */
typedef boost::shared_ptr< KinematicsAcousticLoadInstance > KinematicsAcousticLoadPtr;

/** @typedef std::list de KinematicsLoad */
typedef std::list< KinematicsLoadPtr > ListKineLoad;
/** @typedef Iterateur sur une std::list de KinematicsLoad */
typedef ListKineLoad::iterator ListKineLoadIter;
/** @typedef Iterateur constant sur une std::list de KinematicsLoad */
typedef ListKineLoad::const_iterator ListKineLoadCIter;

#endif /* KINEMATICSLOAD_H_ */
