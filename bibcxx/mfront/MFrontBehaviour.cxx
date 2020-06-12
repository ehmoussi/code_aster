/* -------------------------------------------------------------------- */
/* Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org             */
/* This file is part of code_aster.                                     */
/*                                                                      */
/* code_aster is free software: you can redistribute it and/or modify   */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or    */
/* (at your option) any later version.                                  */
/*                                                                      */
/* code_aster is distributed in the hope that it will be useful,        */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        */
/* GNU General Public License for more details.                         */
/*                                                                      */
/* You should have received a copy of the GNU General Public License    */
/* along with code_aster.  If not, see <http://www.gnu.org/licenses/>.  */
/* -------------------------------------------------------------------- */

#include <string>
#include <vector>
#include <stdexcept>
#include <algorithm>

#include <stdlib.h>
#include <string.h>

#include "astercxx.h"
#include "asterc_config.h"
#include "MFrontBehaviour.h"


/* Constructor */
MFrontBehaviour::MFrontBehaviour( std::string hypo, std::string lib, std::string behav )
    : _hypothesis( hypo ), _libname( lib ), _bname( behav ), _mpnames_computed( false ) {
    // empty
}

/* Destructor */
MFrontBehaviour::~MFrontBehaviour() {
    // empty
}

VectorString MFrontBehaviour::getMaterialPropertiesNames() {
    if ( !_mpnames_computed ) {
        fillMaterialPropertiesNames();
    }
    return _mpnames;
}

/* private members */
void MFrontBehaviour::fillMaterialPropertiesNames() {
    using tfel::system::ExternalLibraryManager;

    ExternalLibraryManager &elm = ExternalLibraryManager::getExternalLibraryManager();
    _mpnames = elm.getUMATMaterialPropertiesNames( _libname, _bname, _hypothesis );
    bool eo = elm.getUMATRequiresStiffnessTensor( _libname, _bname, _hypothesis );
    bool to = elm.getUMATRequiresThermalExpansionCoefficientTensor( _libname, _bname, _hypothesis );
    unsigned short etype = elm.getUMATElasticSymmetryType( _libname, _bname );
    VectorString tmp;
    if ( etype == 0u ) {
        if ( eo ) {
            tmp.push_back( "YoungModulus" );
            tmp.push_back( "PoissonRatio" );
        }
        if ( to ) {
            tmp.push_back( "ThermalExpansion" );
        }
    } else if ( etype == 1u ) {
        if ( _hypothesis == "AxisymmetricalGeneralisedPlaneStrain" ) {
            if ( eo ) {
                tmp.push_back( "YoungModulus1" );
                tmp.push_back( "YoungModulus2" );
                tmp.push_back( "YoungModulus3" );
                tmp.push_back( "PoissonRatio12" );
                tmp.push_back( "PoissonRatio23" );
                tmp.push_back( "PoissonRatio13" );
            }
            if ( to ) {
                tmp.push_back( "ThermalExpansion1" );
                tmp.push_back( "ThermalExpansion2" );
                tmp.push_back( "ThermalExpansion3" );
            }
        } else if ( ( _hypothesis == "PlaneStress" ) || ( _hypothesis == "PlaneStrain" ) ||
                    ( _hypothesis == "Axisymmetrical" ) ||
                    ( _hypothesis == "GeneralisedPlaneStrain" ) ) {
            if ( eo ) {
                tmp.push_back( "YoungModulus1" );
                tmp.push_back( "YoungModulus2" );
                tmp.push_back( "YoungModulus3" );
                tmp.push_back( "PoissonRatio12" );
                tmp.push_back( "PoissonRatio23" );
                tmp.push_back( "PoissonRatio13" );
                tmp.push_back( "ShearModulus12" );
            }
            if ( to ) {
                tmp.push_back( "ThermalExpansion1" );
                tmp.push_back( "ThermalExpansion2" );
                tmp.push_back( "ThermalExpansion3" );
            }
        } else if ( _hypothesis == "Tridimensional" ) {
            if ( eo ) {
                tmp.push_back( "YoungModulus1" );
                tmp.push_back( "YoungModulus2" );
                tmp.push_back( "YoungModulus3" );
                tmp.push_back( "PoissonRatio12" );
                tmp.push_back( "PoissonRatio23" );
                tmp.push_back( "PoissonRatio13" );
                tmp.push_back( "ShearModulus12" );
                tmp.push_back( "ShearModulus23" );
                tmp.push_back( "ShearModulus13" );
            }
            if ( to ) {
                tmp.push_back( "ThermalExpansion1" );
                tmp.push_back( "ThermalExpansion2" );
                tmp.push_back( "ThermalExpansion3" );
            }
        } else {
            std::string msg( "MFrontBehaviour::fillMaterialPropertiesNames : "
                        "unsupported modelling hypothesis" );
            throw std::runtime_error( msg );
        }
    } else {
        std::string msg( "MFrontBehaviour::fillMaterialPropertiesNames : "
                    "unsupported behaviour type "
                    "(neither isotropic nor orthotropic)" );
        throw std::runtime_error( msg );
    }
    _mpnames.insert( _mpnames.begin(), tmp.begin(), tmp.end() );
    _mpnames_computed = true;
}

std::string toAsterParameter( const std::string &param ) {
    std::string buff;
    for ( std::string::const_iterator it = param.begin(); it != param.end(); ++it ) {
        if ( *it == '[' ) {
            buff.push_back( '_' );
        } else if ( *it != ']' ) {
            buff.push_back( *it );
        }
    }
    return buff;
}

VectorString toAsterParameterVect( const VectorString &svect ) {
    VectorString res;
    for ( VectorString::const_iterator it = svect.begin(); it != svect.end(); ++it ) {
        res.push_back( toAsterParameter( *it ) );
    }
    return res;
}

char **vectorOfStringsAsCharArray( const VectorString &svect, unsigned int *size ) {
    char **res;
    *size = (unsigned int)( svect.size() );
    res = (char **)malloc( (size_t)*size * sizeof( char * ) );
    for ( unsigned int i = 0; i < *size; ++i ) {
        res[i] = (char *)malloc( ( (size_t)svect[i].size() + 1 ) * sizeof( char ) );
        strcpy( res[i], svect[i].c_str() );
    }
    return res;
}

/* for a simple C access */
char **getMaterialPropertiesNames( const char *hyp, const char *lib, const char *funct,
                                   unsigned int *size ) {
    char **res;

    MFrontBehaviour behaviour( hyp, lib, funct );
    VectorString names = behaviour.getMaterialPropertiesNames();
    VectorString conv = toAsterParameterVect( names );
    res = vectorOfStringsAsCharArray( conv, size );
    return res;
}

char **getTridimMaterialPropertiesNames( const char *behav, unsigned int *size ) {
    char **res;
    std::string bname( behav );
    transform( bname.begin(), bname.end(), bname.begin(), ::tolower );
    bname.insert( 0, "aster" );

    MFrontBehaviour behaviour( "Tridimensional", "lib" + std::string( ASTERBEHAVIOUR ) + ".so",
                               bname.c_str() );
    VectorString names = behaviour.getMaterialPropertiesNames();
    VectorString conv = toAsterParameterVect( names );
    res = vectorOfStringsAsCharArray( conv, size );
    return res;
}
