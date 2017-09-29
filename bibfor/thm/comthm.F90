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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504, W1306
!
subroutine comthm(option, l_steady, &
                  j_mater, typmod, compor, carcri,&
                  instam, instap, ndim, dimdef, dimcon,&
                  nbvari, yamec, yap1, yap2, yate,&
                  addeme, adcome, addep1, adcp11, adcp12,&
                  addep2, adcp21, adcp22, addete, adcote,&
                  defgem, defgep, congem, congep, vintm,&
                  vintp, dsde, pesa, retcom, kpi,&
                  npg, angl_naut,&
                  thmc, hydr,&
                  advihy, advico, vihrho, vicphi, vicpvp, vicsat)

!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcco.h"
#include "asterfort/calcfh.h"
#include "asterfort/calcft.h"
#include "asterfort/thmSelectMeca.h"
#include "asterfort/kitdec.h"
#include "asterfort/nvithm.h"
#include "asterfort/thmGetParaBiot.h"
#include "asterfort/thmGetParaElas.h"
#include "asterfort/thmGetParaTher.h"
#include "asterfort/thmGetParaHydr.h"
#include "asterfort/thmMatrHooke.h"
#include "asterfort/tebiot.h"
#include "asterfort/thmGetParaBehaviour.h"
#include "asterfort/thmEvalSatuFinal.h"
#include "asterfort/thmGetPermeabilityTensor.h"
#include "asterfort/thmEvalGravity.h"
#include "asterfort/thmEvalConductivity.h"
!
character(len=16), intent(in) :: thmc
character(len=16), intent(in) :: hydr
integer, intent(in) :: advihy
integer, intent(in) :: advico
integer, intent(in) :: vihrho
integer, intent(in) :: vicphi
integer, intent(in) :: vicpvp
integer, intent(in) :: vicsat

! **********************************************************************
!
! VERSION DU 07/06/99  ECRITE PAR PASCAL CHARLES
! ROUTINE COMTHM
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE AU POINT
! DE GAUSS SUIVANT LES OPTIONS DEFINIES
!
! **********************************************************************
!               CRIT    CRITERES  LOCAUX
!                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
!                                 (ITER_INTE_MAXI == ITECREL)
!                       CRIT(2) = TYPE DE JACOBIEN A T+DT
!                                 (TYPE_MATR_COMP == MACOMP)
!                                 0 = EN VITESSE     > SYMETRIQUE
!                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
!                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
!                                 (RESI_INTE_RELA == RESCREL)
!                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
!                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
!                                 (RESI_INTE_PAS == ITEDEC )
!                                 0 = PAS DE REDECOUPAGE
!                                 N = NOMBRE DE PALIERS
! ======================================================================
! IN OPTION : OPTION DE CALCUL
! IN l_steady : TRUE SI l_steadyENT
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
!
    aster_logical :: yachai
    integer :: retcom, kpi, npg
    integer :: ndim, dimdef, dimcon, nbvari, j_mater, yamec, yap1
    integer :: yap2, yate, addeme, addep1, addep2, addete
    integer :: adcome, adcp11, adcp12, adcp21, adcp22, adcote
    real(kind=8) :: defgem(1:dimdef), defgep(1:dimdef), congep(1:dimcon)
    real(kind=8) :: congem(1:dimcon), vintm(1:nbvari), vintp(1:nbvari)
    real(kind=8) :: dsde(1:dimcon, 1:dimdef), carcri(*), instam, instap
    character(len=8) :: typmod(2)
    character(len=16) :: compor(*), option
    aster_logical :: l_steady
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    real(kind=8) :: p1, dp1, grap1(3), p2, dp2, grap2(3), t, dt, grat(3)
    real(kind=8) :: phi, pvp, pad, h11, h12, rho11, epsv, deps(6), depsv
    real(kind=8) :: tbiot(6), satur, dsatur, pesa(3)
    real(kind=8) :: tperm(ndim, ndim)
    real(kind=8) :: lambp, dlambp, lambs, dlambs
    real(kind=8) :: tlambt(ndim, ndim), tlamct(ndim, ndim), tdlamt(ndim, ndim)
    real(kind=8) :: angl_naut(3)
    integer :: nume_thmc
! ======================================================================
! --- INITIALISATION ---------------------------------------------------
! ======================================================================
    retcom = 0
!
! - Update unknowns
!
    call kitdec(kpi   , ndim   , &
                yachai, yamec  , yate  , yap1  , yap2,&
                defgem, defgep ,&
                addeme, addep1 , addep2, addete,&
                depsv , epsv   , deps  ,&
                t     , dt     , grat  ,&
                p1    , dp1    , grap1 ,&
                p2    , dp2    , grap2 ,&
                retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
!
! - Get hydraulic parameters
!
    call thmGetParaHydr(hydr, j_mater)
!
! - Get Biot parameters (for porosity evolution)
!
    call thmGetParaBiot(j_mater)
!
! - Compute Biot tensor
!
    call tebiot(angl_naut, tbiot)
!
! - Get elastic parameters
!
    if (ds_thm%ds_elem%l_dof_meca .or. ds_thm%ds_elem%l_weak_coupling) then
        call thmGetParaElas(j_mater, kpi, t, ndim)
        call thmMatrHooke(angl_naut)
    endif
!
! - Get thermic parameters
!
    call thmGetParaTher(j_mater, kpi, t)
!
! - Compute generalized stresses and matrix for coupled quantities
!
    call thmGetParaBehaviour(compor,&
                             nume_thmc_ = nume_thmc)
    call calcco(l_steady, nume_thmc,&
                option  , angl_naut,&
                hydr    , j_mater  ,&
                ndim    , nbvari   ,&
                dimdef  , dimcon   ,&
                adcome  , adcote   , adcp11, adcp12, adcp21, adcp22,&
                addeme  , addete   , addep1, addep2,&
                advico  , advihy   ,&
                vihrho  , vicphi   , vicpvp, vicsat,&
                t       , p1       , p2    ,&
                dt      , dp1      , dp2   ,&
                deps    , epsv     , depsv ,&
                tbiot   ,&
                phi     , rho11    , satur ,&
                pad     , pvp      , h11   , h12   ,&
                congem  , congep   ,&
                vintm   , vintp    , dsde  ,& 
                retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
!
! ======================================================================
! --- CALCUL DES GRANDEURS MECANIQUES PURES UNIQUEMENT SI YAMEC = 1 -
! ET SI ON EST SUR UN POINT DE GAUSS (POUR L'INTEGRATION REDUITE)
!  C'EST A DIRE SI KPI<NPG
! ======================================================================
    if (ds_thm%ds_elem%l_dof_meca .and. kpi .le. npg) then
        call thmSelectMeca(p1    , dp1    , p2    , dp2   , satur   , tbiot,&
                           option, j_mater, ndim  , typmod, angl_naut,&
                           compor, carcri , instam, instap, dt       ,&
                           addeme, addete , adcome, addep1, addep2   ,&
                           dimdef, dimcon ,&
                           defgem, deps   ,&
                           congem, vintm  ,&
                           congep, vintp  ,&
                           dsde  , retcom)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
!
! - Evaluation of final saturation
!
    call thmEvalSatuFinal(hydr , j_mater , p1    ,&
                          satur, dsatur, retcom)
!
! - Evaluate thermal conductivity
!
    call thmEvalConductivity(angl_naut, ndim  , j_mater, &
                             satur    , phi   , &
                             lambs    , dlambs, lambp , dlambp,&
                             tlambt   , tlamct, tdlamt)

!
! - Get permeability tensor
!
    call thmGetPermeabilityTensor(ndim , angl_naut, j_mater, phi, vintp(1),&
                                  tperm)
!
! - Compute pesa
!
    call thmEvalGravity(j_mater, instap, pesa)

! ======================================================================
! --- CALCUL DES FLUX HYDRAULIQUES UNIQUEMENT SI YAP1 = 1 --------------
! ======================================================================
    if (ds_thm%ds_elem%l_dof_pre1) then
        call calcfh(nume_thmc, &
                    option   , l_steady, hydr   , ndim  , j_mater,&
                    dimdef   , dimcon,&
                    addep1   , addep2,&
                    adcp11   , adcp12, adcp21 , adcp22,&
                    addeme   , addete, &
                    t        , p1    , p2     , pvp   , pad,&
                    grat     , grap1 , grap2  ,& 
                    rho11    , h11   , h12    ,&
                    satur    , dsatur, pesa   , tperm,&
                    congep   , dsde)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
! ======================================================================
! --- CALCUL DU FLUX THERMIQUE UNIQUEMENT SI YATE = 1 ------------------
! ======================================================================
    if (ds_thm%ds_elem%l_dof_ther) then
        call calcft(option, thmc, ndim, dimdef,&
                    dimcon, addete,&
                    addeme, addep1, addep2, adcote, congep,&
                    dsde, t, grat, phi, pvp,&
                    tbiot, satur, dsatur, lambp,&
                    dlambp, lambs, dlambs, tlambt, tdlamt,&
                    tlamct, rho11, h11, h12,&
                    angl_naut)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
! ======================================================================
99  continue
! ======================================================================
end subroutine
