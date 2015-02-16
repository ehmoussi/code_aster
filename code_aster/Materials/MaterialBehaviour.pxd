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

    cdef cppclass Elas_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_foMaterialBehaviourInstance()

    cdef cppclass Elas_foMaterialBehaviourPtr:

        Elas_foMaterialBehaviourPtr( Elas_foMaterialBehaviourPtr& )
        Elas_foMaterialBehaviourPtr( Elas_foMaterialBehaviourInstance* )
        Elas_foMaterialBehaviourInstance* get()



    cdef cppclass Elas_fluiMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_fluiMaterialBehaviourInstance()

    cdef cppclass Elas_fluiMaterialBehaviourPtr:

        Elas_fluiMaterialBehaviourPtr( Elas_fluiMaterialBehaviourPtr& )
        Elas_fluiMaterialBehaviourPtr( Elas_fluiMaterialBehaviourInstance* )
        Elas_fluiMaterialBehaviourInstance* get()



    cdef cppclass Elas_istrMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_istrMaterialBehaviourInstance()

    cdef cppclass Elas_istrMaterialBehaviourPtr:

        Elas_istrMaterialBehaviourPtr( Elas_istrMaterialBehaviourPtr& )
        Elas_istrMaterialBehaviourPtr( Elas_istrMaterialBehaviourInstance* )
        Elas_istrMaterialBehaviourInstance* get()



    cdef cppclass Elas_istr_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_istr_foMaterialBehaviourInstance()

    cdef cppclass Elas_istr_foMaterialBehaviourPtr:

        Elas_istr_foMaterialBehaviourPtr( Elas_istr_foMaterialBehaviourPtr& )
        Elas_istr_foMaterialBehaviourPtr( Elas_istr_foMaterialBehaviourInstance* )
        Elas_istr_foMaterialBehaviourInstance* get()



    cdef cppclass Elas_orthMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_orthMaterialBehaviourInstance()

    cdef cppclass Elas_orthMaterialBehaviourPtr:

        Elas_orthMaterialBehaviourPtr( Elas_orthMaterialBehaviourPtr& )
        Elas_orthMaterialBehaviourPtr( Elas_orthMaterialBehaviourInstance* )
        Elas_orthMaterialBehaviourInstance* get()



    cdef cppclass Elas_orth_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_orth_foMaterialBehaviourInstance()

    cdef cppclass Elas_orth_foMaterialBehaviourPtr:

        Elas_orth_foMaterialBehaviourPtr( Elas_orth_foMaterialBehaviourPtr& )
        Elas_orth_foMaterialBehaviourPtr( Elas_orth_foMaterialBehaviourInstance* )
        Elas_orth_foMaterialBehaviourInstance* get()



    cdef cppclass Elas_hyperMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_hyperMaterialBehaviourInstance()

    cdef cppclass Elas_hyperMaterialBehaviourPtr:

        Elas_hyperMaterialBehaviourPtr( Elas_hyperMaterialBehaviourPtr& )
        Elas_hyperMaterialBehaviourPtr( Elas_hyperMaterialBehaviourInstance* )
        Elas_hyperMaterialBehaviourInstance* get()



    cdef cppclass Elas_coqueMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_coqueMaterialBehaviourInstance()

    cdef cppclass Elas_coqueMaterialBehaviourPtr:

        Elas_coqueMaterialBehaviourPtr( Elas_coqueMaterialBehaviourPtr& )
        Elas_coqueMaterialBehaviourPtr( Elas_coqueMaterialBehaviourInstance* )
        Elas_coqueMaterialBehaviourInstance* get()



    cdef cppclass Elas_coque_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_coque_foMaterialBehaviourInstance()

    cdef cppclass Elas_coque_foMaterialBehaviourPtr:

        Elas_coque_foMaterialBehaviourPtr( Elas_coque_foMaterialBehaviourPtr& )
        Elas_coque_foMaterialBehaviourPtr( Elas_coque_foMaterialBehaviourInstance* )
        Elas_coque_foMaterialBehaviourInstance* get()



    cdef cppclass Elas_membraneMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_membraneMaterialBehaviourInstance()

    cdef cppclass Elas_membraneMaterialBehaviourPtr:

        Elas_membraneMaterialBehaviourPtr( Elas_membraneMaterialBehaviourPtr& )
        Elas_membraneMaterialBehaviourPtr( Elas_membraneMaterialBehaviourInstance* )
        Elas_membraneMaterialBehaviourInstance* get()



    cdef cppclass Elas_2ndgMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_2ndgMaterialBehaviourInstance()

    cdef cppclass Elas_2ndgMaterialBehaviourPtr:

        Elas_2ndgMaterialBehaviourPtr( Elas_2ndgMaterialBehaviourPtr& )
        Elas_2ndgMaterialBehaviourPtr( Elas_2ndgMaterialBehaviourInstance* )
        Elas_2ndgMaterialBehaviourInstance* get()



    cdef cppclass Elas_glrcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_glrcMaterialBehaviourInstance()

    cdef cppclass Elas_glrcMaterialBehaviourPtr:

        Elas_glrcMaterialBehaviourPtr( Elas_glrcMaterialBehaviourPtr& )
        Elas_glrcMaterialBehaviourPtr( Elas_glrcMaterialBehaviourInstance* )
        Elas_glrcMaterialBehaviourInstance* get()



    cdef cppclass Elas_glrc_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_glrc_foMaterialBehaviourInstance()

    cdef cppclass Elas_glrc_foMaterialBehaviourPtr:

        Elas_glrc_foMaterialBehaviourPtr( Elas_glrc_foMaterialBehaviourPtr& )
        Elas_glrc_foMaterialBehaviourPtr( Elas_glrc_foMaterialBehaviourInstance* )
        Elas_glrc_foMaterialBehaviourInstance* get()



    cdef cppclass Elas_dhrcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_dhrcMaterialBehaviourInstance()

    cdef cppclass Elas_dhrcMaterialBehaviourPtr:

        Elas_dhrcMaterialBehaviourPtr( Elas_dhrcMaterialBehaviourPtr& )
        Elas_dhrcMaterialBehaviourPtr( Elas_dhrcMaterialBehaviourInstance* )
        Elas_dhrcMaterialBehaviourInstance* get()



    cdef cppclass CableMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        CableMaterialBehaviourInstance()

    cdef cppclass CableMaterialBehaviourPtr:

        CableMaterialBehaviourPtr( CableMaterialBehaviourPtr& )
        CableMaterialBehaviourPtr( CableMaterialBehaviourInstance* )
        CableMaterialBehaviourInstance* get()



    cdef cppclass Veri_borneMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Veri_borneMaterialBehaviourInstance()

    cdef cppclass Veri_borneMaterialBehaviourPtr:

        Veri_borneMaterialBehaviourPtr( Veri_borneMaterialBehaviourPtr& )
        Veri_borneMaterialBehaviourPtr( Veri_borneMaterialBehaviourInstance* )
        Veri_borneMaterialBehaviourInstance* get()



    cdef cppclass TractionMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TractionMaterialBehaviourInstance()

    cdef cppclass TractionMaterialBehaviourPtr:

        TractionMaterialBehaviourPtr( TractionMaterialBehaviourPtr& )
        TractionMaterialBehaviourPtr( TractionMaterialBehaviourInstance* )
        TractionMaterialBehaviourInstance* get()



    cdef cppclass Ecro_lineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ecro_lineMaterialBehaviourInstance()

    cdef cppclass Ecro_lineMaterialBehaviourPtr:

        Ecro_lineMaterialBehaviourPtr( Ecro_lineMaterialBehaviourPtr& )
        Ecro_lineMaterialBehaviourPtr( Ecro_lineMaterialBehaviourInstance* )
        Ecro_lineMaterialBehaviourInstance* get()



    cdef cppclass Endo_heterogeneMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Endo_heterogeneMaterialBehaviourInstance()

    cdef cppclass Endo_heterogeneMaterialBehaviourPtr:

        Endo_heterogeneMaterialBehaviourPtr( Endo_heterogeneMaterialBehaviourPtr& )
        Endo_heterogeneMaterialBehaviourPtr( Endo_heterogeneMaterialBehaviourInstance* )
        Endo_heterogeneMaterialBehaviourInstance* get()



    cdef cppclass Ecro_line_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ecro_line_foMaterialBehaviourInstance()

    cdef cppclass Ecro_line_foMaterialBehaviourPtr:

        Ecro_line_foMaterialBehaviourPtr( Ecro_line_foMaterialBehaviourPtr& )
        Ecro_line_foMaterialBehaviourPtr( Ecro_line_foMaterialBehaviourInstance* )
        Ecro_line_foMaterialBehaviourInstance* get()



    cdef cppclass Ecro_puisMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ecro_puisMaterialBehaviourInstance()

    cdef cppclass Ecro_puisMaterialBehaviourPtr:

        Ecro_puisMaterialBehaviourPtr( Ecro_puisMaterialBehaviourPtr& )
        Ecro_puisMaterialBehaviourPtr( Ecro_puisMaterialBehaviourInstance* )
        Ecro_puisMaterialBehaviourInstance* get()



    cdef cppclass Ecro_puis_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ecro_puis_foMaterialBehaviourInstance()

    cdef cppclass Ecro_puis_foMaterialBehaviourPtr:

        Ecro_puis_foMaterialBehaviourPtr( Ecro_puis_foMaterialBehaviourPtr& )
        Ecro_puis_foMaterialBehaviourPtr( Ecro_puis_foMaterialBehaviourInstance* )
        Ecro_puis_foMaterialBehaviourInstance* get()



    cdef cppclass Ecro_cookMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ecro_cookMaterialBehaviourInstance()

    cdef cppclass Ecro_cookMaterialBehaviourPtr:

        Ecro_cookMaterialBehaviourPtr( Ecro_cookMaterialBehaviourPtr& )
        Ecro_cookMaterialBehaviourPtr( Ecro_cookMaterialBehaviourInstance* )
        Ecro_cookMaterialBehaviourInstance* get()



    cdef cppclass Ecro_cook_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ecro_cook_foMaterialBehaviourInstance()

    cdef cppclass Ecro_cook_foMaterialBehaviourPtr:

        Ecro_cook_foMaterialBehaviourPtr( Ecro_cook_foMaterialBehaviourPtr& )
        Ecro_cook_foMaterialBehaviourPtr( Ecro_cook_foMaterialBehaviourInstance* )
        Ecro_cook_foMaterialBehaviourInstance* get()



    cdef cppclass Beton_ecro_lineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Beton_ecro_lineMaterialBehaviourInstance()

    cdef cppclass Beton_ecro_lineMaterialBehaviourPtr:

        Beton_ecro_lineMaterialBehaviourPtr( Beton_ecro_lineMaterialBehaviourPtr& )
        Beton_ecro_lineMaterialBehaviourPtr( Beton_ecro_lineMaterialBehaviourInstance* )
        Beton_ecro_lineMaterialBehaviourInstance* get()



    cdef cppclass Beton_regle_prMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Beton_regle_prMaterialBehaviourInstance()

    cdef cppclass Beton_regle_prMaterialBehaviourPtr:

        Beton_regle_prMaterialBehaviourPtr( Beton_regle_prMaterialBehaviourPtr& )
        Beton_regle_prMaterialBehaviourPtr( Beton_regle_prMaterialBehaviourInstance* )
        Beton_regle_prMaterialBehaviourInstance* get()



    cdef cppclass Endo_orth_betonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Endo_orth_betonMaterialBehaviourInstance()

    cdef cppclass Endo_orth_betonMaterialBehaviourPtr:

        Endo_orth_betonMaterialBehaviourPtr( Endo_orth_betonMaterialBehaviourPtr& )
        Endo_orth_betonMaterialBehaviourPtr( Endo_orth_betonMaterialBehaviourInstance* )
        Endo_orth_betonMaterialBehaviourInstance* get()



    cdef cppclass PragerMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        PragerMaterialBehaviourInstance()

    cdef cppclass PragerMaterialBehaviourPtr:

        PragerMaterialBehaviourPtr( PragerMaterialBehaviourPtr& )
        PragerMaterialBehaviourPtr( PragerMaterialBehaviourInstance* )
        PragerMaterialBehaviourInstance* get()



    cdef cppclass Prager_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Prager_foMaterialBehaviourInstance()

    cdef cppclass Prager_foMaterialBehaviourPtr:

        Prager_foMaterialBehaviourPtr( Prager_foMaterialBehaviourPtr& )
        Prager_foMaterialBehaviourPtr( Prager_foMaterialBehaviourInstance* )
        Prager_foMaterialBehaviourInstance* get()



    cdef cppclass TaheriMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TaheriMaterialBehaviourInstance()

    cdef cppclass TaheriMaterialBehaviourPtr:

        TaheriMaterialBehaviourPtr( TaheriMaterialBehaviourPtr& )
        TaheriMaterialBehaviourPtr( TaheriMaterialBehaviourInstance* )
        TaheriMaterialBehaviourInstance* get()



    cdef cppclass Taheri_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Taheri_foMaterialBehaviourInstance()

    cdef cppclass Taheri_foMaterialBehaviourPtr:

        Taheri_foMaterialBehaviourPtr( Taheri_foMaterialBehaviourPtr& )
        Taheri_foMaterialBehaviourPtr( Taheri_foMaterialBehaviourInstance* )
        Taheri_foMaterialBehaviourInstance* get()



    cdef cppclass RousselierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RousselierMaterialBehaviourInstance()

    cdef cppclass RousselierMaterialBehaviourPtr:

        RousselierMaterialBehaviourPtr( RousselierMaterialBehaviourPtr& )
        RousselierMaterialBehaviourPtr( RousselierMaterialBehaviourInstance* )
        RousselierMaterialBehaviourInstance* get()



    cdef cppclass Rousselier_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Rousselier_foMaterialBehaviourInstance()

    cdef cppclass Rousselier_foMaterialBehaviourPtr:

        Rousselier_foMaterialBehaviourPtr( Rousselier_foMaterialBehaviourPtr& )
        Rousselier_foMaterialBehaviourPtr( Rousselier_foMaterialBehaviourInstance* )
        Rousselier_foMaterialBehaviourInstance* get()



    cdef cppclass Visc_sinhMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Visc_sinhMaterialBehaviourInstance()

    cdef cppclass Visc_sinhMaterialBehaviourPtr:

        Visc_sinhMaterialBehaviourPtr( Visc_sinhMaterialBehaviourPtr& )
        Visc_sinhMaterialBehaviourPtr( Visc_sinhMaterialBehaviourInstance* )
        Visc_sinhMaterialBehaviourInstance* get()



    cdef cppclass Visc_sinh_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Visc_sinh_foMaterialBehaviourInstance()

    cdef cppclass Visc_sinh_foMaterialBehaviourPtr:

        Visc_sinh_foMaterialBehaviourPtr( Visc_sinh_foMaterialBehaviourPtr& )
        Visc_sinh_foMaterialBehaviourPtr( Visc_sinh_foMaterialBehaviourInstance* )
        Visc_sinh_foMaterialBehaviourInstance* get()



    cdef cppclass Cin1_chabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin1_chabMaterialBehaviourInstance()

    cdef cppclass Cin1_chabMaterialBehaviourPtr:

        Cin1_chabMaterialBehaviourPtr( Cin1_chabMaterialBehaviourPtr& )
        Cin1_chabMaterialBehaviourPtr( Cin1_chabMaterialBehaviourInstance* )
        Cin1_chabMaterialBehaviourInstance* get()



    cdef cppclass Cin1_chab_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin1_chab_foMaterialBehaviourInstance()

    cdef cppclass Cin1_chab_foMaterialBehaviourPtr:

        Cin1_chab_foMaterialBehaviourPtr( Cin1_chab_foMaterialBehaviourPtr& )
        Cin1_chab_foMaterialBehaviourPtr( Cin1_chab_foMaterialBehaviourInstance* )
        Cin1_chab_foMaterialBehaviourInstance* get()



    cdef cppclass Cin2_chabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin2_chabMaterialBehaviourInstance()

    cdef cppclass Cin2_chabMaterialBehaviourPtr:

        Cin2_chabMaterialBehaviourPtr( Cin2_chabMaterialBehaviourPtr& )
        Cin2_chabMaterialBehaviourPtr( Cin2_chabMaterialBehaviourInstance* )
        Cin2_chabMaterialBehaviourInstance* get()



    cdef cppclass Cin2_chab_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin2_chab_foMaterialBehaviourInstance()

    cdef cppclass Cin2_chab_foMaterialBehaviourPtr:

        Cin2_chab_foMaterialBehaviourPtr( Cin2_chab_foMaterialBehaviourPtr& )
        Cin2_chab_foMaterialBehaviourPtr( Cin2_chab_foMaterialBehaviourInstance* )
        Cin2_chab_foMaterialBehaviourInstance* get()



    cdef cppclass Cin2_nradMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cin2_nradMaterialBehaviourInstance()

    cdef cppclass Cin2_nradMaterialBehaviourPtr:

        Cin2_nradMaterialBehaviourPtr( Cin2_nradMaterialBehaviourPtr& )
        Cin2_nradMaterialBehaviourPtr( Cin2_nradMaterialBehaviourInstance* )
        Cin2_nradMaterialBehaviourInstance* get()



    cdef cppclass Memo_ecroMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Memo_ecroMaterialBehaviourInstance()

    cdef cppclass Memo_ecroMaterialBehaviourPtr:

        Memo_ecroMaterialBehaviourPtr( Memo_ecroMaterialBehaviourPtr& )
        Memo_ecroMaterialBehaviourPtr( Memo_ecroMaterialBehaviourInstance* )
        Memo_ecroMaterialBehaviourInstance* get()



    cdef cppclass Memo_ecro_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Memo_ecro_foMaterialBehaviourInstance()

    cdef cppclass Memo_ecro_foMaterialBehaviourPtr:

        Memo_ecro_foMaterialBehaviourPtr( Memo_ecro_foMaterialBehaviourPtr& )
        Memo_ecro_foMaterialBehaviourPtr( Memo_ecro_foMaterialBehaviourInstance* )
        Memo_ecro_foMaterialBehaviourInstance* get()



    cdef cppclass ViscochabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ViscochabMaterialBehaviourInstance()

    cdef cppclass ViscochabMaterialBehaviourPtr:

        ViscochabMaterialBehaviourPtr( ViscochabMaterialBehaviourPtr& )
        ViscochabMaterialBehaviourPtr( ViscochabMaterialBehaviourInstance* )
        ViscochabMaterialBehaviourInstance* get()



    cdef cppclass Viscochab_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Viscochab_foMaterialBehaviourInstance()

    cdef cppclass Viscochab_foMaterialBehaviourPtr:

        Viscochab_foMaterialBehaviourPtr( Viscochab_foMaterialBehaviourPtr& )
        Viscochab_foMaterialBehaviourPtr( Viscochab_foMaterialBehaviourInstance* )
        Viscochab_foMaterialBehaviourInstance* get()



    cdef cppclass LemaitreMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        LemaitreMaterialBehaviourInstance()

    cdef cppclass LemaitreMaterialBehaviourPtr:

        LemaitreMaterialBehaviourPtr( LemaitreMaterialBehaviourPtr& )
        LemaitreMaterialBehaviourPtr( LemaitreMaterialBehaviourInstance* )
        LemaitreMaterialBehaviourInstance* get()



    cdef cppclass Lemaitre_irraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Lemaitre_irraMaterialBehaviourInstance()

    cdef cppclass Lemaitre_irraMaterialBehaviourPtr:

        Lemaitre_irraMaterialBehaviourPtr( Lemaitre_irraMaterialBehaviourPtr& )
        Lemaitre_irraMaterialBehaviourPtr( Lemaitre_irraMaterialBehaviourInstance* )
        Lemaitre_irraMaterialBehaviourInstance* get()



    cdef cppclass Lmarc_irraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Lmarc_irraMaterialBehaviourInstance()

    cdef cppclass Lmarc_irraMaterialBehaviourPtr:

        Lmarc_irraMaterialBehaviourPtr( Lmarc_irraMaterialBehaviourPtr& )
        Lmarc_irraMaterialBehaviourPtr( Lmarc_irraMaterialBehaviourInstance* )
        Lmarc_irraMaterialBehaviourInstance* get()



    cdef cppclass Visc_irra_logMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Visc_irra_logMaterialBehaviourInstance()

    cdef cppclass Visc_irra_logMaterialBehaviourPtr:

        Visc_irra_logMaterialBehaviourPtr( Visc_irra_logMaterialBehaviourPtr& )
        Visc_irra_logMaterialBehaviourPtr( Visc_irra_logMaterialBehaviourInstance* )
        Visc_irra_logMaterialBehaviourInstance* get()



    cdef cppclass Gran_irra_logMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Gran_irra_logMaterialBehaviourInstance()

    cdef cppclass Gran_irra_logMaterialBehaviourPtr:

        Gran_irra_logMaterialBehaviourPtr( Gran_irra_logMaterialBehaviourPtr& )
        Gran_irra_logMaterialBehaviourPtr( Gran_irra_logMaterialBehaviourInstance* )
        Gran_irra_logMaterialBehaviourInstance* get()



    cdef cppclass Lema_seuilMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Lema_seuilMaterialBehaviourInstance()

    cdef cppclass Lema_seuilMaterialBehaviourPtr:

        Lema_seuilMaterialBehaviourPtr( Lema_seuilMaterialBehaviourPtr& )
        Lema_seuilMaterialBehaviourPtr( Lema_seuilMaterialBehaviourInstance* )
        Lema_seuilMaterialBehaviourInstance* get()



    cdef cppclass Lemaitre_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Lemaitre_foMaterialBehaviourInstance()

    cdef cppclass Lemaitre_foMaterialBehaviourPtr:

        Lemaitre_foMaterialBehaviourPtr( Lemaitre_foMaterialBehaviourPtr& )
        Lemaitre_foMaterialBehaviourPtr( Lemaitre_foMaterialBehaviourInstance* )
        Lemaitre_foMaterialBehaviourInstance* get()



    cdef cppclass Meta_lema_aniMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_lema_aniMaterialBehaviourInstance()

    cdef cppclass Meta_lema_aniMaterialBehaviourPtr:

        Meta_lema_aniMaterialBehaviourPtr( Meta_lema_aniMaterialBehaviourPtr& )
        Meta_lema_aniMaterialBehaviourPtr( Meta_lema_aniMaterialBehaviourInstance* )
        Meta_lema_aniMaterialBehaviourInstance* get()



    cdef cppclass Meta_lema_ani_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_lema_ani_foMaterialBehaviourInstance()

    cdef cppclass Meta_lema_ani_foMaterialBehaviourPtr:

        Meta_lema_ani_foMaterialBehaviourPtr( Meta_lema_ani_foMaterialBehaviourPtr& )
        Meta_lema_ani_foMaterialBehaviourPtr( Meta_lema_ani_foMaterialBehaviourInstance* )
        Meta_lema_ani_foMaterialBehaviourInstance* get()



    cdef cppclass ArmeMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        ArmeMaterialBehaviourInstance()

    cdef cppclass ArmeMaterialBehaviourPtr:

        ArmeMaterialBehaviourPtr( ArmeMaterialBehaviourPtr& )
        ArmeMaterialBehaviourPtr( ArmeMaterialBehaviourInstance* )
        ArmeMaterialBehaviourInstance* get()



    cdef cppclass Asse_cornMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Asse_cornMaterialBehaviourInstance()

    cdef cppclass Asse_cornMaterialBehaviourPtr:

        Asse_cornMaterialBehaviourPtr( Asse_cornMaterialBehaviourPtr& )
        Asse_cornMaterialBehaviourPtr( Asse_cornMaterialBehaviourInstance* )
        Asse_cornMaterialBehaviourInstance* get()



    cdef cppclass Dis_contactMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Dis_contactMaterialBehaviourInstance()

    cdef cppclass Dis_contactMaterialBehaviourPtr:

        Dis_contactMaterialBehaviourPtr( Dis_contactMaterialBehaviourPtr& )
        Dis_contactMaterialBehaviourPtr( Dis_contactMaterialBehaviourInstance* )
        Dis_contactMaterialBehaviourInstance* get()



    cdef cppclass Endo_scalaireMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Endo_scalaireMaterialBehaviourInstance()

    cdef cppclass Endo_scalaireMaterialBehaviourPtr:

        Endo_scalaireMaterialBehaviourPtr( Endo_scalaireMaterialBehaviourPtr& )
        Endo_scalaireMaterialBehaviourPtr( Endo_scalaireMaterialBehaviourInstance* )
        Endo_scalaireMaterialBehaviourInstance* get()



    cdef cppclass Endo_scalaire_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Endo_scalaire_foMaterialBehaviourInstance()

    cdef cppclass Endo_scalaire_foMaterialBehaviourPtr:

        Endo_scalaire_foMaterialBehaviourPtr( Endo_scalaire_foMaterialBehaviourPtr& )
        Endo_scalaire_foMaterialBehaviourPtr( Endo_scalaire_foMaterialBehaviourInstance* )
        Endo_scalaire_foMaterialBehaviourInstance* get()



    cdef cppclass Endo_fiss_expMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Endo_fiss_expMaterialBehaviourInstance()

    cdef cppclass Endo_fiss_expMaterialBehaviourPtr:

        Endo_fiss_expMaterialBehaviourPtr( Endo_fiss_expMaterialBehaviourPtr& )
        Endo_fiss_expMaterialBehaviourPtr( Endo_fiss_expMaterialBehaviourInstance* )
        Endo_fiss_expMaterialBehaviourInstance* get()



    cdef cppclass Endo_fiss_exp_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Endo_fiss_exp_foMaterialBehaviourInstance()

    cdef cppclass Endo_fiss_exp_foMaterialBehaviourPtr:

        Endo_fiss_exp_foMaterialBehaviourPtr( Endo_fiss_exp_foMaterialBehaviourPtr& )
        Endo_fiss_exp_foMaterialBehaviourPtr( Endo_fiss_exp_foMaterialBehaviourInstance* )
        Endo_fiss_exp_foMaterialBehaviourInstance* get()



    cdef cppclass Dis_gricraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Dis_gricraMaterialBehaviourInstance()

    cdef cppclass Dis_gricraMaterialBehaviourPtr:

        Dis_gricraMaterialBehaviourPtr( Dis_gricraMaterialBehaviourPtr& )
        Dis_gricraMaterialBehaviourPtr( Dis_gricraMaterialBehaviourInstance* )
        Dis_gricraMaterialBehaviourInstance* get()



    cdef cppclass Beton_double_dpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Beton_double_dpMaterialBehaviourInstance()

    cdef cppclass Beton_double_dpMaterialBehaviourPtr:

        Beton_double_dpMaterialBehaviourPtr( Beton_double_dpMaterialBehaviourPtr& )
        Beton_double_dpMaterialBehaviourPtr( Beton_double_dpMaterialBehaviourInstance* )
        Beton_double_dpMaterialBehaviourInstance* get()



    cdef cppclass VendochabMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        VendochabMaterialBehaviourInstance()

    cdef cppclass VendochabMaterialBehaviourPtr:

        VendochabMaterialBehaviourPtr( VendochabMaterialBehaviourPtr& )
        VendochabMaterialBehaviourPtr( VendochabMaterialBehaviourInstance* )
        VendochabMaterialBehaviourInstance* get()



    cdef cppclass Vendochab_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Vendochab_foMaterialBehaviourInstance()

    cdef cppclass Vendochab_foMaterialBehaviourPtr:

        Vendochab_foMaterialBehaviourPtr( Vendochab_foMaterialBehaviourPtr& )
        Vendochab_foMaterialBehaviourPtr( Vendochab_foMaterialBehaviourInstance* )
        Vendochab_foMaterialBehaviourInstance* get()



    cdef cppclass HayhurstMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        HayhurstMaterialBehaviourInstance()

    cdef cppclass HayhurstMaterialBehaviourPtr:

        HayhurstMaterialBehaviourPtr( HayhurstMaterialBehaviourPtr& )
        HayhurstMaterialBehaviourPtr( HayhurstMaterialBehaviourInstance* )
        HayhurstMaterialBehaviourInstance* get()



    cdef cppclass Visc_endoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Visc_endoMaterialBehaviourInstance()

    cdef cppclass Visc_endoMaterialBehaviourPtr:

        Visc_endoMaterialBehaviourPtr( Visc_endoMaterialBehaviourPtr& )
        Visc_endoMaterialBehaviourPtr( Visc_endoMaterialBehaviourInstance* )
        Visc_endoMaterialBehaviourInstance* get()



    cdef cppclass Visc_endo_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Visc_endo_foMaterialBehaviourInstance()

    cdef cppclass Visc_endo_foMaterialBehaviourPtr:

        Visc_endo_foMaterialBehaviourPtr( Visc_endo_foMaterialBehaviourPtr& )
        Visc_endo_foMaterialBehaviourPtr( Visc_endo_foMaterialBehaviourInstance* )
        Visc_endo_foMaterialBehaviourInstance* get()



    cdef cppclass Pinto_menegottoMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Pinto_menegottoMaterialBehaviourInstance()

    cdef cppclass Pinto_menegottoMaterialBehaviourPtr:

        Pinto_menegottoMaterialBehaviourPtr( Pinto_menegottoMaterialBehaviourPtr& )
        Pinto_menegottoMaterialBehaviourPtr( Pinto_menegottoMaterialBehaviourInstance* )
        Pinto_menegottoMaterialBehaviourInstance* get()



    cdef cppclass Bpel_betonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Bpel_betonMaterialBehaviourInstance()

    cdef cppclass Bpel_betonMaterialBehaviourPtr:

        Bpel_betonMaterialBehaviourPtr( Bpel_betonMaterialBehaviourPtr& )
        Bpel_betonMaterialBehaviourPtr( Bpel_betonMaterialBehaviourInstance* )
        Bpel_betonMaterialBehaviourInstance* get()



    cdef cppclass Bpel_acierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Bpel_acierMaterialBehaviourInstance()

    cdef cppclass Bpel_acierMaterialBehaviourPtr:

        Bpel_acierMaterialBehaviourPtr( Bpel_acierMaterialBehaviourPtr& )
        Bpel_acierMaterialBehaviourPtr( Bpel_acierMaterialBehaviourInstance* )
        Bpel_acierMaterialBehaviourInstance* get()



    cdef cppclass Etcc_betonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Etcc_betonMaterialBehaviourInstance()

    cdef cppclass Etcc_betonMaterialBehaviourPtr:

        Etcc_betonMaterialBehaviourPtr( Etcc_betonMaterialBehaviourPtr& )
        Etcc_betonMaterialBehaviourPtr( Etcc_betonMaterialBehaviourInstance* )
        Etcc_betonMaterialBehaviourInstance* get()



    cdef cppclass Etcc_acierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Etcc_acierMaterialBehaviourInstance()

    cdef cppclass Etcc_acierMaterialBehaviourPtr:

        Etcc_acierMaterialBehaviourPtr( Etcc_acierMaterialBehaviourPtr& )
        Etcc_acierMaterialBehaviourPtr( Etcc_acierMaterialBehaviourInstance* )
        Etcc_acierMaterialBehaviourInstance* get()



    cdef cppclass Mohr_coulombMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mohr_coulombMaterialBehaviourInstance()

    cdef cppclass Mohr_coulombMaterialBehaviourPtr:

        Mohr_coulombMaterialBehaviourPtr( Mohr_coulombMaterialBehaviourPtr& )
        Mohr_coulombMaterialBehaviourPtr( Mohr_coulombMaterialBehaviourInstance* )
        Mohr_coulombMaterialBehaviourInstance* get()



    cdef cppclass Cam_clayMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cam_clayMaterialBehaviourInstance()

    cdef cppclass Cam_clayMaterialBehaviourPtr:

        Cam_clayMaterialBehaviourPtr( Cam_clayMaterialBehaviourPtr& )
        Cam_clayMaterialBehaviourPtr( Cam_clayMaterialBehaviourInstance* )
        Cam_clayMaterialBehaviourInstance* get()



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



    cdef cppclass Ecro_asym_lineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ecro_asym_lineMaterialBehaviourInstance()

    cdef cppclass Ecro_asym_lineMaterialBehaviourPtr:

        Ecro_asym_lineMaterialBehaviourPtr( Ecro_asym_lineMaterialBehaviourPtr& )
        Ecro_asym_lineMaterialBehaviourPtr( Ecro_asym_lineMaterialBehaviourInstance* )
        Ecro_asym_lineMaterialBehaviourInstance* get()



    cdef cppclass Granger_fpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Granger_fpMaterialBehaviourInstance()

    cdef cppclass Granger_fpMaterialBehaviourPtr:

        Granger_fpMaterialBehaviourPtr( Granger_fpMaterialBehaviourPtr& )
        Granger_fpMaterialBehaviourPtr( Granger_fpMaterialBehaviourInstance* )
        Granger_fpMaterialBehaviourInstance* get()



    cdef cppclass Granger_fp_indtMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Granger_fp_indtMaterialBehaviourInstance()

    cdef cppclass Granger_fp_indtMaterialBehaviourPtr:

        Granger_fp_indtMaterialBehaviourPtr( Granger_fp_indtMaterialBehaviourPtr& )
        Granger_fp_indtMaterialBehaviourPtr( Granger_fp_indtMaterialBehaviourInstance* )
        Granger_fp_indtMaterialBehaviourInstance* get()



    cdef cppclass V_granger_fpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        V_granger_fpMaterialBehaviourInstance()

    cdef cppclass V_granger_fpMaterialBehaviourPtr:

        V_granger_fpMaterialBehaviourPtr( V_granger_fpMaterialBehaviourPtr& )
        V_granger_fpMaterialBehaviourPtr( V_granger_fpMaterialBehaviourInstance* )
        V_granger_fpMaterialBehaviourInstance* get()



    cdef cppclass Beton_burger_fpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Beton_burger_fpMaterialBehaviourInstance()

    cdef cppclass Beton_burger_fpMaterialBehaviourPtr:

        Beton_burger_fpMaterialBehaviourPtr( Beton_burger_fpMaterialBehaviourPtr& )
        Beton_burger_fpMaterialBehaviourPtr( Beton_burger_fpMaterialBehaviourInstance* )
        Beton_burger_fpMaterialBehaviourInstance* get()



    cdef cppclass Beton_umlv_fpMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Beton_umlv_fpMaterialBehaviourInstance()

    cdef cppclass Beton_umlv_fpMaterialBehaviourPtr:

        Beton_umlv_fpMaterialBehaviourPtr( Beton_umlv_fpMaterialBehaviourPtr& )
        Beton_umlv_fpMaterialBehaviourPtr( Beton_umlv_fpMaterialBehaviourInstance* )
        Beton_umlv_fpMaterialBehaviourInstance* get()



    cdef cppclass Beton_ragMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Beton_ragMaterialBehaviourInstance()

    cdef cppclass Beton_ragMaterialBehaviourPtr:

        Beton_ragMaterialBehaviourPtr( Beton_ragMaterialBehaviourPtr& )
        Beton_ragMaterialBehaviourPtr( Beton_ragMaterialBehaviourInstance* )
        Beton_ragMaterialBehaviourInstance* get()



    cdef cppclass Poro_betonMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Poro_betonMaterialBehaviourInstance()

    cdef cppclass Poro_betonMaterialBehaviourPtr:

        Poro_betonMaterialBehaviourPtr( Poro_betonMaterialBehaviourPtr& )
        Poro_betonMaterialBehaviourPtr( Poro_betonMaterialBehaviourInstance* )
        Poro_betonMaterialBehaviourInstance* get()



    cdef cppclass Glrc_dmMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Glrc_dmMaterialBehaviourInstance()

    cdef cppclass Glrc_dmMaterialBehaviourPtr:

        Glrc_dmMaterialBehaviourPtr( Glrc_dmMaterialBehaviourPtr& )
        Glrc_dmMaterialBehaviourPtr( Glrc_dmMaterialBehaviourInstance* )
        Glrc_dmMaterialBehaviourInstance* get()



    cdef cppclass DhrcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        DhrcMaterialBehaviourInstance()

    cdef cppclass DhrcMaterialBehaviourPtr:

        DhrcMaterialBehaviourPtr( DhrcMaterialBehaviourPtr& )
        DhrcMaterialBehaviourPtr( DhrcMaterialBehaviourInstance* )
        DhrcMaterialBehaviourInstance* get()



    cdef cppclass Gatt_monerieMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Gatt_monerieMaterialBehaviourInstance()

    cdef cppclass Gatt_monerieMaterialBehaviourPtr:

        Gatt_monerieMaterialBehaviourPtr( Gatt_monerieMaterialBehaviourPtr& )
        Gatt_monerieMaterialBehaviourPtr( Gatt_monerieMaterialBehaviourInstance* )
        Gatt_monerieMaterialBehaviourInstance* get()



    cdef cppclass Corr_acierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Corr_acierMaterialBehaviourInstance()

    cdef cppclass Corr_acierMaterialBehaviourPtr:

        Corr_acierMaterialBehaviourPtr( Corr_acierMaterialBehaviourPtr& )
        Corr_acierMaterialBehaviourPtr( Corr_acierMaterialBehaviourInstance* )
        Corr_acierMaterialBehaviourInstance* get()



    cdef cppclass Dis_ecro_cineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Dis_ecro_cineMaterialBehaviourInstance()

    cdef cppclass Dis_ecro_cineMaterialBehaviourPtr:

        Dis_ecro_cineMaterialBehaviourPtr( Dis_ecro_cineMaterialBehaviourPtr& )
        Dis_ecro_cineMaterialBehaviourPtr( Dis_ecro_cineMaterialBehaviourInstance* )
        Dis_ecro_cineMaterialBehaviourInstance* get()



    cdef cppclass Dis_viscMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Dis_viscMaterialBehaviourInstance()

    cdef cppclass Dis_viscMaterialBehaviourPtr:

        Dis_viscMaterialBehaviourPtr( Dis_viscMaterialBehaviourPtr& )
        Dis_viscMaterialBehaviourPtr( Dis_viscMaterialBehaviourInstance* )
        Dis_viscMaterialBehaviourInstance* get()



    cdef cppclass Dis_bili_elasMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Dis_bili_elasMaterialBehaviourInstance()

    cdef cppclass Dis_bili_elasMaterialBehaviourPtr:

        Dis_bili_elasMaterialBehaviourPtr( Dis_bili_elasMaterialBehaviourPtr& )
        Dis_bili_elasMaterialBehaviourPtr( Dis_bili_elasMaterialBehaviourInstance* )
        Dis_bili_elasMaterialBehaviourInstance* get()



    cdef cppclass Ther_nlMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ther_nlMaterialBehaviourInstance()

    cdef cppclass Ther_nlMaterialBehaviourPtr:

        Ther_nlMaterialBehaviourPtr( Ther_nlMaterialBehaviourPtr& )
        Ther_nlMaterialBehaviourPtr( Ther_nlMaterialBehaviourInstance* )
        Ther_nlMaterialBehaviourInstance* get()



    cdef cppclass Ther_hydrMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ther_hydrMaterialBehaviourInstance()

    cdef cppclass Ther_hydrMaterialBehaviourPtr:

        Ther_hydrMaterialBehaviourPtr( Ther_hydrMaterialBehaviourPtr& )
        Ther_hydrMaterialBehaviourPtr( Ther_hydrMaterialBehaviourInstance* )
        Ther_hydrMaterialBehaviourInstance* get()



    cdef cppclass TherMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        TherMaterialBehaviourInstance()

    cdef cppclass TherMaterialBehaviourPtr:

        TherMaterialBehaviourPtr( TherMaterialBehaviourPtr& )
        TherMaterialBehaviourPtr( TherMaterialBehaviourInstance* )
        TherMaterialBehaviourInstance* get()



    cdef cppclass Ther_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ther_foMaterialBehaviourInstance()

    cdef cppclass Ther_foMaterialBehaviourPtr:

        Ther_foMaterialBehaviourPtr( Ther_foMaterialBehaviourPtr& )
        Ther_foMaterialBehaviourPtr( Ther_foMaterialBehaviourInstance* )
        Ther_foMaterialBehaviourInstance* get()



    cdef cppclass Ther_orthMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ther_orthMaterialBehaviourInstance()

    cdef cppclass Ther_orthMaterialBehaviourPtr:

        Ther_orthMaterialBehaviourPtr( Ther_orthMaterialBehaviourPtr& )
        Ther_orthMaterialBehaviourPtr( Ther_orthMaterialBehaviourInstance* )
        Ther_orthMaterialBehaviourInstance* get()



    cdef cppclass Ther_coqueMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ther_coqueMaterialBehaviourInstance()

    cdef cppclass Ther_coqueMaterialBehaviourPtr:

        Ther_coqueMaterialBehaviourPtr( Ther_coqueMaterialBehaviourPtr& )
        Ther_coqueMaterialBehaviourPtr( Ther_coqueMaterialBehaviourInstance* )
        Ther_coqueMaterialBehaviourInstance* get()



    cdef cppclass Ther_coque_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Ther_coque_foMaterialBehaviourInstance()

    cdef cppclass Ther_coque_foMaterialBehaviourPtr:

        Ther_coque_foMaterialBehaviourPtr( Ther_coque_foMaterialBehaviourPtr& )
        Ther_coque_foMaterialBehaviourPtr( Ther_coque_foMaterialBehaviourInstance* )
        Ther_coque_foMaterialBehaviourInstance* get()



    cdef cppclass Sech_grangerMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Sech_grangerMaterialBehaviourInstance()

    cdef cppclass Sech_grangerMaterialBehaviourPtr:

        Sech_grangerMaterialBehaviourPtr( Sech_grangerMaterialBehaviourPtr& )
        Sech_grangerMaterialBehaviourPtr( Sech_grangerMaterialBehaviourInstance* )
        Sech_grangerMaterialBehaviourInstance* get()



    cdef cppclass Sech_mensiMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Sech_mensiMaterialBehaviourInstance()

    cdef cppclass Sech_mensiMaterialBehaviourPtr:

        Sech_mensiMaterialBehaviourPtr( Sech_mensiMaterialBehaviourPtr& )
        Sech_mensiMaterialBehaviourPtr( Sech_mensiMaterialBehaviourInstance* )
        Sech_mensiMaterialBehaviourInstance* get()



    cdef cppclass Sech_bazantMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Sech_bazantMaterialBehaviourInstance()

    cdef cppclass Sech_bazantMaterialBehaviourPtr:

        Sech_bazantMaterialBehaviourPtr( Sech_bazantMaterialBehaviourPtr& )
        Sech_bazantMaterialBehaviourPtr( Sech_bazantMaterialBehaviourInstance* )
        Sech_bazantMaterialBehaviourInstance* get()



    cdef cppclass Sech_nappeMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Sech_nappeMaterialBehaviourInstance()

    cdef cppclass Sech_nappeMaterialBehaviourPtr:

        Sech_nappeMaterialBehaviourPtr( Sech_nappeMaterialBehaviourPtr& )
        Sech_nappeMaterialBehaviourPtr( Sech_nappeMaterialBehaviourInstance* )
        Sech_nappeMaterialBehaviourInstance* get()



    cdef cppclass Meta_acierMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_acierMaterialBehaviourInstance()

    cdef cppclass Meta_acierMaterialBehaviourPtr:

        Meta_acierMaterialBehaviourPtr( Meta_acierMaterialBehaviourPtr& )
        Meta_acierMaterialBehaviourPtr( Meta_acierMaterialBehaviourInstance* )
        Meta_acierMaterialBehaviourInstance* get()



    cdef cppclass Meta_zircMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_zircMaterialBehaviourInstance()

    cdef cppclass Meta_zircMaterialBehaviourPtr:

        Meta_zircMaterialBehaviourPtr( Meta_zircMaterialBehaviourPtr& )
        Meta_zircMaterialBehaviourPtr( Meta_zircMaterialBehaviourInstance* )
        Meta_zircMaterialBehaviourInstance* get()



    cdef cppclass Durt_metaMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Durt_metaMaterialBehaviourInstance()

    cdef cppclass Durt_metaMaterialBehaviourPtr:

        Durt_metaMaterialBehaviourPtr( Durt_metaMaterialBehaviourPtr& )
        Durt_metaMaterialBehaviourPtr( Durt_metaMaterialBehaviourInstance* )
        Durt_metaMaterialBehaviourInstance* get()



    cdef cppclass Elas_metaMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_metaMaterialBehaviourInstance()

    cdef cppclass Elas_metaMaterialBehaviourPtr:

        Elas_metaMaterialBehaviourPtr( Elas_metaMaterialBehaviourPtr& )
        Elas_metaMaterialBehaviourPtr( Elas_metaMaterialBehaviourInstance* )
        Elas_metaMaterialBehaviourInstance* get()



    cdef cppclass Elas_meta_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_meta_foMaterialBehaviourInstance()

    cdef cppclass Elas_meta_foMaterialBehaviourPtr:

        Elas_meta_foMaterialBehaviourPtr( Elas_meta_foMaterialBehaviourPtr& )
        Elas_meta_foMaterialBehaviourPtr( Elas_meta_foMaterialBehaviourInstance* )
        Elas_meta_foMaterialBehaviourInstance* get()



    cdef cppclass Meta_ecro_lineMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_ecro_lineMaterialBehaviourInstance()

    cdef cppclass Meta_ecro_lineMaterialBehaviourPtr:

        Meta_ecro_lineMaterialBehaviourPtr( Meta_ecro_lineMaterialBehaviourPtr& )
        Meta_ecro_lineMaterialBehaviourPtr( Meta_ecro_lineMaterialBehaviourInstance* )
        Meta_ecro_lineMaterialBehaviourInstance* get()



    cdef cppclass Meta_tractionMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_tractionMaterialBehaviourInstance()

    cdef cppclass Meta_tractionMaterialBehaviourPtr:

        Meta_tractionMaterialBehaviourPtr( Meta_tractionMaterialBehaviourPtr& )
        Meta_tractionMaterialBehaviourPtr( Meta_tractionMaterialBehaviourInstance* )
        Meta_tractionMaterialBehaviourInstance* get()



    cdef cppclass Meta_visc_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_visc_foMaterialBehaviourInstance()

    cdef cppclass Meta_visc_foMaterialBehaviourPtr:

        Meta_visc_foMaterialBehaviourPtr( Meta_visc_foMaterialBehaviourPtr& )
        Meta_visc_foMaterialBehaviourPtr( Meta_visc_foMaterialBehaviourInstance* )
        Meta_visc_foMaterialBehaviourInstance* get()



    cdef cppclass Meta_ptMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_ptMaterialBehaviourInstance()

    cdef cppclass Meta_ptMaterialBehaviourPtr:

        Meta_ptMaterialBehaviourPtr( Meta_ptMaterialBehaviourPtr& )
        Meta_ptMaterialBehaviourPtr( Meta_ptMaterialBehaviourInstance* )
        Meta_ptMaterialBehaviourInstance* get()



    cdef cppclass Meta_reMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Meta_reMaterialBehaviourInstance()

    cdef cppclass Meta_reMaterialBehaviourPtr:

        Meta_reMaterialBehaviourPtr( Meta_reMaterialBehaviourPtr& )
        Meta_reMaterialBehaviourPtr( Meta_reMaterialBehaviourInstance* )
        Meta_reMaterialBehaviourInstance* get()



    cdef cppclass FluideMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        FluideMaterialBehaviourInstance()

    cdef cppclass FluideMaterialBehaviourPtr:

        FluideMaterialBehaviourPtr( FluideMaterialBehaviourPtr& )
        FluideMaterialBehaviourPtr( FluideMaterialBehaviourInstance* )
        FluideMaterialBehaviourInstance* get()



    cdef cppclass Thm_initMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Thm_initMaterialBehaviourInstance()

    cdef cppclass Thm_initMaterialBehaviourPtr:

        Thm_initMaterialBehaviourPtr( Thm_initMaterialBehaviourPtr& )
        Thm_initMaterialBehaviourPtr( Thm_initMaterialBehaviourInstance* )
        Thm_initMaterialBehaviourInstance* get()



    cdef cppclass Thm_diffuMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Thm_diffuMaterialBehaviourInstance()

    cdef cppclass Thm_diffuMaterialBehaviourPtr:

        Thm_diffuMaterialBehaviourPtr( Thm_diffuMaterialBehaviourPtr& )
        Thm_diffuMaterialBehaviourPtr( Thm_diffuMaterialBehaviourInstance* )
        Thm_diffuMaterialBehaviourInstance* get()



    cdef cppclass Thm_liquMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Thm_liquMaterialBehaviourInstance()

    cdef cppclass Thm_liquMaterialBehaviourPtr:

        Thm_liquMaterialBehaviourPtr( Thm_liquMaterialBehaviourPtr& )
        Thm_liquMaterialBehaviourPtr( Thm_liquMaterialBehaviourInstance* )
        Thm_liquMaterialBehaviourInstance* get()



    cdef cppclass Thm_gazMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Thm_gazMaterialBehaviourInstance()

    cdef cppclass Thm_gazMaterialBehaviourPtr:

        Thm_gazMaterialBehaviourPtr( Thm_gazMaterialBehaviourPtr& )
        Thm_gazMaterialBehaviourPtr( Thm_gazMaterialBehaviourInstance* )
        Thm_gazMaterialBehaviourInstance* get()



    cdef cppclass Thm_vape_gazMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Thm_vape_gazMaterialBehaviourInstance()

    cdef cppclass Thm_vape_gazMaterialBehaviourPtr:

        Thm_vape_gazMaterialBehaviourPtr( Thm_vape_gazMaterialBehaviourPtr& )
        Thm_vape_gazMaterialBehaviourPtr( Thm_vape_gazMaterialBehaviourInstance* )
        Thm_vape_gazMaterialBehaviourInstance* get()

    cdef cppclass Thm_air_dissMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Thm_air_dissMaterialBehaviourInstance()

    cdef cppclass Thm_air_dissMaterialBehaviourPtr:

        Thm_air_dissMaterialBehaviourPtr( Thm_air_dissMaterialBehaviourPtr& )
        Thm_air_dissMaterialBehaviourPtr( Thm_air_dissMaterialBehaviourInstance* )
        Thm_air_dissMaterialBehaviourInstance* get()



    cdef cppclass FatigueMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        FatigueMaterialBehaviourInstance()

    cdef cppclass FatigueMaterialBehaviourPtr:

        FatigueMaterialBehaviourPtr( FatigueMaterialBehaviourPtr& )
        FatigueMaterialBehaviourPtr( FatigueMaterialBehaviourInstance* )
        FatigueMaterialBehaviourInstance* get()



    cdef cppclass Domma_lemaitreMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Domma_lemaitreMaterialBehaviourInstance()

    cdef cppclass Domma_lemaitreMaterialBehaviourPtr:

        Domma_lemaitreMaterialBehaviourPtr( Domma_lemaitreMaterialBehaviourPtr& )
        Domma_lemaitreMaterialBehaviourPtr( Domma_lemaitreMaterialBehaviourInstance* )
        Domma_lemaitreMaterialBehaviourInstance* get()



    cdef cppclass Cisa_plan_critMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Cisa_plan_critMaterialBehaviourInstance()

    cdef cppclass Cisa_plan_critMaterialBehaviourPtr:

        Cisa_plan_critMaterialBehaviourPtr( Cisa_plan_critMaterialBehaviourPtr& )
        Cisa_plan_critMaterialBehaviourPtr( Cisa_plan_critMaterialBehaviourInstance* )
        Cisa_plan_critMaterialBehaviourInstance* get()



    cdef cppclass Thm_ruptMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Thm_ruptMaterialBehaviourInstance()

    cdef cppclass Thm_ruptMaterialBehaviourPtr:

        Thm_ruptMaterialBehaviourPtr( Thm_ruptMaterialBehaviourPtr& )
        Thm_ruptMaterialBehaviourPtr( Thm_ruptMaterialBehaviourInstance* )
        Thm_ruptMaterialBehaviourInstance* get()



    cdef cppclass WeibullMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        WeibullMaterialBehaviourInstance()

    cdef cppclass WeibullMaterialBehaviourPtr:

        WeibullMaterialBehaviourPtr( WeibullMaterialBehaviourPtr& )
        WeibullMaterialBehaviourPtr( WeibullMaterialBehaviourInstance* )
        WeibullMaterialBehaviourInstance* get()



    cdef cppclass Weibull_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Weibull_foMaterialBehaviourInstance()

    cdef cppclass Weibull_foMaterialBehaviourPtr:

        Weibull_foMaterialBehaviourPtr( Weibull_foMaterialBehaviourPtr& )
        Weibull_foMaterialBehaviourPtr( Weibull_foMaterialBehaviourInstance* )
        Weibull_foMaterialBehaviourInstance* get()



    cdef cppclass Non_localMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Non_localMaterialBehaviourInstance()

    cdef cppclass Non_localMaterialBehaviourPtr:

        Non_localMaterialBehaviourPtr( Non_localMaterialBehaviourPtr& )
        Non_localMaterialBehaviourPtr( Non_localMaterialBehaviourInstance* )
        Non_localMaterialBehaviourInstance* get()



    cdef cppclass Rupt_fragMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Rupt_fragMaterialBehaviourInstance()

    cdef cppclass Rupt_fragMaterialBehaviourPtr:

        Rupt_fragMaterialBehaviourPtr( Rupt_fragMaterialBehaviourPtr& )
        Rupt_fragMaterialBehaviourPtr( Rupt_fragMaterialBehaviourInstance* )
        Rupt_fragMaterialBehaviourInstance* get()



    cdef cppclass Rupt_frag_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Rupt_frag_foMaterialBehaviourInstance()

    cdef cppclass Rupt_frag_foMaterialBehaviourPtr:

        Rupt_frag_foMaterialBehaviourPtr( Rupt_frag_foMaterialBehaviourPtr& )
        Rupt_frag_foMaterialBehaviourPtr( Rupt_frag_foMaterialBehaviourInstance* )
        Rupt_frag_foMaterialBehaviourInstance* get()



    cdef cppclass Czm_lab_mixMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Czm_lab_mixMaterialBehaviourInstance()

    cdef cppclass Czm_lab_mixMaterialBehaviourPtr:

        Czm_lab_mixMaterialBehaviourPtr( Czm_lab_mixMaterialBehaviourPtr& )
        Czm_lab_mixMaterialBehaviourPtr( Czm_lab_mixMaterialBehaviourInstance* )
        Czm_lab_mixMaterialBehaviourInstance* get()



    cdef cppclass Rupt_ductMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Rupt_ductMaterialBehaviourInstance()

    cdef cppclass Rupt_ductMaterialBehaviourPtr:

        Rupt_ductMaterialBehaviourPtr( Rupt_ductMaterialBehaviourPtr& )
        Rupt_ductMaterialBehaviourPtr( Rupt_ductMaterialBehaviourInstance* )
        Rupt_ductMaterialBehaviourInstance* get()



    cdef cppclass Joint_meca_ruptMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Joint_meca_ruptMaterialBehaviourInstance()

    cdef cppclass Joint_meca_ruptMaterialBehaviourPtr:

        Joint_meca_ruptMaterialBehaviourPtr( Joint_meca_ruptMaterialBehaviourPtr& )
        Joint_meca_ruptMaterialBehaviourPtr( Joint_meca_ruptMaterialBehaviourInstance* )
        Joint_meca_ruptMaterialBehaviourInstance* get()



    cdef cppclass Joint_meca_frotMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Joint_meca_frotMaterialBehaviourInstance()

    cdef cppclass Joint_meca_frotMaterialBehaviourPtr:

        Joint_meca_frotMaterialBehaviourPtr( Joint_meca_frotMaterialBehaviourPtr& )
        Joint_meca_frotMaterialBehaviourPtr( Joint_meca_frotMaterialBehaviourInstance* )
        Joint_meca_frotMaterialBehaviourInstance* get()



    cdef cppclass RccmMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        RccmMaterialBehaviourInstance()

    cdef cppclass RccmMaterialBehaviourPtr:

        RccmMaterialBehaviourPtr( RccmMaterialBehaviourPtr& )
        RccmMaterialBehaviourPtr( RccmMaterialBehaviourInstance* )
        RccmMaterialBehaviourInstance* get()



    cdef cppclass Rccm_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Rccm_foMaterialBehaviourInstance()

    cdef cppclass Rccm_foMaterialBehaviourPtr:

        Rccm_foMaterialBehaviourPtr( Rccm_foMaterialBehaviourPtr& )
        Rccm_foMaterialBehaviourPtr( Rccm_foMaterialBehaviourInstance* )
        Rccm_foMaterialBehaviourInstance* get()



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



    cdef cppclass Druck_pragerMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Druck_pragerMaterialBehaviourInstance()

    cdef cppclass Druck_pragerMaterialBehaviourPtr:

        Druck_pragerMaterialBehaviourPtr( Druck_pragerMaterialBehaviourPtr& )
        Druck_pragerMaterialBehaviourPtr( Druck_pragerMaterialBehaviourInstance* )
        Druck_pragerMaterialBehaviourInstance* get()



    cdef cppclass Druck_prager_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Druck_prager_foMaterialBehaviourInstance()

    cdef cppclass Druck_prager_foMaterialBehaviourPtr:

        Druck_prager_foMaterialBehaviourPtr( Druck_prager_foMaterialBehaviourPtr& )
        Druck_prager_foMaterialBehaviourPtr( Druck_prager_foMaterialBehaviourInstance* )
        Druck_prager_foMaterialBehaviourInstance* get()



    cdef cppclass Visc_druc_pragMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Visc_druc_pragMaterialBehaviourInstance()

    cdef cppclass Visc_druc_pragMaterialBehaviourPtr:

        Visc_druc_pragMaterialBehaviourPtr( Visc_druc_pragMaterialBehaviourPtr& )
        Visc_druc_pragMaterialBehaviourPtr( Visc_druc_pragMaterialBehaviourInstance* )
        Visc_druc_pragMaterialBehaviourInstance* get()



    cdef cppclass Hoek_brownMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Hoek_brownMaterialBehaviourInstance()

    cdef cppclass Hoek_brownMaterialBehaviourPtr:

        Hoek_brownMaterialBehaviourPtr( Hoek_brownMaterialBehaviourPtr& )
        Hoek_brownMaterialBehaviourPtr( Hoek_brownMaterialBehaviourInstance* )
        Hoek_brownMaterialBehaviourInstance* get()



    cdef cppclass Elas_gonfMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Elas_gonfMaterialBehaviourInstance()

    cdef cppclass Elas_gonfMaterialBehaviourPtr:

        Elas_gonfMaterialBehaviourPtr( Elas_gonfMaterialBehaviourPtr& )
        Elas_gonfMaterialBehaviourPtr( Elas_gonfMaterialBehaviourInstance* )
        Elas_gonfMaterialBehaviourInstance* get()



    cdef cppclass Joint_bandisMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Joint_bandisMaterialBehaviourInstance()

    cdef cppclass Joint_bandisMaterialBehaviourPtr:

        Joint_bandisMaterialBehaviourPtr( Joint_bandisMaterialBehaviourPtr& )
        Joint_bandisMaterialBehaviourPtr( Joint_bandisMaterialBehaviourInstance* )
        Joint_bandisMaterialBehaviourInstance* get()



    cdef cppclass Mono_visc1MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_visc1MaterialBehaviourInstance()

    cdef cppclass Mono_visc1MaterialBehaviourPtr:

        Mono_visc1MaterialBehaviourPtr( Mono_visc1MaterialBehaviourPtr& )
        Mono_visc1MaterialBehaviourPtr( Mono_visc1MaterialBehaviourInstance* )
        Mono_visc1MaterialBehaviourInstance* get()



    cdef cppclass Mono_visc2MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_visc2MaterialBehaviourInstance()

    cdef cppclass Mono_visc2MaterialBehaviourPtr:

        Mono_visc2MaterialBehaviourPtr( Mono_visc2MaterialBehaviourPtr& )
        Mono_visc2MaterialBehaviourPtr( Mono_visc2MaterialBehaviourInstance* )
        Mono_visc2MaterialBehaviourInstance* get()



    cdef cppclass Mono_isot1MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_isot1MaterialBehaviourInstance()

    cdef cppclass Mono_isot1MaterialBehaviourPtr:

        Mono_isot1MaterialBehaviourPtr( Mono_isot1MaterialBehaviourPtr& )
        Mono_isot1MaterialBehaviourPtr( Mono_isot1MaterialBehaviourInstance* )
        Mono_isot1MaterialBehaviourInstance* get()



    cdef cppclass Mono_isot2MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_isot2MaterialBehaviourInstance()

    cdef cppclass Mono_isot2MaterialBehaviourPtr:

        Mono_isot2MaterialBehaviourPtr( Mono_isot2MaterialBehaviourPtr& )
        Mono_isot2MaterialBehaviourPtr( Mono_isot2MaterialBehaviourInstance* )
        Mono_isot2MaterialBehaviourInstance* get()



    cdef cppclass Mono_cine1MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_cine1MaterialBehaviourInstance()

    cdef cppclass Mono_cine1MaterialBehaviourPtr:

        Mono_cine1MaterialBehaviourPtr( Mono_cine1MaterialBehaviourPtr& )
        Mono_cine1MaterialBehaviourPtr( Mono_cine1MaterialBehaviourInstance* )
        Mono_cine1MaterialBehaviourInstance* get()



    cdef cppclass Mono_cine2MaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_cine2MaterialBehaviourInstance()

    cdef cppclass Mono_cine2MaterialBehaviourPtr:

        Mono_cine2MaterialBehaviourPtr( Mono_cine2MaterialBehaviourPtr& )
        Mono_cine2MaterialBehaviourPtr( Mono_cine2MaterialBehaviourInstance* )
        Mono_cine2MaterialBehaviourInstance* get()



    cdef cppclass Mono_dd_krMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_dd_krMaterialBehaviourInstance()

    cdef cppclass Mono_dd_krMaterialBehaviourPtr:

        Mono_dd_krMaterialBehaviourPtr( Mono_dd_krMaterialBehaviourPtr& )
        Mono_dd_krMaterialBehaviourPtr( Mono_dd_krMaterialBehaviourInstance* )
        Mono_dd_krMaterialBehaviourInstance* get()



    cdef cppclass Mono_dd_cfcMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_dd_cfcMaterialBehaviourInstance()

    cdef cppclass Mono_dd_cfcMaterialBehaviourPtr:

        Mono_dd_cfcMaterialBehaviourPtr( Mono_dd_cfcMaterialBehaviourPtr& )
        Mono_dd_cfcMaterialBehaviourPtr( Mono_dd_cfcMaterialBehaviourInstance* )
        Mono_dd_cfcMaterialBehaviourInstance* get()



    cdef cppclass Mono_dd_cfc_irraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_dd_cfc_irraMaterialBehaviourInstance()

    cdef cppclass Mono_dd_cfc_irraMaterialBehaviourPtr:

        Mono_dd_cfc_irraMaterialBehaviourPtr( Mono_dd_cfc_irraMaterialBehaviourPtr& )
        Mono_dd_cfc_irraMaterialBehaviourPtr( Mono_dd_cfc_irraMaterialBehaviourInstance* )
        Mono_dd_cfc_irraMaterialBehaviourInstance* get()



    cdef cppclass Mono_dd_fatMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_dd_fatMaterialBehaviourInstance()

    cdef cppclass Mono_dd_fatMaterialBehaviourPtr:

        Mono_dd_fatMaterialBehaviourPtr( Mono_dd_fatMaterialBehaviourPtr& )
        Mono_dd_fatMaterialBehaviourPtr( Mono_dd_fatMaterialBehaviourInstance* )
        Mono_dd_fatMaterialBehaviourInstance* get()



    cdef cppclass Mono_dd_ccMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_dd_ccMaterialBehaviourInstance()

    cdef cppclass Mono_dd_ccMaterialBehaviourPtr:

        Mono_dd_ccMaterialBehaviourPtr( Mono_dd_ccMaterialBehaviourPtr& )
        Mono_dd_ccMaterialBehaviourPtr( Mono_dd_ccMaterialBehaviourInstance* )
        Mono_dd_ccMaterialBehaviourInstance* get()



    cdef cppclass Mono_dd_cc_irraMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Mono_dd_cc_irraMaterialBehaviourInstance()

    cdef cppclass Mono_dd_cc_irraMaterialBehaviourPtr:

        Mono_dd_cc_irraMaterialBehaviourPtr( Mono_dd_cc_irraMaterialBehaviourPtr& )
        Mono_dd_cc_irraMaterialBehaviourPtr( Mono_dd_cc_irraMaterialBehaviourInstance* )
        Mono_dd_cc_irraMaterialBehaviourInstance* get()



    cdef cppclass UmatMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        UmatMaterialBehaviourInstance()

    cdef cppclass UmatMaterialBehaviourPtr:

        UmatMaterialBehaviourPtr( UmatMaterialBehaviourPtr& )
        UmatMaterialBehaviourPtr( UmatMaterialBehaviourInstance* )
        UmatMaterialBehaviourInstance* get()



    cdef cppclass Umat_foMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Umat_foMaterialBehaviourInstance()

    cdef cppclass Umat_foMaterialBehaviourPtr:

        Umat_foMaterialBehaviourPtr( Umat_foMaterialBehaviourPtr& )
        Umat_foMaterialBehaviourPtr( Umat_foMaterialBehaviourInstance* )
        Umat_foMaterialBehaviourInstance* get()



    cdef cppclass Crit_ruptMaterialBehaviourInstance( GeneralMaterialBehaviourInstance ):

        Crit_ruptMaterialBehaviourInstance()

    cdef cppclass Crit_ruptMaterialBehaviourPtr:

        Crit_ruptMaterialBehaviourPtr( Crit_ruptMaterialBehaviourPtr& )
        Crit_ruptMaterialBehaviourPtr( Crit_ruptMaterialBehaviourInstance* )
        Crit_ruptMaterialBehaviourInstance* get()


cdef class GeneralMaterialBehaviour:

    cdef GeneralMaterialBehaviourPtr* _cptr

    cdef set( self, GeneralMaterialBehaviourPtr other )
    cdef GeneralMaterialBehaviourPtr* getPtr( self )
    cdef GeneralMaterialBehaviourInstance* getInstance( self )
    
cdef class ElasMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_fluiMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_istrMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_istr_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_orthMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_orth_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_hyperMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_coqueMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_coque_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_membraneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_2ndgMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_glrcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_glrc_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_dhrcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class CableMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Veri_borneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class TractionMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ecro_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Endo_heterogeneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ecro_line_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ecro_puisMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ecro_puis_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ecro_cookMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ecro_cook_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Beton_ecro_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Beton_regle_prMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Endo_orth_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class PragerMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Prager_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class TaheriMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Taheri_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class RousselierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Rousselier_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Visc_sinhMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Visc_sinh_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Cin1_chabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Cin1_chab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Cin2_chabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Cin2_chab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Cin2_nradMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Memo_ecroMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Memo_ecro_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class ViscochabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Viscochab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class LemaitreMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Lemaitre_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Lmarc_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Visc_irra_logMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Gran_irra_logMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Lema_seuilMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Lemaitre_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_lema_aniMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_lema_ani_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class ArmeMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Asse_cornMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Dis_contactMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Endo_scalaireMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Endo_scalaire_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Endo_fiss_expMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Endo_fiss_exp_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Dis_gricraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Beton_double_dpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class VendochabMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Vendochab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class HayhurstMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Visc_endoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Visc_endo_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Pinto_menegottoMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Bpel_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Bpel_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Etcc_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Etcc_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mohr_coulombMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Cam_clayMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class BarceloneMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class CjsMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class HujeuxMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ecro_asym_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Granger_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Granger_fp_indtMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class V_granger_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Beton_burger_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Beton_umlv_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Beton_ragMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Poro_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Glrc_dmMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class DhrcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Gatt_monerieMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Corr_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Dis_ecro_cineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Dis_viscMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Dis_bili_elasMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ther_nlMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ther_hydrMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class TherMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ther_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ther_orthMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ther_coqueMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Ther_coque_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Sech_grangerMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Sech_mensiMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Sech_bazantMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Sech_nappeMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_zircMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Durt_metaMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_metaMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_meta_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_ecro_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_tractionMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_visc_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_ptMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Meta_reMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class FluideMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Thm_initMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Thm_diffuMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Thm_liquMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Thm_gazMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Thm_vape_gazMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

cdef class Thm_air_dissMaterialBehaviour( GeneralMaterialBehaviour ):

    pass

    
cdef class FatigueMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Domma_lemaitreMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Cisa_plan_critMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Thm_ruptMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class WeibullMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Weibull_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Non_localMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Rupt_fragMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Rupt_frag_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Czm_lab_mixMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Rupt_ductMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Joint_meca_ruptMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Joint_meca_frotMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class RccmMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Rccm_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class LaigleMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class LetkMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Druck_pragerMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Druck_prager_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Visc_druc_pragMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Hoek_brownMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Elas_gonfMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Joint_bandisMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_visc1MaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_visc2MaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_isot1MaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_isot2MaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_cine1MaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_cine2MaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_dd_krMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_dd_cfcMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_dd_cfc_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_dd_fatMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_dd_ccMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Mono_dd_cc_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class UmatMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Umat_foMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
cdef class Crit_ruptMaterialBehaviour( GeneralMaterialBehaviour ):

    pass
    
