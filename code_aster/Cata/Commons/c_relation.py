# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: david.haboussa at edf.fr
#
from code_aster.Cata.Syntax import *
from code_aster.Cata.DataStructure import *
from code_aster.Cata.Commons import C_MFRONT_OFFICIAL


def C_RELATION( COMMAND ):

    if COMMAND in ('CALC_G',):
                   return (             "ELAS",            #COMMUN#
                                        "ELAS_VMIS_LINE",
                                        "ELAS_VMIS_TRAC",
                                        "ELAS_VMIS_PUIS",
                                     )
    elif COMMAND in ('MACR_ASCOUF_CALC','MACR_ASPIC_CALC',):
                   return (             "ELAS",
                                        "ELAS_VMIS_TRAC",
                                     )
    elif COMMAND =='DEFI_COMPOR' :
                   return ( "ELAS",  #uniquement ce qui a du sens (cf doc) et qui fait l'objet d'un test
                            "CORR_ACIER",
                            "BETON_GRANGER",
                            "GRAN_IRRA_LOG",
                            "MAZARS_GC",
                            "VISC_IRRA_LOG",
                            "VMIS_CINE_GC",
                            "VMIS_CINE_LINE",
                            "VMIS_ISOT_LINE",
                            "VMIS_ISOT_TRAC",
                            )
    else:
        native = [
                                        "ELAS",
                                        "ELAS_VMIS_LINE",
                                        "ELAS_VMIS_TRAC",
                                        "ELAS_VMIS_PUIS",
                                        "ELAS_HYPER",
                                        "ELAS_POUTRE_GR",
                                        "CABLE",
                                        "ARME",
                                        "ASSE_CORN",
                                        "BARCELONE",
                                        "BETON_BURGER",
                                        "BETON_DOUBLE_DP",
                                        "BETON_RAG",
                                        "BETON_REGLE_PR",
                                        "BETON_UMLV",
                                        "CABLE_GAINE_FROT",
                                        "CAM_CLAY",
                                        "CJS",
                                        "CORR_ACIER",
                                        "CZM_EXP",
                                        "CZM_EXP_REG",
                                        "CZM_EXP_MIX",
                                        "CZM_FAT_MIX",
                                        "CZM_LIN_REG",
                                        "CZM_OUV_MIX",
                                        "CZM_TAC_MIX",
                                        "CZM_LAB_MIX",
                                        "CZM_TRA_MIX",
                                        "DIS_BILI_ELAS",
                                        "DIS_CHOC",
                                        "DIS_CONTACT",
                                        "DIS_ECRO_CINE",
                                        "DIS_GOUJ2E_ELAS",
                                        "DIS_GOUJ2E_PLAS",
                                        "DIS_GRICRA",
                                        "DIS_VISC",
                                        "DIS_ECRO_TRAC",
                                        "DRUCK_PRAGER",
                                        "DRUCK_PRAG_N_A",
                                        "GONF_ELAS",
                                        "ELAS_HYPER",
                                        "ELAS_MEMBRANE_NH",
                                        "ELAS_MEMBRANE_SV",
                                        "ENDO_PORO_BETON",
                                        "ENDO_CARRE",
                                        "ENDO_FISS_EXP",
                                        "ENDO_HETEROGENE",
                                        "ENDO_ISOT_BETON",
                                        "ENDO_ORTH_BETON",
                                        "ENDO_SCALAIRE",
                                        "FLUA_PORO_BETON",
                                        "FLUA_ENDO_PORO",
                                        "GLRC_DAMAGE",
                                        "GLRC_DM",
                                        "GTN",
                                        "DHRC",
                                        "BETON_GRANGER",
                                        "BETON_GRANGER_V",
                                        "GRAN_IRRA_LOG",
                                        "GRILLE_CINE_LINE",
                                        "GRILLE_ISOT_LINE",
                                        "GRILLE_PINTO_MEN",
                                        "HAYHURST",
                                        "HOEK_BROWN",
                                        "HOEK_BROWN_EFF",
                                        "HOEK_BROWN_TOT",
                                        "HUJEUX",
                                        "IRRAD3M",
                                        "JOINT_BA",
                                        "JOINT_BANDIS",
                                        "JOINT_MECA_RUPT",
                                        "JOINT_MECA_FROT",
                                        "KIT_CG",
                                        "KIT_DDI",
                                        "KIT_HH",
                                        "KIT_H",
                                        "KIT_HHM",
                                        "KIT_HM",
                                        "KIT_THH",
                                        "KIT_THHM",
                                        "KIT_THM",
                                        "KIT_THV",
                                        "KIT_THH2M",
                                        "KIT_HH2M",
                                        "KIT_HH2",
                                        "KIT_THH2",
                                        "LAIGLE",
                                        "LEMAITRE",
                                        "LEMAITRE_IRRA",
                                        "LEMA_SEUIL",
                                        "LETK",
                                        "LKR",
                                        "MAZARS",
                                        "MAZARS_GC",
                                        "META_LEMA_ANI",
                                        "META_P_CL",
                                        "META_P_CL_PT",
                                        "META_P_CL_PT_RE",
                                        "META_P_CL_RE",
                                        "META_P_IL",
                                        "META_P_IL_PT",
                                        "META_P_IL_PT_RE",
                                        "META_P_IL_RE",
                                        "META_P_INL",
                                        "META_P_INL_PT",
                                        "META_P_INL_PT_RE",
                                        "META_P_INL_RE",
                                        "META_V_CL",
                                        "META_V_CL_PT",
                                        "META_V_CL_PT_RE",
                                        "META_V_CL_RE",
                                        "META_V_IL",
                                        "META_V_IL_PT",
                                        "META_V_IL_PT_RE",
                                        "META_V_IL_RE",
                                        "META_V_INL",
                                        "META_V_INL_PT",
                                        "META_V_INL_PT_RE",
                                        "META_V_INL_RE",
                                        "MOHR_COULOMB",
                                        "RANKINE",
                                        "RGI_BETON",
                                        "MONOCRISTAL",
                                        "MULTIFIBRE",
                                        "NORTON",
                                        "NORTON_HOFF",
                                        "PINTO_MENEGOTTO",
                                        "POLYCRISTAL",
                                        "RELAX_ACIER",
                                        "ROUSSELIER",
                                        "ROUSS_PR",
                                        "ROUSS_VISC",
                                        "RUPT_FRAG",
                                        "SANS",
                                        "VENDOCHAB",
                                        "VISC_ENDO_LEMA",
                                        "VISCOCHAB",
                                        "VISC_CIN1_CHAB",
                                        "VISC_CIN2_CHAB",
                                        "VISC_CIN2_MEMO",
                                        "VISC_CIN2_NRAD",
                                        "VISC_MEMO_NRAD",
                                        "VISC_DRUC_PRAG",
                                        "VISC_IRRA_LOG",
                                        "VISC_ISOT_LINE",
                                        "VISC_ISOT_TRAC",
                                        "VISC_TAHERI",
                                        "VMIS_ASYM_LINE",
                                        "VMIS_CIN1_CHAB",
                                        "VMIS_CIN2_CHAB",
                                        "VMIS_CINE_GC",
                                        "VMIS_CIN2_MEMO",
                                        "VMIS_CIN2_NRAD",
                                        "VMIS_MEMO_NRAD",
                                        "VMIS_CINE_LINE",
                                        "VMIS_ECMI_LINE",
                                        "VMIS_ECMI_TRAC",
                                        "VMIS_ISOT_LINE",
                                        "VMIS_ISOT_PUIS",
                                        "VMIS_ISOT_TRAC",
                                        "VMIS_JOHN_COOK",
                                        "UMAT",
                                        "MFRONT",
        ]
        mfront = [ i for i in list(C_MFRONT_OFFICIAL().keys()) \
                     if not i.endswith('_FO') ]
        return tuple(native + mfront)
