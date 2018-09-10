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
subroutine metaGetParaHardLine(poum     , fami     , kpg, ksp, j_mater,&
                               meta_type, nb_phasis,&
                               young    , coef     , h)
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
real(kind=8), intent(in) :: young
real(kind=8), intent(in) :: coef
real(kind=8), intent(out) :: h(*)
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Get hardening slope (linear)
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
! In  young        : Young modulusure
! In  coef         : coefficient before hardening slope
! Out h            : current hardening slope
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
    nb_resu = nb_phasis
!
    if (meta_type .eq. META_STEEL) then
        resu_name(1) = 'F1_D_SIGM_EPSI'
        resu_name(2) = 'F2_D_SIGM_EPSI'
        resu_name(3) = 'F3_D_SIGM_EPSI'
        resu_name(4) = 'F4_D_SIGM_EPSI'
        resu_name(5) = 'C_D_SIGM_EPSI'
    elseif (meta_type .eq. META_ZIRC) then
        resu_name(1) = 'F1_D_SIGM_EPSI'
        resu_name(2) = 'F2_D_SIGM_EPSI'
        resu_name(3) = 'C_D_SIGM_EPSI'
    else
        ASSERT(ASTER_FALSE)
    endif
!
    call rcvalb(fami, kpg, ksp, poum, j_mater,&
                ' ', 'META_ECRO_LINE', 0, ' ', [0.d0],&
                nb_resu, resu_name, resu_vale, codret, 2)
    do i_resu = 1, nb_resu
        h(i_resu) = resu_vale(i_resu)
        h(i_resu) = coef*h(i_resu)*young/(young-h(i_resu))
    end do
!
end subroutine
