! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
subroutine metaGetParaPlasTransf(poum     , fami     , kpg       , ksp       , j_mater,&
                                 meta_type, nb_phasis, phase_incr, phase_cold,&
                                 kpt      , fpt)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterfort/Metallurgy_type.h"
!
character(len=1), intent(in) :: poum
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp
integer, intent(in) :: j_mater
integer, intent(in) :: meta_type
integer, intent(in) :: nb_phasis
real(kind=8), intent(in) :: phase_incr(*), phase_cold
real(kind=8), intent(out) :: kpt(*), fpt(*)
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Get plasticity of transformation
!
! --------------------------------------------------------------------------------------------------
!
! In  poum         : '-' or '+' for parameters evaluation (previous or current)
! In  fami         : Gauss family for integration point rule
! In  kpg          : current point gauss
! In  ksp          : current "sous-point" gauss
! In  j_mater      : coded material address
! In  meta_type    : type of metallurgy
! In  nb_phasis    : total number of phasis (cold and hot)
! In  phase_incr   : increment of phasis
! In  phase_cold   : sum of "cold" phasis
! Out kpt          : transformation plasticity - constant k
! Out fpt          : transformation plasticity - function f'
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_resu_max = 5
    real(kind=8) :: resu_vale(nb_resu_max)
    integer :: codret(nb_resu_max)
    character(len=16) :: resu_name(nb_resu_max)
    integer :: nb_resu, i_resu
!
! --------------------------------------------------------------------------------------------------
!
    nb_resu = nb_phasis - 1
!
! - Coefficient K
!
    if (meta_type .eq. META_STEEL) then
        resu_name(1) = 'F1_K'
        resu_name(2) = 'F2_K'
        resu_name(3) = 'F3_K'
        resu_name(4) = 'F4_K'
    elseif (meta_type .eq. META_ZIRC) then
        resu_name(1) = 'F1_K'
        resu_name(2) = 'F2_K'
    else
        ASSERT(ASTER_FALSE)
    endif
    call rcvalb(fami, kpg, ksp, poum, j_mater,&
                ' ', 'META_PT', 0, ' ', [0.d0],&
                nb_resu, resu_name, resu_vale, codret, 2)
    do i_resu = 1, nb_resu
        kpt(i_resu) = resu_vale(i_resu)
    end do
!
! - Function F'
!
    if (meta_type .eq. META_STEEL) then
        resu_name(1) = 'F1_D_F_META'
        resu_name(2) = 'F2_D_F_META'
        resu_name(3) = 'F3_D_F_META'
        resu_name(4) = 'F4_D_F_META'
    elseif (meta_type .eq. META_ZIRC) then
        resu_name(1) = 'F1_D_F_META'
        resu_name(2) = 'F2_D_F_META'
    else
        ASSERT(ASTER_FALSE)
    endif
    do i_resu = 1, nb_resu
        if (phase_incr(i_resu) .gt. 0.d0) then
            call rcvalb(fami, kpg, ksp, poum, j_mater,&
                        ' ', 'META_PT', 1, 'META', [phase_cold],&
                        1, resu_name(i_resu), resu_vale(i_resu), codret, 2)
            fpt(i_resu) = resu_vale(i_resu)
        else
            fpt(i_resu) = 0.d0
        endif
    end do
!
end subroutine
