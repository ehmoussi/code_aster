#ifndef KINEMATICSLOAD_H_
#define KINEMATICSLOAD_H_

/**
 * @file KinematicsLoad.h
 * @brief Fichier entete de la classe KinematicsLoad
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2014  EDF R&D                www.code-aster.org
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
#include <string>
#include "astercxx.h"
#include "Modeling/Model.h"
#include "Loads/UnitaryLoad.h"

/**
 * @class KinematicsLoadInstance
 * @brief Classe definissant une charge cinematique (issue d'AFFE_CHAR_CINE)
 * @author Nicolas Sellenet
 */
class KinematicsLoadInstance: public DataStructure
{
    private:
        /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

        /** @typedef std::list de DoubleLoadDisplacement */
        typedef std::list< DoubleLoadDisplacement > ListDoubleDisp;
        /** @typedef Iterateur sur ListDoubleDisp */
        typedef ListDoubleDisp::iterator ListDoubleDispIter;

        /** @typedef std::list de DoubleLoadTemperature */
        typedef std::list< DoubleLoadTemperature > ListDoubleTemp;
        /** @typedef Iterateur sur ListDoubleTemp */
        typedef ListDoubleTemp::iterator ListDoubleTempIter;

        /** @brief Modele support */
        ModelPtr       _supportModel;
        /** @brief Listes des valeurs imposees DEPL_R et TEMP_R */
        ListDoubleDisp _listOfDoubleImposedDisplacement;
        ListDoubleTemp _listOfDoubleImposedTemperature;
        /** @brief La SD est-elle vide ? */
        bool           _isEmpty;

    public:
        /**
         * @brief Constructeur
         */
        KinematicsLoadInstance();

        /**
         * @brief Ajout d'une valeur acoustique imposee sur un groupe de mailles
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedAcousticDOFOnElements( std::string nameOfGroup,
                                              double value ) throw ( std::runtime_error )
        {
            throw std::runtime_error( "Not yet implemented" );
        };

        /**
         * @brief Ajout d'une valeur acoustique imposee sur un groupe de noeuds
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedAcousticDOFOnNodes( std::string nameOfGroup,
                                           double value ) throw ( std::runtime_error )
        {
            throw std::runtime_error( "Not yet implemented" );
        };

        /**
         * @brief Ajout d'une valeur mecanique imposee sur un groupe de mailles
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedMechanicalDOFOnElements( PhysicalQuantityComponent coordinate, double value,
                                                std::string nameOfGroup ) throw ( std::runtime_error )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw std::runtime_error( "The support model is empty" );
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in support mesh" );

            MeshEntityPtr meshEnt( new GroupOfElements( nameOfGroup ) );
            DoubleLoadDisplacement resu( meshEnt, coordinate, value );
            _listOfDoubleImposedDisplacement.push_back( resu );
            return true;
        };

        /**
         * @brief Ajout d'une valeur mecanique imposee sur un groupe de noeuds
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedMechanicalDOFOnNodes( PhysicalQuantityComponent coordinate, double value,
                                             std::string nameOfGroup ) throw ( std::runtime_error )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw std::runtime_error( "The support model is empty" );
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in support mesh" );

            MeshEntityPtr meshEnt( new GroupOfNodes( nameOfGroup ) );
            DoubleLoadDisplacement resu( meshEnt, coordinate, value );
            _listOfDoubleImposedDisplacement.push_back( resu );
            return true;
        };

        /**
         * @brief Ajout d'une valeur thermique imposee sur un groupe de mailles
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedThermalDOFOnElements( PhysicalQuantityComponent coordinate, double value,
                                             std::string nameOfGroup ) throw ( std::runtime_error )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw std::runtime_error( "The support model is empty");
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in support mesh" );

            MeshEntityPtr meshEnt( new GroupOfElements( nameOfGroup ) );
            DoubleLoadTemperature resu( meshEnt, coordinate, value );
            _listOfDoubleImposedTemperature.push_back( resu );
            return true;
        };

        /**
         * @brief Ajout d'une valeur thermique imposee sur un groupe de noeuds
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedThermalDOFOnNodes( PhysicalQuantityComponent coordinate, double value,
                                          std::string nameOfGroup ) throw ( std::runtime_error )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw std::runtime_error( "The support model is empty" );
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "not in support mesh" );

            MeshEntityPtr meshEnt( new GroupOfNodes( nameOfGroup ) );
            DoubleLoadTemperature resu( meshEnt, coordinate, value );
            _listOfDoubleImposedTemperature.push_back( resu );
            return true;
        };

        /**
         * @brief Construction de la charge (appel a OP0101)
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool build() throw ( std::runtime_error );

        /**
         * @brief Definition du modele support
         * @param currentMesh objet Model sur lequel la charge reposera
         */
        bool setSupportModel( ModelPtr& currentModel )
        {
            if ( currentModel->isEmpty() )
                throw std::runtime_error( "Model is empty" );
            _supportModel = currentModel;
            return true;
        };
};

/**
 * @typedef KinematicsLoad
 * @brief Pointeur intelligent vers un KinematicsLoadInstance
 */
typedef boost::shared_ptr< KinematicsLoadInstance > KinematicsLoadPtr;
/** @typedef std::list de KinematicsLoad */
typedef std::list< KinematicsLoadPtr > ListKineLoad;
/** @typedef Iterateur sur une std::list de KinematicsLoad */
typedef ListKineLoad::iterator ListKineLoadIter;
/** @typedef Iterateur constant sur une std::list de KinematicsLoad */
typedef ListKineLoad::const_iterator ListKineLoadCIter;

#endif /* KINEMATICSLOAD_H_ */
