# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.
from libcpp.string cimport string


cdef extern from "Materials/MaterialBehaviour.h":

    cdef cppclass GeneralMaterialBehaviourInstance:

        GeneralMaterialBehaviourInstance()
        const string getAsterName()
        bint setDoubleValue( string nameOfProperty, double value )
        bint build()
        void debugPrint( int logicalUnit )

    cdef cppclass GeneralMaterialBehaviourPtr:

        GeneralMaterialBehaviourPtr( GeneralMaterialBehaviourPtr& )
        GeneralMaterialBehaviourPtr( GeneralMaterialBehaviourInstance* )
        GeneralMaterialBehaviourInstance* get()


    cdef cppclass ElasMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasMaterialBehaviourInstance()

    cdef cppclass ElasMaterialBehaviourPtr:

        ElasMaterialBehaviourPtr( ElasMaterialBehaviourPtr& )
        ElasMaterialBehaviourPtr( ElasMaterialBehaviourInstance* )
        ElasMaterialBehaviourInstance* get()



    cdef cppclass ElasFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasFoMaterialBehaviourInstance()

    cdef cppclass ElasFoMaterialBehaviourPtr:

        ElasFoMaterialBehaviourPtr( ElasFoMaterialBehaviourPtr& )
        ElasFoMaterialBehaviourPtr( ElasFoMaterialBehaviourInstance* )
        ElasFoMaterialBehaviourInstance* get()



    cdef cppclass ElasFluiMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasFluiMaterialBehaviourInstance()

    cdef cppclass ElasFluiMaterialBehaviourPtr:

        ElasFluiMaterialBehaviourPtr( ElasFluiMaterialBehaviourPtr& )
        ElasFluiMaterialBehaviourPtr( ElasFluiMaterialBehaviourInstance* )
        ElasFluiMaterialBehaviourInstance* get()



    cdef cppclass ElasIstrMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasIstrMaterialBehaviourInstance()

    cdef cppclass ElasIstrMaterialBehaviourPtr:

        ElasIstrMaterialBehaviourPtr( ElasIstrMaterialBehaviourPtr& )
        ElasIstrMaterialBehaviourPtr( ElasIstrMaterialBehaviourInstance* )
        ElasIstrMaterialBehaviourInstance* get()



    cdef cppclass ElasIstrFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasIstrFoMaterialBehaviourInstance()

    cdef cppclass ElasIstrFoMaterialBehaviourPtr:

        ElasIstrFoMaterialBehaviourPtr( ElasIstrFoMaterialBehaviourPtr& )
        ElasIstrFoMaterialBehaviourPtr( ElasIstrFoMaterialBehaviourInstance* )
        ElasIstrFoMaterialBehaviourInstance* get()



    cdef cppclass ElasOrthMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasOrthMaterialBehaviourInstance()

    cdef cppclass ElasOrthMaterialBehaviourPtr:

        ElasOrthMaterialBehaviourPtr( ElasOrthMaterialBehaviourPtr& )
        ElasOrthMaterialBehaviourPtr( ElasOrthMaterialBehaviourInstance* )
        ElasOrthMaterialBehaviourInstance* get()



    cdef cppclass ElasOrthFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasOrthFoMaterialBehaviourInstance()

    cdef cppclass ElasOrthFoMaterialBehaviourPtr:

        ElasOrthFoMaterialBehaviourPtr( ElasOrthFoMaterialBehaviourPtr& )
        ElasOrthFoMaterialBehaviourPtr( ElasOrthFoMaterialBehaviourInstance* )
        ElasOrthFoMaterialBehaviourInstance* get()



    cdef cppclass ElasHyperMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasHyperMaterialBehaviourInstance()

    cdef cppclass ElasHyperMaterialBehaviourPtr:

        ElasHyperMaterialBehaviourPtr( ElasHyperMaterialBehaviourPtr& )
        ElasHyperMaterialBehaviourPtr( ElasHyperMaterialBehaviourInstance* )
        ElasHyperMaterialBehaviourInstance* get()



    cdef cppclass ElasCoqueMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasCoqueMaterialBehaviourInstance()

    cdef cppclass ElasCoqueMaterialBehaviourPtr:

        ElasCoqueMaterialBehaviourPtr( ElasCoqueMaterialBehaviourPtr& )
        ElasCoqueMaterialBehaviourPtr( ElasCoqueMaterialBehaviourInstance* )
        ElasCoqueMaterialBehaviourInstance* get()



    cdef cppclass ElasCoqueFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasCoqueFoMaterialBehaviourInstance()

    cdef cppclass ElasCoqueFoMaterialBehaviourPtr:

        ElasCoqueFoMaterialBehaviourPtr( ElasCoqueFoMaterialBehaviourPtr& )
        ElasCoqueFoMaterialBehaviourPtr( ElasCoqueFoMaterialBehaviourInstance* )
        ElasCoqueFoMaterialBehaviourInstance* get()



    cdef cppclass ElasMembraneMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasMembraneMaterialBehaviourInstance()

    cdef cppclass ElasMembraneMaterialBehaviourPtr:

        ElasMembraneMaterialBehaviourPtr( ElasMembraneMaterialBehaviourPtr& )
        ElasMembraneMaterialBehaviourPtr( ElasMembraneMaterialBehaviourInstance* )
        ElasMembraneMaterialBehaviourInstance* get()



    cdef cppclass Elas2ndgMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas2ndgMaterialBehaviourInstance()

    cdef cppclass Elas2ndgMaterialBehaviourPtr:

        Elas2ndgMaterialBehaviourPtr( Elas2ndgMaterialBehaviourPtr& )
        Elas2ndgMaterialBehaviourPtr( Elas2ndgMaterialBehaviourInstance* )
        Elas2ndgMaterialBehaviourInstance* get()



    cdef cppclass ElasGlrcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasGlrcMaterialBehaviourInstance()

    cdef cppclass ElasGlrcMaterialBehaviourPtr:

        ElasGlrcMaterialBehaviourPtr( ElasGlrcMaterialBehaviourPtr& )
        ElasGlrcMaterialBehaviourPtr( ElasGlrcMaterialBehaviourInstance* )
        ElasGlrcMaterialBehaviourInstance* get()



    cdef cppclass ElasGlrcFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasGlrcFoMaterialBehaviourInstance()

    cdef cppclass ElasGlrcFoMaterialBehaviourPtr:

        ElasGlrcFoMaterialBehaviourPtr( ElasGlrcFoMaterialBehaviourPtr& )
        ElasGlrcFoMaterialBehaviourPtr( ElasGlrcFoMaterialBehaviourInstance* )
        ElasGlrcFoMaterialBehaviourInstance* get()



    cdef cppclass ElasDhrcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasDhrcMaterialBehaviourInstance()

    cdef cppclass ElasDhrcMaterialBehaviourPtr:

        ElasDhrcMaterialBehaviourPtr( ElasDhrcMaterialBehaviourPtr& )
        ElasDhrcMaterialBehaviourPtr( ElasDhrcMaterialBehaviourInstance* )
        ElasDhrcMaterialBehaviourInstance* get()



    cdef cppclass CableMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CableMaterialBehaviourInstance()

    cdef cppclass CableMaterialBehaviourPtr:

        CableMaterialBehaviourPtr( CableMaterialBehaviourPtr& )
        CableMaterialBehaviourPtr( CableMaterialBehaviourInstance* )
        CableMaterialBehaviourInstance* get()



    cdef cppclass VeriBorneMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        VeriBorneMaterialBehaviourInstance()

    cdef cppclass VeriBorneMaterialBehaviourPtr:

        VeriBorneMaterialBehaviourPtr( VeriBorneMaterialBehaviourPtr& )
        VeriBorneMaterialBehaviourPtr( VeriBorneMaterialBehaviourInstance* )
        VeriBorneMaterialBehaviourInstance* get()



    cdef cppclass TractionMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TractionMaterialBehaviourInstance()

    cdef cppclass TractionMaterialBehaviourPtr:

        TractionMaterialBehaviourPtr( TractionMaterialBehaviourPtr& )
        TractionMaterialBehaviourPtr( TractionMaterialBehaviourInstance* )
        TractionMaterialBehaviourInstance* get()



    cdef cppclass EcroLineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EcroLineMaterialBehaviourInstance()

    cdef cppclass EcroLineMaterialBehaviourPtr:

        EcroLineMaterialBehaviourPtr( EcroLineMaterialBehaviourPtr& )
        EcroLineMaterialBehaviourPtr( EcroLineMaterialBehaviourInstance* )
        EcroLineMaterialBehaviourInstance* get()



    cdef cppclass EndoHeterogeneMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EndoHeterogeneMaterialBehaviourInstance()

    cdef cppclass EndoHeterogeneMaterialBehaviourPtr:

        EndoHeterogeneMaterialBehaviourPtr( EndoHeterogeneMaterialBehaviourPtr& )
        EndoHeterogeneMaterialBehaviourPtr( EndoHeterogeneMaterialBehaviourInstance* )
        EndoHeterogeneMaterialBehaviourInstance* get()



    cdef cppclass EcroLineFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EcroLineFoMaterialBehaviourInstance()

    cdef cppclass EcroLineFoMaterialBehaviourPtr:

        EcroLineFoMaterialBehaviourPtr( EcroLineFoMaterialBehaviourPtr& )
        EcroLineFoMaterialBehaviourPtr( EcroLineFoMaterialBehaviourInstance* )
        EcroLineFoMaterialBehaviourInstance* get()



    cdef cppclass EcroPuisMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EcroPuisMaterialBehaviourInstance()

    cdef cppclass EcroPuisMaterialBehaviourPtr:

        EcroPuisMaterialBehaviourPtr( EcroPuisMaterialBehaviourPtr& )
        EcroPuisMaterialBehaviourPtr( EcroPuisMaterialBehaviourInstance* )
        EcroPuisMaterialBehaviourInstance* get()



    cdef cppclass EcroPuisFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EcroPuisFoMaterialBehaviourInstance()

    cdef cppclass EcroPuisFoMaterialBehaviourPtr:

        EcroPuisFoMaterialBehaviourPtr( EcroPuisFoMaterialBehaviourPtr& )
        EcroPuisFoMaterialBehaviourPtr( EcroPuisFoMaterialBehaviourInstance* )
        EcroPuisFoMaterialBehaviourInstance* get()



    cdef cppclass EcroCookMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EcroCookMaterialBehaviourInstance()

    cdef cppclass EcroCookMaterialBehaviourPtr:

        EcroCookMaterialBehaviourPtr( EcroCookMaterialBehaviourPtr& )
        EcroCookMaterialBehaviourPtr( EcroCookMaterialBehaviourInstance* )
        EcroCookMaterialBehaviourInstance* get()



    cdef cppclass EcroCookFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EcroCookFoMaterialBehaviourInstance()

    cdef cppclass EcroCookFoMaterialBehaviourPtr:

        EcroCookFoMaterialBehaviourPtr( EcroCookFoMaterialBehaviourPtr& )
        EcroCookFoMaterialBehaviourPtr( EcroCookFoMaterialBehaviourInstance* )
        EcroCookFoMaterialBehaviourInstance* get()



    cdef cppclass BetonEcroLineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BetonEcroLineMaterialBehaviourInstance()

    cdef cppclass BetonEcroLineMaterialBehaviourPtr:

        BetonEcroLineMaterialBehaviourPtr( BetonEcroLineMaterialBehaviourPtr& )
        BetonEcroLineMaterialBehaviourPtr( BetonEcroLineMaterialBehaviourInstance* )
        BetonEcroLineMaterialBehaviourInstance* get()



    cdef cppclass BetonReglePrMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BetonReglePrMaterialBehaviourInstance()

    cdef cppclass BetonReglePrMaterialBehaviourPtr:

        BetonReglePrMaterialBehaviourPtr( BetonReglePrMaterialBehaviourPtr& )
        BetonReglePrMaterialBehaviourPtr( BetonReglePrMaterialBehaviourInstance* )
        BetonReglePrMaterialBehaviourInstance* get()



    cdef cppclass EndoOrthBetonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EndoOrthBetonMaterialBehaviourInstance()

    cdef cppclass EndoOrthBetonMaterialBehaviourPtr:

        EndoOrthBetonMaterialBehaviourPtr( EndoOrthBetonMaterialBehaviourPtr& )
        EndoOrthBetonMaterialBehaviourPtr( EndoOrthBetonMaterialBehaviourInstance* )
        EndoOrthBetonMaterialBehaviourInstance* get()



    cdef cppclass PragerMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        PragerMaterialBehaviourInstance()

    cdef cppclass PragerMaterialBehaviourPtr:

        PragerMaterialBehaviourPtr( PragerMaterialBehaviourPtr& )
        PragerMaterialBehaviourPtr( PragerMaterialBehaviourInstance* )
        PragerMaterialBehaviourInstance* get()



    cdef cppclass PragerFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        PragerFoMaterialBehaviourInstance()

    cdef cppclass PragerFoMaterialBehaviourPtr:

        PragerFoMaterialBehaviourPtr( PragerFoMaterialBehaviourPtr& )
        PragerFoMaterialBehaviourPtr( PragerFoMaterialBehaviourInstance* )
        PragerFoMaterialBehaviourInstance* get()



    cdef cppclass TaheriMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TaheriMaterialBehaviourInstance()

    cdef cppclass TaheriMaterialBehaviourPtr:

        TaheriMaterialBehaviourPtr( TaheriMaterialBehaviourPtr& )
        TaheriMaterialBehaviourPtr( TaheriMaterialBehaviourInstance* )
        TaheriMaterialBehaviourInstance* get()



    cdef cppclass TaheriFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TaheriFoMaterialBehaviourInstance()

    cdef cppclass TaheriFoMaterialBehaviourPtr:

        TaheriFoMaterialBehaviourPtr( TaheriFoMaterialBehaviourPtr& )
        TaheriFoMaterialBehaviourPtr( TaheriFoMaterialBehaviourInstance* )
        TaheriFoMaterialBehaviourInstance* get()



    cdef cppclass RousselierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RousselierMaterialBehaviourInstance()

    cdef cppclass RousselierMaterialBehaviourPtr:

        RousselierMaterialBehaviourPtr( RousselierMaterialBehaviourPtr& )
        RousselierMaterialBehaviourPtr( RousselierMaterialBehaviourInstance* )
        RousselierMaterialBehaviourInstance* get()



    cdef cppclass RousselierFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RousselierFoMaterialBehaviourInstance()

    cdef cppclass RousselierFoMaterialBehaviourPtr:

        RousselierFoMaterialBehaviourPtr( RousselierFoMaterialBehaviourPtr& )
        RousselierFoMaterialBehaviourPtr( RousselierFoMaterialBehaviourInstance* )
        RousselierFoMaterialBehaviourInstance* get()



    cdef cppclass ViscSinhMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscSinhMaterialBehaviourInstance()

    cdef cppclass ViscSinhMaterialBehaviourPtr:

        ViscSinhMaterialBehaviourPtr( ViscSinhMaterialBehaviourPtr& )
        ViscSinhMaterialBehaviourPtr( ViscSinhMaterialBehaviourInstance* )
        ViscSinhMaterialBehaviourInstance* get()



    cdef cppclass ViscSinhFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscSinhFoMaterialBehaviourInstance()

    cdef cppclass ViscSinhFoMaterialBehaviourPtr:

        ViscSinhFoMaterialBehaviourPtr( ViscSinhFoMaterialBehaviourPtr& )
        ViscSinhFoMaterialBehaviourPtr( ViscSinhFoMaterialBehaviourInstance* )
        ViscSinhFoMaterialBehaviourInstance* get()



    cdef cppclass Cin1ChabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin1ChabMaterialBehaviourInstance()

    cdef cppclass Cin1ChabMaterialBehaviourPtr:

        Cin1ChabMaterialBehaviourPtr( Cin1ChabMaterialBehaviourPtr& )
        Cin1ChabMaterialBehaviourPtr( Cin1ChabMaterialBehaviourInstance* )
        Cin1ChabMaterialBehaviourInstance* get()



    cdef cppclass Cin1ChabFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin1ChabFoMaterialBehaviourInstance()

    cdef cppclass Cin1ChabFoMaterialBehaviourPtr:

        Cin1ChabFoMaterialBehaviourPtr( Cin1ChabFoMaterialBehaviourPtr& )
        Cin1ChabFoMaterialBehaviourPtr( Cin1ChabFoMaterialBehaviourInstance* )
        Cin1ChabFoMaterialBehaviourInstance* get()



    cdef cppclass Cin2ChabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin2ChabMaterialBehaviourInstance()

    cdef cppclass Cin2ChabMaterialBehaviourPtr:

        Cin2ChabMaterialBehaviourPtr( Cin2ChabMaterialBehaviourPtr& )
        Cin2ChabMaterialBehaviourPtr( Cin2ChabMaterialBehaviourInstance* )
        Cin2ChabMaterialBehaviourInstance* get()



    cdef cppclass Cin2ChabFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin2ChabFoMaterialBehaviourInstance()

    cdef cppclass Cin2ChabFoMaterialBehaviourPtr:

        Cin2ChabFoMaterialBehaviourPtr( Cin2ChabFoMaterialBehaviourPtr& )
        Cin2ChabFoMaterialBehaviourPtr( Cin2ChabFoMaterialBehaviourInstance* )
        Cin2ChabFoMaterialBehaviourInstance* get()



    cdef cppclass Cin2NradMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin2NradMaterialBehaviourInstance()

    cdef cppclass Cin2NradMaterialBehaviourPtr:

        Cin2NradMaterialBehaviourPtr( Cin2NradMaterialBehaviourPtr& )
        Cin2NradMaterialBehaviourPtr( Cin2NradMaterialBehaviourInstance* )
        Cin2NradMaterialBehaviourInstance* get()



    cdef cppclass MemoEcroMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MemoEcroMaterialBehaviourInstance()

    cdef cppclass MemoEcroMaterialBehaviourPtr:

        MemoEcroMaterialBehaviourPtr( MemoEcroMaterialBehaviourPtr& )
        MemoEcroMaterialBehaviourPtr( MemoEcroMaterialBehaviourInstance* )
        MemoEcroMaterialBehaviourInstance* get()



    cdef cppclass MemoEcroFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MemoEcroFoMaterialBehaviourInstance()

    cdef cppclass MemoEcroFoMaterialBehaviourPtr:

        MemoEcroFoMaterialBehaviourPtr( MemoEcroFoMaterialBehaviourPtr& )
        MemoEcroFoMaterialBehaviourPtr( MemoEcroFoMaterialBehaviourInstance* )
        MemoEcroFoMaterialBehaviourInstance* get()



    cdef cppclass ViscochabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscochabMaterialBehaviourInstance()

    cdef cppclass ViscochabMaterialBehaviourPtr:

        ViscochabMaterialBehaviourPtr( ViscochabMaterialBehaviourPtr& )
        ViscochabMaterialBehaviourPtr( ViscochabMaterialBehaviourInstance* )
        ViscochabMaterialBehaviourInstance* get()



    cdef cppclass ViscochabFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscochabFoMaterialBehaviourInstance()

    cdef cppclass ViscochabFoMaterialBehaviourPtr:

        ViscochabFoMaterialBehaviourPtr( ViscochabFoMaterialBehaviourPtr& )
        ViscochabFoMaterialBehaviourPtr( ViscochabFoMaterialBehaviourInstance* )
        ViscochabFoMaterialBehaviourInstance* get()



    cdef cppclass LemaitreMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LemaitreMaterialBehaviourInstance()

    cdef cppclass LemaitreMaterialBehaviourPtr:

        LemaitreMaterialBehaviourPtr( LemaitreMaterialBehaviourPtr& )
        LemaitreMaterialBehaviourPtr( LemaitreMaterialBehaviourInstance* )
        LemaitreMaterialBehaviourInstance* get()



    cdef cppclass LemaitreIrraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LemaitreIrraMaterialBehaviourInstance()

    cdef cppclass LemaitreIrraMaterialBehaviourPtr:

        LemaitreIrraMaterialBehaviourPtr( LemaitreIrraMaterialBehaviourPtr& )
        LemaitreIrraMaterialBehaviourPtr( LemaitreIrraMaterialBehaviourInstance* )
        LemaitreIrraMaterialBehaviourInstance* get()



    cdef cppclass LmarcIrraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LmarcIrraMaterialBehaviourInstance()

    cdef cppclass LmarcIrraMaterialBehaviourPtr:

        LmarcIrraMaterialBehaviourPtr( LmarcIrraMaterialBehaviourPtr& )
        LmarcIrraMaterialBehaviourPtr( LmarcIrraMaterialBehaviourInstance* )
        LmarcIrraMaterialBehaviourInstance* get()



    cdef cppclass ViscIrraLogMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscIrraLogMaterialBehaviourInstance()

    cdef cppclass ViscIrraLogMaterialBehaviourPtr:

        ViscIrraLogMaterialBehaviourPtr( ViscIrraLogMaterialBehaviourPtr& )
        ViscIrraLogMaterialBehaviourPtr( ViscIrraLogMaterialBehaviourInstance* )
        ViscIrraLogMaterialBehaviourInstance* get()



    cdef cppclass GranIrraLogMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        GranIrraLogMaterialBehaviourInstance()

    cdef cppclass GranIrraLogMaterialBehaviourPtr:

        GranIrraLogMaterialBehaviourPtr( GranIrraLogMaterialBehaviourPtr& )
        GranIrraLogMaterialBehaviourPtr( GranIrraLogMaterialBehaviourInstance* )
        GranIrraLogMaterialBehaviourInstance* get()



    cdef cppclass LemaSeuilMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LemaSeuilMaterialBehaviourInstance()

    cdef cppclass LemaSeuilMaterialBehaviourPtr:

        LemaSeuilMaterialBehaviourPtr( LemaSeuilMaterialBehaviourPtr& )
        LemaSeuilMaterialBehaviourPtr( LemaSeuilMaterialBehaviourInstance* )
        LemaSeuilMaterialBehaviourInstance* get()



    cdef cppclass LemaSeuilFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LemaSeuilFoMaterialBehaviourInstance()

    cdef cppclass LemaSeuilFoMaterialBehaviourPtr:

        LemaSeuilFoMaterialBehaviourPtr( LemaSeuilFoMaterialBehaviourPtr& )
        LemaSeuilFoMaterialBehaviourPtr( LemaSeuilFoMaterialBehaviourInstance* )
        LemaSeuilFoMaterialBehaviourInstance* get()



    cdef cppclass Irrad3mMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Irrad3mMaterialBehaviourInstance()

    cdef cppclass Irrad3mMaterialBehaviourPtr:

        Irrad3mMaterialBehaviourPtr( Irrad3mMaterialBehaviourPtr& )
        Irrad3mMaterialBehaviourPtr( Irrad3mMaterialBehaviourInstance* )
        Irrad3mMaterialBehaviourInstance* get()



    cdef cppclass LemaitreFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LemaitreFoMaterialBehaviourInstance()

    cdef cppclass LemaitreFoMaterialBehaviourPtr:

        LemaitreFoMaterialBehaviourPtr( LemaitreFoMaterialBehaviourPtr& )
        LemaitreFoMaterialBehaviourPtr( LemaitreFoMaterialBehaviourInstance* )
        LemaitreFoMaterialBehaviourInstance* get()



    cdef cppclass MetaLemaAniMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaLemaAniMaterialBehaviourInstance()

    cdef cppclass MetaLemaAniMaterialBehaviourPtr:

        MetaLemaAniMaterialBehaviourPtr( MetaLemaAniMaterialBehaviourPtr& )
        MetaLemaAniMaterialBehaviourPtr( MetaLemaAniMaterialBehaviourInstance* )
        MetaLemaAniMaterialBehaviourInstance* get()



    cdef cppclass MetaLemaAniFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaLemaAniFoMaterialBehaviourInstance()

    cdef cppclass MetaLemaAniFoMaterialBehaviourPtr:

        MetaLemaAniFoMaterialBehaviourPtr( MetaLemaAniFoMaterialBehaviourPtr& )
        MetaLemaAniFoMaterialBehaviourPtr( MetaLemaAniFoMaterialBehaviourInstance* )
        MetaLemaAniFoMaterialBehaviourInstance* get()



    cdef cppclass ArmeMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ArmeMaterialBehaviourInstance()

    cdef cppclass ArmeMaterialBehaviourPtr:

        ArmeMaterialBehaviourPtr( ArmeMaterialBehaviourPtr& )
        ArmeMaterialBehaviourPtr( ArmeMaterialBehaviourInstance* )
        ArmeMaterialBehaviourInstance* get()



    cdef cppclass AsseCornMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        AsseCornMaterialBehaviourInstance()

    cdef cppclass AsseCornMaterialBehaviourPtr:

        AsseCornMaterialBehaviourPtr( AsseCornMaterialBehaviourPtr& )
        AsseCornMaterialBehaviourPtr( AsseCornMaterialBehaviourInstance* )
        AsseCornMaterialBehaviourInstance* get()



    cdef cppclass DisContactMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DisContactMaterialBehaviourInstance()

    cdef cppclass DisContactMaterialBehaviourPtr:

        DisContactMaterialBehaviourPtr( DisContactMaterialBehaviourPtr& )
        DisContactMaterialBehaviourPtr( DisContactMaterialBehaviourInstance* )
        DisContactMaterialBehaviourInstance* get()



    cdef cppclass EndoScalaireMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EndoScalaireMaterialBehaviourInstance()

    cdef cppclass EndoScalaireMaterialBehaviourPtr:

        EndoScalaireMaterialBehaviourPtr( EndoScalaireMaterialBehaviourPtr& )
        EndoScalaireMaterialBehaviourPtr( EndoScalaireMaterialBehaviourInstance* )
        EndoScalaireMaterialBehaviourInstance* get()



    cdef cppclass EndoScalaireFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EndoScalaireFoMaterialBehaviourInstance()

    cdef cppclass EndoScalaireFoMaterialBehaviourPtr:

        EndoScalaireFoMaterialBehaviourPtr( EndoScalaireFoMaterialBehaviourPtr& )
        EndoScalaireFoMaterialBehaviourPtr( EndoScalaireFoMaterialBehaviourInstance* )
        EndoScalaireFoMaterialBehaviourInstance* get()



    cdef cppclass EndoFissExpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EndoFissExpMaterialBehaviourInstance()

    cdef cppclass EndoFissExpMaterialBehaviourPtr:

        EndoFissExpMaterialBehaviourPtr( EndoFissExpMaterialBehaviourPtr& )
        EndoFissExpMaterialBehaviourPtr( EndoFissExpMaterialBehaviourInstance* )
        EndoFissExpMaterialBehaviourInstance* get()



    cdef cppclass EndoFissExpFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EndoFissExpFoMaterialBehaviourInstance()

    cdef cppclass EndoFissExpFoMaterialBehaviourPtr:

        EndoFissExpFoMaterialBehaviourPtr( EndoFissExpFoMaterialBehaviourPtr& )
        EndoFissExpFoMaterialBehaviourPtr( EndoFissExpFoMaterialBehaviourInstance* )
        EndoFissExpFoMaterialBehaviourInstance* get()



    cdef cppclass DisGricraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DisGricraMaterialBehaviourInstance()

    cdef cppclass DisGricraMaterialBehaviourPtr:

        DisGricraMaterialBehaviourPtr( DisGricraMaterialBehaviourPtr& )
        DisGricraMaterialBehaviourPtr( DisGricraMaterialBehaviourInstance* )
        DisGricraMaterialBehaviourInstance* get()



    cdef cppclass BetonDoubleDpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BetonDoubleDpMaterialBehaviourInstance()

    cdef cppclass BetonDoubleDpMaterialBehaviourPtr:

        BetonDoubleDpMaterialBehaviourPtr( BetonDoubleDpMaterialBehaviourPtr& )
        BetonDoubleDpMaterialBehaviourPtr( BetonDoubleDpMaterialBehaviourInstance* )
        BetonDoubleDpMaterialBehaviourInstance* get()



    cdef cppclass MazarsMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MazarsMaterialBehaviourInstance()

    cdef cppclass MazarsMaterialBehaviourPtr:

        MazarsMaterialBehaviourPtr( MazarsMaterialBehaviourPtr& )
        MazarsMaterialBehaviourPtr( MazarsMaterialBehaviourInstance* )
        MazarsMaterialBehaviourInstance* get()



    cdef cppclass MazarsFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MazarsFoMaterialBehaviourInstance()

    cdef cppclass MazarsFoMaterialBehaviourPtr:

        MazarsFoMaterialBehaviourPtr( MazarsFoMaterialBehaviourPtr& )
        MazarsFoMaterialBehaviourPtr( MazarsFoMaterialBehaviourInstance* )
        MazarsFoMaterialBehaviourInstance* get()



    cdef cppclass JointBaMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        JointBaMaterialBehaviourInstance()

    cdef cppclass JointBaMaterialBehaviourPtr:

        JointBaMaterialBehaviourPtr( JointBaMaterialBehaviourPtr& )
        JointBaMaterialBehaviourPtr( JointBaMaterialBehaviourInstance* )
        JointBaMaterialBehaviourInstance* get()



    cdef cppclass VendochabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        VendochabMaterialBehaviourInstance()

    cdef cppclass VendochabMaterialBehaviourPtr:

        VendochabMaterialBehaviourPtr( VendochabMaterialBehaviourPtr& )
        VendochabMaterialBehaviourPtr( VendochabMaterialBehaviourInstance* )
        VendochabMaterialBehaviourInstance* get()



    cdef cppclass VendochabFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        VendochabFoMaterialBehaviourInstance()

    cdef cppclass VendochabFoMaterialBehaviourPtr:

        VendochabFoMaterialBehaviourPtr( VendochabFoMaterialBehaviourPtr& )
        VendochabFoMaterialBehaviourPtr( VendochabFoMaterialBehaviourInstance* )
        VendochabFoMaterialBehaviourInstance* get()



    cdef cppclass HayhurstMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        HayhurstMaterialBehaviourInstance()

    cdef cppclass HayhurstMaterialBehaviourPtr:

        HayhurstMaterialBehaviourPtr( HayhurstMaterialBehaviourPtr& )
        HayhurstMaterialBehaviourPtr( HayhurstMaterialBehaviourInstance* )
        HayhurstMaterialBehaviourInstance* get()



    cdef cppclass ViscEndoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscEndoMaterialBehaviourInstance()

    cdef cppclass ViscEndoMaterialBehaviourPtr:

        ViscEndoMaterialBehaviourPtr( ViscEndoMaterialBehaviourPtr& )
        ViscEndoMaterialBehaviourPtr( ViscEndoMaterialBehaviourInstance* )
        ViscEndoMaterialBehaviourInstance* get()



    cdef cppclass ViscEndoFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscEndoFoMaterialBehaviourInstance()

    cdef cppclass ViscEndoFoMaterialBehaviourPtr:

        ViscEndoFoMaterialBehaviourPtr( ViscEndoFoMaterialBehaviourPtr& )
        ViscEndoFoMaterialBehaviourPtr( ViscEndoFoMaterialBehaviourInstance* )
        ViscEndoFoMaterialBehaviourInstance* get()



    cdef cppclass PintoMenegottoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        PintoMenegottoMaterialBehaviourInstance()

    cdef cppclass PintoMenegottoMaterialBehaviourPtr:

        PintoMenegottoMaterialBehaviourPtr( PintoMenegottoMaterialBehaviourPtr& )
        PintoMenegottoMaterialBehaviourPtr( PintoMenegottoMaterialBehaviourInstance* )
        PintoMenegottoMaterialBehaviourInstance* get()



    cdef cppclass BpelBetonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BpelBetonMaterialBehaviourInstance()

    cdef cppclass BpelBetonMaterialBehaviourPtr:

        BpelBetonMaterialBehaviourPtr( BpelBetonMaterialBehaviourPtr& )
        BpelBetonMaterialBehaviourPtr( BpelBetonMaterialBehaviourInstance* )
        BpelBetonMaterialBehaviourInstance* get()



    cdef cppclass BpelAcierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BpelAcierMaterialBehaviourInstance()

    cdef cppclass BpelAcierMaterialBehaviourPtr:

        BpelAcierMaterialBehaviourPtr( BpelAcierMaterialBehaviourPtr& )
        BpelAcierMaterialBehaviourPtr( BpelAcierMaterialBehaviourInstance* )
        BpelAcierMaterialBehaviourInstance* get()



    cdef cppclass EtccBetonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EtccBetonMaterialBehaviourInstance()

    cdef cppclass EtccBetonMaterialBehaviourPtr:

        EtccBetonMaterialBehaviourPtr( EtccBetonMaterialBehaviourPtr& )
        EtccBetonMaterialBehaviourPtr( EtccBetonMaterialBehaviourInstance* )
        EtccBetonMaterialBehaviourInstance* get()



    cdef cppclass EtccAcierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EtccAcierMaterialBehaviourInstance()

    cdef cppclass EtccAcierMaterialBehaviourPtr:

        EtccAcierMaterialBehaviourPtr( EtccAcierMaterialBehaviourPtr& )
        EtccAcierMaterialBehaviourPtr( EtccAcierMaterialBehaviourInstance* )
        EtccAcierMaterialBehaviourInstance* get()



    cdef cppclass MohrCoulombMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MohrCoulombMaterialBehaviourInstance()

    cdef cppclass MohrCoulombMaterialBehaviourPtr:

        MohrCoulombMaterialBehaviourPtr( MohrCoulombMaterialBehaviourPtr& )
        MohrCoulombMaterialBehaviourPtr( MohrCoulombMaterialBehaviourInstance* )
        MohrCoulombMaterialBehaviourInstance* get()



    cdef cppclass CamClayMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CamClayMaterialBehaviourInstance()

    cdef cppclass CamClayMaterialBehaviourPtr:

        CamClayMaterialBehaviourPtr( CamClayMaterialBehaviourPtr& )
        CamClayMaterialBehaviourPtr( CamClayMaterialBehaviourInstance* )
        CamClayMaterialBehaviourInstance* get()



    cdef cppclass BarceloneMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BarceloneMaterialBehaviourInstance()

    cdef cppclass BarceloneMaterialBehaviourPtr:

        BarceloneMaterialBehaviourPtr( BarceloneMaterialBehaviourPtr& )
        BarceloneMaterialBehaviourPtr( BarceloneMaterialBehaviourInstance* )
        BarceloneMaterialBehaviourInstance* get()



    cdef cppclass CjsMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CjsMaterialBehaviourInstance()

    cdef cppclass CjsMaterialBehaviourPtr:

        CjsMaterialBehaviourPtr( CjsMaterialBehaviourPtr& )
        CjsMaterialBehaviourPtr( CjsMaterialBehaviourInstance* )
        CjsMaterialBehaviourInstance* get()



    cdef cppclass HujeuxMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        HujeuxMaterialBehaviourInstance()

    cdef cppclass HujeuxMaterialBehaviourPtr:

        HujeuxMaterialBehaviourPtr( HujeuxMaterialBehaviourPtr& )
        HujeuxMaterialBehaviourPtr( HujeuxMaterialBehaviourInstance* )
        HujeuxMaterialBehaviourInstance* get()



    cdef cppclass EcroAsymLineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        EcroAsymLineMaterialBehaviourInstance()

    cdef cppclass EcroAsymLineMaterialBehaviourPtr:

        EcroAsymLineMaterialBehaviourPtr( EcroAsymLineMaterialBehaviourPtr& )
        EcroAsymLineMaterialBehaviourPtr( EcroAsymLineMaterialBehaviourInstance* )
        EcroAsymLineMaterialBehaviourInstance* get()



    cdef cppclass GrangerFpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        GrangerFpMaterialBehaviourInstance()

    cdef cppclass GrangerFpMaterialBehaviourPtr:

        GrangerFpMaterialBehaviourPtr( GrangerFpMaterialBehaviourPtr& )
        GrangerFpMaterialBehaviourPtr( GrangerFpMaterialBehaviourInstance* )
        GrangerFpMaterialBehaviourInstance* get()



    cdef cppclass GrangerFp_indtMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        GrangerFp_indtMaterialBehaviourInstance()

    cdef cppclass GrangerFp_indtMaterialBehaviourPtr:

        GrangerFp_indtMaterialBehaviourPtr( GrangerFp_indtMaterialBehaviourPtr& )
        GrangerFp_indtMaterialBehaviourPtr( GrangerFp_indtMaterialBehaviourInstance* )
        GrangerFp_indtMaterialBehaviourInstance* get()



    cdef cppclass VGrangerFpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        VGrangerFpMaterialBehaviourInstance()

    cdef cppclass VGrangerFpMaterialBehaviourPtr:

        VGrangerFpMaterialBehaviourPtr( VGrangerFpMaterialBehaviourPtr& )
        VGrangerFpMaterialBehaviourPtr( VGrangerFpMaterialBehaviourInstance* )
        VGrangerFpMaterialBehaviourInstance* get()



    cdef cppclass BetonBurgerFpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BetonBurgerFpMaterialBehaviourInstance()

    cdef cppclass BetonBurgerFpMaterialBehaviourPtr:

        BetonBurgerFpMaterialBehaviourPtr( BetonBurgerFpMaterialBehaviourPtr& )
        BetonBurgerFpMaterialBehaviourPtr( BetonBurgerFpMaterialBehaviourInstance* )
        BetonBurgerFpMaterialBehaviourInstance* get()



    cdef cppclass BetonUmlvFpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BetonUmlvFpMaterialBehaviourInstance()

    cdef cppclass BetonUmlvFpMaterialBehaviourPtr:

        BetonUmlvFpMaterialBehaviourPtr( BetonUmlvFpMaterialBehaviourPtr& )
        BetonUmlvFpMaterialBehaviourPtr( BetonUmlvFpMaterialBehaviourInstance* )
        BetonUmlvFpMaterialBehaviourInstance* get()



    cdef cppclass BetonRagMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        BetonRagMaterialBehaviourInstance()

    cdef cppclass BetonRagMaterialBehaviourPtr:

        BetonRagMaterialBehaviourPtr( BetonRagMaterialBehaviourPtr& )
        BetonRagMaterialBehaviourPtr( BetonRagMaterialBehaviourInstance* )
        BetonRagMaterialBehaviourInstance* get()



    cdef cppclass PoroBetonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        PoroBetonMaterialBehaviourInstance()

    cdef cppclass PoroBetonMaterialBehaviourPtr:

        PoroBetonMaterialBehaviourPtr( PoroBetonMaterialBehaviourPtr& )
        PoroBetonMaterialBehaviourPtr( PoroBetonMaterialBehaviourInstance* )
        PoroBetonMaterialBehaviourInstance* get()



    cdef cppclass GlrcDmMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        GlrcDmMaterialBehaviourInstance()

    cdef cppclass GlrcDmMaterialBehaviourPtr:

        GlrcDmMaterialBehaviourPtr( GlrcDmMaterialBehaviourPtr& )
        GlrcDmMaterialBehaviourPtr( GlrcDmMaterialBehaviourInstance* )
        GlrcDmMaterialBehaviourInstance* get()



    cdef cppclass DhrcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DhrcMaterialBehaviourInstance()

    cdef cppclass DhrcMaterialBehaviourPtr:

        DhrcMaterialBehaviourPtr( DhrcMaterialBehaviourPtr& )
        DhrcMaterialBehaviourPtr( DhrcMaterialBehaviourInstance* )
        DhrcMaterialBehaviourInstance* get()



    cdef cppclass GattMonerieMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        GattMonerieMaterialBehaviourInstance()

    cdef cppclass GattMonerieMaterialBehaviourPtr:

        GattMonerieMaterialBehaviourPtr( GattMonerieMaterialBehaviourPtr& )
        GattMonerieMaterialBehaviourPtr( GattMonerieMaterialBehaviourInstance* )
        GattMonerieMaterialBehaviourInstance* get()



    cdef cppclass CorrAcierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CorrAcierMaterialBehaviourInstance()

    cdef cppclass CorrAcierMaterialBehaviourPtr:

        CorrAcierMaterialBehaviourPtr( CorrAcierMaterialBehaviourPtr& )
        CorrAcierMaterialBehaviourPtr( CorrAcierMaterialBehaviourInstance* )
        CorrAcierMaterialBehaviourInstance* get()



    cdef cppclass CableGaineFrotMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CableGaineFrotMaterialBehaviourInstance()

    cdef cppclass CableGaineFrotMaterialBehaviourPtr:

        CableGaineFrotMaterialBehaviourPtr( CableGaineFrotMaterialBehaviourPtr& )
        CableGaineFrotMaterialBehaviourPtr( CableGaineFrotMaterialBehaviourInstance* )
        CableGaineFrotMaterialBehaviourInstance* get()



    cdef cppclass DisEcroCineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DisEcroCineMaterialBehaviourInstance()

    cdef cppclass DisEcroCineMaterialBehaviourPtr:

        DisEcroCineMaterialBehaviourPtr( DisEcroCineMaterialBehaviourPtr& )
        DisEcroCineMaterialBehaviourPtr( DisEcroCineMaterialBehaviourInstance* )
        DisEcroCineMaterialBehaviourInstance* get()



    cdef cppclass DisViscMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DisViscMaterialBehaviourInstance()

    cdef cppclass DisViscMaterialBehaviourPtr:

        DisViscMaterialBehaviourPtr( DisViscMaterialBehaviourPtr& )
        DisViscMaterialBehaviourPtr( DisViscMaterialBehaviourInstance* )
        DisViscMaterialBehaviourInstance* get()



    cdef cppclass DisBiliElasMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DisBiliElasMaterialBehaviourInstance()

    cdef cppclass DisBiliElasMaterialBehaviourPtr:

        DisBiliElasMaterialBehaviourPtr( DisBiliElasMaterialBehaviourPtr& )
        DisBiliElasMaterialBehaviourPtr( DisBiliElasMaterialBehaviourInstance* )
        DisBiliElasMaterialBehaviourInstance* get()



    cdef cppclass TherNlMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherNlMaterialBehaviourInstance()

    cdef cppclass TherNlMaterialBehaviourPtr:

        TherNlMaterialBehaviourPtr( TherNlMaterialBehaviourPtr& )
        TherNlMaterialBehaviourPtr( TherNlMaterialBehaviourInstance* )
        TherNlMaterialBehaviourInstance* get()



    cdef cppclass TherHydrMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherHydrMaterialBehaviourInstance()

    cdef cppclass TherHydrMaterialBehaviourPtr:

        TherHydrMaterialBehaviourPtr( TherHydrMaterialBehaviourPtr& )
        TherHydrMaterialBehaviourPtr( TherHydrMaterialBehaviourInstance* )
        TherHydrMaterialBehaviourInstance* get()



    cdef cppclass TherMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherMaterialBehaviourInstance()

    cdef cppclass TherMaterialBehaviourPtr:

        TherMaterialBehaviourPtr( TherMaterialBehaviourPtr& )
        TherMaterialBehaviourPtr( TherMaterialBehaviourInstance* )
        TherMaterialBehaviourInstance* get()



    cdef cppclass TherFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherFoMaterialBehaviourInstance()

    cdef cppclass TherFoMaterialBehaviourPtr:

        TherFoMaterialBehaviourPtr( TherFoMaterialBehaviourPtr& )
        TherFoMaterialBehaviourPtr( TherFoMaterialBehaviourInstance* )
        TherFoMaterialBehaviourInstance* get()



    cdef cppclass TherOrthMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherOrthMaterialBehaviourInstance()

    cdef cppclass TherOrthMaterialBehaviourPtr:

        TherOrthMaterialBehaviourPtr( TherOrthMaterialBehaviourPtr& )
        TherOrthMaterialBehaviourPtr( TherOrthMaterialBehaviourInstance* )
        TherOrthMaterialBehaviourInstance* get()



    cdef cppclass TherCoqueMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherCoqueMaterialBehaviourInstance()

    cdef cppclass TherCoqueMaterialBehaviourPtr:

        TherCoqueMaterialBehaviourPtr( TherCoqueMaterialBehaviourPtr& )
        TherCoqueMaterialBehaviourPtr( TherCoqueMaterialBehaviourInstance* )
        TherCoqueMaterialBehaviourInstance* get()



    cdef cppclass TherCoqueFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherCoqueFoMaterialBehaviourInstance()

    cdef cppclass TherCoqueFoMaterialBehaviourPtr:

        TherCoqueFoMaterialBehaviourPtr( TherCoqueFoMaterialBehaviourPtr& )
        TherCoqueFoMaterialBehaviourPtr( TherCoqueFoMaterialBehaviourInstance* )
        TherCoqueFoMaterialBehaviourInstance* get()



    cdef cppclass SechGrangerMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        SechGrangerMaterialBehaviourInstance()

    cdef cppclass SechGrangerMaterialBehaviourPtr:

        SechGrangerMaterialBehaviourPtr( SechGrangerMaterialBehaviourPtr& )
        SechGrangerMaterialBehaviourPtr( SechGrangerMaterialBehaviourInstance* )
        SechGrangerMaterialBehaviourInstance* get()



    cdef cppclass SechMensiMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        SechMensiMaterialBehaviourInstance()

    cdef cppclass SechMensiMaterialBehaviourPtr:

        SechMensiMaterialBehaviourPtr( SechMensiMaterialBehaviourPtr& )
        SechMensiMaterialBehaviourPtr( SechMensiMaterialBehaviourInstance* )
        SechMensiMaterialBehaviourInstance* get()



    cdef cppclass SechBazantMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        SechBazantMaterialBehaviourInstance()

    cdef cppclass SechBazantMaterialBehaviourPtr:

        SechBazantMaterialBehaviourPtr( SechBazantMaterialBehaviourPtr& )
        SechBazantMaterialBehaviourPtr( SechBazantMaterialBehaviourInstance* )
        SechBazantMaterialBehaviourInstance* get()



    cdef cppclass SechNappeMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        SechNappeMaterialBehaviourInstance()

    cdef cppclass SechNappeMaterialBehaviourPtr:

        SechNappeMaterialBehaviourPtr( SechNappeMaterialBehaviourPtr& )
        SechNappeMaterialBehaviourPtr( SechNappeMaterialBehaviourInstance* )
        SechNappeMaterialBehaviourInstance* get()



    cdef cppclass MetaAcierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaAcierMaterialBehaviourInstance()

    cdef cppclass MetaAcierMaterialBehaviourPtr:

        MetaAcierMaterialBehaviourPtr( MetaAcierMaterialBehaviourPtr& )
        MetaAcierMaterialBehaviourPtr( MetaAcierMaterialBehaviourInstance* )
        MetaAcierMaterialBehaviourInstance* get()



    cdef cppclass MetaZircMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaZircMaterialBehaviourInstance()

    cdef cppclass MetaZircMaterialBehaviourPtr:

        MetaZircMaterialBehaviourPtr( MetaZircMaterialBehaviourPtr& )
        MetaZircMaterialBehaviourPtr( MetaZircMaterialBehaviourInstance* )
        MetaZircMaterialBehaviourInstance* get()



    cdef cppclass DurtMetaMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DurtMetaMaterialBehaviourInstance()

    cdef cppclass DurtMetaMaterialBehaviourPtr:

        DurtMetaMaterialBehaviourPtr( DurtMetaMaterialBehaviourPtr& )
        DurtMetaMaterialBehaviourPtr( DurtMetaMaterialBehaviourInstance* )
        DurtMetaMaterialBehaviourInstance* get()



    cdef cppclass ElasMetaMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasMetaMaterialBehaviourInstance()

    cdef cppclass ElasMetaMaterialBehaviourPtr:

        ElasMetaMaterialBehaviourPtr( ElasMetaMaterialBehaviourPtr& )
        ElasMetaMaterialBehaviourPtr( ElasMetaMaterialBehaviourInstance* )
        ElasMetaMaterialBehaviourInstance* get()



    cdef cppclass ElasMetaFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasMetaFoMaterialBehaviourInstance()

    cdef cppclass ElasMetaFoMaterialBehaviourPtr:

        ElasMetaFoMaterialBehaviourPtr( ElasMetaFoMaterialBehaviourPtr& )
        ElasMetaFoMaterialBehaviourPtr( ElasMetaFoMaterialBehaviourInstance* )
        ElasMetaFoMaterialBehaviourInstance* get()



    cdef cppclass MetaEcroLineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaEcroLineMaterialBehaviourInstance()

    cdef cppclass MetaEcroLineMaterialBehaviourPtr:

        MetaEcroLineMaterialBehaviourPtr( MetaEcroLineMaterialBehaviourPtr& )
        MetaEcroLineMaterialBehaviourPtr( MetaEcroLineMaterialBehaviourInstance* )
        MetaEcroLineMaterialBehaviourInstance* get()



    cdef cppclass MetaTractionMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaTractionMaterialBehaviourInstance()

    cdef cppclass MetaTractionMaterialBehaviourPtr:

        MetaTractionMaterialBehaviourPtr( MetaTractionMaterialBehaviourPtr& )
        MetaTractionMaterialBehaviourPtr( MetaTractionMaterialBehaviourInstance* )
        MetaTractionMaterialBehaviourInstance* get()



    cdef cppclass MetaViscFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaViscFoMaterialBehaviourInstance()

    cdef cppclass MetaViscFoMaterialBehaviourPtr:

        MetaViscFoMaterialBehaviourPtr( MetaViscFoMaterialBehaviourPtr& )
        MetaViscFoMaterialBehaviourPtr( MetaViscFoMaterialBehaviourInstance* )
        MetaViscFoMaterialBehaviourInstance* get()



    cdef cppclass MetaPtMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaPtMaterialBehaviourInstance()

    cdef cppclass MetaPtMaterialBehaviourPtr:

        MetaPtMaterialBehaviourPtr( MetaPtMaterialBehaviourPtr& )
        MetaPtMaterialBehaviourPtr( MetaPtMaterialBehaviourInstance* )
        MetaPtMaterialBehaviourInstance* get()



    cdef cppclass MetaReMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MetaReMaterialBehaviourInstance()

    cdef cppclass MetaReMaterialBehaviourPtr:

        MetaReMaterialBehaviourPtr( MetaReMaterialBehaviourPtr& )
        MetaReMaterialBehaviourPtr( MetaReMaterialBehaviourInstance* )
        MetaReMaterialBehaviourInstance* get()



    cdef cppclass FluideMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        FluideMaterialBehaviourInstance()

    cdef cppclass FluideMaterialBehaviourPtr:

        FluideMaterialBehaviourPtr( FluideMaterialBehaviourPtr& )
        FluideMaterialBehaviourPtr( FluideMaterialBehaviourInstance* )
        FluideMaterialBehaviourInstance* get()


    cdef cppclass ThmGazMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ThmGazMaterialBehaviourInstance()

    cdef cppclass ThmGazMaterialBehaviourPtr:

        ThmGazMaterialBehaviourPtr( ThmGazMaterialBehaviourPtr& )
        ThmGazMaterialBehaviourPtr( ThmGazMaterialBehaviourInstance* )
        ThmGazMaterialBehaviourInstance* get()


    cdef cppclass ThmVapeGazMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ThmVapeGazMaterialBehaviourInstance()

    cdef cppclass ThmVapeGazMaterialBehaviourPtr:

        ThmVapeGazMaterialBehaviourPtr( ThmVapeGazMaterialBehaviourPtr& )
        ThmVapeGazMaterialBehaviourPtr( ThmVapeGazMaterialBehaviourInstance* )
        ThmVapeGazMaterialBehaviourInstance* get()


    cdef cppclass ThmLiquMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ThmLiquMaterialBehaviourInstance()

    cdef cppclass ThmLiquMaterialBehaviourPtr:

        ThmLiquMaterialBehaviourPtr( ThmLiquMaterialBehaviourPtr& )
        ThmLiquMaterialBehaviourPtr( ThmLiquMaterialBehaviourInstance* )
        ThmLiquMaterialBehaviourInstance* get()


    cdef cppclass FatigueMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        FatigueMaterialBehaviourInstance()

    cdef cppclass FatigueMaterialBehaviourPtr:

        FatigueMaterialBehaviourPtr( FatigueMaterialBehaviourPtr& )
        FatigueMaterialBehaviourPtr( FatigueMaterialBehaviourInstance* )
        FatigueMaterialBehaviourInstance* get()



    cdef cppclass DommaLemaitreMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DommaLemaitreMaterialBehaviourInstance()

    cdef cppclass DommaLemaitreMaterialBehaviourPtr:

        DommaLemaitreMaterialBehaviourPtr( DommaLemaitreMaterialBehaviourPtr& )
        DommaLemaitreMaterialBehaviourPtr( DommaLemaitreMaterialBehaviourInstance* )
        DommaLemaitreMaterialBehaviourInstance* get()



    cdef cppclass CisaPlanCritMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CisaPlanCritMaterialBehaviourInstance()

    cdef cppclass CisaPlanCritMaterialBehaviourPtr:

        CisaPlanCritMaterialBehaviourPtr( CisaPlanCritMaterialBehaviourPtr& )
        CisaPlanCritMaterialBehaviourPtr( CisaPlanCritMaterialBehaviourInstance* )
        CisaPlanCritMaterialBehaviourInstance* get()



    cdef cppclass ThmRuptMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ThmRuptMaterialBehaviourInstance()

    cdef cppclass ThmRuptMaterialBehaviourPtr:

        ThmRuptMaterialBehaviourPtr( ThmRuptMaterialBehaviourPtr& )
        ThmRuptMaterialBehaviourPtr( ThmRuptMaterialBehaviourInstance* )
        ThmRuptMaterialBehaviourInstance* get()



    cdef cppclass WeibullMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        WeibullMaterialBehaviourInstance()

    cdef cppclass WeibullMaterialBehaviourPtr:

        WeibullMaterialBehaviourPtr( WeibullMaterialBehaviourPtr& )
        WeibullMaterialBehaviourPtr( WeibullMaterialBehaviourInstance* )
        WeibullMaterialBehaviourInstance* get()



    cdef cppclass WeibullFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        WeibullFoMaterialBehaviourInstance()

    cdef cppclass WeibullFoMaterialBehaviourPtr:

        WeibullFoMaterialBehaviourPtr( WeibullFoMaterialBehaviourPtr& )
        WeibullFoMaterialBehaviourPtr( WeibullFoMaterialBehaviourInstance* )
        WeibullFoMaterialBehaviourInstance* get()



    cdef cppclass NonLocalMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        NonLocalMaterialBehaviourInstance()

    cdef cppclass NonLocalMaterialBehaviourPtr:

        NonLocalMaterialBehaviourPtr( NonLocalMaterialBehaviourPtr& )
        NonLocalMaterialBehaviourPtr( NonLocalMaterialBehaviourInstance* )
        NonLocalMaterialBehaviourInstance* get()



    cdef cppclass RuptFragMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RuptFragMaterialBehaviourInstance()

    cdef cppclass RuptFragMaterialBehaviourPtr:

        RuptFragMaterialBehaviourPtr( RuptFragMaterialBehaviourPtr& )
        RuptFragMaterialBehaviourPtr( RuptFragMaterialBehaviourInstance* )
        RuptFragMaterialBehaviourInstance* get()



    cdef cppclass RuptFragFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RuptFragFoMaterialBehaviourInstance()

    cdef cppclass RuptFragFoMaterialBehaviourPtr:

        RuptFragFoMaterialBehaviourPtr( RuptFragFoMaterialBehaviourPtr& )
        RuptFragFoMaterialBehaviourPtr( RuptFragFoMaterialBehaviourInstance* )
        RuptFragFoMaterialBehaviourInstance* get()



    cdef cppclass CzmLabMixMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CzmLabMixMaterialBehaviourInstance()

    cdef cppclass CzmLabMixMaterialBehaviourPtr:

        CzmLabMixMaterialBehaviourPtr( CzmLabMixMaterialBehaviourPtr& )
        CzmLabMixMaterialBehaviourPtr( CzmLabMixMaterialBehaviourInstance* )
        CzmLabMixMaterialBehaviourInstance* get()



    cdef cppclass RuptDuctMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RuptDuctMaterialBehaviourInstance()

    cdef cppclass RuptDuctMaterialBehaviourPtr:

        RuptDuctMaterialBehaviourPtr( RuptDuctMaterialBehaviourPtr& )
        RuptDuctMaterialBehaviourPtr( RuptDuctMaterialBehaviourInstance* )
        RuptDuctMaterialBehaviourInstance* get()



    cdef cppclass JointMecaRuptMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        JointMecaRuptMaterialBehaviourInstance()

    cdef cppclass JointMecaRuptMaterialBehaviourPtr:

        JointMecaRuptMaterialBehaviourPtr( JointMecaRuptMaterialBehaviourPtr& )
        JointMecaRuptMaterialBehaviourPtr( JointMecaRuptMaterialBehaviourInstance* )
        JointMecaRuptMaterialBehaviourInstance* get()



    cdef cppclass JointMecaFrotMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        JointMecaFrotMaterialBehaviourInstance()

    cdef cppclass JointMecaFrotMaterialBehaviourPtr:

        JointMecaFrotMaterialBehaviourPtr( JointMecaFrotMaterialBehaviourPtr& )
        JointMecaFrotMaterialBehaviourPtr( JointMecaFrotMaterialBehaviourInstance* )
        JointMecaFrotMaterialBehaviourInstance* get()



    cdef cppclass RccmMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RccmMaterialBehaviourInstance()

    cdef cppclass RccmMaterialBehaviourPtr:

        RccmMaterialBehaviourPtr( RccmMaterialBehaviourPtr& )
        RccmMaterialBehaviourPtr( RccmMaterialBehaviourInstance* )
        RccmMaterialBehaviourInstance* get()



    cdef cppclass RccmFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RccmFoMaterialBehaviourInstance()

    cdef cppclass RccmFoMaterialBehaviourPtr:

        RccmFoMaterialBehaviourPtr( RccmFoMaterialBehaviourPtr& )
        RccmFoMaterialBehaviourPtr( RccmFoMaterialBehaviourInstance* )
        RccmFoMaterialBehaviourInstance* get()



    cdef cppclass LaigleMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LaigleMaterialBehaviourInstance()

    cdef cppclass LaigleMaterialBehaviourPtr:

        LaigleMaterialBehaviourPtr( LaigleMaterialBehaviourPtr& )
        LaigleMaterialBehaviourPtr( LaigleMaterialBehaviourInstance* )
        LaigleMaterialBehaviourInstance* get()



    cdef cppclass LetkMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LetkMaterialBehaviourInstance()

    cdef cppclass LetkMaterialBehaviourPtr:

        LetkMaterialBehaviourPtr( LetkMaterialBehaviourPtr& )
        LetkMaterialBehaviourPtr( LetkMaterialBehaviourInstance* )
        LetkMaterialBehaviourInstance* get()



    cdef cppclass DruckPragerMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DruckPragerMaterialBehaviourInstance()

    cdef cppclass DruckPragerMaterialBehaviourPtr:

        DruckPragerMaterialBehaviourPtr( DruckPragerMaterialBehaviourPtr& )
        DruckPragerMaterialBehaviourPtr( DruckPragerMaterialBehaviourInstance* )
        DruckPragerMaterialBehaviourInstance* get()



    cdef cppclass DruckPragerFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DruckPragerFoMaterialBehaviourInstance()

    cdef cppclass DruckPragerFoMaterialBehaviourPtr:

        DruckPragerFoMaterialBehaviourPtr( DruckPragerFoMaterialBehaviourPtr& )
        DruckPragerFoMaterialBehaviourPtr( DruckPragerFoMaterialBehaviourInstance* )
        DruckPragerFoMaterialBehaviourInstance* get()



    cdef cppclass ViscDrucPragMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscDrucPragMaterialBehaviourInstance()

    cdef cppclass ViscDrucPragMaterialBehaviourPtr:

        ViscDrucPragMaterialBehaviourPtr( ViscDrucPragMaterialBehaviourPtr& )
        ViscDrucPragMaterialBehaviourPtr( ViscDrucPragMaterialBehaviourInstance* )
        ViscDrucPragMaterialBehaviourInstance* get()



    cdef cppclass HoekBrownMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        HoekBrownMaterialBehaviourInstance()

    cdef cppclass HoekBrownMaterialBehaviourPtr:

        HoekBrownMaterialBehaviourPtr( HoekBrownMaterialBehaviourPtr& )
        HoekBrownMaterialBehaviourPtr( HoekBrownMaterialBehaviourInstance* )
        HoekBrownMaterialBehaviourInstance* get()



    cdef cppclass ElasGonfMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ElasGonfMaterialBehaviourInstance()

    cdef cppclass ElasGonfMaterialBehaviourPtr:

        ElasGonfMaterialBehaviourPtr( ElasGonfMaterialBehaviourPtr& )
        ElasGonfMaterialBehaviourPtr( ElasGonfMaterialBehaviourInstance* )
        ElasGonfMaterialBehaviourInstance* get()



    cdef cppclass JointBandisMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        JointBandisMaterialBehaviourInstance()

    cdef cppclass JointBandisMaterialBehaviourPtr:

        JointBandisMaterialBehaviourPtr( JointBandisMaterialBehaviourPtr& )
        JointBandisMaterialBehaviourPtr( JointBandisMaterialBehaviourInstance* )
        JointBandisMaterialBehaviourInstance* get()



    cdef cppclass MonoVisc1MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoVisc1MaterialBehaviourInstance()

    cdef cppclass MonoVisc1MaterialBehaviourPtr:

        MonoVisc1MaterialBehaviourPtr( MonoVisc1MaterialBehaviourPtr& )
        MonoVisc1MaterialBehaviourPtr( MonoVisc1MaterialBehaviourInstance* )
        MonoVisc1MaterialBehaviourInstance* get()



    cdef cppclass MonoVisc2MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoVisc2MaterialBehaviourInstance()

    cdef cppclass MonoVisc2MaterialBehaviourPtr:

        MonoVisc2MaterialBehaviourPtr( MonoVisc2MaterialBehaviourPtr& )
        MonoVisc2MaterialBehaviourPtr( MonoVisc2MaterialBehaviourInstance* )
        MonoVisc2MaterialBehaviourInstance* get()



    cdef cppclass MonoIsot1MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoIsot1MaterialBehaviourInstance()

    cdef cppclass MonoIsot1MaterialBehaviourPtr:

        MonoIsot1MaterialBehaviourPtr( MonoIsot1MaterialBehaviourPtr& )
        MonoIsot1MaterialBehaviourPtr( MonoIsot1MaterialBehaviourInstance* )
        MonoIsot1MaterialBehaviourInstance* get()



    cdef cppclass MonoIsot2MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoIsot2MaterialBehaviourInstance()

    cdef cppclass MonoIsot2MaterialBehaviourPtr:

        MonoIsot2MaterialBehaviourPtr( MonoIsot2MaterialBehaviourPtr& )
        MonoIsot2MaterialBehaviourPtr( MonoIsot2MaterialBehaviourInstance* )
        MonoIsot2MaterialBehaviourInstance* get()



    cdef cppclass MonoCine1MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoCine1MaterialBehaviourInstance()

    cdef cppclass MonoCine1MaterialBehaviourPtr:

        MonoCine1MaterialBehaviourPtr( MonoCine1MaterialBehaviourPtr& )
        MonoCine1MaterialBehaviourPtr( MonoCine1MaterialBehaviourInstance* )
        MonoCine1MaterialBehaviourInstance* get()



    cdef cppclass MonoCine2MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoCine2MaterialBehaviourInstance()

    cdef cppclass MonoCine2MaterialBehaviourPtr:

        MonoCine2MaterialBehaviourPtr( MonoCine2MaterialBehaviourPtr& )
        MonoCine2MaterialBehaviourPtr( MonoCine2MaterialBehaviourInstance* )
        MonoCine2MaterialBehaviourInstance* get()



    cdef cppclass MonoDdKrMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoDdKrMaterialBehaviourInstance()

    cdef cppclass MonoDdKrMaterialBehaviourPtr:

        MonoDdKrMaterialBehaviourPtr( MonoDdKrMaterialBehaviourPtr& )
        MonoDdKrMaterialBehaviourPtr( MonoDdKrMaterialBehaviourInstance* )
        MonoDdKrMaterialBehaviourInstance* get()



    cdef cppclass MonoDdCfcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoDdCfcMaterialBehaviourInstance()

    cdef cppclass MonoDdCfcMaterialBehaviourPtr:

        MonoDdCfcMaterialBehaviourPtr( MonoDdCfcMaterialBehaviourPtr& )
        MonoDdCfcMaterialBehaviourPtr( MonoDdCfcMaterialBehaviourInstance* )
        MonoDdCfcMaterialBehaviourInstance* get()



    cdef cppclass MonoDdCfcIrraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoDdCfcIrraMaterialBehaviourInstance()

    cdef cppclass MonoDdCfcIrraMaterialBehaviourPtr:

        MonoDdCfcIrraMaterialBehaviourPtr( MonoDdCfcIrraMaterialBehaviourPtr& )
        MonoDdCfcIrraMaterialBehaviourPtr( MonoDdCfcIrraMaterialBehaviourInstance* )
        MonoDdCfcIrraMaterialBehaviourInstance* get()



    cdef cppclass MonoDdFatMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoDdFatMaterialBehaviourInstance()

    cdef cppclass MonoDdFatMaterialBehaviourPtr:

        MonoDdFatMaterialBehaviourPtr( MonoDdFatMaterialBehaviourPtr& )
        MonoDdFatMaterialBehaviourPtr( MonoDdFatMaterialBehaviourInstance* )
        MonoDdFatMaterialBehaviourInstance* get()



    cdef cppclass MonoDdCcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoDdCcMaterialBehaviourInstance()

    cdef cppclass MonoDdCcMaterialBehaviourPtr:

        MonoDdCcMaterialBehaviourPtr( MonoDdCcMaterialBehaviourPtr& )
        MonoDdCcMaterialBehaviourPtr( MonoDdCcMaterialBehaviourInstance* )
        MonoDdCcMaterialBehaviourInstance* get()



    cdef cppclass MonoDdCcIrraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        MonoDdCcIrraMaterialBehaviourInstance()

    cdef cppclass MonoDdCcIrraMaterialBehaviourPtr:

        MonoDdCcIrraMaterialBehaviourPtr( MonoDdCcIrraMaterialBehaviourPtr& )
        MonoDdCcIrraMaterialBehaviourPtr( MonoDdCcIrraMaterialBehaviourInstance* )
        MonoDdCcIrraMaterialBehaviourInstance* get()



    cdef cppclass UmatMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        UmatMaterialBehaviourInstance()

    cdef cppclass UmatMaterialBehaviourPtr:

        UmatMaterialBehaviourPtr( UmatMaterialBehaviourPtr& )
        UmatMaterialBehaviourPtr( UmatMaterialBehaviourInstance* )
        UmatMaterialBehaviourInstance* get()



    cdef cppclass UmatFoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        UmatFoMaterialBehaviourInstance()

    cdef cppclass UmatFoMaterialBehaviourPtr:

        UmatFoMaterialBehaviourPtr( UmatFoMaterialBehaviourPtr& )
        UmatFoMaterialBehaviourPtr( UmatFoMaterialBehaviourInstance* )
        UmatFoMaterialBehaviourInstance* get()



    cdef cppclass CritRuptMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CritRuptMaterialBehaviourInstance()

    cdef cppclass CritRuptMaterialBehaviourPtr:

        CritRuptMaterialBehaviourPtr( CritRuptMaterialBehaviourPtr& )
        CritRuptMaterialBehaviourPtr( CritRuptMaterialBehaviourInstance* )
        CritRuptMaterialBehaviourInstance* get()


cdef class GeneralMaterialBehaviour:

    cdef GeneralMaterialBehaviourPtr* _cptr

    cdef set( self, GeneralMaterialBehaviourPtr other )
    cdef GeneralMaterialBehaviourPtr* getPtr( self )
    cdef GeneralMaterialBehaviourInstance* getInstance( self )
cdef class ElasMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasFluiMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasIstrMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasIstrFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasOrthMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasOrthFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasHyperMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasCoqueMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasCoqueFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasMembraneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Elas2ndgMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasGlrcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasGlrcFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasDhrcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CableMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class VeriBorneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TractionMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EcroLineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EndoHeterogeneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EcroLineFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EcroPuisMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EcroPuisFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EcroCookMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EcroCookFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BetonEcroLineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BetonReglePrMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EndoOrthBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class PragerMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class PragerFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TaheriMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TaheriFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class RousselierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class RousselierFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscSinhMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscSinhFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Cin1ChabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Cin1ChabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Cin2ChabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Cin2ChabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Cin2NradMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MemoEcroMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MemoEcroFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscochabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscochabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LemaitreMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LemaitreIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LmarcIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscIrraLogMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class GranIrraLogMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LemaSeuilMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LemaSeuilFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Irrad3mMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LemaitreFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaLemaAniMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaLemaAniFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ArmeMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class AsseCornMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DisContactMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EndoScalaireMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EndoScalaireFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EndoFissExpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EndoFissExpFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DisGricraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BetonDoubleDpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MazarsMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MazarsFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class JointBaMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class VendochabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class VendochabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class HayhurstMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscEndoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscEndoFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class PintoMenegottoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BpelBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BpelAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EtccBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EtccAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MohrCoulombMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CamClayMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BarceloneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CjsMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class HujeuxMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class EcroAsymLineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class GrangerFpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class GrangerFp_indtMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class VGrangerFpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BetonBurgerFpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BetonUmlvFpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class BetonRagMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class PoroBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class GlrcDmMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DhrcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class GattMonerieMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CorrAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CableGaineFrotMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DisEcroCineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DisViscMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DisBiliElasMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TherNlMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TherHydrMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TherMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TherFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TherOrthMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TherCoqueMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class TherCoqueFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class SechGrangerMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class SechMensiMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class SechBazantMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class SechNappeMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaZircMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DurtMetaMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasMetaMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasMetaFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaEcroLineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaTractionMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaViscFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaPtMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MetaReMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class FluideMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ThmGazMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ThmVapeGazMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ThmLiquMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class FatigueMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DommaLemaitreMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CisaPlanCritMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ThmRuptMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class WeibullMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class WeibullFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class NonLocalMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class RuptFragMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class RuptFragFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CzmLabMixMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class RuptDuctMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class JointMecaRuptMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class JointMecaFrotMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class RccmMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class RccmFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LaigleMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class LetkMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DruckPragerFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class DruckPragerFoFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ViscDrucPragMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class HoekBrownMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class ElasGonfMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class JointBandisMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoVisc1MaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoVisc2MaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoIsot1MaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoIsot2MaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoCine1MaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoCine2MaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoDdKrMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoDdCfcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoDdCfcIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoDdFatMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoDdCcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class MonoDdCcIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class UmatMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class UmatFoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class CritRuptMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
