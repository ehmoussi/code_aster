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
! person_in_charge: daniele.colombo at ifpen.fr
! aslint: disable=W1504,W1306
!
subroutine xcomhm(option, imate, compor,instap,&
                  ndim, dimdef, dimcon,nbvari,&
                  yamec, yap1, yap2, yate,&
                  addeme, adcome, addep1, adcp11,&
                  addep2, addete, defgem,&
                  defgep, congem, congep, vintm,&
                  vintp, dsde, pesa, retcom, kpi,&
                  npg, dimenr,&
                  angl_naut, yaenrh, adenhy, nfh)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/kitdec.h"
#include "asterfort/nvithm.h"
#include "asterfort/thmlec.h"
#include "asterfort/xcalfh.h"
#include "asterfort/xcalme.h"
#include "asterfort/xhmsat.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetParaBiot.h"
#include "asterfort/thmGetParaElas.h"
#include "asterfort/thmGetParaTher.h"
#include "asterfort/thmGetParaHydr.h"
#include "asterfort/thmMatrHooke.h"
#include "asterfort/tebiot.h"
!
! ======================================================================
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE AU POINT
! DE GAUSS SUIVANT LES OPTIONS DEFINIES
! ======================================================================
! IN OPTION : OPTION DE CALCUL
! IN COMPOR : COMPORTEMENT
! IN IMATE  : MATERIAU CODE
! IN NDIM   : DIMENSION DE L'ESPACE
! IN DIMDEF : DIMENSION DU TABLEAU DES DEFORMATIONS GENERALISEES
!             AU POINT DE GAUSS CONSIDERE
! IN DIMCON : DIMENSION DU TABLEAU DES CONTRAINTES GENERALISEES
!             AU POINT DE GAUSS CONSIDERE
! IN NBVARI : NOMBRE TOTAL DE VARIABLES INTERNES AU POINT DE GAUSS
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
! IN ADCP11 : ADRESSE DES CONTRAINTES FLUIDE 1 PHASE 2
! IN ADCP11 : ADRESSE DES CONTRAINTES FLUIDE 2 PHASE 1
! IN ADCP11 : ADRESSE DES CONTRAINTES FLUIDE 2 PHASE 2
! IN ADCOTE : ADRESSE DES CONTRAINTES THERMIQUES
! IN DEFGEM : DEFORMATIONS GENERALISEES A L'INSTANT MOINS
! IN DEFGEP : DEFORMATIONS GENERALISEES A L'INSTANT PLUS
! IN CONGEM : CONTRAINTES GENERALISEES A L'INSTANT MOINS
! IN VINTM  : VARIABLES INTERNES A L'INSTANT MOINS
! IN TYPMOD : MODELISATION (D_PLAN, AXI, 3D ?)
!
! OUT CONGEP : CONTRAINTES GENERALISEES A L'INSTANT PLUS
! OUT VINTP  : VARIABLES INTERNES A L'INSTANT PLUS
! OUT DSDE   : MATRICE TANGENTE CONTRAINTES DEFORMATIONS
!
! OUT RETCOM : RETOUR LOI DE COMPORTEMENT
! ======================================================================
! VARIABLES IN / OUT
! ======================================================================


    aster_logical :: yachai
    integer :: retcom, kpi, npg, vicpr1, vicpr2, nfh
    integer :: ndim, dimdef, dimcon, nbvari, imate, yamec, yap1
    integer :: yap2, yate, addeme, addep1, addep2, addete
    integer :: adcome, adcp11
    real(kind=8) :: defgem(1:dimdef), defgep(1:dimdef), congep(1:dimcon)
    real(kind=8) :: congem(1:dimcon), vintm(1:nbvari), vintp(1:nbvari)
    real(kind=8) :: instap
    character(len=16) :: compor(*), option
!
! DECLARATION POUR XFEM
    integer :: dimenr
    integer :: yaenrh, adenhy
    real(kind=8) :: dsde(1:dimcon, 1:dimenr)
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: nvim, advime, advith, advihy, advico
    integer :: vihrho, vicphi, vicpvp, vicsat, nvih, nvic, nvit
    real(kind=8) :: p1, dp1, grap1(3), p2, dp2, grap2(3), t, dt, grat(3)
    real(kind=8) :: phi, pvp, pad, rho11, epsv, deps(6), depsv
    real(kind=8) :: sat, mamovg
    real(kind=8) :: rgaz, tbiot(6), satur, dsatur, pesa(3)
    real(kind=8) :: tperm(ndim, ndim), permli, dperml, permgz, dperms, dpermp
    real(kind=8) :: dfickt, dfickg, lambp, dlambp, unsurk, fick
    real(kind=8) :: lambs, dlambs, viscl, dviscl
    real(kind=8) :: viscg, dviscg, mamolg
    real(kind=8) :: fickad, dfadt, alpha
    real(kind=8) :: tlambt(ndim, ndim), tlamct(ndim, ndim), tdlamt(ndim, ndim)
    real(kind=8) :: angl_naut(3)
    character(len=16) :: thmc, ther, hydr, meca
! ======================================================================
! --- INITIALISATION ---------------------------------------------------
! ======================================================================
    retcom = 0
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
! - Update unknowns
!
    call kitdec(kpi   , ndim  , &
                yachai, yamec  , yate  , yap1  , yap2,&
                defgem, defgep ,&
                addeme, addep1 , addep2, addete,&
                depsv , epsv   , deps  ,&
                t     , dt     , grat  ,&
                p1    , dp1    , grap1 ,&
                p2    , dp2    , grap2 ,&
                retcom)
    if (retcom .ne. 0) then
        goto 900
    endif
!
! - Get Biot parameters (for porosity evolution)
!
    call thmGetParaBiot(imate)
!
! - Compute Biot tensor
!
    call tebiot(angl_naut, tbiot)
!
! - Get elastic parameters
!
    call thmGetParaElas(imate, kpi, t, ndim)
    call thmMatrHooke(angl_naut)
!
! - Get hydraulic parameters
!
    call thmGetParaHydr(hydr, imate)
!
! - Get thermic parameters
!
    call thmGetParaTher(imate, kpi, t)

! ======================================================================
! --- CALCUL DES RESIDUS ET DES MATRICES TANGENTES ---------------------
! ======================================================================
    call xhmsat(yachai, option, ther,&
                imate, ndim, dimenr,&
                dimcon, nbvari, yamec, addeme,&
                adcome, advihy, advico, vihrho, vicphi,&
                addep1, adcp11, congem, congep, vintm,&
                vintp, dsde, epsv, depsv,&
                dp1, t, phi, rho11,&
                sat, retcom, tbiot,&
                angl_naut, yaenrh, adenhy, nfh)
    if (retcom .ne. 0) then
        goto 900
    endif
! ======================================================================
! --- CALCUL DES GRANDEURS MECANIQUES PURES UNIQUEMENT SI YAMEC = 1 -
! ET SI ON EST SUR UN POINT DE GAUSS (POUR L'INTEGRATION REDUITE)
!  C'EST A DIRE SI KPI<NPG
! ======================================================================
    if (yamec .eq. 1 .and. kpi .le. npg) then
        call xcalme(option, meca, ndim, dimenr,&
                    dimcon, addeme, adcome, congep,&
                    dsde, deps, angl_naut)
        if (retcom .ne. 0) then
            goto 900
        endif
    endif
! ======================================================================
! --- RECUPERATION DES DONNEES MATERIAU FINALES ------------------------
! ======================================================================
    call thmlec(imate, thmc, hydr, ther,&
                t, p1, p2, phi, vintp(1),&
                pvp, pad, rgaz, tbiot, satur,&
                dsatur, pesa, tperm, permli, dperml,&
                permgz, dperms, dpermp, fick, dfickt,&
                dfickg, lambp, dlambp, unsurk, alpha,&
                lambs, dlambs, viscl, dviscl, mamolg,&
                tlambt, tdlamt, viscg, dviscg, mamovg,&
                fickad, dfadt, tlamct, instap,&
                angl_naut, ndim)
! ======================================================================
! --- CALCUL DES FLUX HYDRAULIQUES UNIQUEMENT SI YAP1 = 1 --------------
! ======================================================================
    if ((yap1.eq.1).and.(yaenrh.eq.1)) then
        call xcalfh(option, thmc, ndim, dimcon, yamec,&
                    addep1, adcp11, addeme, congep, dsde,&
                    grap1, rho11, pesa, tperm, unsurk,&
                    viscl, dviscl, dimenr,&
                    adenhy, nfh)
        if (retcom .ne. 0) then
            goto 900
        endif
    endif
! ======================================================================
900 continue
! ======================================================================
end subroutine
