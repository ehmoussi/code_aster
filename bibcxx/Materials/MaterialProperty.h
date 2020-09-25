#ifndef MATERIALBEHAVIOUR_H_
#define MATERIALBEHAVIOUR_H_

/**
 * @file MaterialProperty.h
 * @brief Fichier entete de la classe MaterialProperty
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

#include <iomanip>
#include <map>
#include <sstream>
#include <string>

#include "astercxx.h"
#include "aster_utils.h"
#include "Materials/BaseMaterialProperty.h"
#include "DataFields/Table.h"
#include "Functions/Formula.h"
#include "Functions/Function.h"
#include "Functions/Function2D.h"
#include "MemoryManager/JeveuxVector.h"


typedef std::vector< FunctionPtr > VectorFunction;


/**
 * @class MaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass
 * @author Jean-Pierre Lefebvre
 */
class MaterialPropertyClass : public GenericMaterialPropertyClass {
    std::string capitalizeName( const std::string &nameInit ) {
        std::string name( nameInit );
        if ( !name.empty() ) {
            name[0] = std::toupper( name[0] );

            for ( std::size_t i = 1; i < name.length(); ++i )
                name[i] = std::tolower( name[i] );
        }
        return name;
    };

  public:
    /**
     * @brief Constructeur
     */
    MaterialPropertyClass( const std::string asterName, const std::string asterNewName = "" )
        : GenericMaterialPropertyClass( asterName, asterNewName ){};

    bool addNewRealProperty( std::string name, const bool mandatory ) {
        return addRealProperty( capitalizeName( name ),
                                  ElementaryMaterialPropertyReal( name, mandatory ) );
    };

    bool addNewRealProperty( std::string name, const double &value, const bool mandatory ) {
        return addRealProperty( capitalizeName( name ),
                                  ElementaryMaterialPropertyReal( name, value, mandatory ) );
    };

    bool addNewComplexProperty( std::string name, const bool mandatory ) {
        return addComplexProperty( capitalizeName( name ),
                                   ElementaryMaterialPropertyComplex( name, mandatory ) );
    };

    bool addNewStringProperty( std::string name, const bool mandatory ) {
        return addStringProperty( capitalizeName( name ),
                                  ElementaryMaterialPropertyString( name, mandatory ) );
    };

    bool addNewStringProperty( std::string name, const std::string &value, const bool mandatory ) {
        return addStringProperty( capitalizeName( name ),
                                  ElementaryMaterialPropertyString( name, value, mandatory ) );
    };

    bool addNewFunctionProperty( std::string name, const bool mandatory ) {
        return addFunctionProperty( capitalizeName( name ),
                                    ElementaryMaterialPropertyDataStructure( name, mandatory ) );
    };

    bool addNewTableProperty( std::string name, const bool mandatory ) {
        return addTableProperty( capitalizeName( name ),
                                 ElementaryMaterialPropertyTable( name, mandatory ) );
    };

    bool addNewVectorOfRealProperty( std::string name, const bool mandatory ) {
        return addVectorOfRealProperty(
            capitalizeName( name ), ElementaryMaterialPropertyVectorReal( name, mandatory ) );
    };

    bool addNewVectorOfFunctionProperty( std::string name, const bool mandatory ) {
        return addVectorOfFunctionProperty(
            capitalizeName( name ), ElementaryMaterialPropertyVectorFunction( name, mandatory ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    std::string getName() { return _asterName; };
};

/** @typedef Pointeur intelligent vers un comportement materiau */
typedef boost::shared_ptr< MaterialPropertyClass > MaterialPropertyPtr;


/**
 * @class MetaTractionMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau MetaTraction
 * @author Jean-Pierre Lefebvre
 */
class MetaTractionMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    MetaTractionMaterialPropertyClass() {
        // Mot cle "META_TRACTION" dans Aster
        _asterName = "META_TRACTION";

        // Parametres matériau
        this->addFunctionProperty( "Sigm_f1",
                                   ElementaryMaterialPropertyDataStructure( "SIGM_F1", false ) );
        this->addFunctionProperty( "Sigm_f2",
                                   ElementaryMaterialPropertyDataStructure( "SIGM_F2", false ) );
        this->addFunctionProperty( "Sigm_f3",
                                   ElementaryMaterialPropertyDataStructure( "SIGM_F3", false ) );
        this->addFunctionProperty( "Sigm_f4",
                                   ElementaryMaterialPropertyDataStructure( "SIGM_F4", false ) );
        this->addFunctionProperty( "Sigm_c",
                                   ElementaryMaterialPropertyDataStructure( "SIGM_C", false ) );
    };

    /**
     * @brief Build ".RDEP"
     * @return true
     */
    bool buildTractionFunction( FunctionPtr &doubleValues ) const;

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "META_TRACTION"; };

    /**
     * @brief Function to know if ".RDEP" is necessary
     * @return true if ".RDEP" is necessary
     */
    bool hasTractionFunction() const { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaTraction */
typedef boost::shared_ptr< MetaTractionMaterialPropertyClass > MetaTractionMaterialPropertyPtr;



/**
 * @class TractionMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau Traction
 * @author Jean-Pierre Lefebvre
 */
class TractionMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    TractionMaterialPropertyClass() {
        // Mot cle "TRACTION" dans Aster
        _asterName = "TRACTION";

        // Parametres matériau
        this->addFunctionProperty( "Sigm",
                                   ElementaryMaterialPropertyDataStructure( "SIGM", true ) );
    };

    /**
     * @brief Build ".RDEP"
     * @return true
     */
    bool buildTractionFunction( FunctionPtr &doubleValues ) const;

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "TRACTION"; };

    /**
     * @brief Function to know if ".RDEP" is necessary
     * @return true if ".RDEP" is necessary
     */
    bool hasTractionFunction() const { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau Traction */
typedef boost::shared_ptr< TractionMaterialPropertyClass > TractionMaterialPropertyPtr;

/**
 * @class ThermalNlMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau TherNl
 * @author Jean-Pierre Lefebvre
 */
class ThermalNlMaterialPropertyClass : public GenericMaterialPropertyClass {
  private:
    FunctionPtr _enthalpyFunction;

  public:
    /**
     * @brief Constructeur
     */
    ThermalNlMaterialPropertyClass() : _enthalpyFunction( new FunctionClass() ) {
        // Mot cle "THER_NL" dans Aster
        _asterName = "THER_NL";

        // Parametres matériau
        this->addFunctionProperty( "Lambda",
                                   ElementaryMaterialPropertyDataStructure( "LAMBDA", true ) );
        this->addFunctionProperty( "Beta",
                                   ElementaryMaterialPropertyDataStructure( "BETA", false ) );
        this->addFunctionProperty( "Rho_cp",
                                   ElementaryMaterialPropertyDataStructure( "RHO_CP", false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "THER_NL"; };

    /**
     * @brief Function to know if material own a function for enthalpy
     */
    bool hasEnthalpyFunction() { return true; };

    /**
     * @brief Construction du GenericMaterialPropertyClass
     * @return Booleen valant true si la tache s'est bien deroulee
     * @todo vérifier les valeurs réelles par défaut du .VALR
     */
    bool buildJeveuxVectors( JeveuxVectorComplex &complexValues, JeveuxVectorReal &doubleValues,
                             JeveuxVectorChar16 &char16Values, JeveuxVectorChar16 &ordr,
                             JeveuxVectorLong &kOrdr, std::vector< JeveuxVectorReal > &,
                             std::vector< JeveuxVectorChar8 > & );
};

/** @typedef Pointeur intelligent vers un comportement materiau TherNl */
typedef boost::shared_ptr< ThermalNlMaterialPropertyClass > ThermalNlMaterialPropertyPtr;


#endif
