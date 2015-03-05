#ifndef MATERIAL_H_
#define MATERIAL_H_

/**
 * @file Material.h
 * @brief Fichier entete de la classe Material
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "DataStructure/DataStructure.h"
#include "Materials/MaterialBehaviour.h"

/**
 * @class MaterialInstance
 * @brief produit une sd identique a celle produite par DEFI_MATERIAU
 * @author Nicolas Sellenet
 */
class MaterialInstance: public DataStructure
{
    private:
        typedef std::vector< GeneralMaterialBehaviourPtr > VectorOfGeneralMaterialBehaviour;
        typedef VectorOfGeneralMaterialBehaviour::iterator VectorOfGeneralMaterialIter;

        /** @brief Nom Jeveux de la SD */
        const std::string                  _jeveuxName;
        /** @brief Vecteur Jeveux '.MATERIAU.NOMRC' */
        JeveuxVectorChar32                 _materialBehaviourNames;
        /** @brief Nombre de MaterialBehaviour deja ajoutes */
        int                                _nbMaterialBehaviour;
        /** @brief Vecteur contenant les GeneralMaterialBehaviourPtr ajoutes par l'utilisateur */
        VectorOfGeneralMaterialBehaviour   _vecMatBehaviour;

        /** @brief Vector of JeveuxVectorComplex named 'CPT.XXXXXX.VALC' */
        std::vector< JeveuxVectorComplex > _vectorOfComplexValues;
        /** @brief Vector of JeveuxVectorDouble named 'CPT.XXXXXX.VALR' */
        std::vector< JeveuxVectorDouble >  _vectorOfDoubleValues;
        /** @brief Vector of JeveuxVectorChar16 named 'CPT.XXXXXX.VALK' */
        std::vector< JeveuxVectorChar16 >  _vectorOfChar16Values;

    public:
        /**
         * @brief Constructeur
         */
        MaterialInstance();

        /**
         * @brief Ajout d'un GeneralMaterialBehaviourPtr
         * @param curMaterBehav GeneralMaterialBehaviourPtr a ajouter au MaterialInstance
         * @todo pouvoiur utiliser addMaterialBehaviour plusieurs fois après build
         */
        void addMaterialBehaviour( const GeneralMaterialBehaviourPtr& curMaterBehav )
        {
            ++_nbMaterialBehaviour;

            std::ostringstream numString;
            numString << std::setw( 6 ) << std::setfill( '0' ) << _nbMaterialBehaviour;
            const std::string currentName = _jeveuxName + ".CPT.";
            _vectorOfComplexValues.push_back( JeveuxVectorComplex( currentName + ".VALC" ) );
            _vectorOfDoubleValues.push_back( JeveuxVectorDouble( currentName + ".VALR" ) );
            _vectorOfChar16Values.push_back( JeveuxVectorChar16( currentName + ".VALK" ) );

            _vecMatBehaviour.push_back( curMaterBehav );
        };

        /**
         * @brief Construction du MaterialInstance
         *   A partir des GeneralMaterialBehaviourPtr ajoutes par l'utilisateur :
         *   creation de objets Jeveux
         * @return Booleen indiquant que la construction s'est bien deroulee
         * @todo pouvoir compléter un matériau (ajout d'un comportement après build)
         */
        bool build() throw ( std::runtime_error );
};

/**
 * @typedef MaterialPtr
 * @brief Pointeur intelligent vers un MaterialInstance
 */
typedef boost::shared_ptr< MaterialInstance > MaterialPtr;


#endif /* MATERIAL_H_ */
