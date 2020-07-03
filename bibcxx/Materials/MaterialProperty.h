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
 * @class BetonRealDpMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau BetonRealDp
 * @author Jean-Pierre Lefebvre
 */
class BetonRealDpMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    BetonRealDpMaterialPropertyClass() {
        // Mot cle "BETON_DOUBLE_DP" dans Aster
        _asterName = "BETON_DOUBLE_DP";

        // Parametres matériau
        this->addFunctionProperty( "F_c", ElementaryMaterialPropertyDataStructure( "F_C", true ) );
        this->addFunctionProperty( "F_t", ElementaryMaterialPropertyDataStructure( "F_T", true ) );
        this->addFunctionProperty( "Coef_biax",
                                   ElementaryMaterialPropertyDataStructure( "COEF_BIAX", true ) );
        this->addFunctionProperty(
            "Ener_comp_rupt", ElementaryMaterialPropertyDataStructure( "ENER_COMP_RUPT", true ) );
        this->addFunctionProperty(
            "Ener_trac_rupt", ElementaryMaterialPropertyDataStructure( "ENER_TRAC_RUPT", true ) );
        this->addRealProperty( "Coef_elas_comp",
                                 ElementaryMaterialPropertyReal( "COEF_ELAS_COMP", true ) );
        this->addRealProperty( "Long_cara",
                                 ElementaryMaterialPropertyReal( "LONG_CARA", false ) );
        this->addConvertibleProperty(
            "Ecro_comp_p_pic",
            ElementaryMaterialPropertyConvertible(
                "ECRO_COMP_P_PIC",
                StringToRealValue( {{"LINEAIRE", 0.}, {"PARABOLE", 1.}}, "LINEAIRE" ), false ) );
        this->addConvertibleProperty(
            "Ecro_trac_p_pic",
            ElementaryMaterialPropertyConvertible(
                "ECRO_TRAC_P_PIC",
                StringToRealValue( {{"LINEAIRE", 0.}, {"EXPONENT", 1.}}, "LINEAIRE" ), false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "BETON_DOUBLE_DP"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonRealDp */
typedef boost::shared_ptr< BetonRealDpMaterialPropertyClass >
    BetonRealDpMaterialPropertyPtr;

/**
 * @class BetonRagMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau BetonRag
 * @author Jean-Pierre Lefebvre
 */
class BetonRagMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    BetonRagMaterialPropertyClass() {
        // Mot cle "BETON_RAG" dans Aster
        _asterName = "BETON_RAG";

        // Parametres matériau
        this->addConvertibleProperty(
            "Comp_beton",
            ElementaryMaterialPropertyConvertible(
                "TYPE_LOI",
                StringToRealValue( {{"ENDO", 1.}, {"ENDO_FLUA", 2.}, {"ENDO_FLUA_RAG", 3.}} ),
                true ) );
        this->addRealProperty( "Endo_mc", ElementaryMaterialPropertyReal( "ENDO_MC", false ) );
        this->addRealProperty( "Endo_mt", ElementaryMaterialPropertyReal( "ENDO_MT", false ) );
        this->addRealProperty( "Endo_siguc",
                                 ElementaryMaterialPropertyReal( "ENDO_SIGUC", false ) );
        this->addRealProperty( "Endo_sigut",
                                 ElementaryMaterialPropertyReal( "ENDO_SIGUT", false ) );
        this->addRealProperty( "Endo_drupra",
                                 ElementaryMaterialPropertyReal( "ENDO_DRUPRA", false ) );
        this->addRealProperty( "Flua_sph_kr",
                                 ElementaryMaterialPropertyReal( "FLUA_SPH_KR", false ) );
        this->addRealProperty( "Flua_sph_ki",
                                 ElementaryMaterialPropertyReal( "FLUA_SPH_KI", false ) );
        this->addRealProperty( "Flua_sph_nr",
                                 ElementaryMaterialPropertyReal( "FLUA_SPH_NR", false ) );
        this->addRealProperty( "Flua_sph_ni",
                                 ElementaryMaterialPropertyReal( "FLUA_SPH_NI", false ) );
        this->addRealProperty( "Flua_dev_kr",
                                 ElementaryMaterialPropertyReal( "FLUA_DEV_KR", false ) );
        this->addRealProperty( "Flua_dev_ki",
                                 ElementaryMaterialPropertyReal( "FLUA_DEV_KI", false ) );
        this->addRealProperty( "Flua_dev_nr",
                                 ElementaryMaterialPropertyReal( "FLUA_DEV_NR", false ) );
        this->addRealProperty( "Flua_dev_ni",
                                 ElementaryMaterialPropertyReal( "FLUA_DEV_NI", false ) );
        this->addRealProperty( "Gel_alpha0",
                                 ElementaryMaterialPropertyReal( "GEL_ALPHA0", false ) );
        this->addRealProperty( "Gel_tref",
                                 ElementaryMaterialPropertyReal( "GEL_TREF", false ) );
        this->addRealProperty( "Gel_ear", ElementaryMaterialPropertyReal( "GEL_EAR", false ) );
        this->addRealProperty( "Gel_sr0", ElementaryMaterialPropertyReal( "GEL_SR0", false ) );
        this->addRealProperty( "Gel_vg", ElementaryMaterialPropertyReal( "GEL_VG", false ) );
        this->addRealProperty( "Gel_mg", ElementaryMaterialPropertyReal( "GEL_MG", false ) );
        this->addRealProperty( "Gel_bg", ElementaryMaterialPropertyReal( "GEL_BG", false ) );
        this->addRealProperty( "Gel_a0", ElementaryMaterialPropertyReal( "GEL_A0", false ) );
        this->addRealProperty( "Rag_epsi0",
                                 ElementaryMaterialPropertyReal( "RAG_EPSI0", false ) );
        this->addRealProperty( "Pw_a", ElementaryMaterialPropertyReal( "PW_A", false ) );
        this->addRealProperty( "Pw_b", ElementaryMaterialPropertyReal( "PW_B", false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "BETON_RAG"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau BetonRag */
typedef boost::shared_ptr< BetonRagMaterialPropertyClass > BetonRagMaterialPropertyPtr;

/**
 * @class CableGaineFrotMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau CableGaineFrot
 */
class CableGaineFrotMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    CableGaineFrotMaterialPropertyClass() {
        // Mot cle "CABLE_GAINE_FROT" dans Aster
        _asterName = "CABLE_GAINE_FROT";

        // Parametres matériau
        this->addConvertibleProperty(
            "Type",
            ElementaryMaterialPropertyConvertible(
                "TYPE",
                StringToRealValue( {{"FROTTANT", 1.}, {"GLISSANT", 2.}, {"ADHERENT", 3.}} ),
                true ) );
        this->addRealProperty( "Frot_line",
                                 ElementaryMaterialPropertyReal( "FROT_LINE", 0., false ) );
        this->addRealProperty( "Frot_courb",
                                 ElementaryMaterialPropertyReal( "FROT_COURB", 0., false ) );
        this->addRealProperty( "Pena_lagr",
                                 ElementaryMaterialPropertyReal( "PENA_LAGR", true ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "CABLE_GAINE_FROT"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau CableGaineFrot */
typedef boost::shared_ptr< CableGaineFrotMaterialPropertyClass >
    CableGaineFrotMaterialPropertyPtr;

/**
 * @class ElasMetaMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau ElasMeta
 * @author Jean-Pierre Lefebvre
 */
class ElasMetaMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    ElasMetaMaterialPropertyClass() {
        // Mot cle "ELAS_META" dans Aster
        _asterName = "ELAS_META";

        // Parametres matériau
        this->addRealProperty( "E", ElementaryMaterialPropertyReal( "E", true ) );
        this->addRealProperty( "Nu", ElementaryMaterialPropertyReal( "NU", true ) );
        this->addRealProperty( "F_alpha", ElementaryMaterialPropertyReal( "F_ALPHA", true ) );
        this->addRealProperty( "C_alpha", ElementaryMaterialPropertyReal( "C_ALPHA", true ) );
        this->addConvertibleProperty(
            "Phase_refe",
            ElementaryMaterialPropertyConvertible(
                "PHASE_REFE", StringToRealValue( {{"CHAUD", 1.}, {"FROID", 0.}} ), true ) );
        this->addRealProperty( "Epsf_epsc_tref",
                                 ElementaryMaterialPropertyReal( "EPSF_EPSC_TREF", true ) );
        this->addRealProperty( "Precision",
                                 ElementaryMaterialPropertyReal( "PRECISION", 1.0E+0, false ) );
        this->addRealProperty( "F1_sy", ElementaryMaterialPropertyReal( "F1_SY", false ) );
        this->addRealProperty( "F2_sy", ElementaryMaterialPropertyReal( "F2_SY", false ) );
        this->addRealProperty( "F3_sy", ElementaryMaterialPropertyReal( "F3_SY", false ) );
        this->addRealProperty( "F4_sy", ElementaryMaterialPropertyReal( "F4_SY", false ) );
        this->addRealProperty( "C_sy", ElementaryMaterialPropertyReal( "C_SY", false ) );
        this->addFunctionProperty( "Sy_melange",
                                   ElementaryMaterialPropertyDataStructure( "SY_MELANGE", false ) );
        this->addRealProperty( "F1_s_vp", ElementaryMaterialPropertyReal( "F1_S_VP", false ) );
        this->addRealProperty( "F2_s_vp", ElementaryMaterialPropertyReal( "F2_S_VP", false ) );
        this->addRealProperty( "F3_s_vp", ElementaryMaterialPropertyReal( "F3_S_VP", false ) );
        this->addRealProperty( "F4_s_vp", ElementaryMaterialPropertyReal( "F4_S_VP", false ) );
        this->addRealProperty( "C_s_vp", ElementaryMaterialPropertyReal( "C_S_VP", false ) );
        this->addFunctionProperty(
            "S_vp_melange", ElementaryMaterialPropertyDataStructure( "S_VP_MELANGE", false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "ELAS_META"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasMeta */
typedef boost::shared_ptr< ElasMetaMaterialPropertyClass > ElasMetaMaterialPropertyPtr;

/**
 * @class ElasMetaFoMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau ElasMetaFo
 * @author Jean-Pierre Lefebvre
 */
class ElasMetaFoMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    ElasMetaFoMaterialPropertyClass() {
        // Mot cle "ELAS_META_FO" dans Aster
        _asterName = "ELAS_META_FO";
        _asterNewName = "ELAS_META";

        // Parametres matériau
        this->addFunctionProperty( "E", ElementaryMaterialPropertyDataStructure( "E", true ) );
        this->addFunctionProperty( "Nu", ElementaryMaterialPropertyDataStructure( "NU", true ) );
        this->addFunctionProperty( "F_alpha",
                                   ElementaryMaterialPropertyDataStructure( "F_ALPHA", true ) );
        this->addFunctionProperty( "C_alpha",
                                   ElementaryMaterialPropertyDataStructure( "C_ALPHA", true ) );
        this->addConvertibleProperty(
            "Phase_refe",
            ElementaryMaterialPropertyConvertible(
                "PHASE_REFE", StringToRealValue( {{"CHAUD", 1.}, {"FROID", 0.}} ), true ) );
        this->addRealProperty( "Epsf_epsc_tref",
                                 ElementaryMaterialPropertyReal( "EPSF_EPSC_TREF", true ) );
        this->addRealProperty( "Temp_def_alpha",
                                 ElementaryMaterialPropertyReal( "TEMP_DEF_ALPHA", false ) );
        this->addRealProperty( "Precision",
                                 ElementaryMaterialPropertyReal( "PRECISION", 1.0E+0, false ) );
        this->addFunctionProperty( "F1_sy",
                                   ElementaryMaterialPropertyDataStructure( "F1_SY", false ) );
        this->addFunctionProperty( "F2_sy",
                                   ElementaryMaterialPropertyDataStructure( "F2_SY", false ) );
        this->addFunctionProperty( "F3_sy",
                                   ElementaryMaterialPropertyDataStructure( "F3_SY", false ) );
        this->addFunctionProperty( "F4_sy",
                                   ElementaryMaterialPropertyDataStructure( "F4_SY", false ) );
        this->addFunctionProperty( "C_sy",
                                   ElementaryMaterialPropertyDataStructure( "C_SY", false ) );
        this->addFunctionProperty( "Sy_melange",
                                   ElementaryMaterialPropertyDataStructure( "SY_MELANGE", false ) );
        this->addFunctionProperty( "F1_s_vp",
                                   ElementaryMaterialPropertyDataStructure( "F1_S_VP", false ) );
        this->addFunctionProperty( "F2_s_vp",
                                   ElementaryMaterialPropertyDataStructure( "F2_S_VP", false ) );
        this->addFunctionProperty( "F3_s_vp",
                                   ElementaryMaterialPropertyDataStructure( "F3_S_VP", false ) );
        this->addFunctionProperty( "F4_s_vp",
                                   ElementaryMaterialPropertyDataStructure( "F4_S_VP", false ) );
        this->addFunctionProperty( "C_s_vp",
                                   ElementaryMaterialPropertyDataStructure( "C_S_VP", false ) );
        this->addFunctionProperty(
            "S_vp_melange", ElementaryMaterialPropertyDataStructure( "S_VP_MELANGE", false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "ELAS_META_FO"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau ElasMetaFo */
typedef boost::shared_ptr< ElasMetaFoMaterialPropertyClass > ElasMetaFoMaterialPropertyPtr;

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
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return false; };

    /**
     * @brief Function to know if ".RDEP" is necessary
     * @return true if ".RDEP" is necessary
     */
    bool hasTractionFunction() const { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau MetaTraction */
typedef boost::shared_ptr< MetaTractionMaterialPropertyClass > MetaTractionMaterialPropertyPtr;

/**
 * @class RuptFragMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau RuptFrag
 * @author Jean-Pierre Lefebvre
 */
class RuptFragMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    RuptFragMaterialPropertyClass() {
        // Mot cle "RUPT_FRAG" dans Aster
        _asterName = "RUPT_FRAG";

        // Parametres matériau
        this->addRealProperty( "Gc", ElementaryMaterialPropertyReal( "GC", true ) );
        this->addRealProperty( "Sigm_c", ElementaryMaterialPropertyReal( "SIGM_C", false ) );
        this->addRealProperty( "Pena_adherence",
                                 ElementaryMaterialPropertyReal( "PENA_ADHERENCE", false ) );
        this->addRealProperty( "Pena_contact",
                                 ElementaryMaterialPropertyReal( "PENA_CONTACT", 1., false ) );
        this->addRealProperty( "Pena_lagr",
                                 ElementaryMaterialPropertyReal( "PENA_LAGR", 1.0E2, false ) );
        this->addRealProperty( "Rigi_glis",
                                 ElementaryMaterialPropertyReal( "RIGI_GLIS", 1.0E1, false ) );
        this->addConvertibleProperty(
            "Cinematique",
            ElementaryMaterialPropertyConvertible(
                "CINEMATIQUE",
                StringToRealValue( {{"UNILATER", 0.}, {"GLIS_1D", 1.}, {"GLIS_2D", 2.}},
                                     "UNILATER" ),
                false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "RUPT_FRAG"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau RuptFrag */
typedef boost::shared_ptr< RuptFragMaterialPropertyClass > RuptFragMaterialPropertyPtr;

/**
 * @class RuptFragFoMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau RuptFragFo
 * @author Jean-Pierre Lefebvre
 */
class RuptFragFoMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    RuptFragFoMaterialPropertyClass() {
        // Mot cle "RUPT_FRAG_FO" dans Aster
        _asterName = "RUPT_FRAG_FO";
        _asterNewName = "RUPT_FRAG";

        // Parametres matériau
        this->addFunctionProperty( "Gc", ElementaryMaterialPropertyDataStructure( "GC", true ) );
        this->addFunctionProperty( "Sigm_c",
                                   ElementaryMaterialPropertyDataStructure( "SIGM_C", false ) );
        this->addFunctionProperty(
            "Pena_adherence", ElementaryMaterialPropertyDataStructure( "PENA_ADHERENCE", false ) );
        this->addRealProperty( "Pena_contact",
                                 ElementaryMaterialPropertyReal( "PENA_CONTACT", 1., false ) );
        this->addRealProperty( "Pena_lagr",
                                 ElementaryMaterialPropertyReal( "PENA_LAGR", 1.0E2, false ) );
        this->addRealProperty( "Rigi_glis",
                                 ElementaryMaterialPropertyReal( "RIGI_GLIS", 1.0E1, false ) );
        this->addConvertibleProperty(
            "Cinematique",
            ElementaryMaterialPropertyConvertible(
                "CINEMATIQUE",
                StringToRealValue( {{"UNILATER", 0.}, {"GLIS_1D", 1.}, {"GLIS_2D", 2.}},
                                     "UNILATER" ),
                false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "RUPT_FRAG_FO"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau RuptFragFo */
typedef boost::shared_ptr< RuptFragFoMaterialPropertyClass > RuptFragFoMaterialPropertyPtr;

/**
 * @class CzmLabMixMaterialPropertyClass
 * @brief Classe fille de GenericMaterialPropertyClass definissant un materiau CzmLabMix
 * @author Nicolas Pignet
 */
class CzmLabMixMaterialPropertyClass : public GenericMaterialPropertyClass {
  public:
    /**
     * @brief Constructeur
     */
    CzmLabMixMaterialPropertyClass() {
        // Mot cle "CZM_LAB_MIX" dans Aster
        _asterName = "CZM_LAB_MIX";

        // Parametres matériau
        this->addRealProperty( "Sigm_c", ElementaryMaterialPropertyReal( "SIGM_C", false ) );
        this->addRealProperty( "Glis_c",
                                 ElementaryMaterialPropertyReal( "GLIS_C", false ) );
        this->addRealProperty( "Alpha",
                                 ElementaryMaterialPropertyReal( "ALPHA", 0.5, false ) );
        this->addRealProperty( "Beta",
                                 ElementaryMaterialPropertyReal( "BETA", 1.0, false ) );
        this->addRealProperty( "Pena_lagr",
                                 ElementaryMaterialPropertyReal( "PENA_LAGR", 100., false ) );
        this->addConvertibleProperty(
            "Cinematique",
            ElementaryMaterialPropertyConvertible(
                "CINEMATIQUE",
                StringToRealValue( {{"UNILATER", 0.}, {"GLIS_1D", 1.}, {"GLIS_2D", 2.}},
                                     "GLIS_1D" ),
                false ) );
    };

    /**
     * @brief Get name link to the class
     * @return name
     */
    static std::string getName() { return "CZM_LAB_MIX"; };

    /**
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return true; };
};

/** @typedef Pointeur intelligent vers un comportement materiau CzmLabMix */
typedef boost::shared_ptr< CzmLabMixMaterialPropertyClass > CzmLabMixMaterialPropertyPtr;

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
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return false; };

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
     * @brief To know if a MaterialProperty has ConvertibleValues
     */
    static bool hasConvertibleValues() { return false; };

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
