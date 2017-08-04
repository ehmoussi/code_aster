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
implicit none
!
#include "asterfort/thmrcp.h"
#include "asterfort/tebiot.h"
#include "asterfort/thmGetPermeabilityTensor.h"
#include "asterfort/thmEvalGravity.h"
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
    real(kind=8) :: rbid1, rbid2, rbid3, rbid4, rbid5, rbid6
    real(kind=8) :: rbid7, rbid8, rbid9
    real(kind=8) :: rbid11, rbid12, rbid13, rbid14, rbid15, rbid16
    real(kind=8) :: rbid17, rbid18, rbid19, rbid20, rbid21, rbid22
    real(kind=8) :: rbid23, rbid24, rbid25, rbid26, rbid27, rbid28
    real(kind=8) :: rbid29, rbid30, rbid31, rbid32
    real(kind=8) :: rbid35, rbid36, rbid37, rbid38, rbid39, rbid40
    real(kind=8) :: rbid41, rbid42, rbid43, rbid44, rbid45, rbid46
    real(kind=8) :: rbid47, rbid48, rbid49, rbid50
!
! --------------------------------------------------------------------------------------------------
!
    rbid1=0.d0
    rbid2=0.d0
    rbid3=0.d0
    rbid4=0.d0
    rbid5=0.d0
    rbid6=0.d0
    rbid7=0.d0
    rbid8=0.d0
    rbid9=0.d0
    rbid11=0.d0
    rbid12=0.d0
    rbid13=0.d0
    rbid14=0.d0
    rbid15=0.d0
    rbid16=0.d0
    rbid17=0.d0
    rbid18=0.d0
    rbid19=0.d0
    rbid20=0.d0
    rbid21=0.d0
    rbid22=0.d0
    rbid23=0.d0
    rbid24=0.d0
    rbid25=0.d0
    rbid26=0.d0
    rbid27=0.d0
    rbid28=0.d0
    rbid29=0.d0
    rbid30=0.d0
    rbid31=0.d0
    rbid32=0.d0
    rbid35=0.d0
    rbid36=0.d0
    rbid37=0.d0
    rbid38=0.d0
    rbid39=0.d0
    rbid40=0.d0
    rbid41=0.d0
    rbid42=0.d0
    rbid43=0.d0
    rbid44=0.d0
    rbid45=0.d0
    rbid46=0.d0
    rbid47=0.d0
    rbid48=0.d0
    rbid49=0.d0
    rbid50=0.d0
    retcom=0
    if (thmc .eq. 'LIQU_SATU') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, rbid6, rbid41, rbid7,&
                    phi, rbid11, rbid12, rbid13,&
                    rbid14, rbid16, rbid17, rbid18,&
                    gravity, rbid19, rbid20, rbid21,&
                    rbid22, rbid23, rbid24, rbid25, rbid26,&
                    lambp, dlambp, rbid27, unsurk, alpha,&
                    rbid28, lambs, dlambs, viscl, dviscl,&
                    rbid31, rbid32, tlambt, tdlamt, rbid35,&
                    rbid36, rbid37, rbid38, rbid39, rbid40,&
                    rbid45, rbid46, rbid47, rbid48, rbid49,&
                    rbid50, tlamct, instap, retcom,&
                    angl_naut, ndim)
    else if (thmc.eq.'GAZ') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, rbid6, rbid44, rbid7,&
                    phi, rbid11, rgaz, rbid13,&
                    rbid14, rbid16, rbid17, rbid18,&
                    gravity, rbid19, rbid20, rbid21,&
                    rbid22, rbid23, rbid24, rbid25, rbid26,&
                    lambp, dlambp, rbid27, rbid42, rbid43,&
                    rbid29, lambs, dlambs, rbid41, rbid31,&
                    mamolg, rbid28, tlambt, tdlamt, viscg,&
                    dviscg, rbid37, rbid38, rbid39, rbid40,&
                    rbid45, rbid46, rbid47, rbid48, rbid49,&
                    rbid50, tlamct,  instap, retcom,&
                    angl_naut, ndim)
    else if (thmc.eq.'LIQU_VAPE') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, p1, rbid6, p2,&
                    phi, pvp, rgaz, rbid8,&
                    rbid9, rbid11, satur, dsatur,&
                    gravity, permli, dperml, permgz,&
                    dperms, dpermp, rbid14, rbid15, rbid16,&
                    lambp, dlambp, rbid17, unsurk, alpha,&
                    rbid18, lambs, dlambs, viscl, dviscl,&
                    rbid19, rbid20, tlambt, tdlamt, rbid23,&
                    rbid24, mamolv, rbid25, viscg, dviscg,&
                    rbid45, rbid46, rbid47, rbid48, rbid49,&
                    rbid50, tlamct, instap, retcom,&
                    angl_naut, ndim)
    else if (thmc.eq.'LIQU_VAPE_GAZ') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, p1, rbid6, p2,&
                    phi, pvp, rgaz, rbid8,&
                    rbid9, rbid11, satur, dsatur,&
                    gravity, permli, dperml, permgz,&
                    dperms, dpermp, fick, dfickt, dfickg,&
                    lambp, dlambp, rbid17, unsurk, alpha,&
                    rbid18, lambs, dlambs, viscl, dviscl,&
                    mamolg, rbid19, tlambt, tdlamt, viscg,&
                    dviscg, mamolv, rbid25, rbid26, rbid27,&
                    rbid45, rbid46, rbid47, rbid48, rbid49,&
                    rbid50, tlamct,  instap, retcom,&
                    angl_naut, ndim)
    else if (thmc.eq.'LIQU_AD_GAZ_VAPE') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, p1, rbid6, p2,&
                    phi, rbid28, rgaz, rbid8,&
                    rbid9, rbid11, satur, dsatur,&
                    gravity, permli, dperml, permgz,&
                    dperms, dpermp, fick, dfickt, dfickg,&
                    lambp, dlambp, rbid17, unsurk, alpha,&
                    rbid18, lambs, dlambs, viscl, dviscl,&
                    mamolg, rbid19, tlambt, tdlamt, viscg,&
                    dviscg, mamolv, rbid25, rbid26, rbid27,&
                    fickad, dfadt, rbid47, rbid48, pad,&
                    rbid50, tlamct,  instap, retcom,&
                    angl_naut, ndim)
!
    else if (thmc.eq.'LIQU_AD_GAZ') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, p1, rbid6, p2,&
                    phi, rbid28, rgaz, rbid8,&
                    rbid9, rbid11, satur, dsatur,&
                    gravity, permli, dperml, permgz,&
                    dperms, dpermp, rbid50, rbid50, rbid50,&
                    lambp, dlambp, rbid17, unsurk, alpha,&
                    rbid18, lambs, dlambs, viscl, dviscl,&
                    mamolg, rbid19, tlambt, tdlamt, viscg,&
                    dviscg, rbid50, rbid25, rbid26, rbid27,&
                    fickad, dfadt, rbid47, rbid48, pad,&
                    rbid50, tlamct,  instap, retcom,&
                    angl_naut, ndim)
    else if (thmc.eq.'LIQU_GAZ') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, p1, rbid6, p2,&
                    phi, rbid28, rgaz, rbid8,&
                    rbid9, rbid11, satur, dsatur,&
                    gravity, permli, dperml, permgz,&
                    dperms, dpermp, rbid14, rbid15, rbid16,&
                    lambp, dlambp, rbid17, unsurk, alpha,&
                    rbid18, lambs, dlambs, viscl, dviscl,&
                    mamolg, rbid19, tlambt, tdlamt, viscg,&
                    dviscg, mamolv, rbid25, rbid26, rbid27,&
                    rbid45, rbid46, rbid47, rbid48, rbid49,&
                    rbid50, tlamct,  instap, retcom,&
                    angl_naut, ndim)
    else if (thmc.eq.'LIQU_GAZ_ATM') then
        call thmrcp('FINALE  ', j_mater, thmc, hydr,&
                    ther, t, p1, rbid6, p2,&
                    phi, rbid28, rbid29, rbid8,&
                    rbid9, rbid11, satur, dsatur,&
                    gravity, permli, dperml, rbid30,&
                    rbid31, rbid32, rbid14, rbid15, rbid16,&
                    lambp, dlambp, rbid17, unsurk, alpha,&
                    rbid18, lambs, dlambs, viscl, dviscl,&
                    rbid20, rbid19, tlambt, tdlamt, rbid23,&
                    rbid24, mamolv, rbid25, rbid26, rbid27,&
                    rbid45, rbid46, rbid47, rbid48, rbid49,&
                    rbid50, tlamct, instap, retcom,&
                    angl_naut, ndim)
    endif

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

! =====================================================================
end subroutine
