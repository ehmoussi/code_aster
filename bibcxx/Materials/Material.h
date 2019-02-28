#ifndef MATERIAL_H_
#define MATERIAL_H_

/**
 * @file Material.h
 * @brief Fichier entete de la classe Material
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "DataStructures/DataStructure.h"
#include "Materials/MaterialBehaviour.h"
#include "Functions/Function.h"

/**
 * @class MaterialInstance
 * @brief produit une sd identique a celle produite par DEFI_MATERIAU
 * @author Nicolas Sellenet
 */
class MaterialInstance: public DataStructure
{
    public:
        /**
         * @typedef MaterialPtr
         * @brief Pointeur intelligent vers un Material
         */
        typedef boost::shared_ptr< MaterialInstance > MaterialPtr;

        typedef std::vector< GeneralMaterialBehaviourPtr > VectorOfGeneralMaterialBehaviour;
        typedef VectorOfGeneralMaterialBehaviour::iterator VectorOfGeneralMaterialIter;
        typedef std::vector< JeveuxVectorDouble > VectorOfJeveuxVectorDouble;
        typedef std::vector< JeveuxVectorChar8 > VectorOfJeveuxVectorChar8;

    private:
        /** @brief Vecteur Jeveux '.MATERIAU.NOMRC' */
        JeveuxVectorChar32                 _materialBehaviourNames;
        /** @brief Nombre de MaterialBehaviour deja ajoutes */
        int                                _nbMaterialBehaviour;
        int                                _nbUserMaterialBehaviour;
        /** @brief Vecteur contenant les GeneralMaterialBehaviourPtr ajoutes par l'utilisateur */
        VectorOfGeneralMaterialBehaviour   _vecMatBehaviour;

        /** @brief Vector of JeveuxVectorComplex named 'CPT.XXXXXX.VALC' */
        std::vector< JeveuxVectorComplex > _vectorOfComplexValues;
        /** @brief Vector of JeveuxVectorDouble named 'CPT.XXXXXX.VALR' */
        std::vector< JeveuxVectorDouble >  _vectorOfDoubleValues;
        /** @brief Vector of JeveuxVectorChar16 named 'CPT.XXXXXX.VALK' */
        std::vector< JeveuxVectorChar16 >  _vectorOfChar16Values;
        /** @brief Vector of JeveuxVectorChar16 named '.ORDR' */
        std::vector< JeveuxVectorChar16 >  _vectorOrdr;
        /** @brief Vector of JeveuxVectorLong named '.KORD' */
        std::vector< JeveuxVectorLong >    _vectorKOrdr;
        /** @brief Vector of JeveuxVectorDouble named '.XXXXXXX.LISV_R8' */
        std::vector< VectorOfJeveuxVectorDouble > _vectorOfUserDoubleValues;
        /** @brief Vector of JeveuxVectorChar8 named '.XXXXXXX.LISV_FO' */
        std::vector< VectorOfJeveuxVectorChar8 >  _vectorOfUserFunctionValues;
        /** @brief Vector of JeveuxVectorDouble named '.&&RDEP' */
        FunctionPtr                        _doubleValues;
        MaterialPtr                        _mater;

        /**
         * @brief Deallocate all Jeveux vector (usefull in reuse mode)
         */
        void deallocateJeveuxVectors();

    public:
        /**
         * @brief Constructeur
         */
        MaterialInstance():
            MaterialInstance( ResultNaming::getNewResultName() )
        {};

        MaterialInstance( const std::string& name ):
            DataStructure( name, 8, "MATER" ),
            _materialBehaviourNames( JeveuxVectorChar32( name + ".MATERIAU.NOMRC " ) ),
            _nbMaterialBehaviour( 0 ),
            _nbUserMaterialBehaviour( 0 ),
            _doubleValues( new FunctionInstance( name + ".&&RDEP" ) ),
            _mater( nullptr )
        {};

        MaterialInstance( const std::string& name, VectorInt vec ):
            MaterialInstance( name )
        {
            setStateAfterUnpickling( vec );
        };

        /**
         * @brief Ajout d'un GeneralMaterialBehaviourPtr
         * @param curMaterBehav GeneralMaterialBehaviourPtr a ajouter au MaterialInstance
         * @todo pouvoiur utiliser addMaterialBehaviour plusieurs fois après build
         */
        void addMaterialBehaviour( const GeneralMaterialBehaviourPtr& curMaterBehav );

        /**
         * @brief Construction du MaterialInstance
         *   A partir des GeneralMaterialBehaviourPtr ajoutes par l'utilisateur :
         *   creation de objets Jeveux
         * @return Booleen indiquant que la construction s'est bien deroulee
         * @todo pouvoir compléter un matériau (ajout d'un comportement après build)
         */
        bool build();

        /**
         * @brief Get the number of list of double properties for one MaterialBehaviour
         * @return number of list of double properties
         */
        int getNumberOfListOfDoubleProperties( int position )
        {
            if( position >= _vectorOfUserDoubleValues.size() )
                throw std::runtime_error("Out of bound");
            return _vectorOfUserDoubleValues[ position ].size();
        };

        /**
         * @brief Get the number of list of function properties for one MaterialBehaviour
         * @return number of list of function properties
         */
        int getNumberOfListOfFunctionProperties( int position )
        {
            if( position >= _vectorOfUserFunctionValues.size() )
                throw std::runtime_error("Out of bound");
            return _vectorOfUserFunctionValues[ position ].size();
        };

        /**
         * @brief Get the number of behaviours
         * @return number of added behaviours
         */
        int getNumberOfMaterialBehviour()
        {
            return _nbMaterialBehaviour;
        };

        /**
         * @brief Get the number of users behaviours
         * @return number of added users behaviours
         */
        int getNumberOfUserMaterialBehviour()
        {
            return _nbUserMaterialBehaviour;
        };

        /**
         * @brief Get vector of double values for a given material behaviour
         * @param position index of vector
         * @return jeveux vector of double values
         */
        VectorOfJeveuxVectorDouble getBehaviourVectorOfDoubleValues( int position )
        {
            if( position >= _vectorOfUserDoubleValues.size() )
                throw std::runtime_error("Out of bound");
            return _vectorOfUserDoubleValues[ position ];
        };

        /**
         * @brief Get vector of function values for a given material behaviour
         * @param position index of vector
         * @return jeveux vector of function values
         */
        VectorOfJeveuxVectorChar8 getBehaviourVectorOfFunctions( int position )
        {
            if( position >= _vectorOfUserFunctionValues.size() )
                throw std::runtime_error("Out of bound");
            return _vectorOfUserFunctionValues[ position ];
        };

        /**
         * @brief Get vector of material behaviours
         */
        VectorOfGeneralMaterialBehaviour getVectorOfMaterialBehaviours()
        {
            return _vecMatBehaviour;
        };

        /**
         * @brief Add a reference to an existing MaterialInstance to enrich
         */
        void setReferenceMaterial( const MaterialPtr& curMater )
        {
            _mater = curMater;
        };

    private:
        /**
         * @brief Add reference to jeveux object after unpickling
         */
        void setStateAfterUnpickling( const VectorInt& );
};

/**
 * @typedef MaterialPtr
 * @brief Pointeur intelligent vers un MaterialInstance
 */
typedef boost::shared_ptr< MaterialInstance > MaterialPtr;


#endif /* MATERIAL_H_ */
