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
subroutine xcomhm(option, j_mater, time_curr,&
                  ndim, dimdef, dimcon, nbvari,&
                  addeme, adcome, addep1, adcp11,&
                  addep2, addete, defgem,&
                  defgep, congem, congep, vintm,&
                  vintp, dsde, gravity, retcom, kpi,&
                  npg, dimenr,&
                  angl_naut, yaenrh, adenhy, nfh)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcva.h"
#include "asterfort/xcalfh.h"
#include "asterfort/xcalme.h"
#include "asterfort/xhmsat.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetParaBiot.h"
#include "asterfort/thmGetParaElas.h"
#include "asterfort/thmGetParaTher.h"
#include "asterfort/thmGetParaHydr.h"
#include "asterfort/thmMatrHooke.h"
#include "asterfort/thmGetPermeabilityTensor.h"
#include "asterfort/thmEvalGravity.h"
#include "asterfort/tebiot.h"
!
integer :: retcom, kpi, npg, nfh
integer :: ndim, dimdef, dimcon, nbvari, j_mater
integer :: addeme, addep1, addep2, addete
integer :: adcome, adcp11
real(kind=8) :: defgem(1:dimdef), defgep(1:dimdef), congep(1:dimcon)
real(kind=8) :: congem(1:dimcon), vintm(1:nbvari), vintp(1:nbvari)
real(kind=8) :: time_curr
character(len=16) :: option
integer :: dimenr
integer :: yaenrh, adenhy
real(kind=8) :: dsde(1:dimcon, 1:dimenr)
real(kind=8) :: gravity(3)
real(kind=8) :: angl_naut(3)
!
! --------------------------------------------------------------------------------------------------
!
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE AU POINT
! DE GAUSS SUIVANT LES OPTIONS DEFINIES
!
! --------------------------------------------------------------------------------------------------
!
! IN OPTION : OPTION DE CALCUL
! IN COMPOR : COMPORTEMENT
! IN IMATE  : MATERIAU CODE
! IN NDIM   : DIMENSION DE L'ESPACE
! IN DIMDEF : DIMENSION DU TABLEAU DES DEFORMATIONS GENERALISEES
!             AU POINT DE GAUSS CONSIDERE
! IN DIMCON : DIMENSION DU TABLEAU DES CONTRAINTES GENERALISEES
!             AU POINT DE GAUSS CONSIDERE
! IN NBVARI : NOMBRE TOTAL DE VARIABLES INTERNES AU POINT DE GAUSS
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
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: p1, dp1, grap1(3), p2, dp2, grap2(3), t, dt, grat(3)
    real(kind=8) :: phi, rho11, epsv, deps(6), depsv
    real(kind=8) :: satur
    real(kind=8) :: tbiot(6)
    real(kind=8) :: tperm(ndim, ndim)
!
! --------------------------------------------------------------------------------------------------
!
    retcom = 0
!
! - Update unknowns
!
    call calcva(kpi   , ndim  ,&
                defgem, defgep,&
                addeme, addep1, addep2   , addete,&
                depsv , epsv  , deps     ,&
                t     , dt    , grat  ,&
                p1    , dp1   , grap1 ,&
                p2    , dp2   , grap2 ,&
                retcom)
    if (retcom .ne. 0) then
        goto 99
    endif
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
! - Get elastic parameters
!
    call thmGetParaElas(j_mater, kpi, t, ndim)
    call thmMatrHooke(angl_naut)
!
! - Get thermic parameters
!
    call thmGetParaTher(j_mater, kpi, t)

! ======================================================================
! --- CALCUL DES RESIDUS ET DES MATRICES TANGENTES ---------------------
! ======================================================================
    call xhmsat(option,&
                ndim, dimenr,&
                dimcon, nbvari, addeme,&
                adcome,&
                addep1, adcp11, congem, congep, vintm,&
                vintp, dsde, epsv, depsv,&
                dp1, phi, rho11,&
                satur, retcom, tbiot,&
                angl_naut, yaenrh, adenhy, nfh)
    if (retcom .ne. 0) then
        goto 99
    endif
! ======================================================================
! --- CALCUL DES GRANDEURS MECANIQUES PURES
! SI ON EST SUR UN POINT DE GAUSS (POUR L'INTEGRATION REDUITE)
!  C'EST A DIRE SI KPI<NPG
! ======================================================================
    if (ds_thm%ds_elem%l_dof_meca .and. kpi .le. npg) then
        call xcalme(option, ndim, dimenr,&
                    dimcon, addeme, adcome, congep,&
                    dsde, deps, angl_naut)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
!
! - Get permeability tensor
!
    call thmGetPermeabilityTensor(ndim , angl_naut, j_mater, phi, vintp(1),&
                                  tperm)
!
! - Compute gravity
!
    call thmEvalGravity(j_mater, time_curr, gravity)
! ======================================================================
! --- CALCUL DES FLUX HYDRAULIQUES UNIQUEMENT
! ======================================================================
    if ((ds_thm%ds_elem%l_dof_pre1).and.(yaenrh.eq.1)) then
        call xcalfh(option, ndim, dimcon,&
                    addep1, adcp11, addeme, congep, dsde,&
                    grap1, rho11, gravity, tperm, &
                    dimenr,&
                    adenhy, nfh)
        if (retcom .ne. 0) then
            goto 99
        endif
    endif
!
99 continue
!
end subroutine
