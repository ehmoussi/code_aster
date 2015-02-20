#ifndef MECHANICALLOAD_H_
#define MECHANICALLOAD_H_

/**
 * @file MechanicalLoad.h
 
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

#include <iostream> 
#include <stdexcept>
#include <string> 
#include "astercxx.h"
#include "DataStructure/DataStructure.h"
#include "Loads/PhysicalQuantity.h"
#include "Mesh/MeshEntities.h"
#include "Modeling/Model.h"

#include "RunManager/CommandSyntaxCython.h"

/**
 * @enum LoadEnum
 * @brief Inventory of all mechanical loads available in Code_Aster
 */
enum LoadEnum { NodalForce, ForceOnEdge, ForceOnFace, LineicForce, ImposedDoF, DistributedPressure, EndLoad };

/**
* @class LoadTraits
* @brief Traits class for a Load
*/
/* This is the most general case (defined but intentionally not implemented) */
/* It will be specialized for each load listed in the inventory */

template < LoadEnum Load > struct LoadTraits; 

/*************************************************************/
/*  Loads consisting of a force applied to some localization */
/*************************************************************/
/** @def LoadTraits <NodalForce>
*  @brief Declare specialization for NodalForce
*/

template <> struct LoadTraits <NodalForce>
{
/* Mot clé facteur pour AFFE_CHAR_MECA */
    static const std::string factorKeyword; 
/* Authorized support MeshEntity */
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = false;
    static bool const isAllowedOnGroupOfNodes = true;
};

/** @def LoadTraits <ForceOnFace>
*  @brief Declare specialization for ForceOnFace
*/

template <> struct LoadTraits <ForceOnFace>
{
/* Mot clé facteur pour AFFE_CHAR_MECA */
    static const std::string factorKeyword; 
/* Authorized support MeshEntity */
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/** @def LoadTraits <ForceOnEdge>
*  @brief Declare specialization for ForceOnEdge
*/

template <> struct LoadTraits <ForceOnEdge>
{
/* Mot clé facteur pour AFFE_CHAR_MECA */
    static const std::string factorKeyword; 
/* Authorized support MeshEntity */
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/** @def LoadTraits <LineicForce>
*  @brief Declare specialization for LineicForce
*/

template <> struct LoadTraits <LineicForce>
{
/* Mot clé facteur pour AFFE_CHAR_MECA */
    static const std::string factorKeyword; 
/* Authorized support MeshEntity */
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};


/***********************************************************/
/* @class MechanicalLoadInstance                           */
/* @brief Define a mechanical load                         */
/***********************************************************/

template< class PhysicalQuantity, LoadEnum Load >
 
class MechanicalLoadInstance: public DataStructure
{
    public:
    /** @typedef Traits Define the Traits type */
    typedef LoadTraits<Load> Traits;
    /** @typedef PhysicalQuantity Define the underlying PhysicalQuantity */
    typedef PhysicalQuantity PhysicalQuantityType; 
    
    private:
    /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    /** @typedef Definition d'un pointeur intelligent sur une PhysicalQuantity */
    typedef boost::shared_ptr< PhysicalQuantity > PhysicalQuantityPtr;

    /** @typedef PhysicalQuantity que l'on veut imposer*/
    PhysicalQuantityPtr _physicalQuantity;
    /** @brief MeshEntity sur laquelle repose le "blocage" */
    MeshEntityPtr    _supportMeshEntity;
    /** @ brief Modèle support */
    ModelPtr _supportModel;
    
    public:

    /** 
    * @brief Constructor
    */ 
    MechanicalLoadInstance():
                    DataStructure( getNewResultObjectName(), "CHAR_MECA" ),
                    _supportModel( ModelPtr() )
    {};

    /** 
    @brief Destructor
    */
    ~MechanicalLoadInstance(){};

    /**
    * @brief Set a physical quantity on a MeshEntity (group of nodes 
    * or group of elements)
    * @param physPtr shared pointer to a PhysicalQuantity 
    * @param nameOfGroup name of the group of elements
    * @return bool success/failure index
    */

    bool setValue( PhysicalQuantityPtr physPtr, std::string nameOfGroup = "") throw ( std::runtime_error )
    {
    /* Check that the pointer to the support model is not empty */
    if ( ( ! _supportModel ) || _supportModel->isEmpty() )
        throw std::runtime_error( "Model is empty" );
    
    /* Get the type of MeshEntity */
    MeshPtr currentMesh= _supportModel->getSupportMesh();
    /* If the support MeshEntity is not given, the quantity is set on the whole mesh */
    if ( nameOfGroup.size() == 0  && Traits::isAllowedOnWholeMesh )
    {
        _supportMeshEntity = MeshEntityPtr( new  AllMeshEntities() ) ;
    } 
    /* nameOfGroup is the name of a group of elements and 
    LoadTraits authorizes to base the current load on such a group */
    else if ( currentMesh->hasGroupOfElements( nameOfGroup ) && Traits::isAllowedOnGroupOfElements )
    {
        _supportMeshEntity = MeshEntityPtr( new GroupOfElements( nameOfGroup ) );
    }
    /* nameOfGroup is the name of a group of nodes and LoadTraits authorizes
    to base the current load on such a group */
    else if ( currentMesh->hasGroupOfNodes( nameOfGroup ) && Traits::isAllowedOnGroupOfNodes )
    {
        _supportMeshEntity = MeshEntityPtr( new GroupOfNodes( nameOfGroup ) );
    }
    else
        throw  std::runtime_error( nameOfGroup + " does not exist in the mesh or it is not authorized as a localization of the current load " );

        /* Copy the shared pointer of the Physical Quantity */
        _physicalQuantity = physPtr; 
        return true;
    };

    /**
    * @brief Define the support model
    * @param currentMesh objet Model sur lequel la charge reposera
    */
    bool setSupportModel( ModelPtr& currentModel )
    {
        _supportModel = currentModel;
        return true;
    };

    /**
    * @brief appel de op0007 
    */
    bool build() throw ( std::runtime_error )
    {
        CommandSyntaxCython cmdSt( "AFFE_CHAR_MECA" );
        cmdSt.setResult( getResultObjectName(), "CHAR_MECA" );

        SyntaxMapContainer dict;
        if ( ! _supportModel )
            throw std::runtime_error("Support model is undefined");
        dict.container["MODELE"] = _supportModel->getName();
        ListSyntaxMapContainer listeLoad;
        SyntaxMapContainer dict2;
        std::cout << "MODELE  " <<  _supportModel->getName() << std::endl;
        /* On itere sur les composantes de la "PhysicalQuantity" */
        typename PhysicalQuantityType::MapOfCompAndVal comp_val=_physicalQuantity-> getMap(); 
        for ( typename PhysicalQuantityType::MapIt curIter(comp_val.begin());
              curIter != comp_val.end(); 
              ++curIter )
        {
            dict2.container[ComponentNames[curIter-> first] ] = curIter->second ;
            std::cout << ComponentNames[curIter-> first] << "   " << curIter->second << std::endl;
        }
        /* Caractéristiques du MeshEntity */
        if ( _supportMeshEntity->getType() == AllMeshEntitiesType )
        {
            dict2.container["TOUT"] = "OUI";
        }
        else
        {
            if ( _supportMeshEntity->getType()  == GroupOfNodesType )
                {dict2.container["GROUP_NO"] = _supportMeshEntity->getEntityName();
                std::cout << "GROUP_NO " <<  _supportMeshEntity->getEntityName() << std::endl;} 
            else if ( _supportMeshEntity->getType()  ==  GroupOfElementsType )
                dict2.container["GROUP_MA"] = _supportMeshEntity->getEntityName();
        }
        listeLoad.push_back( dict2 );
        /*mot-clé facteur*/ 
        std::string kw = Traits::factorKeyword;
        dict.container[kw] = listeLoad;
        cmdSt.define( dict );

        try
        {
            INTEGER op = 7;
            CALL_EXECOP( &op );
        }
        catch( ... )
        {
            throw;
        }
        return true;
    };
};

/**********************************************************/
/*  Explicit instantiation of template classes
/**********************************************************/

/** @typedef NodalForceDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, NodalForce >;
typedef MechanicalLoadInstance< ForceDoubleInstance, NodalForce > NodalForceDoubleInstance;
typedef boost::shared_ptr< NodalForceDoubleInstance > NodalForceDoublePtr;

/** @typedef NodalForceAndMomentumDouble  */
template class MechanicalLoadInstance< ForceAndMomentumDoubleInstance, NodalForce >;
typedef MechanicalLoadInstance< ForceAndMomentumDoubleInstance, NodalForce > NodalForceAndMomentumDoubleInstance;
typedef boost::shared_ptr< NodalForceAndMomentumDoubleInstance > NodalForceAndMomentumDoublePtr;

/** @typedef ForceOnFaceDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, ForceOnFace >;
typedef MechanicalLoadInstance< ForceDoubleInstance, ForceOnFace > ForceOnFaceDoubleInstance;
typedef boost::shared_ptr< ForceOnFaceDoubleInstance > ForceOnFaceDoublePtr;

/** @typedef ForceOnEdgeDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, ForceOnEdge >;
typedef MechanicalLoadInstance< ForceDoubleInstance, ForceOnEdge > ForceOnEdgeDoubleInstance;
typedef boost::shared_ptr< ForceOnEdgeDoubleInstance > ForceOnEdgeDoublePtr;

/** @typedef LineicForceDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, LineicForce >;
typedef MechanicalLoadInstance< ForceDoubleInstance, LineicForce > LineicForceDoubleInstance;
typedef boost::shared_ptr< LineicForceDoubleInstance > LineicForceDoublePtr;

#endif /* MECHANICALLOAD_H_ */
