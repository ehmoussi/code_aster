#ifndef LISTOFLOADS_H_
#define LISTOFLOADS_H_

/**
 * @file ListOfLoads.h
 * @brief Fichier entete de la classe ListOfLoads
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
#include "Loads/MechanicalLoad.h"
#include "Loads/KinematicsLoad.h"
#include "MemoryManager/JeveuxVector.h"

/**
 * @class ListOfLoadInstance
 * @brief Classe definissant une liste de charge
 * @author Nicolas Sellenet
 */
class ListOfLoadsInstance: public DataStructure
{
    private:
        /** @brief Chargements cinematiques */
        ListKineLoad       _listOfKinematicsLoads;
        /** @brief Chargements Mecaniques */
        ListMecaLoad       _listOfMechanicalLoads;
        /** @brief .INFC */
        JeveuxVectorLong   _loadInformations;
        /** @brief .LCHA */
        JeveuxVectorChar24 _list;
        /** @brief La matrice est elle vide ? */
        bool               _isEmpty;

    public:
        /**
         * @brief Constructeur
         */
        ListOfLoadsInstance();

        /**
         * @brief Function d'ajout d'une charge cinematique
         * @param currentLoad charge a ajouter a la sd
         */
        void addKinematicsLoad( const KinematicsLoadPtr& currentLoad )
        {
            _isEmpty = true;
            _listOfKinematicsLoads.push_back( currentLoad );
        };

        /**
         * @brief Function d'ajout d'une charge mecanique
         * @param currentLoad charge a ajouter a la sd
         */
        void addMechanicalLoad( const GenericMechanicalLoadPtr& currentLoad )
        {
            _isEmpty = true;
            _listOfMechanicalLoads.push_back( currentLoad );
        };

        /**
         * @brief Construction de la liste de charge
         * @return Booleen indiquant que tout s'est bien passe
         */
        bool build() throw ( std::runtime_error );

        /**
         * @brief Function de récupération des informations des charges
         * @return _loadInformations
         */
        JeveuxVectorLong getInformationVector() const
        {
            return _loadInformations;
        };

        /**
         * @brief Function de récupération de la liste des charges cinématiques
         * @return _listOfKinematicsLoads
         */
        const ListKineLoad& getListOfKinematicsLoads() const
        {
            return _listOfKinematicsLoads;
        };

        /**
         * @brief Function de récupération de la liste des charges mécaniques
         * @return _listOfMechanicalLoads
         */
        const ListMecaLoad& getListOfMechanicalLoads() const
        {
            return _listOfMechanicalLoads;
        };

        /**
         * @brief Function de récupération de la liste des charges
         * @return _list
         */
        JeveuxVectorChar24 getListVector() const
        {
            return _list;
        };

        /**
         * @brief Nombre de charges
         * @return taille de _listOfMechanicalLoads + taille de _listOfKinematicsLoads
         */
        int size() const
        {
            return _listOfMechanicalLoads.size() + _listOfKinematicsLoads.size();
        };
};

/**
 * @typedef ListOfLoad
 * @brief Pointeur intelligent vers un ListOfLoadInstance
 */
typedef boost::shared_ptr< ListOfLoadsInstance > ListOfLoadsPtr;

#endif /* LISTOFLOAD_H_ */
