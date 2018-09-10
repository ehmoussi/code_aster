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
subroutine metaGetParaAnneal(poum     , fami    , kpg, ksp, j_mater,&
                             meta_type, nb_phase,&
                             theta)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/Metallurgy_type.h"
!
character(len=1), intent(in) :: poum
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp, j_mater
integer, intent(in) :: meta_type, nb_phase
real(kind=8), intent(out) :: theta(*)
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Get parameters for annealing
!
! --------------------------------------------------------------------------------------------------
!
! In  poum         : '-' or '+' for parameters evaluation (previous or current)
! In  fami         : Gauss family for integration point rule
! In  kpg          : current point gauss
! In  ksp          : current "sous-point" gauss
! In  j_mater      : coded material address
! In  meta_type    : type of metallurgy
! In  nb_phase     : total number of phase (cold and hot)
! Out theta        : parameters for annealing
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_resu_max = 8
    real(kind=8) :: resu_vale(nb_resu_max)
    integer :: codret(nb_resu_max)
    character(len=16) :: resu_name(nb_resu_max)
    integer :: nb_resu, i_resu
!
! --------------------------------------------------------------------------------------------------
!
    nb_resu = 2*(nb_phase-1)
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        resu_name(1)   = 'C_F1_THETA'
        resu_name(2)   = 'C_F2_THETA'
        resu_name(3)   = 'C_F3_THETA'
        resu_name(4)   = 'C_F4_THETA'
        resu_name(5)   = 'F1_C_THETA'
        resu_name(6)   = 'F2_C_THETA'
        resu_name(7)   = 'F3_C_THETA'
        resu_name(8)   = 'F4_C_THETA'
        theta(1:nb_resu) = 0.d0
    elseif (meta_type .eq. META_ZIRC) then
        resu_name(1)   = 'C_F1_THETA'
        resu_name(2)   = 'C_F2_THETA'
        resu_name(3)   = 'F1_C_THETA'
        resu_name(4)   = 'F2_C_THETA'
        theta(1:nb_resu) = 0.d0
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Get parameters
!
    call rcvalb(fami, kpg, ksp, poum, j_mater,&
                ' ', 'META_RE', 0, ' ', [0.d0],&
                nb_resu, resu_name, resu_vale, codret, 2)
    do i_resu = 1, nb_resu
        theta(i_resu)    = resu_vale(i_resu)
    end do
!
end subroutine
