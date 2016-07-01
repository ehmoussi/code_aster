#ifndef THERMALLOAD_H_
#define THERMALLOAD_H_

/**
 * @file ThermalLoad.h
 * @brief Fichier entete de la classe ThermalLoad
 * @author Jean-Pierre Lefebvre
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

/**
 * @class ThermalLoadInstance
 * @brief Classe definissant une charge thermique (issue d'AFFE_CHAR_THER)
 * @author Jean-Pierre Lefebvre
 */
class ThermalLoadInstance: public DataStructure
{
private:
    /** @typedef Pointeur intelligent sur un VirtualMeshEntity */
    typedef boost::shared_ptr< VirtualMeshEntity > MeshEntityPtr;
    /** @brief std::list de std::pair de UnitaryThermalLoadPtr et MeshEntityPtr */
    typedef std::vector< UnitaryThermalLoadPtr > listOfLoads;
    /** @brief Valeur contenue dans listOfLoads */
    typedef listOfLoads::value_type listOfLoadsValue;
    /** @brief Iterateur sur un listOfLoads */
    typedef listOfLoads::iterator listOfLoadsIter;

    /** @brief Modele support */
    ModelPtr           _supportModel;
    /** @brief La SD est-elle vide ? */
    bool               _isEmpty;
    listOfLoads        _thermalLoads;

    /** @brief Conteneur des mots-clés avec traduction */
    CapyConvertibleContainer         _toCapyConverter;

public:
    /**
     * @brief Constructeur
     */
    ThermalLoadInstance() ;
    /**
     * @brief Ajout d'une valeur acoustique imposee sur un groupe de mailles
     * @param nameOfGroup Nom du groupe sur lequel imposer la valeur
     * @param value Valeur imposee
     * @return Booleen indiquant que tout s'est bien passe
     */
    bool addUnitaryThermalLoad( const UnitaryThermalLoadPtr& toAdd ) throw ( std::runtime_error )
    {
//         if ( ! _supportModel ) throw std::runtime_error( "Support model is not defined" );
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
    bool build() throw ( std::runtime_error );

    /**
     * @brief Definition du modele support
     * @param currentMesh objet Model sur lequel la charge reposera
     */
    bool setModel( ModelPtr& currentModel )
    {
        if ( currentModel->isEmpty() )
            throw std::runtime_error( "Model is empty" );
        _supportModel = currentModel;
        return true;
    };
};

/**
 * @typedef ThermalLoad
 * @brief Pointeur intelligent vers un ThermalLoadInstance
 */
typedef boost::shared_ptr< ThermalLoadInstance > ThermalLoadPtr;

#endif /* THERMALLOAD_H_ */
