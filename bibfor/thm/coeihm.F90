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
subroutine coeihm(option, l_steady, l_resi, l_matr, j_mater,&
                  time_prev, time_curr, nomail,&
                  ndim, dimdef, dimcon, nbvari, &
                  addeme, adcome,&
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
#include "asterfort/calcva.h"
#include "asterfort/utmess.h"
#include "asterfort/thmGetParaBiot.h"
#include "asterfort/thmGetParaHydr.h"
#include "asterfort/tebiot.h"
#include "asterfort/thmEvalSatuFinal.h"
#include "asterfort/thmEvalConductivity.h"
#include "asterfort/thmEvalGravity.h"
#include "asterfort/THM_type.h"
!
integer, intent(in) :: j_mater
character(len=8), intent(in) :: nomail
character(len=16), intent(in) :: option
integer, intent(in) :: dimdef, dimcon, npg, kpi, npi, ndim
integer, intent(in) :: nbvari
integer, intent(in) :: addeme, addep1, addep2, addete, adcop1, addlh1
integer, intent(in) :: adcome, adcp11, adcp12, adcp21, adcp22, adcote
real(kind=8), intent(in) :: defgem(1:dimdef), defgep(1:dimdef)
real(kind=8), intent(in) :: varim(nbvari), time_prev, time_curr
real(kind=8), intent(in) :: sigm(dimcon)
aster_logical, intent(in) :: l_steady, l_resi, l_matr
integer, intent(out) :: retcom
real(kind=8), intent(inout) :: sigp(dimcon), varip(nbvari)
real(kind=8), intent(out) :: res(dimdef), drde(dimdef, dimdef)
!
! --------------------------------------------------------------------------------------------------
!
!     BUT:  INTEGRATION DES LOIS DE COMPORTEMENT
!
!     L'INTEGRATION DES LOIS DE COMPORTEMENT THM ET D'INTERFACE
!     PERMET DE CALCULER LES CONTRAINTES GENERALISES ET LES VARIABLES
!     INTERNES EN CHAQUE POINT D'INTEGRATION
!     LA ROUTINE RENVOIE EGALEMENT LES l_resiDUS ET L'OPERATEUR TANGENT EN
!     FONCTION DU POINT D'INTEGRATION
!
! --------------------------------------------------------------------------------------------------
!
! IN OPTION : OPTION DE CALCUL
! IN l_steady : l_steadyENT ?
! IN l_resi   : FULL_MECA OU RAPH_MECA ?
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
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, f
    real(kind=8) :: depsv, epsv, deps(6)
    real(kind=8) :: t, p1, p2, dt, dp1, dp2, grat(3), grap1(3), grap2(3)
    real(kind=8) :: pvp, pad, h11, h12, rho11, phi
    real(kind=8) :: tperm(ndim, ndim), sat, tbiot(6), satur, dsatur, pesa(3)
    real(kind=8) :: lambp, dlambp, lambs, dlambs, viscl , viscg
    real(kind=8) :: tlambt(ndim, ndim), tdlamt(ndim, ndim)
    real(kind=8) :: tlamct(ndim, ndim)
    real(kind=8) :: dsde(dimcon, dimdef)
    real(kind=8) :: tlint, ouvh, deltat
    real(kind=8) :: angl_naut(3)
    integer :: nume_thmc
    character(len=16) :: meca
!
! --------------------------------------------------------------------------------------------------
!
    retcom       = 0
    deltat       = time_curr-time_prev
    tperm(:,:)   = 0.d0
    angl_naut(:) = 0.d0
    if (l_resi) then
        varip(1:nbvari) = 0.d0
        sigp(1:dimcon)  = 0.d0
        res(1:dimdef)   = 0.d0
    endif
    if (l_matr) then
        dsde(1:dimcon,1:dimdef) = 0.d0
        drde(1:dimdef,1:dimdef) = 0.d0
    endif
!
! - Get storage parameters for behaviours
!
    meca      = ds_thm%ds_behaviour%rela_meca
    nume_thmc = ds_thm%ds_behaviour%nume_thmc
!
! - Update unknowns
!
    call calcva(kpi   , ndim-1,&
                defgem, defgep,&
                addeme, addep1, addep2   , addete,&
                depsv , epsv  , deps     ,&
                t     , dt, grat,&
                p1    , dp1    , grap1 ,&
                p2    , dp2    , grap2 ,&
                retcom)
!
! - Mechanic - Not fully coupled
!
    epsv  = 0.d0
    depsv = 0.d0
!
! - Get hydraulic parameters
!
    call thmGetParaHydr(j_mater)
!
! - Get Biot parameters (for porosity evolution)
!
    call thmGetParaBiot(j_mater)
!
! - Compute Biot tensor
!
    call tebiot(angl_naut, tbiot)
!
! - Compute generalized stresses and matrix for mechanical behaviour
!
    if ((meca.ne.'JOINT_BANDIS') .and. (meca.ne.'CZM_LIN_REG') .and.&
        (meca.ne.'CZM_EXP_REG')) then
        call utmess('F', 'ALGORITH17_10', sk=meca)
    endif
    call coeime(j_mater, nomail, option, l_resi,&
                l_matr, ndim, dimdef, dimcon, &
                addeme, addep1, &
                nbvari, npg, npi,&
                defgep, defgem, sigm, sigp, varim,&
                varip, ouvh, tlint, drde, kpi,&
                retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
!
! - For JHMS element => initial porosity is non-sense
!
    ds_thm%ds_parainit%poro_init = 0.d0
!
! - Compute generalized stresses and matrix for coupled quantities
!
    call calcco(l_steady,&
                option  , angl_naut,&
                j_mater  ,&
                ndim-1  , nbvari   ,&
                dimdef  , dimcon   ,&
                adcome  , adcote   , adcp11, adcp12, adcp21, adcp22,&
                addeme  , addete   , addep1, addep2,&
                t       , p1       , p2    ,&
                dt      , dp1      , dp2   ,&
                deps    , epsv     , depsv ,&
                tbiot   ,&
                phi     , rho11    , satur ,&
                pad     , pvp      , h11   , h12   ,&
                sigm    , sigp     ,&
                varim   , varip    , dsde  ,& 
                retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
!
! - Evaluation of final saturation
!
    call thmEvalSatuFinal(j_mater, p1    ,&
                          satur  , dsatur, retcom)
!
! - Evaluate thermal conductivity
!
    call thmEvalConductivity(angl_naut, ndim  , j_mater , &
                             satur    , phi   , &
                             lambs    , dlambs, lambp , dlambp,&
                             tlambt   , tlamct, tdlamt)
!
! - Compute gravity
!
    call thmEvalGravity(j_mater, time_curr, pesa)
!
! - (re)-compute Biot tensor
!
    call tebiot(angl_naut, tbiot)
!
! - Get parameters
!
    viscl  = ds_thm%ds_material%liquid%visc
    viscg  = ds_thm%ds_material%gaz%visc
!
! - Compute flux
!
    do i = 1, ndim-1
        tperm(i,i) = tlint
    end do
    if (ds_thm%ds_elem%l_dof_pre1) then
        call calcfh(option, l_steady, ndim  , j_mater,&
                    dimdef, dimcon,&
                    addep1, addep2,&
                    adcp11, adcp12, adcp21 , adcp22,&
                    addeme, addete, &
                    t     , p1    , p2     , pvp   , pad,&
                    grat  , grap1 , grap2  ,& 
                    rho11 , h11   , h12    ,&
                    sat   , dsatur, pesa   , tperm,&
                    sigp  , dsde)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
!
! - Generalized stress and residual
!
    if (l_resi) then
        if (ds_thm%ds_elem%l_dof_pre1) then
            sigp(adcp11+1) = ouvh*sigp(adcp11+1)
            do f = 1, 2
                sigp(adcop1+f-1) = defgep(addlh1+1+f)
                sigp(adcop1+f+1)= defgep(addlh1-1+f)-defgep(addep1)
            end do
        endif
        if (kpi .le. npg) then
            do i = 1, ndim
                res(i) = sigp(i)
            end do
            res(1) = res(1)+sigp(ndim+1)
            if (ds_thm%ds_elem%l_dof_pre1) then
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
        if ((kpi .gt. npg) .or. (npi .eq. npg)) then
            if (ds_thm%ds_elem%l_dof_pre1) then
                res(addep1) = res(addep1) - sigp(adcp11)
                res(addep1) = res(addep1) + sigm(adcp11)
            endif
        endif
    endif
!
! - Tangent matrix
!
    if (l_matr) then
        if (kpi .le. npg) then
            if (ds_thm%ds_elem%l_dof_pre1) then
                do f = 1, 2
                    drde(addep1,addlh1+1+f)= deltat
                    drde(addlh1+f-1,addlh1+1+f)=-deltat
                    drde(addlh1+f+1,addep1)=-1.d0
                    drde(addlh1+f+1,addlh1+f-1)=1.d0
                end do
                do i = 1, ndim-1
                    do j = 1, ndim-1
                        if (nume_thmc .eq. GAZ) then
                            drde(addep1+i,1) = drde(addep1+i,1) +&
                                deltat*3.d0*tlint*rho11/viscg*(-grap1(i)+ rho11*pesa(i))
                        endif
                        if (nume_thmc .eq. LIQU_SATU) then
                            drde(addep1+i,1) = drde(addep1+i,1) +&
                                deltat*3.d0*tlint*rho11/viscl*(-grap1(i)+ rho11*pesa(i))
                        endif
                        drde(addep1+i,addep1)= drde(addep1+i,addep1)+&
                            deltat*ouvh*dsde(adcp11+j,addep1)
                        drde(addep1+i,addep1+j) = drde(addep1+i, addep1+j) +&
                            deltat*ouvh*dsde(adcp11+i,addep1+j)
                    end do
                end do
            endif
        endif
        if ((kpi .gt. npg) .or. (npi .eq. npg)) then
            if (ds_thm%ds_elem%l_dof_pre1) then
                drde(addep1,addeme) = drde(addep1,addeme) - rho11
                drde(addep1,addep1) = rho11*drde(addep1,addep1) + dsde(adcp11,addep1)
            endif
        endif
    endif
!
99  continue
!
end subroutine
