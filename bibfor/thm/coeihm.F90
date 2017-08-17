! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! aslint: disable=W1306,W1504
!
subroutine coeihm(option, perman, resi, rigi, imate,&
                  compor, instam, instap, nomail,&
                  ndim, dimdef, dimcon, nbvari, yamec,&
                  yap1, yap2, yate, addeme, adcome,&
                  addep1, adcp11, adcp12, addlh1, adcop1,&
                  addep2, adcp21, adcp22, addete, adcote,&
                  defgem, defgep, kpi, npg, npi,&
                  sigm, sigp, varim, varip, res,&
                  drde, retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcco.h"
#include "asterfort/calcfh.h"
#include "asterfort/coeime.h"
#include "asterfort/kitdec.h"
#include "asterfort/nvithm.h"
#include "asterfort/thmlec.h"
#include "asterfort/utmess.h"
#include "asterfort/thmGetParaBiot.h"
#include "asterfort/thmGetParaHydr.h"
#include "asterfort/tebiot.h"
!
    integer :: dimdef, dimcon, npg, kpi, npi, ndim
    integer :: nbvari, yamec, yate, yap1, yap2, imate
    integer :: addeme, addep1, addep2, addete, adcop1, addlh1
    integer :: adcome, adcp11, adcp12, adcp21, adcp22, adcote
!
    real(kind=8) :: defgem(1:dimdef), defgep(1:dimdef)
    real(kind=8) :: varim(nbvari), instam, instap
    real(kind=8) :: sigm(dimcon)
    character(len=8) :: nomail
    character(len=16) :: option, compor(*)
    aster_logical :: perman, resi, rigi
!
! - VARIABLES SORTIE
    integer :: retcom
    real(kind=8) :: sigp(dimcon), varip(nbvari)
    real(kind=8) :: res(dimdef), drde(dimdef, dimdef)
!
! - VARIABLES LOCALES
    integer :: nvim, nvit, nvih, nvic, advime, advith, advihy, advico
    integer :: i, j, f
    integer :: vihrho, vicphi, vicpvp, vicsat
    integer :: vicpr1, vicpr2
    real(kind=8) :: depsv, epsv, deps(6)
    real(kind=8) :: t, p1, p2, dt, dp1, dp2, grat(3), grap1(3), grap2(3)
    real(kind=8) :: pvp, pad, h11, h12, kh, rho11, phi
    real(kind=8) :: sat, tbiot(6), rgaz, satur, dsatur, pesa(3)
    real(kind=8) :: tperm(ndim, ndim), permli, dperml, permgz, dperms, dpermp
    real(kind=8) :: lambp, dlambp, unsurk, alpha, lambs, dlambs, viscl, dfickg
    real(kind=8) :: dviscl, mamolg, tlambt(ndim, ndim), tdlamt(ndim, ndim)
    real(kind=8) :: mamovg, fickad, dfadt, tlamct(ndim, ndim), dfickt, dviscg
    real(kind=8) :: klint(ndim-1, ndim-1), fick, viscg
    real(kind=8) :: dsde(dimcon, dimdef)
    real(kind=8) :: tlint, ouvh, deltat, unsurn
    real(kind=8) :: angl_naut(3)
    character(len=16) :: meca, thmc, ther, hydr
    aster_logical :: yachai
!
! =====================================================================
!.......................................................................
!
!     BUT:  INTEGRATION DES LOIS DE COMPORTEMENT
!
!     L'INTEGRATION DES LOIS DE COMPORTEMENT THM ET D'INTERFACE
!     PERMET DE CALCULER LES CONTRAINTES GENERALISES ET LES VARIABLES
!     INTERNES EN CHAQUE POINT D'INTEGRATION
!     LA ROUTINE RENVOIE EGALEMENT LES RESIDUS ET L'OPERATEUR TANGENT EN
!     FONCTION DU POINT D'INTEGRATION
!.......................................................................
! =====================================================================
! IN OPTION : OPTION DE CALCUL
! IN PERMAN : PERMANENT ?
! IN RESI   : FULL_MECA OU RAPH_MECA ?
! IN RIGI   : FULL_MECA OU RIGI_MECA ?
! IN IMATE  : MATERIAU CODE
! IN COMPOR : COMPORTEMENT
! IN CRIT   : CRITERES DE CONVERGENCE LOCAUX
! IN INSTAM : TEMPS MOINS
! IN INSTAP : TEMPS PLUS
! IN NOMAIL : NUMERO DE MAILLE
! IN NDIM   : DIMENSION DE L'ESPACE
! IN DIMDEF : DIMENSION DU TABLEAU DES DEFORMATIONS GENERALISEES
!             AU POINT DE GAUSS CONSIDERE
! IN DIMCON : DIMENSION DU TABLEAU DES CONTRAINTES GENERALISEES
!             AU POINT DE GAUSS CONSIDERE
! IN NBVARI :
! IN YAMEC  : =1 S'IL Y A UNE EQUATION DE DEFORMATION MECANIQUE
! IN YAP1   : =1 S'IL Y A UNE EQUATION DE PRESSION DE FLUIDE
! IN YAP2   : =1 S'IL Y A UNE DEUXIEME EQUATION DE PRESSION DE FLUIDE
! IN YATE   : =1 S'IL YA UNE EQUATION THERMIQUE
! IN ADDEME : ADRESSE DES DEFORMATIONS MECANIQUES
! IN ADDEP1 : ADRESSE DES DEFORMATIONS CORRESPONDANT A LA PRESSION 1
! IN ADDEP2 : ADRESSE DES DEFORMATIONS CORRESPONDANT A LA PRESSION 2
! IN ADDETE : ADRESSE DES DEFORMATIONS THERMIQUES
! IN ADCOME : ADRESSE DES CONTRAINTES MECANIQUES
! IN ADCP11 : ADRESSE DES CONTRAINTES FLUIDE 1 PHASE 1
! IN ADCP12 : ADRESSE DES CONTRAINTES FLUIDE 1 PHASE 2
! IN ADCOP1 : ADRESSE DES CONTRAINTES CORRESPONDANT AU SAUT DE PRE1
! IN ADCP21 : ADRESSE DES CONTRAINTES FLUIDE 2 PHASE 1
! IN ADCP22 : ADRESSE DES CONTRAINTES FLUIDE 2 PHASE 2
! IN ADCOTE : ADRESSE DES CONTRAINTES THERMIQUES
! IN DEFGEM : DEFORMATIONS GENERALISEES A L'INSTANT MOINS
! IN DEFGEP : DEFORMATIONS GENERALISEES A L'INSTANT PLUS
! IN SIGM   : CONTRAINTES GENERALISEES A L'INSTANT MOINS
! IN VINTM  : VARIABLES INTERNES A L'INSTANT MOINS
! IN KPI    : POINT D'INTEGRATION
! IN NPG    : NOMBRE DE POINTS DE GAUSS
! IN NPI    : NOMBRE DE POINTS D'INTEGRATION
! ====================================================================
! OUT SIGP  : CONTRAINTES GENERALISES
! OUT VARIP : VARIABLES INTERNES :
! --- VARIABLES 1 A NVIM : VAR. INT MECANIQUES (VOIR LOI DE
!                          COMPORTEMENT MECANIQUE)
! --- VARIABLES NVIM+1 A NVIM+NVIH : VAR. INT HYDRAULIQUES
!                                    V1 RHO_LIQUIDE - RHO_0
! --- VARIABLES NVIM+NVIH+1 A NVIM+NVIH+NVIC : VAR. INT COUPLAGES
!                        : V1 : OUVERTURE DE FISSURE
!                        : V2 : PVP - PVP_0 SI VAPEUR
!                        : V3 : SATURATION SI LOI NON SATUREE
! OUT RES   : RESIDU AU POINT D'INTEGRATION
! OUT DRDE  : OPERATEUR TANGENT AU POINT D'INTEGRATION
! OUT RETCOM: RETOUR LOI DE COPORTEMENT
! =====================================================================
!
! ======================================================================
! --- INITIALISATION ---------------------------------------------------
! ======================================================================
    retcom = 0
    deltat = instap-instam
!
    if (resi) then
        do i = 1, nbvari
            varip(i)=0.d0
        end do
        do i = 1, dimcon
            sigp(i)=0.d0
        end do
    endif
!
    if (rigi) then
        do i = 1, dimdef
            do j = 1, dimcon
                dsde(j,i)=0.d0
            end do
        end do
!
        do i = 1, dimdef
            do j = 1, dimdef
                drde(i,j)=0.d0
            end do
        end do
    endif
! ======================================================================
! --- MISE AU POINT POUR LES VARIABLES INTERNES ------------------------
! --- DEFINITION DES POINTEURS POUR LES DIFFERENTES RELATIONS DE -------
! --- COMPORTEMENTS ET POUR LES DIFFERENTES COMPOSANTES ----------------
! ======================================================================
    call nvithm(compor, meca, thmc, ther, hydr,&
                nvim, nvit, nvih, nvic, advime,&
                advith, advihy, advico, vihrho, vicphi,&
                vicpvp, vicsat, vicpr1, vicpr2)
!
! - Get Biot parameters (for porosity evolution)
!
    call thmGetParaBiot(imate)
!
! - Compute Biot tensor
!
    angl_naut(:) = 0.d0
    call tebiot(angl_naut, tbiot)
!
! - Get hydraulic parameters
!
    call thmGetParaHydr(hydr, imate)
!
! - TEST LOI DE COMPORTEMENT
!
    if ((meca.ne.'JOINT_BANDIS') .and. (meca.ne.'CZM_LIN_REG') .and.&
        (meca.ne.'CZM_EXP_REG')) then
        call utmess('F', 'ALGORITH17_10', sk=meca)
    endif
! ======================================================================
! --- CALCULS MECA -----------------------------------------------------
! ======================================================================
    call coeime(meca, imate, nomail, option, resi,&
                rigi, ndim, dimdef, dimcon, yap1,&
                yap2, yate, addeme, addep1, addep2,&
                nbvari, advime, advico, npg, npi,&
                defgep, defgem, sigm, sigp, varim,&
                varip, ouvh, tlint, drde, kpi,&
                vicphi, unsurn, retcom)
!
    if (retcom .ne. 0) then
        goto 999
    endif
! ======================================================================
! --- RECUPERATION DES DONNEES INITIALES -------------------------------
! ======================================================================
    call kitdec(kpi, imate, ndim-1,&
                yachai, 0, yate, yap1, yap2,&
                defgem, defgep,&
                addeme, addep1, addep2, addete, &
                depsv , epsv, deps,&
                t     , dt, grat,&
                p1    , dp1    , grap1 ,&
                p2    , dp2    , grap2 ,&
                retcom)
!
    epsv = 0.d0
    depsv = 0.d0
!
! - For JHMS element => initial porosity is non-sense
!
    ds_thm%ds_parainit%poro_init = 0.d0

! ======================================================================
! --- CALCUL DES RESIDUS ET DES MATRICES TANGENTES ---------------------
! ======================================================================
!
    call calcco(option, yachai, perman, meca, thmc,&
                hydr, imate, ndim-1, dimdef,&
                dimcon, nbvari, 2, yate, addeme,&
                adcome, advihy, advico, addep1, adcp11,&
                adcp12, addep2, adcp21, adcp22, addete,&
                adcote, sigm, sigp, varim, varip,&
                dsde, deps, epsv, depsv, p1,&
                p2, dp1, dp2, t, dt,&
                phi, pvp, pad, h11, h12,&
                kh, rho11, sat,&
                retcom, tbiot, vihrho, vicphi,&
                vicpvp, vicsat, angl_naut)
!
    if (retcom .ne. 0) then
        goto 999
    endif
! ======================================================================
! --- RECUPERATION DES DONNEES MATERIAU FINALES ------------------------
! ======================================================================
    call thmlec(imate, thmc, hydr, ther,&
                t, p1, p2, phi, varip(1),&
                pvp, pad, rgaz, tbiot, satur,&
                dsatur, pesa, tperm, permli, dperml,&
                permgz, dperms, dpermp, fick, dfickt,&
                dfickg, lambp, dlambp, unsurk, alpha,&
                lambs, dlambs, viscl, dviscl, mamolg,&
                tlambt, tdlamt, viscg, dviscg, mamovg,&
                fickad, dfadt, tlamct, instap,&
                angl_naut, ndim-1)
! ======================================================================
! --- CALCUL DES FLUX HYDRAULIQUES -------------------------------------
! ======================================================================
    fick = 0.d0
    dfickt = 0.d0
    dfickg = 0.d0
    dperml = 0.d0
!
!
! CREATION D'UN TENSEUR ISOTROPE POUR LA PERMEABILITE LONGTUDINALE
! POUR LE CALCUL DANS CALCF
!
!
    do i = 1, ndim-1
        do j = 1, ndim-1
            klint(i,j)=0.d0
        end do
    end do
!
    do i = 1, ndim-1
        klint(i,i)=tlint
    end do
!
    if (yap1 .eq. 1) then
        call calcfh(option, perman, thmc, ndim-1, dimdef,&
                    dimcon, yamec, yate, addep1, addep2,&
                    adcp11, adcp12, adcp21, adcp22, addeme,&
                    addete, sigp, dsde, p1, p2,&
                    grap1, grap2, t, grat, pvp,&
                    pad, rho11, h11, h12, rgaz,&
                    dsatur, pesa, klint, permli, dperml,&
                    permgz, dperms, dpermp, fick, dfickt,&
                    dfickg, fickad, dfadt, kh, unsurk,&
                    alpha, viscl, dviscl, mamolg, viscg,&
                    dviscg, mamovg)
!
        if (retcom .ne. 0) then
            goto 999
        endif
    endif
! ======================================================================
! --- CONTRAINTES GENERALISEES -----------------------------------------
! ======================================================================
    if (resi) then
! - COMPOSANTES CONSTITUANT 1
        if (yap1 .eq. 1) then
            sigp(adcp11+1) = ouvh*sigp(adcp11+1)
            do f = 1, 2
                sigp(adcop1+f-1) = defgep(addlh1+1+f)
                sigp(adcop1+f+1)= defgep(addlh1-1+f)-defgep(addep1)
            end do
        endif
! ======================================================================
! --- CALCUL DU VECTEUR FORCE INTERNE AUX POINTS DE GAUSS --------------
! ======================================================================
        do i = 1, dimdef
            res(i)=0.d0
        end do
!
        if (kpi .le. npg) then
! - COMPOSANTES MECANIQUES
            do i = 1, ndim
                res(i) = sigp(i)
            end do
            res(1) = res(1)+sigp(ndim+1)
!
! - COMPOSANTES CONSTITUANT 1
            if (yap1 .eq. 1) then
                res(addep1) = deltat*(sigp(adcop1)+sigp(adcop1+1))
                do j = 1, ndim-1
                    res(addep1+j) = deltat*sigp(adcp11+j)
                end do
                do f = 1, 2
                    res(addlh1+f-1) = -deltat*sigp(adcop1+f-1)
                    res(addlh1+f+1) = sigp(adcop1+f+1)
                end do
            endif
        endif
! ======================================================================
! --- CALCUL DU VECTEUR FORCE INTERNE AUX SOMMETS --------------
! ======================================================================
        if ((kpi .gt. npg) .or. (npi .eq. npg)) then
!
! - COMPOSANTES CONSTITUANT 1
            if (yap1 .eq. 1) then
                res(addep1) = res(addep1) - sigp(adcp11)
                res(addep1) = res(addep1) + sigm(adcp11)
            endif
        endif
    endif
! - FIN DE L'OPTION RESI
!
! ======================================================================
! --- CALCUL DE L'OPERATEUR TANGENT ------------------------------------
! ======================================================================
    if (rigi) then
! ======================================================================
! --- D(RESIDU)/D(DEFORMATIONS GENERALISES)------------
! --- POUR MATRICE DE RIGIDITE------------------------------------------
! ======================================================================
        if (kpi .le. npg) then
!
! - LIGNES CORRESPONDANT AUX TERMES HYDRAULIQUES
!
            if (yap1 .eq. 1) then
                do f = 1, 2
                    drde(addep1,addlh1+1+f)= deltat
!
                    drde(addlh1+f-1,addlh1+1+f)=-deltat
!
                    drde(addlh1+f+1,addep1)=-1.d0
                    drde(addlh1+f+1,addlh1+f-1)=1.d0
                end do
                do i = 1, ndim-1
                    do j = 1, ndim-1
                        if (thmc .eq. 'GAZ') then
                            drde(addep1+i,1) = drde(addep1+i,1) +deltat*3.d0*tlint*rho11/viscg*(-&
                                               &grap1(i)+ rho11*pesa(i))
                        endif
                        if (thmc .eq. 'LIQU_SATU') then
                            drde(addep1+i,1) = drde(addep1+i,1) +deltat*3.d0*tlint*rho11/viscl*(-&
                                               &grap1(i)+ rho11*pesa(i))
                        endif
                        drde(addep1+i,addep1)= drde(addep1+i,addep1)&
                        +deltat*ouvh*dsde(adcp11+j,addep1)
                        drde(addep1+i,addep1+j) = drde(addep1+i, addep1+j) + deltat*ouvh*dsde(adc&
                                                  &p11+i,addep1+ j)
                    end do
                end do
            endif
        endif
! ======================================================================
! --- D(RESIDU)/D(DEFORMATIONS GENERALISES)------------
! --- POUR MATRICE DE MASSE---------------------------------------------
! ======================================================================
        if ((kpi .gt. npg) .or. (npi .eq. npg)) then
!
            if (yap1 .eq. 1) then
                drde(addep1,addeme) = drde(addep1,addeme) - rho11
                drde(addep1,addep1) = rho11*drde(addep1,addep1) + dsde(adcp11,addep1)
            endif
        endif
    endif
! ======================================================================
999 continue
! ======================================================================
end subroutine
