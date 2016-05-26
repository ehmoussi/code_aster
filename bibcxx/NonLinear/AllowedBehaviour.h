#ifndef ALLOWEDBEHAVIOUR_H_
#define ALLOWEDBEHAVIOUR_H_

/**
 * @file AllowedBehaviour.h
 * @brief Auxiliary definitions for the constitutive equations 
 * @author Natacha Béreux
 * @section LICENCE
 *   Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

/* person_in_charge: natacha.bereux at edf.fr */
#include "astercxx.h"

/**
 * @enum ConstitutiveLawEnum
 * @brief Enum contenant toutes les lois de comportement de Code_Aster
 * @author Natacha Béreux 
 */
enum ConstitutiveLawEnum { 
            Elas,
            Elas_Vmis_Line,
            Elas_Vmis_Trac,
            Elas_Vmis_Puis,
            Elas_Hyper,
            Elas_Poutre_Gr,
            Cable,
            Arme,
            Asse_Corn,
            Barcelone,
            Beton_Burger_Fp,
            Beton_Double_Dp,
            Beton_Rag,
            Beton_Regle_Pr,
            Beton_Umlv_Fp,
            Cable_Gaine_Frot,
            Cam_Clay,
            Cjs,
            Corr_Acier,
            Czm_Exp,
            Czm_Exp_Reg,
            Czm_Exp_Mix,
            Czm_Fat_Mix,
            Czm_Lin_Reg,
            Czm_Ouv_Mix,
            Czm_Tac_Mix,
            Czm_Lab_Mix,
            Czm_Tra_Mix,
            Dis_Bili_Elas,
            Dis_Choc,
            Dis_Ecro_Cine,
            Dis_Gouj2e_Elas,
            Dis_Gouj2e_Plas,
            Dis_Gricra,
            Dis_Visc,
            Druck_Prager,
            Druck_Prag_N_A,
            Elas_Gonf,
            Endo_Poro_Beton,
            Endo_Carre,
            Endo_Fiss_Exp,
            Endo_Fragile,
            Endo_Heterogene,
            Endo_Isot_Beton,
            Endo_Orth_Beton,
            Endo_Scalaire,
            Flua_Poro_Beton,
            Glrc_Damage,
            Glrc_Dm,
            Dhrc,
            Granger_Fp,
            Granger_Fp_Indt,
            Granger_Fp_V,
            Gran_Irra_Log,
            Grille_Cine_Line,
            Grille_Isot_Line,
            Grille_Pinto_Men,
            Hayhurst,
            Hoek_Brown,
            Hoek_Brown_Eff,
            Hoek_Brown_Tot,
            Hujeux,
            Irrad3m,
            Joint_Ba,
            Joint_Bandis,
            Joint_Meca_Rupt,
            Joint_Meca_Frot,
            Kit_Cg,
            Kit_Ddi,
            Kit_Hh,
            Kit_H,
            Kit_Hhm,
            Kit_Hm,
            Kit_Thh,
            Kit_Thhm,
            Kit_Thm,
            Kit_Thv,
            Laigle,
            Lemaitre,
            Lemaitre_Irra,
            Lema_Seuil,
            Letk,
            Mazars,
            Mazars_Gc,
            Meta_Lema_Ani,
            Meta_P_Cl,
            Meta_P_Cl_Pt,
            Meta_P_Cl_Pt_Re,
            Meta_P_Cl_Re,
            Meta_P_Il,
            Meta_P_Il_Pt,
            Meta_P_Il_Pt_Re,
            Meta_P_Il_Re,
            Meta_P_Inl,
            Meta_P_Inl_Pt,
            Meta_P_Inl_Pt_Re,
            Meta_P_Inl_Re,
            Meta_V_Cl,
            Meta_V_Cl_Pt,
            Meta_V_Cl_Pt_Re,
            Meta_V_Cl_Re,
            Meta_V_Il,
            Meta_V_Il_Pt,
            Meta_V_Il_Pt_Re,
            Meta_V_Il_Re,
            Meta_V_Inl,
            Meta_V_Inl_Pt,
            Meta_V_Inl_Pt_Re,
            Meta_V_Inl_Re,
            Mohr_Coulomb,
            Monocristal,
            Multifibre,
            Norton,
            Norton_Hoff,
            Pinto_Menegotto,
            Polycristal,
            Rgi_Beton,
            Rousselier,
            Rouss_Pr,
            Rouss_Visc,
            Rupt_Frag,
// Originellement Sans mais renommé Sans_Rel pour ne pas etre en conflit avec l'enum Renumbering
            Sans_Rel,
            Vendochab,
            Visc_Endo_Lema,
            Viscochab,
            Visc_Cin1_Chab,
            Visc_Cin2_Chab,
            Visc_Cin2_Memo,
            Visc_Cin2_Nrad,
            Visc_Memo_Nrad,
            Visc_Druc_Prag,
            Visc_Irra_Log,
            Visc_Isot_Line,
            Visc_Isot_Trac,
            Visc_Taheri,
            Vmis_Asym_Line,
            Vmis_Cin1_Chab,
            Vmis_Cin2_Chab,
            Vmis_Cine_Gc,
            Vmis_Cin2_Memo,
            Vmis_Cin2_Nrad,
            Vmis_Memo_Nrad,
            Vmis_Cine_Line,
            Vmis_Ecmi_Line,
            Vmis_Ecmi_Trac,
            Vmis_Isot_Line,
            Vmis_Isot_Puis,
            Vmis_Isot_Trac,
            Vmis_John_Cook,
            Umat,
            Mfront  };

const int nbLaw = 151;
extern const char* ConstitutiveLawNames[nbLaw];

/**
 * @enum DeformationEnum
 * @brief Enum contenant tous les types de deformations
 * @author Natacha Béreux 
 */
enum DeformationEnum { SmallDeformation, PetitReac, LargeDeformationAndRotation, SimoMiehe, GdefLog }; 
const int nbDeformation = 5;
extern const char* DeformationNames[nbDeformation];

enum TangentMatrixEnum { PerturbationMatrix, VerificationMatrix, TangentSecantMatrix };
const int nbTangMatr = 3;
extern const char* TangentMatrixNames[nbTangMatr]; 

#endif /* ALLOWEDBEHAVIOUR_H_ */
