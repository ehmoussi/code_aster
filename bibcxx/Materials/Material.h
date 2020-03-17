#ifndef MATERIAL_H_
#define MATERIAL_H_

/**
 * @file Material.h
 * @brief Fichier entete de la classe Material
 * @author Nicolas Sellenet
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

/* person_in_charge: nicolas.sellenet at edf.fr */

#include "astercxx.h"
#include "DataStructures/DataStructure.h"
#include "Materials/MaterialProperty.h"
#include "Functions/Function.h"

/**
 * @class MaterialClass
 * @brief produit une sd identique a celle produite par DEFI_MATERIAU
 * @author Nicolas Sellenet
 */
class MaterialClass: public DataStructure
{
    public:
        /**
         * @typedef MaterialPtr
         * @brief Pointeur intelligent vers un Material
         */
        typedef boost::shared_ptr< MaterialClass > MaterialPtr;

        typedef std::vector< GenericMaterialPropertyPtr > VectorOfGenericMaterialProperty;
        typedef VectorOfGenericMaterialProperty::iterator VectorOfGeneralMaterialIter;
        typedef std::vector< JeveuxVectorReal > VectorOfJeveuxVectorReal;
        typedef std::vector< JeveuxVectorChar8 > VectorOfJeveuxVectorChar8;

    private:
        /** @brief Vecteur Jeveux '.MATERIAU.NOMRC' */
        JeveuxVectorChar32                 _materialBehaviourNames;
        /** @brief Nombre de MaterialProperty deja ajoutes */
        int                                _nbMaterialProperty;
        int                                _nbUserMaterialProperty;
        /** @brief Vecteur contenant les GenericMaterialPropertyPtr ajoutes par l'utilisateur */
        VectorOfGenericMaterialProperty   _vecMatBehaviour;

        /** @brief Vector of JeveuxVectorComplex named 'CPT.XXXXXX.VALC' */
        std::vector< JeveuxVectorComplex > _vectorOfComplexValues;
        /** @brief Vector of JeveuxVectorReal named 'CPT.XXXXXX.VALR' */
        std::vector< JeveuxVectorReal >  _vectorOfRealValues;
        /** @brief Vector of JeveuxVectorChar16 named 'CPT.XXXXXX.VALK' */
        std::vector< JeveuxVectorChar16 >  _vectorOfChar16Values;
        /** @brief Vector of JeveuxVectorChar16 named '.ORDR' */
        std::vector< JeveuxVectorChar16 >  _vectorOrdr;
        /** @brief Vector of JeveuxVectorLong named '.KORD' */
        std::vector< JeveuxVectorLong >    _vectorKOrdr;
        /** @brief Vector of JeveuxVectorReal named '.XXXXXXX.LISV_R8' */
        std::vector< VectorOfJeveuxVectorReal > _vectorOfUserRealValues;
        /** @brief Vector of JeveuxVectorChar8 named '.XXXXXXX.LISV_FO' */
        std::vector< VectorOfJeveuxVectorChar8 >  _vectorOfUserFunctionValues;
        /** @brief Vector of JeveuxVectorReal named '.&&RDEP' */
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
        MaterialClass():
            MaterialClass( ResultNaming::getNewResultName() )
        {};

        MaterialClass( const std::string& name ):
            DataStructure( name, 8, "MATER" ),
            _materialBehaviourNames( JeveuxVectorChar32( name + ".MATERIAU.NOMRC " ) ),
            _nbMaterialProperty( 0 ),
            _nbUserMaterialProperty( 0 ),
            _doubleValues( new FunctionClass( name + ".&&RDEP" ) ),
            _mater( nullptr )
        {};

        MaterialClass( const std::string& name, VectorInt vec ):
            MaterialClass( name )
        {
            setStateAfterUnpickling( vec );
        };

        /**
         * @brief Ajout d'un GenericMaterialPropertyPtr
         * @param curMaterBehav GenericMaterialPropertyPtr a ajouter au MaterialClass
         * @todo pouvoiur utiliser addMaterialProperty plusieurs fois après build
         */
        void addMaterialProperty( const GenericMaterialPropertyPtr& curMaterBehav );

        /**
         * @brief Construction du MaterialClass
         *   A partir des GenericMaterialPropertyPtr ajoutes par l'utilisateur :
         *   creation de objets Jeveux
         * @return Booleen indiquant que la construction s'est bien deroulee
         * @todo pouvoir compléter un matériau (ajout d'un comportement après build)
         */
        bool build();

        /**
         * @brief Get the number of list of double properties for one MaterialProperty
         * @return number of list of double properties
         */
        int getNumberOfListOfRealProperties( int position )
        {
            if( position >= _vectorOfUserRealValues.size() )
                throw std::runtime_error("Out of bound");
            return _vectorOfUserRealValues[ position ].size();
        };

        /**
         * @brief Get the number of list of function properties for one MaterialProperty
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
        int getNumberOfMaterialBehaviour()
        {
            return _nbMaterialProperty;
        };

        /**
         * @brief Get the number of users behaviours
         * @return number of added users behaviours
         */
        int getNumberOfUserMaterialBehviour()
        {
            return _nbUserMaterialProperty;
        };

        /**
         * @brief Get vector of double values for a given material behaviour
         * @param position index of vector
         * @return jeveux vector of double values
         */
        VectorOfJeveuxVectorReal getBehaviourVectorOfRealValues( int position )
        {
            if( position >= _vectorOfUserRealValues.size() )
                throw std::runtime_error("Out of bound");
            return _vectorOfUserRealValues[ position ];
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
        VectorOfGenericMaterialProperty getVectorOfMaterialPropertys()
        {
            return _vecMatBehaviour;
        };

        /**
         * @brief Add a reference to an existing MaterialClass to enrich
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
 * @brief Pointeur intelligent vers un MaterialClass
 */
typedef boost::shared_ptr< MaterialClass > MaterialPtr;


#endif /* MATERIAL_H_ */
