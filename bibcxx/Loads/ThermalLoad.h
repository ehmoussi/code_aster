#ifndef THERMALLOAD_H_
#define THERMALLOAD_H_

/**
 * @file ThermalLoad.h
 * @brief Fichier entete de la classe ThermalLoad
 * @author Jean-Pierre Lefebvre
 * @section LICENCE
 *   Copyright (C) 1991 - 2019  EDF R&D                www.code-aster.org
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
#include "Loads/UnitaryThermalLoad.h"
#include "Utilities/CapyConvertibleValue.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "DataFields/PCFieldOnMesh.h"

/**
 * @class ThermalLoadInstance
 * @brief Classe definissant une charge thermique (issue d'AFFE_CHAR_THER)
 * @author Jean-Pierre Lefebvre
 */
class ThermalLoadInstance : public DataStructure {
  private:
    struct TherLoad {
        /** @brief Modèle support */
        ModelPtr _supportModel;
        /** @brief support mesh */
        BaseMeshPtr _mesh;
        /** @brief Vecteur Jeveux '.MODEL.NOMO' */
        JeveuxVectorChar8 _modelName;
        /** @brief Vecteur Jeveux '.CONVE.VALE' */
        JeveuxVectorChar8 _convection;
        /** @brief Vecteur Jeveux '.LIGRE' */
        FiniteElementDescriptorPtr _FEDesc;
        /** @brief Carte '.CIMPO' */
        PCFieldOnMeshDoublePtr _cimpo;
        /** @brief Carte '.CMULT' */
        PCFieldOnMeshDoublePtr _cmult;
        /** @brief Carte '.COEFH' */
        PCFieldOnMeshDoublePtr _coefh;
        /** @brief Carte '.FLUNL' */
        PCFieldOnMeshDoublePtr _flunl;
        /** @brief Carte '.FLURE' */
        PCFieldOnMeshDoublePtr _flure;
        /** @brief Carte '.GRAIN' */
        PCFieldOnMeshDoublePtr _grain;
        /** @brief Carte '.HECHP' */
        PCFieldOnMeshDoublePtr _hechp;
        /** @brief Carte '.SOURE' */
        PCFieldOnMeshDoublePtr _soure;
        /** @brief Carte '.T_EXT' */
        PCFieldOnMeshDoublePtr _tExt;

        /** @brief Constructeur */
        TherLoad( const std::string &name, const ModelPtr &currentModel )
            : _supportModel( currentModel ), _mesh( _supportModel->getSupportMesh() ),
              _modelName( name + ".MODEL.NOMO" ), _convection( name + ".CONVE.VALE" ),
              _FEDesc( new FiniteElementDescriptorInstance( name + ".LIGRE", _mesh ) ),
              _cimpo( new PCFieldOnMeshDoubleInstance( name + ".CIMPO", _FEDesc ) ),
              _cmult( new PCFieldOnMeshDoubleInstance( name + ".CMULT", _FEDesc ) ),
              _coefh( new PCFieldOnMeshDoubleInstance( name + ".COEFH", _FEDesc ) ),
              _flunl( new PCFieldOnMeshDoubleInstance( name + ".FLUNL", _FEDesc ) ),
              _flure( new PCFieldOnMeshDoubleInstance( name + ".FLURE", _FEDesc ) ),
              _grain( new PCFieldOnMeshDoubleInstance( name + ".GRAIN", _FEDesc ) ),
              _hechp( new PCFieldOnMeshDoubleInstance( name + ".HECHP", _FEDesc ) ),
              _soure( new PCFieldOnMeshDoubleInstance( name + ".SOURE", _FEDesc ) ),
              _tExt( new PCFieldOnMeshDoubleInstance( name + ".T_EXT", _FEDesc ) ){};
    };

    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    /** @brief std::list de std::pair de UnitaryThermalLoadPtr et MeshEntityPtr */
    typedef std::vector< UnitaryThermalLoadPtr > listOfLoads;
    /** @brief Valeur contenue dans listOfLoads */
    typedef listOfLoads::value_type listOfLoadsValue;
    /** @brief Iterateur sur un listOfLoads */
    typedef listOfLoads::iterator listOfLoadsIter;

    /** @brief Vecteur Jeveux '.TYPE' */
    JeveuxVectorChar8 _type;
    TherLoad _therLoad;
    /** @brief Modele support */
    ModelPtr _supportModel;
    /** @brief La SD est-elle vide ? */
    bool _isEmpty;
    listOfLoads _thermalLoads;

    /** @brief Conteneur des mots-clés avec traduction */
    CapyConvertibleContainer _toCapyConverter;

  public:
    /**
     * @typedef ThermalLoadPtr
     * @brief Pointeur intelligent vers un ThermalLoad
     */
    typedef boost::shared_ptr< ThermalLoadInstance > ThermalLoadPtr;

    /**
     * @brief Constructeur
     */
    ThermalLoadInstance( const ModelPtr &currentModel )
        : ThermalLoadInstance( ResultNaming::getNewResultName(), currentModel ){};

    /**
     * @brief Constructeur
     */
    ThermalLoadInstance( const std::string name, const ModelPtr &currentModel )
        : DataStructure( name, 8, "CHAR_THER" ), _therLoad( getName() + ".CHTH", currentModel ),
          _type( getName() + ".TYPE" ), _supportModel( currentModel ), _isEmpty( true ){};

    /**
     * @brief Ajout d'une valeur acoustique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addUnitaryThermalLoad( const UnitaryThermalLoadPtr &toAdd ) {
        //         if ( ! _supportModel ) throw std::runtime_error( "Support model is not defined"
        //         );
        //         MeshPtr mesh = _supportModel->getSupportMesh();
        //         if ( ! _supportMesh->hasGroupOfNodes( nameOfGroup ) )
        //             throw std::runtime_error( nameOfGroup + "not in support mesh" );
        //         throw std::runtime_error( "Not yet implemented" );
        _thermalLoads.push_back( toAdd );
    };

    /**
     * @brief Construction de la charge (appel a OP0101)
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool build() ;

    /**
     * @brief Get the support finite element descriptor
     */
    FiniteElementDescriptorPtr getFiniteElementDescriptor() const { return _therLoad._FEDesc; };

    /**
     * @brief Get the support model
     */
    ModelPtr getModel() const { return _supportModel; };
};

/**
 * @typedef ThermalLoad
 * @brief Pointeur intelligent vers un ThermalLoadInstance
 */
typedef boost::shared_ptr< ThermalLoadInstance > ThermalLoadPtr;

#endif /* THERMALLOAD_H_ */
