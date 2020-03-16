#ifndef THERMALLOAD_H_
#define THERMALLOAD_H_

/**
 * @file ThermalLoad.h
 * @brief Fichier entete de la classe ThermalLoad
 * @author Jean-Pierre Lefebvre
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

#include <stdexcept>
#include <list>
#include <string>
#include "astercxx.h"
#include "Modeling/Model.h"
#include "Loads/UnitaryThermalLoad.h"
#include "Utilities/CapyConvertibleValue.h"
#include "Modeling/FiniteElementDescriptor.h"
#include "DataFields/ConstantFieldOnCells.h"

/**
 * @class ThermalLoadClass
 * @brief Classe definissant une charge thermique (issue d'AFFE_CHAR_THER)
 * @author Jean-Pierre Lefebvre
 */
class ThermalLoadClass : public DataStructure {
  private:
    struct TherLoad {
        /** @brief Modele */
        ModelPtr _model;
        /** @brief mesh */
        BaseMeshPtr _mesh;
        /** @brief Vecteur Jeveux '.MODEL.NOMO' */
        JeveuxVectorChar8 _modelName;
        /** @brief Vecteur Jeveux '.CONVE.VALE' */
        JeveuxVectorChar8 _convection;
        /** @brief Vecteur Jeveux '.LIGRE' */
        FiniteElementDescriptorPtr _FEDesc;
        /** @brief Carte '.CIMPO' */
        ConstantFieldOnCellsRealPtr _cimpo;
        /** @brief Carte '.CMULT' */
        ConstantFieldOnCellsRealPtr _cmult;
        /** @brief Carte '.COEFH' */
        ConstantFieldOnCellsRealPtr _coefh;
        /** @brief Carte '.FLUNL' */
        ConstantFieldOnCellsRealPtr _flunl;
        /** @brief Carte '.FLURE' */
        ConstantFieldOnCellsRealPtr _flure;
        /** @brief Carte '.GRAIN' */
        ConstantFieldOnCellsRealPtr _grain;
        /** @brief Carte '.HECHP' */
        ConstantFieldOnCellsRealPtr _hechp;
        /** @brief Carte '.SOURE' */
        ConstantFieldOnCellsRealPtr _soure;
        /** @brief Carte '.T_EXT' */
        ConstantFieldOnCellsRealPtr _tExt;

        /** @brief Constructeur */
        TherLoad( const std::string &name, const ModelPtr &currentModel )
            : _model( currentModel ), _mesh( _model->getMesh() ),
              _modelName( name + ".MODEL.NOMO" ), _convection( name + ".CONVE.VALE" ),
              _FEDesc( new FiniteElementDescriptorClass( name + ".LIGRE", _mesh ) ),
              _cimpo( new ConstantFieldOnCellsRealClass( name + ".CIMPO", _FEDesc ) ),
              _cmult( new ConstantFieldOnCellsRealClass( name + ".CMULT", _FEDesc ) ),
              _coefh( new ConstantFieldOnCellsRealClass( name + ".COEFH", _FEDesc ) ),
              _flunl( new ConstantFieldOnCellsRealClass( name + ".FLUNL", _FEDesc ) ),
              _flure( new ConstantFieldOnCellsRealClass( name + ".FLURE", _FEDesc ) ),
              _grain( new ConstantFieldOnCellsRealClass( name + ".GRAIN", _FEDesc ) ),
              _hechp( new ConstantFieldOnCellsRealClass( name + ".HECHP", _FEDesc ) ),
              _soure( new ConstantFieldOnCellsRealClass( name + ".SOURE", _FEDesc ) ),
              _tExt( new ConstantFieldOnCellsRealClass( name + ".T_EXT", _FEDesc ) ){};
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
    /** @brief Modele */
    ModelPtr _model;
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
    typedef boost::shared_ptr< ThermalLoadClass > ThermalLoadPtr;

    /**
     * @brief Constructeur
     */
    ThermalLoadClass( const ModelPtr &currentModel )
        : ThermalLoadClass( ResultNaming::getNewResultName(), currentModel ){};

    /**
     * @brief Constructeur
     */
    ThermalLoadClass( const std::string name, const ModelPtr &currentModel )
        : DataStructure( name, 8, "CHAR_THER" ), _therLoad( getName() + ".CHTH", currentModel ),
          _type( getName() + ".TYPE" ), _model( currentModel ), _isEmpty( true ){};

    /**
     * @brief Ajout d'une valeur acoustique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addUnitaryThermalLoad( const UnitaryThermalLoadPtr &toAdd ) {
        //         if ( ! _model ) throw std::runtime_error( "Model is not defined"
        //         );
        //         MeshPtr mesh = _model->getMesh();
        //         if ( ! _mesh->hasGroupOfNodes( nameOfGroup ) )
        //             throw std::runtime_error( nameOfGroup + "not in mesh" );
        //         throw std::runtime_error( "Not yet implemented" );
        _thermalLoads.push_back( toAdd );
    };

    /**
     * @brief Construction de la charge (appel a OP0101)
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool build() ;

    /**
     * @brief Get the finite element descriptor
     */
    FiniteElementDescriptorPtr getFiniteElementDescriptor() const { return _therLoad._FEDesc; };

    /**
     * @brief Get the model
     */
    ModelPtr getModel() const { return _model; };
};

/**
 * @typedef ThermalLoad
 * @brief Pointeur intelligent vers un ThermalLoadClass
 */
typedef boost::shared_ptr< ThermalLoadClass > ThermalLoadPtr;

#endif /* THERMALLOAD_H_ */
