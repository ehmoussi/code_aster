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
! aslint: disable=W1504
! person_in_charge: sylvie.granet at edf.fr
!
subroutine thmlec(j_mater, thmc, hydr, ther,&
                  t, p1, p2, phi, endo,&
                  pvp, pad, rgaz, tbiot, satur,&
                  dsatur, gravity, tperm, permli, dperml,&
                  permgz, dperms, dpermp, fick, dfickt,&
                  dfickg, lambp, dlambp, unsurk, alpha,&
                  lambs, dlambs, viscl, dviscl, mamolg,&
                  tlambt, tdlamt, viscg, dviscg, mamolv,&
                  fickad, dfadt, tlamct, instap,&
                  angl_naut, ndim)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/tebiot.h"
#include "asterfort/thmGetPermeabilityTensor.h"
#include "asterfort/thmEvalGravity.h"
#include "asterfort/thmEvalConductivity.h"
!#include "asterfort/thmEvalSatuFinal.h"
#include "asterfort/thmEvalPermLiquGaz.h"
#include "asterfort/thmEvalFickSteam.h"
#include "asterfort/thmEvalFickAir.h"
!
integer, intent(in) :: ndim
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: j_mater
real(kind=8), intent(in) :: phi, endo
real(kind=8), intent(out) :: tperm(ndim, ndim)
real(kind=8), intent(out) :: gravity(3)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get final parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of space (2 or 3)
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (3) Gamma - clockwise around X
! In  j_mater          : coded material address
! In  phi              : porosity
! In  endo             : damage
! Out tperm            : permeability tensor
! Out gravity          : gravity
!
! --------------------------------------------------------------------------------------------------
!
    integer :: retcom
    real(kind=8) :: t, p1, p2, pvp
    real(kind=8) :: rgaz, tbiot(6), satur, dsatur
    real(kind=8) :: permli, dperml, permgz, dperms, dpermp
    real(kind=8) :: fick, dfickt, dfickg, lambp, dlambp
    real(kind=8) :: alpha, lambs, dlambs, viscl, dviscl
    real(kind=8) :: tlambt(ndim, ndim), tdlamt(ndim, ndim), viscg
    real(kind=8) :: dviscg, mamolg, instap
    real(kind=8) :: mamolv, fickad, dfadt, pad, tlamct(ndim, ndim), unsurk
    character(len=16) :: thmc, ther, hydr
!
! --------------------------------------------------------------------------------------------------
!
    retcom=0
!    call thmEvalSatuFinal(hydr , j_mater , p1    ,&
!                          satur, dsatur, retcom)
    if (thmc .eq. 'LIQU_SATU') then
!        unsurk = ds_thm%ds_material%liquid%unsurk
!        alpha  = ds_thm%ds_material%liquid%alpha
!        viscl  = ds_thm%ds_material%liquid%visc
!        dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    else if (thmc.eq.'GAZ') then
!        rgaz   = ds_thm%ds_material%solid%r_gaz
!        viscg  = ds_thm%ds_material%gaz%visc
!        dviscg = ds_thm%ds_material%gaz%dvisc_dtemp
!        mamolg = ds_thm%ds_material%gaz%mass_mol
    else if (thmc.eq.'LIQU_VAPE') then
!        call thmEvalPermLiquGaz(hydr  , j_mater , satur, p2, t,&
!                                permli, dperml,&
!                                permgz, dperms, dpermp)
!        rgaz   = ds_thm%ds_material%solid%r_gaz
!        unsurk = ds_thm%ds_material%liquid%unsurk
!        alpha  = ds_thm%ds_material%liquid%alpha
!        viscl  = ds_thm%ds_material%liquid%visc
!        dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
!        mamolv = ds_thm%ds_material%steam%mass_mol
!        viscg  = ds_thm%ds_material%steam%visc
!        dviscg = ds_thm%ds_material%steam%dvisc_dtemp
    else if (thmc.eq.'LIQU_VAPE_GAZ') then
!        call thmEvalPermLiquGaz(hydr  , j_mater , satur, p2, t,&
!                                permli, dperml,&
!                                permgz, dperms, dpermp)
!        call thmEvalFickSteam(j_mater,&
!                              satur, p2    , pvp   , t,&
!                              fick , dfickt, dfickg)
!        rgaz   = ds_thm%ds_material%solid%r_gaz
!        unsurk = ds_thm%ds_material%liquid%unsurk
!        alpha  = ds_thm%ds_material%liquid%alpha
!        viscl  = ds_thm%ds_material%liquid%visc
!        dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
!        mamolv = ds_thm%ds_material%steam%mass_mol
!        viscg  = ds_thm%ds_material%steam%visc
!        dviscg = ds_thm%ds_material%steam%dvisc_dtemp
!        mamolg = ds_thm%ds_material%gaz%mass_mol
    else if (thmc.eq.'LIQU_AD_GAZ_VAPE') then
!        call thmEvalPermLiquGaz(hydr  , j_mater , satur, p2, t,&
!                                permli, dperml,&
!                                permgz, dperms, dpermp)
!        call thmEvalFickSteam(j_mater,&
!                              satur, p2    , pvp   , t,&
!                              fick , dfickt, dfickg)
!        call thmEvalFickAir(j_mater,&
!                            satur  , pad  , p2-p1, t,&
!                            fickad , dfadt)
!        rgaz   = ds_thm%ds_material%solid%r_gaz
!        unsurk = ds_thm%ds_material%liquid%unsurk
!        alpha  = ds_thm%ds_material%liquid%alpha
!        viscl  = ds_thm%ds_material%liquid%visc
!        dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
!        mamolv = ds_thm%ds_material%steam%mass_mol
!        viscg  = ds_thm%ds_material%steam%visc
!        dviscg = ds_thm%ds_material%steam%dvisc_dtemp
!        mamolg = ds_thm%ds_material%gaz%mass_mol
    else if (thmc.eq.'LIQU_AD_GAZ') then
!        call thmEvalPermLiquGaz(hydr  , j_mater , satur, p2, t,&
!                                permli, dperml,&
!                                permgz, dperms, dpermp)
!        call thmEvalFickSteam(j_mater,&
!                              satur, p2    , pvp   , t,&
!                              fick , dfickt, dfickg)
!        call thmEvalFickAir(j_mater,&
!                            satur  , pad  , p2-p1, t,&
!                            fickad , dfadt)
!        rgaz   = ds_thm%ds_material%solid%r_gaz
!        unsurk = ds_thm%ds_material%liquid%unsurk
!        alpha  = ds_thm%ds_material%liquid%alpha
!        viscl  = ds_thm%ds_material%liquid%visc
!        dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
!        viscg  = ds_thm%ds_material%gaz%visc
!        dviscg = ds_thm%ds_material%gaz%dvisc_dtemp
!        mamolg = ds_thm%ds_material%gaz%mass_mol
    else if (thmc.eq.'LIQU_GAZ') then
!        call thmEvalPermLiquGaz(hydr  , j_mater , satur, p2, t,&
!                                permli, dperml,&
!                                permgz, dperms, dpermp)
!        rgaz   = ds_thm%ds_material%solid%r_gaz
!        unsurk = ds_thm%ds_material%liquid%unsurk
!        alpha  = ds_thm%ds_material%liquid%alpha
!        viscl  = ds_thm%ds_material%liquid%visc
!        dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
!        viscg  = ds_thm%ds_material%gaz%visc
!        dviscg = ds_thm%ds_material%gaz%dvisc_dtemp
!        mamolg = ds_thm%ds_material%gaz%mass_mol
    else if (thmc.eq.'LIQU_GAZ_ATM') then
!        call thmEvalPermLiquGaz(hydr  , j_mater , satur, p2, t,&
!                                permli, dperml)
!        unsurk = ds_thm%ds_material%liquid%unsurk
!        alpha  = ds_thm%ds_material%liquid%alpha
!        viscl  = ds_thm%ds_material%liquid%visc
!        dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    endif
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
    call thmGetPermeabilityTensor(ndim , angl_naut, j_mater, phi, endo,&
                                  tperm)
!
! - Compute gravity
!
    call thmEvalGravity(j_mater, instap, gravity)
!
! - (re)-compute Biot tensor
!
    call tebiot(angl_naut, tbiot)
!
end subroutine
