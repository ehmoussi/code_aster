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
#include "PythonBindings/factory.h"
#include <boost/python.hpp>

void exportMaterialBehaviourToPython()
{
    using namespace boost::python;

    class_< GeneralMaterialBehaviourInstance,
            GeneralMaterialBehaviourPtr > ( "GeneralMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< GeneralMaterialBehaviourInstance > ) )
        .def( "getAsterName", &GeneralMaterialBehaviourInstance::getAsterName )
        .def( "setDoubleValue", &GeneralMaterialBehaviourInstance::setDoubleValue )
        .def( "setTableValue", &GeneralMaterialBehaviourInstance::setTableValue )
    ;

    class_< ElasMaterialBehaviourInstance, ElasMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasMaterialBehaviourInstance > ) )
    ;

    class_< ElasFoMaterialBehaviourInstance, ElasFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasFoMaterialBehaviourInstance > ) )
    ;

    class_< ElasFluiMaterialBehaviourInstance, ElasFluiMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasFluiMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasFluiMaterialBehaviourInstance > ) )
    ;

    class_< ElasIstrMaterialBehaviourInstance, ElasIstrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasIstrMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasIstrMaterialBehaviourInstance > ) )
    ;

    class_< ElasIstrFoMaterialBehaviourInstance, ElasIstrFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasIstrFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasIstrFoMaterialBehaviourInstance > ) )
    ;

    class_< ElasOrthMaterialBehaviourInstance, ElasOrthMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasOrthMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasOrthMaterialBehaviourInstance > ) )
    ;

    class_< ElasOrthFoMaterialBehaviourInstance, ElasOrthFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasOrthFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasOrthFoMaterialBehaviourInstance > ) )
    ;

    class_< ElasHyperMaterialBehaviourInstance, ElasHyperMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasHyperMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasHyperMaterialBehaviourInstance > ) )
    ;

    class_< ElasCoqueMaterialBehaviourInstance, ElasCoqueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasCoqueMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasCoqueMaterialBehaviourInstance > ) )
    ;

    class_< ElasCoqueFoMaterialBehaviourInstance, ElasCoqueFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasCoqueFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasCoqueFoMaterialBehaviourInstance > ) )
    ;

    class_< ElasMembraneMaterialBehaviourInstance, ElasMembraneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMembraneMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasMembraneMaterialBehaviourInstance > ) )
    ;

    class_< Elas2ndgMaterialBehaviourInstance, Elas2ndgMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Elas2ndgMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< Elas2ndgMaterialBehaviourInstance > ) )
    ;

    class_< ElasGlrcMaterialBehaviourInstance, ElasGlrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasGlrcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasGlrcMaterialBehaviourInstance > ) )
    ;

    class_< ElasGlrcFoMaterialBehaviourInstance, ElasGlrcFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasGlrcFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasGlrcFoMaterialBehaviourInstance > ) )
    ;

    class_< ElasDhrcMaterialBehaviourInstance, ElasDhrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasDhrcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasDhrcMaterialBehaviourInstance > ) )
    ;

    class_< CableMaterialBehaviourInstance, CableMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CableMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CableMaterialBehaviourInstance > ) )
    ;

    class_< VeriBorneMaterialBehaviourInstance, VeriBorneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VeriBorneMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< VeriBorneMaterialBehaviourInstance > ) )
    ;

    class_< TractionMaterialBehaviourInstance, TractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TractionMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TractionMaterialBehaviourInstance > ) )
    ;

    class_< EcroLineMaterialBehaviourInstance, EcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroLineMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EcroLineMaterialBehaviourInstance > ) )
    ;

    class_< EndoHeterogeneMaterialBehaviourInstance, EndoHeterogeneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoHeterogeneMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EndoHeterogeneMaterialBehaviourInstance > ) )
    ;

    class_< EcroLineFoMaterialBehaviourInstance, EcroLineFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroLineFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EcroLineFoMaterialBehaviourInstance > ) )
    ;

    class_< EcroPuisMaterialBehaviourInstance, EcroPuisMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroPuisMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EcroPuisMaterialBehaviourInstance > ) )
    ;

    class_< EcroPuisFoMaterialBehaviourInstance, EcroPuisFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroPuisFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EcroPuisFoMaterialBehaviourInstance > ) )
    ;

    class_< EcroCookMaterialBehaviourInstance, EcroCookMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroCookMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EcroCookMaterialBehaviourInstance > ) )
    ;

    class_< EcroCookFoMaterialBehaviourInstance, EcroCookFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroCookFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EcroCookFoMaterialBehaviourInstance > ) )
    ;

    class_< BetonEcroLineMaterialBehaviourInstance, BetonEcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonEcroLineMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BetonEcroLineMaterialBehaviourInstance > ) )
    ;

    class_< BetonReglePrMaterialBehaviourInstance, BetonReglePrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonReglePrMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BetonReglePrMaterialBehaviourInstance > ) )
    ;

    class_< EndoOrthBetonMaterialBehaviourInstance, EndoOrthBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoOrthBetonMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EndoOrthBetonMaterialBehaviourInstance > ) )
    ;

    class_< PragerMaterialBehaviourInstance, PragerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PragerMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< PragerMaterialBehaviourInstance > ) )
    ;

    class_< PragerFoMaterialBehaviourInstance, PragerFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PragerFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< PragerFoMaterialBehaviourInstance > ) )
    ;

    class_< TaheriMaterialBehaviourInstance, TaheriMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TaheriMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TaheriMaterialBehaviourInstance > ) )
    ;

    class_< TaheriFoMaterialBehaviourInstance, TaheriFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TaheriFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TaheriFoMaterialBehaviourInstance > ) )
    ;

    class_< RousselierMaterialBehaviourInstance, RousselierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RousselierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< RousselierMaterialBehaviourInstance > ) )
    ;

    class_< RousselierFoMaterialBehaviourInstance, RousselierFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RousselierFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< RousselierFoMaterialBehaviourInstance > ) )
    ;

    class_< ViscSinhMaterialBehaviourInstance, ViscSinhMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscSinhMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscSinhMaterialBehaviourInstance > ) )
    ;

    class_< ViscSinhFoMaterialBehaviourInstance, ViscSinhFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscSinhFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscSinhFoMaterialBehaviourInstance > ) )
    ;

    class_< Cin1ChabMaterialBehaviourInstance, Cin1ChabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin1ChabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< Cin1ChabMaterialBehaviourInstance > ) )
    ;

    class_< Cin1ChabFoMaterialBehaviourInstance, Cin1ChabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin1ChabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< Cin1ChabFoMaterialBehaviourInstance > ) )
    ;

    class_< Cin2ChabMaterialBehaviourInstance, Cin2ChabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin2ChabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< Cin2ChabMaterialBehaviourInstance > ) )
    ;

    class_< Cin2ChabFoMaterialBehaviourInstance, Cin2ChabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin2ChabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< Cin2ChabFoMaterialBehaviourInstance > ) )
    ;

    class_< Cin2NradMaterialBehaviourInstance, Cin2NradMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Cin2NradMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< Cin2NradMaterialBehaviourInstance > ) )
    ;

    class_< MemoEcroMaterialBehaviourInstance, MemoEcroMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MemoEcroMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MemoEcroMaterialBehaviourInstance > ) )
    ;

    class_< MemoEcroFoMaterialBehaviourInstance, MemoEcroFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MemoEcroFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MemoEcroFoMaterialBehaviourInstance > ) )
    ;

    class_< ViscochabMaterialBehaviourInstance, ViscochabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscochabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscochabMaterialBehaviourInstance > ) )
    ;

    class_< ViscochabFoMaterialBehaviourInstance, ViscochabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscochabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscochabFoMaterialBehaviourInstance > ) )
    ;

    class_< LemaitreMaterialBehaviourInstance, LemaitreMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaitreMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LemaitreMaterialBehaviourInstance > ) )
    ;

    class_< LemaitreIrraMaterialBehaviourInstance, LemaitreIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaitreIrraMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LemaitreIrraMaterialBehaviourInstance > ) )
    ;

    class_< LmarcIrraMaterialBehaviourInstance, LmarcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LmarcIrraMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LmarcIrraMaterialBehaviourInstance > ) )
    ;

    class_< ViscIrraLogMaterialBehaviourInstance, ViscIrraLogMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscIrraLogMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscIrraLogMaterialBehaviourInstance > ) )
    ;

    class_< GranIrraLogMaterialBehaviourInstance, GranIrraLogMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GranIrraLogMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< GranIrraLogMaterialBehaviourInstance > ) )
    ;

    class_< LemaSeuilMaterialBehaviourInstance, LemaSeuilMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaSeuilMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LemaSeuilMaterialBehaviourInstance > ) )
    ;

    class_< LemaSeuilFoMaterialBehaviourInstance, LemaSeuilFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaSeuilFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LemaSeuilFoMaterialBehaviourInstance > ) )
    ;

    class_< Irrad3mMaterialBehaviourInstance, Irrad3mMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "Irrad3mMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< Irrad3mMaterialBehaviourInstance > ) )
    ;

    class_< LemaitreFoMaterialBehaviourInstance, LemaitreFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LemaitreFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LemaitreFoMaterialBehaviourInstance > ) )
    ;

    class_< MetaLemaAniMaterialBehaviourInstance, MetaLemaAniMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaLemaAniMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaLemaAniMaterialBehaviourInstance > ) )
    ;

    class_< MetaLemaAniFoMaterialBehaviourInstance, MetaLemaAniFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaLemaAniFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaLemaAniFoMaterialBehaviourInstance > ) )
    ;

    class_< ArmeMaterialBehaviourInstance, ArmeMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ArmeMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ArmeMaterialBehaviourInstance > ) )
    ;

    class_< AsseCornMaterialBehaviourInstance, AsseCornMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "AsseCornMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< AsseCornMaterialBehaviourInstance > ) )
    ;

    class_< DisContactMaterialBehaviourInstance, DisContactMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisContactMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DisContactMaterialBehaviourInstance > ) )
    ;

    class_< EndoScalaireMaterialBehaviourInstance, EndoScalaireMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoScalaireMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EndoScalaireMaterialBehaviourInstance > ) )
    ;

    class_< EndoScalaireFoMaterialBehaviourInstance, EndoScalaireFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoScalaireFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EndoScalaireFoMaterialBehaviourInstance > ) )
    ;

    class_< EndoFissExpMaterialBehaviourInstance, EndoFissExpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoFissExpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EndoFissExpMaterialBehaviourInstance > ) )
    ;

    class_< EndoFissExpFoMaterialBehaviourInstance, EndoFissExpFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EndoFissExpFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EndoFissExpFoMaterialBehaviourInstance > ) )
    ;

    class_< DisGricraMaterialBehaviourInstance, DisGricraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisGricraMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DisGricraMaterialBehaviourInstance > ) )
    ;

    class_< BetonDoubleDpMaterialBehaviourInstance, BetonDoubleDpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonDoubleDpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BetonDoubleDpMaterialBehaviourInstance > ) )
    ;

    class_< MazarsMaterialBehaviourInstance, MazarsMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MazarsMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MazarsMaterialBehaviourInstance > ) )
    ;

    class_< MazarsFoMaterialBehaviourInstance, MazarsFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MazarsFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MazarsFoMaterialBehaviourInstance > ) )
    ;

    class_< JointBaMaterialBehaviourInstance, JointBaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointBaMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< JointBaMaterialBehaviourInstance > ) )
    ;

    class_< VendochabMaterialBehaviourInstance, VendochabMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VendochabMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< VendochabMaterialBehaviourInstance > ) )
    ;

    class_< VendochabFoMaterialBehaviourInstance, VendochabFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VendochabFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< VendochabFoMaterialBehaviourInstance > ) )
    ;

    class_< HayhurstMaterialBehaviourInstance, HayhurstMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "HayhurstMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< HayhurstMaterialBehaviourInstance > ) )
    ;

    class_< ViscEndoMaterialBehaviourInstance, ViscEndoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscEndoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscEndoMaterialBehaviourInstance > ) )
    ;

    class_< ViscEndoFoMaterialBehaviourInstance, ViscEndoFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscEndoFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscEndoFoMaterialBehaviourInstance > ) )
    ;

    class_< PintoMenegottoMaterialBehaviourInstance, PintoMenegottoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PintoMenegottoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< PintoMenegottoMaterialBehaviourInstance > ) )
    ;

    class_< BpelBetonMaterialBehaviourInstance, BpelBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BpelBetonMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BpelBetonMaterialBehaviourInstance > ) )
    ;

    class_< BpelAcierMaterialBehaviourInstance, BpelAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BpelAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BpelAcierMaterialBehaviourInstance > ) )
    ;

    class_< EtccBetonMaterialBehaviourInstance, EtccBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EtccBetonMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EtccBetonMaterialBehaviourInstance > ) )
    ;

    class_< EtccAcierMaterialBehaviourInstance, EtccAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EtccAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EtccAcierMaterialBehaviourInstance > ) )
    ;

    class_< MohrCoulombMaterialBehaviourInstance, MohrCoulombMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MohrCoulombMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MohrCoulombMaterialBehaviourInstance > ) )
    ;

    class_< CamClayMaterialBehaviourInstance, CamClayMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CamClayMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CamClayMaterialBehaviourInstance > ) )
    ;

    class_< BarceloneMaterialBehaviourInstance, BarceloneMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BarceloneMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BarceloneMaterialBehaviourInstance > ) )
    ;

    class_< CjsMaterialBehaviourInstance, CjsMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CjsMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CjsMaterialBehaviourInstance > ) )
    ;

    class_< HujeuxMaterialBehaviourInstance, HujeuxMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "HujeuxMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< HujeuxMaterialBehaviourInstance > ) )
    ;

    class_< EcroAsymLineMaterialBehaviourInstance, EcroAsymLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "EcroAsymLineMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< EcroAsymLineMaterialBehaviourInstance > ) )
    ;

    class_< GrangerFpMaterialBehaviourInstance, GrangerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GrangerFpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< GrangerFpMaterialBehaviourInstance > ) )
    ;

    class_< GrangerFp_indtMaterialBehaviourInstance, GrangerFp_indtMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GrangerFp_indtMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< GrangerFp_indtMaterialBehaviourInstance > ) )
    ;

    class_< VGrangerFpMaterialBehaviourInstance, VGrangerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "VGrangerFpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< VGrangerFpMaterialBehaviourInstance > ) )
    ;

    class_< BetonBurgerFpMaterialBehaviourInstance, BetonBurgerFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonBurgerFpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BetonBurgerFpMaterialBehaviourInstance > ) )
    ;

    class_< BetonUmlvFpMaterialBehaviourInstance, BetonUmlvFpMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonUmlvFpMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BetonUmlvFpMaterialBehaviourInstance > ) )
    ;

    class_< BetonRagMaterialBehaviourInstance, BetonRagMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "BetonRagMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< BetonRagMaterialBehaviourInstance > ) )
    ;

    class_< PoroBetonMaterialBehaviourInstance, PoroBetonMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "PoroBetonMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< PoroBetonMaterialBehaviourInstance > ) )
    ;

    class_< GlrcDmMaterialBehaviourInstance, GlrcDmMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GlrcDmMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< GlrcDmMaterialBehaviourInstance > ) )
    ;

    class_< DhrcMaterialBehaviourInstance, DhrcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DhrcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DhrcMaterialBehaviourInstance > ) )
    ;

    class_< GattMonerieMaterialBehaviourInstance, GattMonerieMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "GattMonerieMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< GattMonerieMaterialBehaviourInstance > ) )
    ;

    class_< CorrAcierMaterialBehaviourInstance, CorrAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CorrAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CorrAcierMaterialBehaviourInstance > ) )
    ;

    class_< CableGaineFrotMaterialBehaviourInstance, CableGaineFrotMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CableGaineFrotMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CableGaineFrotMaterialBehaviourInstance > ) )
    ;

    class_< DisEcroCineMaterialBehaviourInstance, DisEcroCineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisEcroCineMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DisEcroCineMaterialBehaviourInstance > ) )
    ;

    class_< DisViscMaterialBehaviourInstance, DisViscMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisViscMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DisViscMaterialBehaviourInstance > ) )
    ;

    class_< DisBiliElasMaterialBehaviourInstance, DisBiliElasMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DisBiliElasMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DisBiliElasMaterialBehaviourInstance > ) )
    ;

    class_< TherNlMaterialBehaviourInstance, TherNlMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherNlMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TherNlMaterialBehaviourInstance > ) )
    ;

    class_< TherHydrMaterialBehaviourInstance, TherHydrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherHydrMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TherHydrMaterialBehaviourInstance > ) )
    ;

    class_< TherMaterialBehaviourInstance, TherMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TherMaterialBehaviourInstance > ) )
    ;

    class_< TherFoMaterialBehaviourInstance, TherFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TherFoMaterialBehaviourInstance > ) )
    ;

    class_< TherOrthMaterialBehaviourInstance, TherOrthMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherOrthMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TherOrthMaterialBehaviourInstance > ) )
    ;

    class_< TherCoqueMaterialBehaviourInstance, TherCoqueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherCoqueMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TherCoqueMaterialBehaviourInstance > ) )
    ;

    class_< TherCoqueFoMaterialBehaviourInstance, TherCoqueFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "TherCoqueFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< TherCoqueFoMaterialBehaviourInstance > ) )
    ;

    class_< SechGrangerMaterialBehaviourInstance, SechGrangerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechGrangerMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< SechGrangerMaterialBehaviourInstance > ) )
    ;

    class_< SechMensiMaterialBehaviourInstance, SechMensiMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechMensiMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< SechMensiMaterialBehaviourInstance > ) )
    ;

    class_< SechBazantMaterialBehaviourInstance, SechBazantMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechBazantMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< SechBazantMaterialBehaviourInstance > ) )
    ;

    class_< SechNappeMaterialBehaviourInstance, SechNappeMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "SechNappeMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< SechNappeMaterialBehaviourInstance > ) )
    ;

    class_< MetaAcierMaterialBehaviourInstance, MetaAcierMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaAcierMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaAcierMaterialBehaviourInstance > ) )
    ;

    class_< MetaZircMaterialBehaviourInstance, MetaZircMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaZircMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaZircMaterialBehaviourInstance > ) )
    ;

    class_< DurtMetaMaterialBehaviourInstance, DurtMetaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DurtMetaMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DurtMetaMaterialBehaviourInstance > ) )
    ;

    class_< ElasMetaMaterialBehaviourInstance, ElasMetaMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMetaMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasMetaMaterialBehaviourInstance > ) )
    ;

    class_< ElasMetaFoMaterialBehaviourInstance, ElasMetaFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasMetaFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasMetaFoMaterialBehaviourInstance > ) )
    ;

    class_< MetaEcroLineMaterialBehaviourInstance, MetaEcroLineMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaEcroLineMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaEcroLineMaterialBehaviourInstance > ) )
    ;

    class_< MetaTractionMaterialBehaviourInstance, MetaTractionMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaTractionMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaTractionMaterialBehaviourInstance > ) )
    ;

    class_< MetaViscFoMaterialBehaviourInstance, MetaViscFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaViscFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaViscFoMaterialBehaviourInstance > ) )
    ;

    class_< MetaPtMaterialBehaviourInstance, MetaPtMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaPtMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaPtMaterialBehaviourInstance > ) )
    ;

    class_< MetaReMaterialBehaviourInstance, MetaReMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MetaReMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MetaReMaterialBehaviourInstance > ) )
    ;

    class_< FluideMaterialBehaviourInstance, FluideMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "FluideMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FluideMaterialBehaviourInstance > ) )
    ;

    class_< ThmGazMaterialBehaviourInstance, ThmGazMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmGazMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ThmGazMaterialBehaviourInstance > ) )
    ;

    class_< ThmVapeGazMaterialBehaviourInstance, ThmVapeGazMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmVapeGazMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ThmVapeGazMaterialBehaviourInstance > ) )
    ;

    class_< ThmLiquMaterialBehaviourInstance, ThmLiquMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmLiquMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ThmLiquMaterialBehaviourInstance > ) )
    ;

    class_< FatigueMaterialBehaviourInstance, FatigueMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "FatigueMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< FatigueMaterialBehaviourInstance > ) )
    ;

    class_< DommaLemaitreMaterialBehaviourInstance, DommaLemaitreMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DommaLemaitreMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DommaLemaitreMaterialBehaviourInstance > ) )
    ;

    class_< CisaPlanCritMaterialBehaviourInstance, CisaPlanCritMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CisaPlanCritMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CisaPlanCritMaterialBehaviourInstance > ) )
    ;

    class_< ThmRuptMaterialBehaviourInstance, ThmRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ThmRuptMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ThmRuptMaterialBehaviourInstance > ) )
    ;

    class_< WeibullMaterialBehaviourInstance, WeibullMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "WeibullMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< WeibullMaterialBehaviourInstance > ) )
    ;

    class_< WeibullFoMaterialBehaviourInstance, WeibullFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "WeibullFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< WeibullFoMaterialBehaviourInstance > ) )
    ;

    class_< NonLocalMaterialBehaviourInstance, NonLocalMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "NonLocalMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< NonLocalMaterialBehaviourInstance > ) )
    ;

    class_< RuptFragMaterialBehaviourInstance, RuptFragMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RuptFragMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< RuptFragMaterialBehaviourInstance > ) )
    ;

    class_< RuptFragFoMaterialBehaviourInstance, RuptFragFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RuptFragFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< RuptFragFoMaterialBehaviourInstance > ) )
    ;

    class_< CzmLabMixMaterialBehaviourInstance, CzmLabMixMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CzmLabMixMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CzmLabMixMaterialBehaviourInstance > ) )
    ;

    class_< RuptDuctMaterialBehaviourInstance, RuptDuctMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RuptDuctMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< RuptDuctMaterialBehaviourInstance > ) )
    ;

    class_< JointMecaRuptMaterialBehaviourInstance, JointMecaRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointMecaRuptMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< JointMecaRuptMaterialBehaviourInstance > ) )
    ;

    class_< JointMecaFrotMaterialBehaviourInstance, JointMecaFrotMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointMecaFrotMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< JointMecaFrotMaterialBehaviourInstance > ) )
    ;

    class_< RccmMaterialBehaviourInstance, RccmMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RccmMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< RccmMaterialBehaviourInstance > ) )
    ;

    class_< RccmFoMaterialBehaviourInstance, RccmFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "RccmFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< RccmFoMaterialBehaviourInstance > ) )
    ;

    class_< LaigleMaterialBehaviourInstance, LaigleMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LaigleMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LaigleMaterialBehaviourInstance > ) )
    ;

    class_< LetkMaterialBehaviourInstance, LetkMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "LetkMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< LetkMaterialBehaviourInstance > ) )
    ;

    class_< DruckPragerMaterialBehaviourInstance, DruckPragerMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DruckPragerMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DruckPragerMaterialBehaviourInstance > ) )
    ;

    class_< DruckPragerFoMaterialBehaviourInstance, DruckPragerFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "DruckPragerFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< DruckPragerFoMaterialBehaviourInstance > ) )
    ;

    class_< ViscDrucPragMaterialBehaviourInstance, ViscDrucPragMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ViscDrucPragMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ViscDrucPragMaterialBehaviourInstance > ) )
    ;

    class_< HoekBrownMaterialBehaviourInstance, HoekBrownMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "HoekBrownMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< HoekBrownMaterialBehaviourInstance > ) )
    ;

    class_< ElasGonfMaterialBehaviourInstance, ElasGonfMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "ElasGonfMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< ElasGonfMaterialBehaviourInstance > ) )
    ;

    class_< JointBandisMaterialBehaviourInstance, JointBandisMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "JointBandisMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< JointBandisMaterialBehaviourInstance > ) )
    ;

    class_< MonoVisc1MaterialBehaviourInstance, MonoVisc1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoVisc1MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoVisc1MaterialBehaviourInstance > ) )
    ;

    class_< MonoVisc2MaterialBehaviourInstance, MonoVisc2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoVisc2MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoVisc2MaterialBehaviourInstance > ) )
    ;

    class_< MonoIsot1MaterialBehaviourInstance, MonoIsot1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoIsot1MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoIsot1MaterialBehaviourInstance > ) )
    ;

    class_< MonoIsot2MaterialBehaviourInstance, MonoIsot2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoIsot2MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoIsot2MaterialBehaviourInstance > ) )
    ;

    class_< MonoCine1MaterialBehaviourInstance, MonoCine1MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoCine1MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoCine1MaterialBehaviourInstance > ) )
    ;

    class_< MonoCine2MaterialBehaviourInstance, MonoCine2MaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoCine2MaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoCine2MaterialBehaviourInstance > ) )
    ;

    class_< MonoDdKrMaterialBehaviourInstance, MonoDdKrMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdKrMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoDdKrMaterialBehaviourInstance > ) )
    ;

    class_< MonoDdCfcMaterialBehaviourInstance, MonoDdCfcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCfcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoDdCfcMaterialBehaviourInstance > ) )
    ;

    class_< MonoDdCfcIrraMaterialBehaviourInstance, MonoDdCfcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCfcIrraMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoDdCfcIrraMaterialBehaviourInstance > ) )
    ;

    class_< MonoDdFatMaterialBehaviourInstance, MonoDdFatMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdFatMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoDdFatMaterialBehaviourInstance > ) )
    ;

    class_< MonoDdCcMaterialBehaviourInstance, MonoDdCcMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCcMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoDdCcMaterialBehaviourInstance > ) )
    ;

    class_< MonoDdCcIrraMaterialBehaviourInstance, MonoDdCcIrraMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "MonoDdCcIrraMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< MonoDdCcIrraMaterialBehaviourInstance > ) )
    ;

    class_< UmatMaterialBehaviourInstance, UmatMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "UmatMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< UmatMaterialBehaviourInstance > ) )
    ;

    class_< UmatFoMaterialBehaviourInstance, UmatFoMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "UmatFoMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< UmatFoMaterialBehaviourInstance > ) )
    ;

    class_< CritRuptMaterialBehaviourInstance, CritRuptMaterialBehaviourPtr,
            bases< GeneralMaterialBehaviourInstance > >
        ( "CritRuptMaterialBehaviour", no_init )
        .def( "__init__", make_constructor(
            &initFactoryPtr< CritRuptMaterialBehaviourInstance > ) )
    ;
};
