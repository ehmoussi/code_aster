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
#include <iostream>
#include <stdexcept>
#include <string>

#include "astercxx.h"
#include "aster_fort_superv.h"

#include "DataFields/ConstantFieldOnCells.h"
#include "DataFields/ListOfTables.h"
#include "DataStructures/DataStructure.h"
#include "Loads/PhysicalQuantity.h"
#include "Meshes/BaseMesh.h"
#include "Meshes/MeshEntities.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "Modeling/Model.h"
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
    static bool const isAllowedOnGroupOfCells = false;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
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
    static bool const isAllowedOnGroupOfCells = true;
    static bool const isAllowedOnGroupOfNodes = false;
};

/**
 * @class GenericMechanicalLoadClass
 * @brief Define a generic mechanical load
 * @author Nicolas Sellenet
 */
class GenericMechanicalLoadClass : public DataStructure, public ListOfTablesClass {
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
        ConstantFieldOnCellsRealPtr _cimpo;
        /** @brief Carte '.CMULT' */
        ConstantFieldOnCellsRealPtr _cmult;
        /** @brief Carte '.DPGEN' */
        ConstantFieldOnCellsRealPtr _dpgen;
        /** @brief Carte '.EPSIN' */
        ConstantFieldOnCellsRealPtr _epsin;
        /** @brief Carte '.F1D2D' */
        ConstantFieldOnCellsRealPtr _f1d2d;
        /** @brief Carte '.F1D3D' */
        ConstantFieldOnCellsRealPtr _f1d3d;
        /** @brief Carte '.F2D3D' */
        ConstantFieldOnCellsRealPtr _f2d3d;
        /** @brief Carte '.FCO2D' */
        ConstantFieldOnCellsRealPtr _fco2d;
        /** @brief Carte '.FCO3D' */
        ConstantFieldOnCellsRealPtr _fco3d;
        /** @brief Carte '.FELEC' */
        ConstantFieldOnCellsRealPtr _felec;
        /** @brief Carte '.FL101' */
        ConstantFieldOnCellsRealPtr _fl101;
        /** @brief Carte '.FL102' */
        ConstantFieldOnCellsRealPtr _fl102;
        /** @brief Carte '.FORNO' */
        ConstantFieldOnCellsRealPtr _forno;
        /** @brief Carte '.IMPE' */
        ConstantFieldOnCellsRealPtr _impe;
        /** @brief Carte '.PESAN' */
        ConstantFieldOnCellsRealPtr _pesan;
        /** @brief Carte '.PRESS' */
        ConstantFieldOnCellsRealPtr _press;
        /** @brief Carte '.ROTAT' */
        ConstantFieldOnCellsRealPtr _rotat;
        /** @brief Carte '.SIGIN' */
        ConstantFieldOnCellsRealPtr _sigin;
        /** @brief Carte '.SIINT' */
        ConstantFieldOnCellsRealPtr _siint;
        /** @brief Carte '.VNOR' */
        ConstantFieldOnCellsRealPtr _vnor;
        /** @brief Carte '.ONDPL' */
        ConstantFieldOnCellsRealPtr _ondpl;
        /** @brief Carte '.ONDPR' */
        ConstantFieldOnCellsRealPtr _ondpr;

        /** @brief Constructeur */
        MecaLoad( const std::string &name, const ModelPtr &currentModel )
            : _model( currentModel ), _mesh( _model->getMesh() ),
              _temperatureField( name + ".TEMPE.TEMP" ), _modelName( name + ".MODEL.NOMO" ),
              _nameOfAssemblyVector( name + ".VEASS" ), _veiss( name + ".VEISS" ),
              _evolChar( name + ".EVOL.CHAR" ),
              _FEDesc( new FiniteElementDescriptorClass( name + ".LIGRE", _mesh ) ),
              _cimpo( new ConstantFieldOnCellsRealClass( name + ".CIMPO", _FEDesc ) ),
              _cmult( new ConstantFieldOnCellsRealClass( name + ".CMULT", _FEDesc ) ),
              _dpgen( new ConstantFieldOnCellsRealClass( name + ".DPGEN", _FEDesc ) ),
              _epsin( new ConstantFieldOnCellsRealClass( name + ".EPSIN", _FEDesc ) ),
              _f1d2d( new ConstantFieldOnCellsRealClass( name + ".F1D2D", _FEDesc ) ),
              _f1d3d( new ConstantFieldOnCellsRealClass( name + ".F1D3D", _FEDesc ) ),
              _f2d3d( new ConstantFieldOnCellsRealClass( name + ".F2D3D", _FEDesc ) ),
              _fco2d( new ConstantFieldOnCellsRealClass( name + ".FCO2D", _FEDesc ) ),
              _fco3d( new ConstantFieldOnCellsRealClass( name + ".FCO3D", _FEDesc ) ),
              _felec( new ConstantFieldOnCellsRealClass( name + ".FELEC", _FEDesc ) ),
              _fl101( new ConstantFieldOnCellsRealClass( name + ".FL101", _FEDesc ) ),
              _fl102( new ConstantFieldOnCellsRealClass( name + ".FL102", _FEDesc ) ),
              _forno( new ConstantFieldOnCellsRealClass( name + ".FORNO", _FEDesc ) ),
              _impe( new ConstantFieldOnCellsRealClass( name + ".IMPE", _FEDesc ) ),
              _pesan( new ConstantFieldOnCellsRealClass( name + ".PESAN", _FEDesc ) ),
              _press( new ConstantFieldOnCellsRealClass( name + ".PRESS", _FEDesc ) ),
              _rotat( new ConstantFieldOnCellsRealClass( name + ".ROTAT", _FEDesc ) ),
              _sigin( new ConstantFieldOnCellsRealClass( name + ".SIGIN", _FEDesc ) ),
              _siint( new ConstantFieldOnCellsRealClass( name + ".SIINT", _FEDesc ) ),
              _vnor( new ConstantFieldOnCellsRealClass( name + ".VNOR", _FEDesc ) ),
              _ondpl( new ConstantFieldOnCellsRealClass( name + ".ONDPL", _FEDesc ) ),
              _ondpr( new ConstantFieldOnCellsRealClass( name + ".ONDPR", _FEDesc ) ){};
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
    JeveuxVectorReal _trans01;
    /** @brief Vecteur Jeveux '.TRANS02' */
    JeveuxVectorReal _trans02;
    /** @brief Vecteur Jeveux '.POIDS_MAILLE' */
    JeveuxVectorReal _poidsMaille;

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
        : DataStructure( name, 8, "CHAR_MECA" ),
          ListOfTablesClass( name ),
          _mecaLoad( getName() + ".CHME", currentModel ),
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

    virtual bool build(){ return false;};
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
     *        or group of cells)
     * @param physPtr shared pointer to a PhysicalQuantity
     * @param nameOfGroup name of the group of cells
     * @return bool success/failure index
     */
    bool setValue( PhysicalQuantityPtr physPtr, std::string nameOfGroup = "" ) {
        // Check that the pointer to the model is not empty
        if ( ( !_mecaLoad._model ) || _mecaLoad._model->isEmpty() )
            throw std::runtime_error( "Model is empty" );

        // Get the type of MeshEntity
        BaseMeshPtr currentMesh = _mecaLoad._model->getMesh();
        // If the MeshEntity is not given, the quantity is set on the whole mesh
        if ( nameOfGroup.size() == 0 && Traits::isAllowedOnWholeMesh ) {
            _meshEntity = MeshEntityPtr( new AllMeshEntities() );
        }
        // nameOfGroup is the name of a group of cells and
        // LoadTraits authorizes to base the current load on such a group
        else if ( currentMesh->hasGroupOfCells( nameOfGroup ) && Traits::isAllowedOnGroupOfCells ) {
            _meshEntity = MeshEntityPtr( new GroupOfCells( nameOfGroup ) );
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
            } else if ( _meshEntity->getType() == GroupOfCellsType )
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
        return update_tables();
    };
};

/**********************************************************/
/*  Explicit instantiation of template classes
/**********************************************************/

/** @typedef GenericMechanicalLoad  */
typedef boost::shared_ptr< GenericMechanicalLoadClass > GenericMechanicalLoadPtr;

/* Appliquer une force nodale sur une modélisation 3D */
/** @typedef NodalForceReal  */
template class MechanicalLoadClass< ForceRealClass, NodalForce >;
typedef MechanicalLoadClass< ForceRealClass, NodalForce > NodalForceRealClass;
typedef boost::shared_ptr< NodalForceRealClass > NodalForceRealPtr;

/* Appliquer une force nodale sur des éléments de structure */
/** @typedef NodalStructuralForceReal  */
template class MechanicalLoadClass< StructuralForceRealClass, NodalForce >;
typedef MechanicalLoadClass< StructuralForceRealClass, NodalForce > NodalStructuralForceRealClass;
typedef boost::shared_ptr< NodalStructuralForceRealClass > NodalStructuralForceRealPtr;

/** @typedef ForceOnFaceReal  */
template class MechanicalLoadClass< ForceRealClass, ForceOnFace >;
typedef MechanicalLoadClass< ForceRealClass, ForceOnFace > ForceOnFaceRealClass;
typedef boost::shared_ptr< ForceOnFaceRealClass > ForceOnFaceRealPtr;

/* Appliquer une force sur une arête d'élément volumique */
/** @typedef ForceOnEdgeReal  */
template class MechanicalLoadClass< ForceRealClass, ForceOnEdge >;
typedef MechanicalLoadClass< ForceRealClass, ForceOnEdge > ForceOnEdgeRealClass;
typedef boost::shared_ptr< ForceOnEdgeRealClass > ForceOnEdgeRealPtr;

/* Appliquer une force sur une arête d'élément de structure (coque/plaque) */
/** @typedef StructuralForceOnEdgeReal  */
template class MechanicalLoadClass< StructuralForceRealClass, ForceOnEdge >;
typedef MechanicalLoadClass< StructuralForceRealClass, ForceOnEdge > StructuralForceOnEdgeRealClass;
typedef boost::shared_ptr< StructuralForceOnEdgeRealClass > StructuralForceOnEdgeRealPtr;

/** @typedef LineicForceReal  */
template class MechanicalLoadClass< ForceRealClass, LineicForce >;
typedef MechanicalLoadClass< ForceRealClass, LineicForce > LineicForceRealClass;
typedef boost::shared_ptr< LineicForceRealClass > LineicForceRealPtr;

/** @typedef InternalForceReal  */
template class MechanicalLoadClass< ForceRealClass, InternalForce >;
typedef MechanicalLoadClass< ForceRealClass, InternalForce > InternalForceRealClass;
typedef boost::shared_ptr< InternalForceRealClass > InternalForceRealPtr;

/* Appliquer une force (définie dans le repère global) à une poutre */
/** @typedef StructuralForceOnBeamReal  */
template class MechanicalLoadClass< StructuralForceRealClass, ForceOnBeam >;
typedef MechanicalLoadClass< StructuralForceRealClass, ForceOnBeam > StructuralForceOnBeamRealClass;
typedef boost::shared_ptr< StructuralForceOnBeamRealClass > StructuralForceOnBeamRealPtr;

/* Appliquer une force (définie dans le repère local) à une poutre */
/** @typedef LocalForceOnBeamReal  */
template class MechanicalLoadClass< LocalBeamForceRealClass, ForceOnBeam >;
typedef MechanicalLoadClass< LocalBeamForceRealClass, ForceOnBeam > LocalForceOnBeamRealClass;
typedef boost::shared_ptr< LocalForceOnBeamRealClass > LocalForceOnBeamRealPtr;

/* Appliquer une force (définie dans le repère global) à une coque/plaque */
/** @typedef StructuralForceOnShellReal  */
template class MechanicalLoadClass< StructuralForceRealClass, ForceOnShell >;
typedef MechanicalLoadClass< StructuralForceRealClass, ForceOnShell >
    StructuralForceOnShellRealClass;
typedef boost::shared_ptr< StructuralForceOnShellRealClass > StructuralForceOnShellRealPtr;

/* Appliquer une force (définie dans le repère local) à une coque/plaque */
/** @typedef LocalForceOnShellReal  */
template class MechanicalLoadClass< LocalShellForceRealClass, ForceOnShell >;
typedef MechanicalLoadClass< LocalShellForceRealClass, ForceOnShell > LocalForceOnShellRealClass;
typedef boost::shared_ptr< LocalForceOnShellRealClass > LocalForceOnShellRealPtr;

/* Appliquer une pression à une coque/plaque */
/** @typedef PressureOnShellReal  */
template class MechanicalLoadClass< PressureRealClass, ForceOnShell >;
typedef MechanicalLoadClass< PressureRealClass, ForceOnShell > PressureOnShellRealClass;
typedef boost::shared_ptr< PressureOnShellRealClass > PressureOnShellRealPtr;

/* Appliquer une pression à un tuyau */
/** @typedef PressureOnPipeReal  */
template class MechanicalLoadClass< PressureRealClass, PressureOnPipe >;
typedef MechanicalLoadClass< PressureRealClass, PressureOnPipe > PressureOnPipeRealClass;
typedef boost::shared_ptr< PressureOnPipeRealClass > PressureOnPipeRealPtr;

/* Imposer un déplacement sur des noeuds */
/** @typedef ImposedDisplacementReal  */
template class MechanicalLoadClass< DisplacementRealClass, ImposedDoF >;
typedef MechanicalLoadClass< DisplacementRealClass, ImposedDoF > ImposedDisplacementRealClass;
typedef boost::shared_ptr< ImposedDisplacementRealClass > ImposedDisplacementRealPtr;

/* Imposer une pression sur des noeuds */
/** @typedef ImposedPressureReal  */
template class MechanicalLoadClass< PressureRealClass, ImposedDoF >;
typedef MechanicalLoadClass< PressureRealClass, ImposedDoF > ImposedPressureRealClass;
typedef boost::shared_ptr< ImposedPressureRealClass > ImposedPressureRealPtr;

/** @typedef DistributedPressureReal  */
template class MechanicalLoadClass< PressureRealClass, DistributedPressure >;
typedef MechanicalLoadClass< PressureRealClass, DistributedPressure > DistributedPressureRealClass;
typedef boost::shared_ptr< DistributedPressureRealClass > DistributedPressureRealPtr;

/** @typedef ImpedanceOnFaceReal  */
template class MechanicalLoadClass< ImpedanceRealClass, ImpedanceOnFace >;
typedef MechanicalLoadClass< ImpedanceRealClass, ImpedanceOnFace > ImpedanceOnFaceRealClass;
typedef boost::shared_ptr< ImpedanceOnFaceRealClass > ImpedanceOnFaceRealPtr;

/** @typedef NormalSpeedOnFaceReal  */
template class MechanicalLoadClass< NormalSpeedRealClass, NormalSpeedOnFace >;
typedef MechanicalLoadClass< NormalSpeedRealClass, NormalSpeedOnFace > NormalSpeedOnFaceRealClass;
typedef boost::shared_ptr< NormalSpeedOnFaceRealClass > NormalSpeedOnFaceRealPtr;

/** @typedef WavePressureOnFaceReal  */
template class MechanicalLoadClass< PressureRealClass, WavePressureOnFace >;
typedef MechanicalLoadClass< PressureRealClass, WavePressureOnFace > WavePressureOnFaceRealClass;
typedef boost::shared_ptr< WavePressureOnFaceRealClass > WavePressureOnFaceRealPtr;

/** @typedef DistributedHeatFluxReal  */
template class MechanicalLoadClass< HeatFluxRealClass, THMFlux >;
typedef MechanicalLoadClass< HeatFluxRealClass, THMFlux > DistributedHeatFluxRealClass;
typedef boost::shared_ptr< DistributedHeatFluxRealClass > DistributedHeatFluxRealPtr;

/** @typedef DistributedHydraulicFluxReal  */
template class MechanicalLoadClass< HydraulicFluxRealClass, THMFlux >;
typedef MechanicalLoadClass< HydraulicFluxRealClass, THMFlux > DistributedHydraulicFluxRealClass;
typedef boost::shared_ptr< DistributedHydraulicFluxRealClass > DistributedHydraulicFluxRealPtr;

/** @typedef std::list de MechanicalLoad */
typedef std::list< GenericMechanicalLoadPtr > ListMecaLoad;
/** @typedef Iterateur sur une std::list de MechanicalLoad */
typedef ListMecaLoad::iterator ListMecaLoadIter;
/** @typedef Iterateur constant sur une std::list de MechanicalLoad */
typedef ListMecaLoad::const_iterator ListMecaLoadCIter;

#endif /* MECHANICALLOAD_H_ */
