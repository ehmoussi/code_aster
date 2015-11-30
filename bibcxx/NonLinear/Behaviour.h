#ifndef BEHAVIOUR_H_
#define BEHAVIOUR_H_

/**
 * @file Behaviour.h
 * @brief Definition of the (nonlinear) behaviour
 * @author Natacha Béreux
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

/* person_in_charge: natacha.bereux at edf.fr */
#include "astercxx.h"

#include "LinearAlgebra/SolverControl.h"
#include "Materials/MaterialOnMesh.h"
#include "Mesh/MeshEntities.h"
#include "Modeling/Model.h"
#include "RunManager/CommandSyntaxCython.h"
#include "Utilities/SyntaxDictionary.h"


class BehaviourInstance
{
    public:
        /**
         * @brief Constructeur
         */
        BehaviourInstance( std::string relation="ELAS", std::string deformation="PETIT"): 
          _relation(relation), _deformation(deformation), 
          _control( SolverControlPtr( new SolverControlInstance())), _isEmpty(true)
        {};
        /**
         * @brief Add model
         */
        void setSupportModel( ModelPtr currentModel)
        {
          _supportModel=currentModel; 
        };
        /**
        * @brief 
        */
        void setGroupOfElements( std::string nameOfGroup ) throw ( std::runtime_error )
        {
        if ( ! _supportModel ) throw std::runtime_error( "Support model is not defined" );
        if ( ! _supportModel->getSupportMesh()->hasGroupOfElements( nameOfGroup ) )
                throw std::runtime_error( nameOfGroup + "is not a group of elements in support mesh" );

        _supportMeshEntity =  MeshEntityPtr ( new GroupOfElements( nameOfGroup ) ) ;
        };
        /**
         * @brief Construction des cartes Compor, Carcri ... 
         */
        bool build() throw ( std::runtime_error ); 
        
     private:
        /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
        /** @brief Relation name*/
        std::string _relation;
        /** @brief Deformation name */
        std::string _deformation;
        /** @brief Contrôle de la convergence de la loi de comportement  */
        SolverControlPtr _control;
        /** @brief MeshEntity sur lequel on définit la loi de comportement */
        MeshEntityPtr _supportMeshEntity;
        /** @brief Modèle sous-jacent */
        ModelPtr _supportModel; 
        /** @brief Matériaux sous-jacents */
        MaterialOnMeshPtr _supportMaterialOnMesh;
        /** @brief Nom de la carte COMPOR */
        std::string _nameOfCompor;
        /** @brief Nom de la carte CARCRI */
        std::string _nameOfCarcri;
        /** @brief flag indiquant si les cartes ont été construites */
        bool _isEmpty;
};

/**
 * @typedef BehaviourPtr
 * @brief Enveloppe d'un pointeur intelligent vers un BehaviourInstance
 */
typedef boost::shared_ptr< BehaviourInstance > BehaviourPtr;

#endif /* BEHAVIOUR_H_ */
