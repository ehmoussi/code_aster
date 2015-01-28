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
        typedef list< DoubleLoadDisplacement > ListDoubleDisp;
        /** @typedef Iterateur sur ListDoubleDisp */
        typedef ListDoubleDisp::iterator ListDoubleDispIter;

        /** @typedef std::list de DoubleLoadTemperature */
        typedef list< DoubleLoadTemperature > ListDoubleTemp;
        /** @typedef Iterateur sur ListDoubleTemp */
        typedef ListDoubleTemp::iterator ListDoubleTempIter;

        /** @brief Modele support */
        ModelPtr       _supportModel;
        /** @brief Listes des valeurs imposees DEPL_R et TEMP_R */
        ListDoubleDisp _listOfDoubleImposedDisplacement;
        ListDoubleTemp _listOfDoubleImposedTemperature;

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
        bool addImposedAcousticDOFOnElements( string nameOfGroup, double value )
        {
            throw "Not yet implemented";
        };

        /**
         * @brief Ajout d'une valeur acoustique imposee sur un groupe de noeuds
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedAcousticDOFOnNodes( string nameOfGroup, double value )
        {
            throw "Not yet implemented";
        };

        /**
         * @brief Ajout d'une valeur mecanique imposee sur un groupe de mailles
         * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
         * @param value Valeur imposee
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool addImposedMechanicalDOFOnElements( AsterCoordinates coordinate,
                                                double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfElementsInstance( nameOfGroup ) );
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
        bool addImposedMechanicalDOFOnNodes( AsterCoordinates coordinate,
                                             double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfNodesInstance( nameOfGroup ) );
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
        bool addImposedThermalDOFOnElements( AsterCoordinates coordinate,
                                             double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfElementsInstance( nameOfGroup ) );
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
        bool addImposedThermalDOFOnNodes( AsterCoordinates coordinate,
                                          double value, string nameOfGroup )
        {
            // On verifie que le pointeur vers le modele support ET que le modele lui-meme
            // ne sont pas vides
            if ( ( ! _supportModel ) || _supportModel->isEmpty() )
                throw "The support model is empty";
            if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw nameOfGroup + "not in support mesh";

            MeshEntityPtr meshEnt( new GroupOfNodesInstance( nameOfGroup ) );
            DoubleLoadTemperature resu( meshEnt, coordinate, value );
            _listOfDoubleImposedTemperature.push_back( resu );
            return true;
        };

        /**
         * @brief Construction de la charge (appel a OP0101)
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool build();

        /**
         * @brief Definition du modele support
         * @param currentMesh objet Model sur lequel la charge reposera
         */
        void setSupportModel( ModelPtr& currentModel )
        {
            _supportModel = currentModel;
        };
};

/**
 * @class KinematicsLoad
 * @brief Enveloppe d'un pointeur intelligent vers un KinematicsLoadInstance
 * @author Nicolas Sellenet
 */
class KinematicsLoad
{
    public:
        typedef boost::shared_ptr< KinematicsLoadInstance > KinematicsLoadPtr;

    private:
        KinematicsLoadPtr _kinematicsLoadPtr;

    public:
        KinematicsLoad(bool initilisation = true): _kinematicsLoadPtr()
        {
            if ( initilisation == true )
                _kinematicsLoadPtr = KinematicsLoadPtr( new KinematicsLoadInstance() );
        };

        ~KinematicsLoad()
        {};

        KinematicsLoad& operator=(const KinematicsLoad& tmp)
        {
            _kinematicsLoadPtr = tmp._kinematicsLoadPtr;
            return *this;
        };

        const KinematicsLoadPtr& operator->() const
        {
            return _kinematicsLoadPtr;
        };

        KinematicsLoadInstance& operator*(void) const
        {
            return *_kinematicsLoadPtr;
        };

        bool isEmpty() const
        {
            if ( _kinematicsLoadPtr.use_count() == 0 ) return true;
            return false;
        };
};

#endif /* KINEMATICSLOAD_H_ */
