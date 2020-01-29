#ifndef MECHANICALLOAD_H_
#define MECHANICALLOAD_H_

/**
 * @file MechanicalLoad.h
 * @author Natacha Bereux
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

#include "DataFields/PCFieldOnMesh.h"
#include "DataStructures/DataStructure.h"
#include "Loads/PhysicalQuantity.h"
#include "Meshes/MeshEntities.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Modeling/Model.h"
#include "astercxx.h"
#include <iostream>
#include <stdexcept>
#include <string>

#include "Supervis/CommandSyntax.h"
#include "Supervis/ResultNaming.h"

/**
 * @enum LoadEnum
 * @brief Inventory of all mechanical loads available in Code_Aster
 */
enum LoadEnum {
    NodalForce,
    ForceOnEdge,
    ForceOnFace,
    LineicForce,
    InternalForce,
    ForceOnBeam,
    ForceOnShell,
    PressureOnPipe,
    ImposedDoF,
    DistributedPressure,
    ImpedanceOnFace,
    NormalSpeedOnFace,
    WavePressureOnFace,
    THMFlux
};

/**
 * @class LoadTraits
 * @brief Traits class for a Load
 */
// This is the most general case (defined but intentionally not implemented)
// It will be specialized for each load listed in the inventory

template < LoadEnum Load > struct LoadTraits;

/*************************************************************/
/*  Loads consisting of a force applied to some localization */
/*************************************************************/
/**
 * @def LoadTraits<NodalForce>
 * @brief Declare specialization for NodalForce
 */
template <> struct LoadTraits< NodalForce > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = false;
    static bool const isAllowedOnGroupOfNodes = true;
};

/**
 * @def LoadTraits<ForceOnFace>
 * @brief Declare specialization for ForceOnFace
 */
template <> struct LoadTraits< ForceOnFace > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ForceOnEdge>
 * @brief Declare specialization for ForceOnEdge
 */
template <> struct LoadTraits< ForceOnEdge > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<LineicForce>
 * @brief Declare specialization for LineicForce
 */
template <> struct LoadTraits< LineicForce > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<InternalForce>
 * @brief Declare specialization for InternalForce
 */
template <> struct LoadTraits< InternalForce > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ForceOnBeam>
 * @brief Declare specialization for ForceOnBeam
 */
template <> struct LoadTraits< ForceOnBeam > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
    /** @todo mot clé supplémentaire TYPE_CHARGE=FORCE */
};

/**
 * @def LoadTraits<ForceOnShell>
 * @brief Declare specialization for ForceOnShell
 */
template <> struct LoadTraits< ForceOnShell > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<PressureOnPipe>
 * @brief Declare specialization for PressureOnPipe
 */
template <> struct LoadTraits< PressureOnPipe > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ImposedDoF>
 * @brief Declare specialization for ImposedDoF
 */
template <> struct LoadTraits< ImposedDoF > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = true;
};

/**
 * @def LoadTraits<DistributedPressure>
 * @brief Declare specialization for DistributedPressure
 */
template <> struct LoadTraits< DistributedPressure > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<ImpedanceOnFace>
 * @brief Declare specialization for ImpedanceOnFace
 */
template <> struct LoadTraits< ImpedanceOnFace > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<NormalSpeedOnFace>
 * @brief Declare specialization for NormalSpeedOnFace
 */
template <> struct LoadTraits< NormalSpeedOnFace > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<WavePressureOnFace>
 * @brief Declare specialization for WavePressureOnFace
 */
template <> struct LoadTraits< WavePressureOnFace > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = false;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @def LoadTraits<THMFlux>
 * @brief Declare specialization for THMFlux
 */
template <> struct LoadTraits< THMFlux > {
    // Mot clé facteur pour AFFE_CHAR_MECA
    static const std::string factorKeyword;
    // Authorized MeshEntity
    static bool const isAllowedOnWholeMesh = true;
    static bool const isAllowedOnGroupOfElements = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @class GenericMechanicalLoadClass
 * @brief Define a generic mechanical load
 * @author Nicolas Sellenet
 */
class GenericMechanicalLoadClass : public DataStructure {
  public:
    struct MecaLoad {
        /** @brief Modele */
        ModelPtr _model;
        /** @brief mesh */
        BaseMeshPtr _mesh;
        /** @brief Vecteur Jeveux '.TEMPE.TEMP' */
        JeveuxVectorChar8 _temperatureField;
        /** @brief Vecteur Jeveux '.MODEL.NOMO' */
        JeveuxVectorChar8 _modelName;
        /** @brief Vecteur Jeveux '.VEASS' */
        JeveuxVectorChar8 _nameOfAssemblyVector;
        /** @brief Vecteur Jeveux '.VEISS' */
        JeveuxVectorChar8 _veiss;
        /** @brief Vecteur Jeveux '.EVOL.CHAR' */
        JeveuxVectorChar8 _evolChar;
        /** @brief Vecteur Jeveux '.LIGRE' */
        FiniteElementDescriptorPtr _FEDesc;
        /** @brief Carte '.CIMPO' */
        PCFieldOnMeshDoublePtr _cimpo;
        /** @brief Carte '.CMULT' */
        PCFieldOnMeshDoublePtr _cmult;
        /** @brief Carte '.DPGEN' */
        PCFieldOnMeshDoublePtr _dpgen;
        /** @brief Carte '.EPSIN' */
        PCFieldOnMeshDoublePtr _epsin;
        /** @brief Carte '.F1D2D' */
        PCFieldOnMeshDoublePtr _f1d2d;
        /** @brief Carte '.F1D3D' */
        PCFieldOnMeshDoublePtr _f1d3d;
        /** @brief Carte '.F2D3D' */
        PCFieldOnMeshDoublePtr _f2d3d;
        /** @brief Carte '.FCO2D' */
        PCFieldOnMeshDoublePtr _fco2d;
        /** @brief Carte '.FCO3D' */
        PCFieldOnMeshDoublePtr _fco3d;
        /** @brief Carte '.FELEC' */
        PCFieldOnMeshDoublePtr _felec;
        /** @brief Carte '.FL101' */
        PCFieldOnMeshDoublePtr _fl101;
        /** @brief Carte '.FL102' */
        PCFieldOnMeshDoublePtr _fl102;
        /** @brief Carte '.FORNO' */
        PCFieldOnMeshDoublePtr _forno;
        /** @brief Carte '.IMPE' */
        PCFieldOnMeshDoublePtr _impe;
        /** @brief Carte '.PESAN' */
        PCFieldOnMeshDoublePtr _pesan;
        /** @brief Carte '.PRESS' */
        PCFieldOnMeshDoublePtr _press;
        /** @brief Carte '.ROTAT' */
        PCFieldOnMeshDoublePtr _rotat;
        /** @brief Carte '.SIGIN' */
        PCFieldOnMeshDoublePtr _sigin;
        /** @brief Carte '.SIINT' */
        PCFieldOnMeshDoublePtr _siint;
        /** @brief Carte '.VNOR' */
        PCFieldOnMeshDoublePtr _vnor;
        /** @brief Carte '.ONDPL' */
        PCFieldOnMeshDoublePtr _ondpl;
        /** @brief Carte '.ONDPR' */
        PCFieldOnMeshDoublePtr _ondpr;

        /** @brief Constructeur */
        MecaLoad( const std::string &name, const ModelPtr &currentModel )
            : _model( currentModel ), _mesh( _model->getMesh() ),
              _temperatureField( name + ".TEMPE.TEMP" ), _modelName( name + ".MODEL.NOMO" ),
              _nameOfAssemblyVector( name + ".VEASS" ), _veiss( name + ".VEISS" ),
              _evolChar( name + ".EVOL.CHAR" ),
              _FEDesc( new FiniteElementDescriptorClass( name + ".LIGRE", _mesh ) ),
              _cimpo( new PCFieldOnMeshDoubleClass( name + ".CIMPO", _FEDesc ) ),
              _cmult( new PCFieldOnMeshDoubleClass( name + ".CMULT", _FEDesc ) ),
              _dpgen( new PCFieldOnMeshDoubleClass( name + ".DPGEN", _FEDesc ) ),
              _epsin( new PCFieldOnMeshDoubleClass( name + ".EPSIN", _FEDesc ) ),
              _f1d2d( new PCFieldOnMeshDoubleClass( name + ".F1D2D", _FEDesc ) ),
              _f1d3d( new PCFieldOnMeshDoubleClass( name + ".F1D3D", _FEDesc ) ),
              _f2d3d( new PCFieldOnMeshDoubleClass( name + ".F2D3D", _FEDesc ) ),
              _fco2d( new PCFieldOnMeshDoubleClass( name + ".FCO2D", _FEDesc ) ),
              _fco3d( new PCFieldOnMeshDoubleClass( name + ".FCO3D", _FEDesc ) ),
              _felec( new PCFieldOnMeshDoubleClass( name + ".FELEC", _FEDesc ) ),
              _fl101( new PCFieldOnMeshDoubleClass( name + ".FL101", _FEDesc ) ),
              _fl102( new PCFieldOnMeshDoubleClass( name + ".FL102", _FEDesc ) ),
              _forno( new PCFieldOnMeshDoubleClass( name + ".FORNO", _FEDesc ) ),
              _impe( new PCFieldOnMeshDoubleClass( name + ".IMPE", _FEDesc ) ),
              _pesan( new PCFieldOnMeshDoubleClass( name + ".PESAN", _FEDesc ) ),
              _press( new PCFieldOnMeshDoubleClass( name + ".PRESS", _FEDesc ) ),
              _rotat( new PCFieldOnMeshDoubleClass( name + ".ROTAT", _FEDesc ) ),
              _sigin( new PCFieldOnMeshDoubleClass( name + ".SIGIN", _FEDesc ) ),
              _siint( new PCFieldOnMeshDoubleClass( name + ".SIINT", _FEDesc ) ),
              _vnor( new PCFieldOnMeshDoubleClass( name + ".VNOR", _FEDesc ) ),
              _ondpl( new PCFieldOnMeshDoubleClass( name + ".ONDPL", _FEDesc ) ),
              _ondpr( new PCFieldOnMeshDoubleClass( name + ".ONDPR", _FEDesc ) ){};
    };

  protected:
    /** @typedef Definition d'un pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;

    /** @brief MeshEntity sur laquelle repose le "blocage" */
    MeshEntityPtr _meshEntity;
    MecaLoad _mecaLoad;
    /** @brief Vecteur Jeveux '.TYPE' */
    JeveuxVectorChar8 _type;
    /** @brief Vecteur Jeveux '.LISMA01' */
    JeveuxVectorLong _lisma01;
    /** @brief Vecteur Jeveux '.LISMA02' */
    JeveuxVectorLong _lisma02;
    /** @brief Vecteur Jeveux '.TRANS01' */
    JeveuxVectorDouble _trans01;
    /** @brief Vecteur Jeveux '.TRANS02' */
    JeveuxVectorDouble _trans02;
    /** @brief Vecteur Jeveux '.POIDS_MAILLE' */
    JeveuxVectorDouble _poidsMaille;

  public:
    /**
     * @typedef MechanicalLoadPtr
     * @brief Pointeur intelligent vers un MechanicalLoad
     */
    typedef boost::shared_ptr< GenericMechanicalLoadClass > GenericMechanicalLoadPtr;

    /**
     * @brief Constructor
     */
    GenericMechanicalLoadClass( const ModelPtr &currentModel )
        : GenericMechanicalLoadClass( ResultNaming::getNewResultName(), currentModel ){};

    /**
     * @brief Constructor
     */
    GenericMechanicalLoadClass( const std::string name, const ModelPtr &currentModel )
        : DataStructure( name, 8, "CHAR_MECA" ), _mecaLoad( getName() + ".CHME", currentModel ),
          _type( getName() + ".TYPE" ), _lisma01( getName() + ".LISMA01" ),
          _lisma02( getName() + ".LISMA02" ), _trans01( getName() + ".TRANS01" ),
          _trans02( getName() + ".TRANS02" ), _poidsMaille( getName() + ".POIDS_MAILLE" ){};

    /**
     * @brief Destructor
     */
    ~GenericMechanicalLoadClass(){};

    /**
     * @brief Get the finite element descriptor
     */
    FiniteElementDescriptorPtr getFiniteElementDescriptor() const { return _mecaLoad._FEDesc; };

    /**
     * @brief Get the model
     */
    const MecaLoad &getMechanicalLoadDescription() const { return _mecaLoad; };

    /**
     * @brief Get the model
     */
    const ModelPtr &getModel() const {
        if ( ( !_mecaLoad._model ) || _mecaLoad._model->isEmpty() )
            throw std::runtime_error( "Model of current load is empty" );
        return _mecaLoad._model;
    };

    virtual bool build(){};
};

/**
 * @class MechanicalLoadClass
 * @brief Define a mechanical load
 * @author Natacha Bereux
 */
template < class PhysicalQuantity, LoadEnum Load >
class MechanicalLoadClass : public GenericMechanicalLoadClass {
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
     * @typedef MechanicalLoadPtr
     * @brief Pointeur intelligent vers un MechanicalLoad
     */
    typedef boost::shared_ptr< MechanicalLoadClass< PhysicalQuantity, Load > > MechanicalLoadPtr;

    /**
     * @brief Constructor
     */
    MechanicalLoadClass( const ModelPtr &model ) : GenericMechanicalLoadClass( model ){};

    /**
     * @brief Constructor
     */
    MechanicalLoadClass( const std::string name, const ModelPtr &model )
        : GenericMechanicalLoadClass( name, model ){};

    /**
     * @brief Destructor
     */
    ~MechanicalLoadClass(){};

    /**
     * @brief Set a physical quantity on a MeshEntity (group of nodes
     *        or group of elements)
     * @param physPtr shared pointer to a PhysicalQuantity
     * @param nameOfGroup name of the group of elements
     * @return bool success/failure index
     */
    bool setValue( PhysicalQuantityPtr physPtr,
                   std::string nameOfGroup = "" ) {
        // Check that the pointer to the model is not empty
        if ( ( !_mecaLoad._model ) || _mecaLoad._model->isEmpty() )
            throw std::runtime_error( "Model is empty" );

        // Get the type of MeshEntity
        BaseMeshPtr currentMesh = _mecaLoad._model->getMesh();
        // If the MeshEntity is not given, the quantity is set on the whole mesh
        if ( nameOfGroup.size() == 0 && Traits::isAllowedOnWholeMesh ) {
            _meshEntity = MeshEntityPtr( new AllMeshEntities() );
        }
        // nameOfGroup is the name of a group of elements and
        // LoadTraits authorizes to base the current load on such a group
        else if ( currentMesh->hasGroupOfElements( nameOfGroup ) &&
                  Traits::isAllowedOnGroupOfElements ) {
            _meshEntity = MeshEntityPtr( new GroupOfElements( nameOfGroup ) );
        }
        // nameOfGroup is the name of a group of nodes and LoadTraits authorizes
        // to base the current load on such a group
        else if ( currentMesh->hasGroupOfNodes( nameOfGroup ) && Traits::isAllowedOnGroupOfNodes ) {
            _meshEntity = MeshEntityPtr( new GroupOfNodes( nameOfGroup ) );
        } else
            throw std::runtime_error(
                nameOfGroup + " does not exist in the mesh " +
                "or it is not authorized as a localization of the current load " );

        // Copy the shared pointer of the Physical Quantity
        _physicalQuantity = physPtr;
        return true;
    };

    /**
     * @brief appel de op0007
     */
    bool build() {
        // std::cout << " build " << std::endl;
        CommandSyntax cmdSt( "AFFE_CHAR_MECA" );
        cmdSt.setResult( ResultNaming::getCurrentName(), "CHAR_MECA" );

        SyntaxMapContainer dict;
        if ( !_mecaLoad._model )
            throw std::runtime_error( "Model is undefined" );
        dict.container["MODELE"] = _mecaLoad._model->getName();
        ListSyntaxMapContainer listeLoad;
        SyntaxMapContainer dict2;
        /* On itere sur les composantes de la "PhysicalQuantity" */
        typename PhysicalQuantityType::MapOfCompAndVal comp_val = _physicalQuantity->getMap();
        for ( typename PhysicalQuantityType::MapIt curIter( comp_val.begin() );
              curIter != comp_val.end(); ++curIter ) {
            const auto &tmp = ComponentNames.find( curIter->first );
            dict2.container[tmp->second] = curIter->second;
        }
        /* Caractéristiques du MeshEntity */
        if ( _meshEntity->getType() == AllMeshEntitiesType ) {
            dict2.container["TOUT"] = "OUI";
        } else {
            if ( _meshEntity->getType() == GroupOfNodesType ) {
                dict2.container["GROUP_NO"] = _meshEntity->getName();
                //        std::cout << "GROUP_NO " <<  _meshEntity->getName() << std::endl;
            } else if ( _meshEntity->getType() == GroupOfElementsType )
                dict2.container["GROUP_MA"] = _meshEntity->getName();
        }
        listeLoad.push_back( dict2 );
        // mot-clé facteur
        std::string kw = Traits::factorKeyword;
        dict.container[kw] = listeLoad;
        cmdSt.define( dict );
        // cmdSt.debugPrint();
        try {
            ASTERINTEGER op = 7;
            CALL_EXECOP( &op );
        } catch ( ... ) {
            throw;
        }
        return true;
    };
};

/**********************************************************/
/*  Explicit instantiation of template classes
/**********************************************************/

/** @typedef GenericMechanicalLoad  */
typedef boost::shared_ptr< GenericMechanicalLoadClass > GenericMechanicalLoadPtr;

/* Appliquer une force nodale sur une modélisation 3D */
/** @typedef NodalForceDouble  */
template class MechanicalLoadClass< ForceDoubleClass, NodalForce >;
typedef MechanicalLoadClass< ForceDoubleClass, NodalForce > NodalForceDoubleClass;
typedef boost::shared_ptr< NodalForceDoubleClass > NodalForceDoublePtr;

/* Appliquer une force nodale sur des éléments de structure */
/** @typedef NodalStructuralForceDouble  */
template class MechanicalLoadClass< StructuralForceDoubleClass, NodalForce >;
typedef MechanicalLoadClass< StructuralForceDoubleClass, NodalForce >
    NodalStructuralForceDoubleClass;
typedef boost::shared_ptr< NodalStructuralForceDoubleClass > NodalStructuralForceDoublePtr;

/** @typedef ForceOnFaceDouble  */
template class MechanicalLoadClass< ForceDoubleClass, ForceOnFace >;
typedef MechanicalLoadClass< ForceDoubleClass, ForceOnFace > ForceOnFaceDoubleClass;
typedef boost::shared_ptr< ForceOnFaceDoubleClass > ForceOnFaceDoublePtr;

/* Appliquer une force sur une arête d'élément volumique */
/** @typedef ForceOnEdgeDouble  */
template class MechanicalLoadClass< ForceDoubleClass, ForceOnEdge >;
typedef MechanicalLoadClass< ForceDoubleClass, ForceOnEdge > ForceOnEdgeDoubleClass;
typedef boost::shared_ptr< ForceOnEdgeDoubleClass > ForceOnEdgeDoublePtr;

/* Appliquer une force sur une arête d'élément de structure (coque/plaque) */
/** @typedef StructuralForceOnEdgeDouble  */
template class MechanicalLoadClass< StructuralForceDoubleClass, ForceOnEdge >;
typedef MechanicalLoadClass< StructuralForceDoubleClass, ForceOnEdge >
    StructuralForceOnEdgeDoubleClass;
typedef boost::shared_ptr< StructuralForceOnEdgeDoubleClass > StructuralForceOnEdgeDoublePtr;

/** @typedef LineicForceDouble  */
template class MechanicalLoadClass< ForceDoubleClass, LineicForce >;
typedef MechanicalLoadClass< ForceDoubleClass, LineicForce > LineicForceDoubleClass;
typedef boost::shared_ptr< LineicForceDoubleClass > LineicForceDoublePtr;

/** @typedef InternalForceDouble  */
template class MechanicalLoadClass< ForceDoubleClass, InternalForce >;
typedef MechanicalLoadClass< ForceDoubleClass, InternalForce > InternalForceDoubleClass;
typedef boost::shared_ptr< InternalForceDoubleClass > InternalForceDoublePtr;

/* Appliquer une force (définie dans le repère global) à une poutre */
/** @typedef StructuralForceOnBeamDouble  */
template class MechanicalLoadClass< StructuralForceDoubleClass, ForceOnBeam >;
typedef MechanicalLoadClass< StructuralForceDoubleClass, ForceOnBeam >
    StructuralForceOnBeamDoubleClass;
typedef boost::shared_ptr< StructuralForceOnBeamDoubleClass > StructuralForceOnBeamDoublePtr;

/* Appliquer une force (définie dans le repère local) à une poutre */
/** @typedef LocalForceOnBeamDouble  */
template class MechanicalLoadClass< LocalBeamForceDoubleClass, ForceOnBeam >;
typedef MechanicalLoadClass< LocalBeamForceDoubleClass, ForceOnBeam >
    LocalForceOnBeamDoubleClass;
typedef boost::shared_ptr< LocalForceOnBeamDoubleClass > LocalForceOnBeamDoublePtr;

/* Appliquer une force (définie dans le repère global) à une coque/plaque */
/** @typedef StructuralForceOnShellDouble  */
template class MechanicalLoadClass< StructuralForceDoubleClass, ForceOnShell >;
typedef MechanicalLoadClass< StructuralForceDoubleClass, ForceOnShell >
    StructuralForceOnShellDoubleClass;
typedef boost::shared_ptr< StructuralForceOnShellDoubleClass > StructuralForceOnShellDoublePtr;

/* Appliquer une force (définie dans le repère local) à une coque/plaque */
/** @typedef LocalForceOnShellDouble  */
template class MechanicalLoadClass< LocalShellForceDoubleClass, ForceOnShell >;
typedef MechanicalLoadClass< LocalShellForceDoubleClass, ForceOnShell >
    LocalForceOnShellDoubleClass;
typedef boost::shared_ptr< LocalForceOnShellDoubleClass > LocalForceOnShellDoublePtr;

/* Appliquer une pression à une coque/plaque */
/** @typedef PressureOnShellDouble  */
template class MechanicalLoadClass< PressureDoubleClass, ForceOnShell >;
typedef MechanicalLoadClass< PressureDoubleClass, ForceOnShell >
    PressureOnShellDoubleClass;
typedef boost::shared_ptr< PressureOnShellDoubleClass > PressureOnShellDoublePtr;

/* Appliquer une pression à un tuyau */
/** @typedef PressureOnPipeDouble  */
template class MechanicalLoadClass< PressureDoubleClass, PressureOnPipe >;
typedef MechanicalLoadClass< PressureDoubleClass, PressureOnPipe >
    PressureOnPipeDoubleClass;
typedef boost::shared_ptr< PressureOnPipeDoubleClass > PressureOnPipeDoublePtr;

/* Imposer un déplacement sur des noeuds */
/** @typedef ImposedDisplacementDouble  */
template class MechanicalLoadClass< DisplacementDoubleClass, ImposedDoF >;
typedef MechanicalLoadClass< DisplacementDoubleClass, ImposedDoF >
    ImposedDisplacementDoubleClass;
typedef boost::shared_ptr< ImposedDisplacementDoubleClass > ImposedDisplacementDoublePtr;

/* Imposer une pression sur des noeuds */
/** @typedef ImposedPressureDouble  */
template class MechanicalLoadClass< PressureDoubleClass, ImposedDoF >;
typedef MechanicalLoadClass< PressureDoubleClass, ImposedDoF > ImposedPressureDoubleClass;
typedef boost::shared_ptr< ImposedPressureDoubleClass > ImposedPressureDoublePtr;

/** @typedef DistributedPressureDouble  */
template class MechanicalLoadClass< PressureDoubleClass, DistributedPressure >;
typedef MechanicalLoadClass< PressureDoubleClass, DistributedPressure >
    DistributedPressureDoubleClass;
typedef boost::shared_ptr< DistributedPressureDoubleClass > DistributedPressureDoublePtr;

/** @typedef ImpedanceOnFaceDouble  */
template class MechanicalLoadClass< ImpedanceDoubleClass, ImpedanceOnFace >;
typedef MechanicalLoadClass< ImpedanceDoubleClass, ImpedanceOnFace >
    ImpedanceOnFaceDoubleClass;
typedef boost::shared_ptr< ImpedanceOnFaceDoubleClass > ImpedanceOnFaceDoublePtr;

/** @typedef NormalSpeedOnFaceDouble  */
template class MechanicalLoadClass< NormalSpeedDoubleClass, NormalSpeedOnFace >;
typedef MechanicalLoadClass< NormalSpeedDoubleClass, NormalSpeedOnFace >
    NormalSpeedOnFaceDoubleClass;
typedef boost::shared_ptr< NormalSpeedOnFaceDoubleClass > NormalSpeedOnFaceDoublePtr;

/** @typedef WavePressureOnFaceDouble  */
template class MechanicalLoadClass< PressureDoubleClass, WavePressureOnFace >;
typedef MechanicalLoadClass< PressureDoubleClass, WavePressureOnFace >
    WavePressureOnFaceDoubleClass;
typedef boost::shared_ptr< WavePressureOnFaceDoubleClass > WavePressureOnFaceDoublePtr;

/** @typedef DistributedHeatFluxDouble  */
template class MechanicalLoadClass< HeatFluxDoubleClass, THMFlux >;
typedef MechanicalLoadClass< HeatFluxDoubleClass, THMFlux > DistributedHeatFluxDoubleClass;
typedef boost::shared_ptr< DistributedHeatFluxDoubleClass > DistributedHeatFluxDoublePtr;

/** @typedef DistributedHydraulicFluxDouble  */
template class MechanicalLoadClass< HydraulicFluxDoubleClass, THMFlux >;
typedef MechanicalLoadClass< HydraulicFluxDoubleClass, THMFlux >
    DistributedHydraulicFluxDoubleClass;
typedef boost::shared_ptr< DistributedHydraulicFluxDoubleClass >
    DistributedHydraulicFluxDoublePtr;

/** @typedef std::list de MechanicalLoad */
typedef std::list< GenericMechanicalLoadPtr > ListMecaLoad;
/** @typedef Iterateur sur une std::list de MechanicalLoad */
typedef ListMecaLoad::iterator ListMecaLoadIter;
/** @typedef Iterateur constant sur une std::list de MechanicalLoad */
typedef ListMecaLoad::const_iterator ListMecaLoadCIter;

#endif /* MECHANICALLOAD_H_ */
