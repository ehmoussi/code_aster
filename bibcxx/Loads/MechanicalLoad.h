#ifndef MECHANICALLOAD_H_
#define MECHANICALLOAD_H_

/**
 * @file MechanicalLoad.h
 * @author Natacha Bereux
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
enum LoadEnum { NodalForce, ForceOnEdge, ForceOnFace, LineicForce, InternalForce, ForceOnBeam, ForceOnShell,
                PressureOnPipe, ImposedDoF, DistributedPressure, ImpedanceOnFace, NormalSpeedOnFace, WavePressureOnFace, 
                THMFlux};

/**
 * @class LoadTraits
 * @brief Traits class for a Load
 */
// This is the most general case (defined but intentionally not implemented)
// It will be specialized for each load listed in the inventory

template< LoadEnum Load > struct LoadTraits; 

/*************************************************************/
/*  Loads consisting of a force applied to some localization */
/*************************************************************/
/**
 * @def LoadTraits<NodalForce>
 * @brief Declare specialization for NodalForce
 */
template <> struct LoadTraits< NodalForce >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = false;
    static bool const isAllowedOnGroupOfNodes = true;
};

/**
 * @def LoadTraits<ForceOnFace>
 * @brief Declare specialization for ForceOnFace
 */
template <> struct LoadTraits< ForceOnFace >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ForceOnEdge>
 * @brief Declare specialization for ForceOnEdge
 */
template <> struct LoadTraits< ForceOnEdge >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<LineicForce>
 * @brief Declare specialization for LineicForce
 */
template <> struct LoadTraits< LineicForce >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<InternalForce>
 * @brief Declare specialization for InternalForce
 */
template <> struct LoadTraits< InternalForce >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ForceOnBeam>
 * @brief Declare specialization for ForceOnBeam
 */
template <> struct LoadTraits< ForceOnBeam >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
    /** @todo mot clé supplémentaire TYPE_CHARGE=FORCE */
};

/**
 * @def LoadTraits<ForceOnShell>
 * @brief Declare specialization for ForceOnShell
 */
template <> struct LoadTraits< ForceOnShell >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<PressureOnPipe>
 * @brief Declare specialization for PressureOnPipe
 */
template <> struct LoadTraits< PressureOnPipe >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ImposedDoF>
 * @brief Declare specialization for ImposedDoF
 */
template <> struct LoadTraits< ImposedDoF >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = true;
};

/**
 * @def LoadTraits<DistributedPressure>
 * @brief Declare specialization for DistributedPressure
 */
template <> struct LoadTraits< DistributedPressure >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ImpedanceOnFace>
 * @brief Declare specialization for ImpedanceOnFace
 */
template <> struct LoadTraits< ImpedanceOnFace >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<NormalSpeedOnFace>
 * @brief Declare specialization for NormalSpeedOnFace
 */
template <> struct LoadTraits< NormalSpeedOnFace >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<WavePressureOnFace>
 * @brief Declare specialization for WavePressureOnFace
 */
template <> struct LoadTraits< WavePressureOnFace >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<THMFlux>
 * @brief Declare specialization for THMFlux
 */
template <> struct LoadTraits< THMFlux >
{
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword; 
    // Authorized support MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};


/**
 * @class GenericMechanicalLoadInstance
 * @brief Define a generic mechanical load
 * @author Nicolas Sellenet
 */
class GenericMechanicalLoadInstance: public DataStructure
{
    protected:
        /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
        typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

        /** @brief MeshEntity sur laquelle repose le "blocage" */
        MeshEntityPtr    _supportMeshEntity;
        /** @brief Modèle support */
        ModelPtr         _supportModel;

    public:
        /**
         * @brief Constructor
         */
        GenericMechanicalLoadInstance():
                        DataStructure( getNewResultObjectName(), "CHAR_MECA" ),
                        _supportModel( ModelPtr() )
        {};

        /**
         * @brief Destructor
         */
        ~GenericMechanicalLoadInstance()
        {};

        /**
         * @brief Define the support model
         * @param currentMesh objet Model sur lequel la charge reposera
         */
        bool setSupportModel( ModelPtr& currentModel )
        {
            _supportModel = currentModel;
            return true;
        };

        virtual bool build() = 0;
};

/**
 * @class MechanicalLoadInstance
 * @brief Define a mechanical load
 * @author Natacha Bereux
 */
template< class PhysicalQuantity, LoadEnum Load >
class MechanicalLoadInstance: public GenericMechanicalLoadInstance
{
    public:
    /** @typedef Traits Define the Traits type */
    typedef LoadTraits< Load > Traits;
    /** @typedef PhysicalQuantity Define the underlying PhysicalQuantity */
    typedef PhysicalQuantity PhysicalQuantityType; 

    private:
    /** @typedef Definition d'un pointeur intelligent sur une PhysicalQuantity */
    typedef boost::shared_ptr< PhysicalQuantity > PhysicalQuantityPtr;

    /** @typedef PhysicalQuantity que l'on veut imposer*/
    PhysicalQuantityPtr _physicalQuantity;

    public:

    /**
     * @brief Constructor
     */
    MechanicalLoadInstance(): GenericMechanicalLoadInstance()
    {};

    /**
     * @brief Destructor
     */
    ~MechanicalLoadInstance()
    {};

    /**
     * @brief Set a physical quantity on a MeshEntity (group of nodes 
     *        or group of elements)
     * @param physPtr shared pointer to a PhysicalQuantity 
     * @param nameOfGroup name of the group of elements
     * @return bool success/failure index
     */
    bool setValue( PhysicalQuantityPtr physPtr, std::string nameOfGroup = "") throw ( std::runtime_error )
    {
        // Check that the pointer to the support model is not empty
        if ( ( ! _supportModel ) || _supportModel->isEmpty() )
            throw std::runtime_error( "Model is empty" );

        // Get the type of MeshEntity
        MeshPtr currentMesh= _supportModel->getSupportMesh();
        // If the support MeshEntity is not given, the quantity is set on the whole mesh
        if ( nameOfGroup.size() == 0  && Traits::isAllowedOnWholeMesh )
        {
            _supportMeshEntity = MeshEntityPtr( new  AllMeshEntities() ) ;
        }
        // nameOfGroup is the name of a group of elements and 
        // LoadTraits authorizes to base the current load on such a group
        else if ( currentMesh->hasGroupOfElements( nameOfGroup ) && Traits::isAllowedOnGroupOfElements )
        {
            _supportMeshEntity = MeshEntityPtr( new GroupOfElements( nameOfGroup ) );
        }
        // nameOfGroup is the name of a group of nodes and LoadTraits authorizes
        //to base the current load on such a group
        else if ( currentMesh->hasGroupOfNodes( nameOfGroup ) && Traits::isAllowedOnGroupOfNodes )
        {
            _supportMeshEntity = MeshEntityPtr( new GroupOfNodes( nameOfGroup ) );
        }
        else
            throw  std::runtime_error( nameOfGroup + " does not exist in the mesh or it is not authorized as a localization of the current load " );

        // Copy the shared pointer of the Physical Quantity
        _physicalQuantity = physPtr; 
        return true;
    };

    /**
     * @brief appel de op0007
     */
    bool build() throw ( std::runtime_error )
    {
        //std::cout << " build " << std::endl; 
        CommandSyntaxCython cmdSt( "AFFE_CHAR_MECA" );
        cmdSt.setResult( getResultObjectName(), "CHAR_MECA" );

        SyntaxMapContainer dict;
        if ( ! _supportModel )
            throw std::runtime_error("Support model is undefined");
        dict.container["MODELE"] = _supportModel->getName();
        ListSyntaxMapContainer listeLoad;
        SyntaxMapContainer dict2;
        //std::cout << "MODELE  " <<  _supportModel->getName() << std::endl;
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
        //        std::cout << "GROUP_NO " <<  _supportMeshEntity->getEntityName() << std::endl;
                } 
            else if ( _supportMeshEntity->getType()  ==  GroupOfElementsType )
                dict2.container["GROUP_MA"] = _supportMeshEntity->getEntityName();
        }
        listeLoad.push_back( dict2 );
        //mot-clé facteur
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

/** @typedef GenericMechanicalLoad  */
typedef boost::shared_ptr< GenericMechanicalLoadInstance > GenericMechanicalLoadPtr;

/* Appliquer une force nodale sur une modélisation 3D */
/** @typedef NodalForceDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, NodalForce >;
typedef MechanicalLoadInstance< ForceDoubleInstance, NodalForce > NodalForceDoubleInstance;
typedef boost::shared_ptr< NodalForceDoubleInstance > NodalForceDoublePtr;

/* Appliquer une force nodale sur des éléments de structure */
/** @typedef NodalStructuralForceDouble  */
template class MechanicalLoadInstance< StructuralForceDoubleInstance, NodalForce >;
typedef MechanicalLoadInstance< StructuralForceDoubleInstance, NodalForce > NodalStructuralForceDoubleInstance;
typedef boost::shared_ptr< NodalStructuralForceDoubleInstance > NodalStructuralForceDoublePtr;

/** @typedef ForceOnFaceDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, ForceOnFace >;
typedef MechanicalLoadInstance< ForceDoubleInstance, ForceOnFace > ForceOnFaceDoubleInstance;
typedef boost::shared_ptr< ForceOnFaceDoubleInstance > ForceOnFaceDoublePtr;

/* Appliquer une force sur une arête d'élément volumique */
/** @typedef ForceOnEdgeDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, ForceOnEdge >;
typedef MechanicalLoadInstance< ForceDoubleInstance, ForceOnEdge > ForceOnEdgeDoubleInstance;
typedef boost::shared_ptr< ForceOnEdgeDoubleInstance > ForceOnEdgeDoublePtr;

/* Appliquer une force sur une arête d'élément de structure (coque/plaque) */
/** @typedef StructuralForceOnEdgeDouble  */
template class MechanicalLoadInstance< StructuralForceDoubleInstance, ForceOnEdge >;
typedef MechanicalLoadInstance< StructuralForceDoubleInstance, ForceOnEdge > StructuralForceOnEdgeDoubleInstance;
typedef boost::shared_ptr< StructuralForceOnEdgeDoubleInstance > StructuralForceOnEdgeDoublePtr;

/** @typedef LineicForceDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, LineicForce >;
typedef MechanicalLoadInstance< ForceDoubleInstance, LineicForce > LineicForceDoubleInstance;
typedef boost::shared_ptr< LineicForceDoubleInstance > LineicForceDoublePtr;

/** @typedef InternalForceDouble  */
template class MechanicalLoadInstance< ForceDoubleInstance, InternalForce >;
typedef MechanicalLoadInstance< ForceDoubleInstance, InternalForce > InternalForceDoubleInstance;
typedef boost::shared_ptr< InternalForceDoubleInstance > InternalForceDoublePtr;

/* Appliquer une force (définie dans le repère global) à une poutre */
/** @typedef StructuralForceOnBeamDouble  */
template class MechanicalLoadInstance< StructuralForceDoubleInstance, ForceOnBeam >;
typedef MechanicalLoadInstance< StructuralForceDoubleInstance, ForceOnBeam > StructuralForceOnBeamDoubleInstance;
typedef boost::shared_ptr< StructuralForceOnBeamDoubleInstance > StructuralForceOnBeamDoublePtr;

/* Appliquer une force (définie dans le repère local) à une poutre */
/** @typedef LocalForceOnBeamDouble  */
template class MechanicalLoadInstance< LocalBeamForceDoubleInstance, ForceOnBeam >;
typedef MechanicalLoadInstance< LocalBeamForceDoubleInstance, ForceOnBeam > LocalForceOnBeamDoubleInstance;
typedef boost::shared_ptr< LocalForceOnBeamDoubleInstance > LocalForceOnBeamDoublePtr;

/* Appliquer une force (définie dans le repère global) à une coque/plaque */
/** @typedef StructuralForceOnShellDouble  */
template class MechanicalLoadInstance< StructuralForceDoubleInstance, ForceOnShell >;
typedef MechanicalLoadInstance< StructuralForceDoubleInstance, ForceOnShell > StructuralForceOnShellDoubleInstance;
typedef boost::shared_ptr< StructuralForceOnShellDoubleInstance > StructuralForceOnShellDoublePtr;

/* Appliquer une force (définie dans le repère local) à une coque/plaque */
/** @typedef LocalForceOnShellDouble  */
template class MechanicalLoadInstance< LocalShellForceDoubleInstance, ForceOnShell >;
typedef MechanicalLoadInstance< LocalShellForceDoubleInstance, ForceOnShell > LocalForceOnShellDoubleInstance;
typedef boost::shared_ptr< LocalForceOnShellDoubleInstance > LocalForceOnShellDoublePtr;

/* Appliquer une pression à une coque/plaque */
/** @typedef PressureOnShellDouble  */
template class MechanicalLoadInstance< PressureDoubleInstance, ForceOnShell >;
typedef MechanicalLoadInstance< PressureDoubleInstance, ForceOnShell > PressureOnShellDoubleInstance;
typedef boost::shared_ptr< PressureOnShellDoubleInstance > PressureOnShellDoublePtr;

/* Appliquer une pression à un tuyau */
/** @typedef PressureOnPipeDouble  */
template class MechanicalLoadInstance< PressureDoubleInstance, PressureOnPipe >;
typedef MechanicalLoadInstance< PressureDoubleInstance, PressureOnPipe > PressureOnPipeDoubleInstance;
typedef boost::shared_ptr< PressureOnPipeDoubleInstance > PressureOnPipeDoublePtr;

/* Imposer un déplacement sur des noeuds */
/** @typedef ImposedDisplacementDouble  */
template class MechanicalLoadInstance< DisplacementDoubleInstance, ImposedDoF >;
typedef MechanicalLoadInstance< DisplacementDoubleInstance, ImposedDoF > ImposedDisplacementDoubleInstance;
typedef boost::shared_ptr< ImposedDisplacementDoubleInstance > ImposedDisplacementDoublePtr;

/* Imposer une pression sur des noeuds */
/** @typedef ImposedPressureDouble  */
template class MechanicalLoadInstance< PressureDoubleInstance, ImposedDoF >;
typedef MechanicalLoadInstance< PressureDoubleInstance, ImposedDoF > ImposedPressureDoubleInstance;
typedef boost::shared_ptr< ImposedPressureDoubleInstance > ImposedPressureDoublePtr;


/** @typedef DistributedPressureDouble  */
template class MechanicalLoadInstance< PressureDoubleInstance, DistributedPressure >;
typedef MechanicalLoadInstance< PressureDoubleInstance, DistributedPressure > DistributedPressureDoubleInstance;
typedef boost::shared_ptr< DistributedPressureDoubleInstance > DistributedPressureDoublePtr;

/** @typedef ImpedanceOnFaceDouble  */
template class MechanicalLoadInstance< ImpedanceDoubleInstance, ImpedanceOnFace >;
typedef MechanicalLoadInstance< ImpedanceDoubleInstance, ImpedanceOnFace > ImpedanceOnFaceDoubleInstance;
typedef boost::shared_ptr< ImpedanceOnFaceDoubleInstance > ImpedanceOnFaceDoublePtr;

/** @typedef NormalSpeedOnFaceDouble  */
template class MechanicalLoadInstance< NormalSpeedDoubleInstance, NormalSpeedOnFace >;
typedef MechanicalLoadInstance< NormalSpeedDoubleInstance, NormalSpeedOnFace > NormalSpeedOnFaceDoubleInstance;
typedef boost::shared_ptr< NormalSpeedOnFaceDoubleInstance > NormalSpeedOnFaceDoublePtr;

/** @typedef WavePressureOnFaceDouble  */
template class MechanicalLoadInstance< PressureDoubleInstance, WavePressureOnFace >;
typedef MechanicalLoadInstance< PressureDoubleInstance, WavePressureOnFace > WavePressureOnFaceDoubleInstance;
typedef boost::shared_ptr< WavePressureOnFaceDoubleInstance > WavePressureOnFaceDoublePtr;

/** @typedef DistributedHeatFluxDouble  */
template class MechanicalLoadInstance< HeatFluxDoubleInstance, THMFlux >;
typedef MechanicalLoadInstance< HeatFluxDoubleInstance, THMFlux > DistributedHeatFluxDoubleInstance;
typedef boost::shared_ptr< DistributedHeatFluxDoubleInstance > DistributedHeatFluxDoublePtr;

/** @typedef DistributedHydraulicFluxDouble  */
template class MechanicalLoadInstance< HydraulicFluxDoubleInstance, THMFlux >;
typedef MechanicalLoadInstance< HydraulicFluxDoubleInstance, THMFlux > DistributedHydraulicFluxDoubleInstance;
typedef boost::shared_ptr< DistributedHydraulicFluxDoubleInstance > DistributedHydraulicFluxDoublePtr;

/** @typedef std::list de MechanicalLoad */
typedef std::list< GenericMechanicalLoadPtr > ListMecaLoad;
/** @typedef Iterateur sur une std::list de MechanicalLoad */
typedef ListMecaLoad::iterator ListMecaLoadIter;
/** @typedef Iterateur constant sur une std::list de MechanicalLoad */
typedef ListMecaLoad::const_iterator ListMecaLoadCIter;

#endif /* MECHANICALLOAD_H_ */
