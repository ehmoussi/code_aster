/**
 * @file MaterialBehaviourInterface.cxx
 * @brief Interface python de MaterialBehaviour
 * @author Nicolas Sellenet
 * @section LICENCE
 *   Copyright (C) 1991 - 2017  EDF R&D                www.code-aster.org
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

#include "PythonBindings/MaterialBehaviourInterface.h"
#include "PythonBindings/SharedPtrUtilities.h"
#include <boost/python.hpp>

void exportMaterialBehaviourToPython()
{
    using namespace boost::python;

    class_< GeneralMaterialBehaviourInstance,
            GeneralMaterialBehaviourPtr > ( "GeneralMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< GeneralMaterialBehaviourInstance > )
        .staticmethod( "create" )
        .def( "getAsterName", &GeneralMaterialBehaviourInstance::getAsterName )
        .def( "setDoubleValue", &GeneralMaterialBehaviourInstance::setDoubleValue )
    ;

    class_< ElasMaterialBehaviourInstance, ElasMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasFoMaterialBehaviourInstance, ElasFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasFluiMaterialBehaviourInstance, ElasFluiMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasFluiMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasFluiMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasIstrMaterialBehaviourInstance, ElasIstrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasIstrMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasIstrMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasIstrFoMaterialBehaviourInstance, ElasIstrFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasIstrFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasIstrFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasOrthMaterialBehaviourInstance, ElasOrthMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasOrthMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasOrthMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasOrthFoMaterialBehaviourInstance, ElasOrthFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasOrthFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasOrthFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasHyperMaterialBehaviourInstance, ElasHyperMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasHyperMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasHyperMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasCoqueMaterialBehaviourInstance, ElasCoqueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasCoqueMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasCoqueMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasCoqueFoMaterialBehaviourInstance, ElasCoqueFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasCoqueFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasCoqueFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasMembraneMaterialBehaviourInstance, ElasMembraneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMembraneMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasMembraneMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< Elas2ndgMaterialBehaviourInstance, Elas2ndgMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Elas2ndgMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< Elas2ndgMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasGlrcMaterialBehaviourInstance, ElasGlrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasGlrcMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasGlrcMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasGlrcFoMaterialBehaviourInstance, ElasGlrcFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasGlrcFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasGlrcFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasDhrcMaterialBehaviourInstance, ElasDhrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasDhrcMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasDhrcMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CableMaterialBehaviourInstance, CableMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CableMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CableMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< VeriBorneMaterialBehaviourInstance, VeriBorneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VeriBorneMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< VeriBorneMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TractionMaterialBehaviourInstance, TractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TractionMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TractionMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EcroLineMaterialBehaviourInstance, EcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroLineMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EcroLineMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EndoHeterogeneMaterialBehaviourInstance, EndoHeterogeneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoHeterogeneMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EndoHeterogeneMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EcroLineFoMaterialBehaviourInstance, EcroLineFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroLineFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EcroLineFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EcroPuisMaterialBehaviourInstance, EcroPuisMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroPuisMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EcroPuisMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EcroPuisFoMaterialBehaviourInstance, EcroPuisFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroPuisFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EcroPuisFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EcroCookMaterialBehaviourInstance, EcroCookMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroCookMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EcroCookMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EcroCookFoMaterialBehaviourInstance, EcroCookFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroCookFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EcroCookFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BetonEcroLineMaterialBehaviourInstance, BetonEcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonEcroLineMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BetonEcroLineMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BetonReglePrMaterialBehaviourInstance, BetonReglePrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonReglePrMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BetonReglePrMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EndoOrthBetonMaterialBehaviourInstance, EndoOrthBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoOrthBetonMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EndoOrthBetonMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< PragerMaterialBehaviourInstance, PragerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PragerMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< PragerMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< PragerFoMaterialBehaviourInstance, PragerFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PragerFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< PragerFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TaheriMaterialBehaviourInstance, TaheriMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TaheriMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TaheriMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TaheriFoMaterialBehaviourInstance, TaheriFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TaheriFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TaheriFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< RousselierMaterialBehaviourInstance, RousselierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RousselierMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< RousselierMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< RousselierFoMaterialBehaviourInstance, RousselierFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RousselierFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< RousselierFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscSinhMaterialBehaviourInstance, ViscSinhMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscSinhMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscSinhMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscSinhFoMaterialBehaviourInstance, ViscSinhFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscSinhFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscSinhFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< Cin1ChabMaterialBehaviourInstance, Cin1ChabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin1ChabMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< Cin1ChabMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< Cin1ChabFoMaterialBehaviourInstance, Cin1ChabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin1ChabFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< Cin1ChabFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< Cin2ChabMaterialBehaviourInstance, Cin2ChabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin2ChabMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< Cin2ChabMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< Cin2ChabFoMaterialBehaviourInstance, Cin2ChabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin2ChabFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< Cin2ChabFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< Cin2NradMaterialBehaviourInstance, Cin2NradMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin2NradMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< Cin2NradMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MemoEcroMaterialBehaviourInstance, MemoEcroMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MemoEcroMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MemoEcroMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MemoEcroFoMaterialBehaviourInstance, MemoEcroFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MemoEcroFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MemoEcroFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscochabMaterialBehaviourInstance, ViscochabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscochabMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscochabMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscochabFoMaterialBehaviourInstance, ViscochabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscochabFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscochabFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LemaitreMaterialBehaviourInstance, LemaitreMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaitreMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LemaitreMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LemaitreIrraMaterialBehaviourInstance, LemaitreIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaitreIrraMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LemaitreIrraMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LmarcIrraMaterialBehaviourInstance, LmarcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LmarcIrraMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LmarcIrraMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscIrraLogMaterialBehaviourInstance, ViscIrraLogMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscIrraLogMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscIrraLogMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< GranIrraLogMaterialBehaviourInstance, GranIrraLogMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GranIrraLogMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< GranIrraLogMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LemaSeuilMaterialBehaviourInstance, LemaSeuilMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaSeuilMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LemaSeuilMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LemaSeuilFoMaterialBehaviourInstance, LemaSeuilFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaSeuilFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LemaSeuilFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< Irrad3mMaterialBehaviourInstance, Irrad3mMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Irrad3mMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< Irrad3mMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LemaitreFoMaterialBehaviourInstance, LemaitreFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaitreFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LemaitreFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaLemaAniMaterialBehaviourInstance, MetaLemaAniMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaLemaAniMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaLemaAniMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaLemaAniFoMaterialBehaviourInstance, MetaLemaAniFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaLemaAniFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaLemaAniFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ArmeMaterialBehaviourInstance, ArmeMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ArmeMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ArmeMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< AsseCornMaterialBehaviourInstance, AsseCornMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "AsseCornMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< AsseCornMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DisContactMaterialBehaviourInstance, DisContactMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisContactMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DisContactMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EndoScalaireMaterialBehaviourInstance, EndoScalaireMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoScalaireMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EndoScalaireMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EndoScalaireFoMaterialBehaviourInstance, EndoScalaireFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoScalaireFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EndoScalaireFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EndoFissExpMaterialBehaviourInstance, EndoFissExpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoFissExpMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EndoFissExpMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EndoFissExpFoMaterialBehaviourInstance, EndoFissExpFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoFissExpFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EndoFissExpFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DisGricraMaterialBehaviourInstance, DisGricraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisGricraMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DisGricraMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BetonDoubleDpMaterialBehaviourInstance, BetonDoubleDpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonDoubleDpMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BetonDoubleDpMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MazarsMaterialBehaviourInstance, MazarsMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MazarsMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MazarsMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MazarsFoMaterialBehaviourInstance, MazarsFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MazarsFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MazarsFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< JointBaMaterialBehaviourInstance, JointBaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointBaMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< JointBaMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< VendochabMaterialBehaviourInstance, VendochabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VendochabMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< VendochabMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< VendochabFoMaterialBehaviourInstance, VendochabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VendochabFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< VendochabFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< HayhurstMaterialBehaviourInstance, HayhurstMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "HayhurstMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< HayhurstMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscEndoMaterialBehaviourInstance, ViscEndoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscEndoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscEndoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscEndoFoMaterialBehaviourInstance, ViscEndoFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscEndoFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscEndoFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< PintoMenegottoMaterialBehaviourInstance, PintoMenegottoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PintoMenegottoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< PintoMenegottoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BpelBetonMaterialBehaviourInstance, BpelBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BpelBetonMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BpelBetonMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BpelAcierMaterialBehaviourInstance, BpelAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BpelAcierMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BpelAcierMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EtccBetonMaterialBehaviourInstance, EtccBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EtccBetonMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EtccBetonMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EtccAcierMaterialBehaviourInstance, EtccAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EtccAcierMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EtccAcierMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MohrCoulombMaterialBehaviourInstance, MohrCoulombMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MohrCoulombMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MohrCoulombMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CamClayMaterialBehaviourInstance, CamClayMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CamClayMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CamClayMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BarceloneMaterialBehaviourInstance, BarceloneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BarceloneMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BarceloneMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CjsMaterialBehaviourInstance, CjsMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CjsMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CjsMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< HujeuxMaterialBehaviourInstance, HujeuxMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "HujeuxMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< HujeuxMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< EcroAsymLineMaterialBehaviourInstance, EcroAsymLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroAsymLineMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< EcroAsymLineMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< GrangerFpMaterialBehaviourInstance, GrangerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GrangerFpMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< GrangerFpMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< GrangerFp_indtMaterialBehaviourInstance, GrangerFp_indtMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GrangerFp_indtMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< GrangerFp_indtMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< VGrangerFpMaterialBehaviourInstance, VGrangerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VGrangerFpMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< VGrangerFpMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BetonBurgerFpMaterialBehaviourInstance, BetonBurgerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonBurgerFpMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BetonBurgerFpMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BetonUmlvFpMaterialBehaviourInstance, BetonUmlvFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonUmlvFpMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BetonUmlvFpMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< BetonRagMaterialBehaviourInstance, BetonRagMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonRagMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< BetonRagMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< PoroBetonMaterialBehaviourInstance, PoroBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PoroBetonMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< PoroBetonMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< GlrcDmMaterialBehaviourInstance, GlrcDmMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GlrcDmMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< GlrcDmMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DhrcMaterialBehaviourInstance, DhrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DhrcMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DhrcMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< GattMonerieMaterialBehaviourInstance, GattMonerieMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GattMonerieMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< GattMonerieMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CorrAcierMaterialBehaviourInstance, CorrAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CorrAcierMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CorrAcierMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CableGaineFrotMaterialBehaviourInstance, CableGaineFrotMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CableGaineFrotMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CableGaineFrotMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DisEcroCineMaterialBehaviourInstance, DisEcroCineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisEcroCineMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DisEcroCineMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DisViscMaterialBehaviourInstance, DisViscMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisViscMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DisViscMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DisBiliElasMaterialBehaviourInstance, DisBiliElasMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisBiliElasMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DisBiliElasMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TherNlMaterialBehaviourInstance, TherNlMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherNlMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TherNlMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TherHydrMaterialBehaviourInstance, TherHydrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherHydrMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TherHydrMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TherMaterialBehaviourInstance, TherMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TherMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TherFoMaterialBehaviourInstance, TherFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TherFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TherOrthMaterialBehaviourInstance, TherOrthMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherOrthMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TherOrthMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TherCoqueMaterialBehaviourInstance, TherCoqueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherCoqueMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TherCoqueMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< TherCoqueFoMaterialBehaviourInstance, TherCoqueFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherCoqueFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< TherCoqueFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< SechGrangerMaterialBehaviourInstance, SechGrangerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechGrangerMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< SechGrangerMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< SechMensiMaterialBehaviourInstance, SechMensiMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechMensiMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< SechMensiMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< SechBazantMaterialBehaviourInstance, SechBazantMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechBazantMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< SechBazantMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< SechNappeMaterialBehaviourInstance, SechNappeMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechNappeMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< SechNappeMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaAcierMaterialBehaviourInstance, MetaAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaAcierMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaAcierMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaZircMaterialBehaviourInstance, MetaZircMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaZircMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaZircMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DurtMetaMaterialBehaviourInstance, DurtMetaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DurtMetaMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DurtMetaMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasMetaMaterialBehaviourInstance, ElasMetaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMetaMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasMetaMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasMetaFoMaterialBehaviourInstance, ElasMetaFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMetaFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasMetaFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaEcroLineMaterialBehaviourInstance, MetaEcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaEcroLineMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaEcroLineMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaTractionMaterialBehaviourInstance, MetaTractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaTractionMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaTractionMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaViscFoMaterialBehaviourInstance, MetaViscFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaViscFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaViscFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaPtMaterialBehaviourInstance, MetaPtMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaPtMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaPtMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MetaReMaterialBehaviourInstance, MetaReMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaReMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MetaReMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< FluideMaterialBehaviourInstance, FluideMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "FluideMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< FluideMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ThmGazMaterialBehaviourInstance, ThmGazMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmGazMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ThmGazMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ThmVapeGazMaterialBehaviourInstance, ThmVapeGazMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmVapeGazMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ThmVapeGazMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ThmLiquMaterialBehaviourInstance, ThmLiquMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmLiquMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ThmLiquMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< FatigueMaterialBehaviourInstance, FatigueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "FatigueMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< FatigueMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DommaLemaitreMaterialBehaviourInstance, DommaLemaitreMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DommaLemaitreMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DommaLemaitreMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CisaPlanCritMaterialBehaviourInstance, CisaPlanCritMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CisaPlanCritMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CisaPlanCritMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ThmRuptMaterialBehaviourInstance, ThmRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmRuptMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ThmRuptMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< WeibullMaterialBehaviourInstance, WeibullMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "WeibullMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< WeibullMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< WeibullFoMaterialBehaviourInstance, WeibullFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "WeibullFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< WeibullFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< NonLocalMaterialBehaviourInstance, NonLocalMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "NonLocalMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< NonLocalMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< RuptFragMaterialBehaviourInstance, RuptFragMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RuptFragMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< RuptFragMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< RuptFragFoMaterialBehaviourInstance, RuptFragFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RuptFragFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< RuptFragFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CzmLabMixMaterialBehaviourInstance, CzmLabMixMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CzmLabMixMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CzmLabMixMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< RuptDuctMaterialBehaviourInstance, RuptDuctMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RuptDuctMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< RuptDuctMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< JointMecaRuptMaterialBehaviourInstance, JointMecaRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointMecaRuptMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< JointMecaRuptMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< JointMecaFrotMaterialBehaviourInstance, JointMecaFrotMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointMecaFrotMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< JointMecaFrotMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< RccmMaterialBehaviourInstance, RccmMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RccmMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< RccmMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< RccmFoMaterialBehaviourInstance, RccmFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RccmFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< RccmFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LaigleMaterialBehaviourInstance, LaigleMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LaigleMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LaigleMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< LetkMaterialBehaviourInstance, LetkMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LetkMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< LetkMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DruckPragerMaterialBehaviourInstance, DruckPragerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DruckPragerMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DruckPragerMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< DruckPragerFoMaterialBehaviourInstance, DruckPragerFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DruckPragerFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< DruckPragerFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ViscDrucPragMaterialBehaviourInstance, ViscDrucPragMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscDrucPragMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ViscDrucPragMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< HoekBrownMaterialBehaviourInstance, HoekBrownMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "HoekBrownMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< HoekBrownMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< ElasGonfMaterialBehaviourInstance, ElasGonfMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasGonfMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< ElasGonfMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< JointBandisMaterialBehaviourInstance, JointBandisMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointBandisMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< JointBandisMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoVisc1MaterialBehaviourInstance, MonoVisc1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoVisc1MaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoVisc1MaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoVisc2MaterialBehaviourInstance, MonoVisc2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoVisc2MaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoVisc2MaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoIsot1MaterialBehaviourInstance, MonoIsot1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoIsot1MaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoIsot1MaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoIsot2MaterialBehaviourInstance, MonoIsot2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoIsot2MaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoIsot2MaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoCine1MaterialBehaviourInstance, MonoCine1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoCine1MaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoCine1MaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoCine2MaterialBehaviourInstance, MonoCine2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoCine2MaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoCine2MaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoDdKrMaterialBehaviourInstance, MonoDdKrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdKrMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoDdKrMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoDdCfcMaterialBehaviourInstance, MonoDdCfcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCfcMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoDdCfcMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoDdCfcIrraMaterialBehaviourInstance, MonoDdCfcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCfcIrraMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoDdCfcIrraMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoDdFatMaterialBehaviourInstance, MonoDdFatMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdFatMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoDdFatMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoDdCcMaterialBehaviourInstance, MonoDdCcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCcMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoDdCcMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< MonoDdCcIrraMaterialBehaviourInstance, MonoDdCcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCcIrraMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< MonoDdCcIrraMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< UmatMaterialBehaviourInstance, UmatMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "UmatMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< UmatMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< UmatFoMaterialBehaviourInstance, UmatFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "UmatFoMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< UmatFoMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;

    class_< CritRuptMaterialBehaviourInstance, CritRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CritRuptMaterialBehaviour", no_init )
        .def( "create", &createSharedPtr< CritRuptMaterialBehaviourInstance > )
        .staticmethod( "create" )
    ;
};
