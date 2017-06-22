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

subroutine get_meta_id(meta_id, nb_phasis)
!
use calcul_module, only : calcul_status
!
implicit none
!
#include "asterfort/rcvarc.h"
!
!
    integer, intent(out) :: meta_id
    integer, intent(out) :: nb_phasis
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Get metallurgy type
!
! --------------------------------------------------------------------------------------------------
!
! Out meta_id      : type of metallurgy
!                       0 - No metallurgy
!                       1 - Steel
!                       2 - Zirconium
! Out nb_phasis    : total number of phasis (cold and hot)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: steel, zirc, fami
    integer :: kpg, ksp
    integer :: iret_steel, iret_zirc
    real(kind=8) :: r8dummy
!
    data steel /'PFERRITE'/
    data zirc  /'ALPHPUR'/
!
! --------------------------------------------------------------------------------------------------
!
    kpg       = 1
    ksp       = 1
    meta_id = 0
    nb_phasis = 0
!
! - Choice of integration scheme: for CALC_POINT_MAT is PMAT !
!
    if (calcul_status() .eq. 2) then
        fami = 'PMAT'
    else
        fami = 'RIGI'
    endif
!
    call rcvarc(' ', steel, '+', fami, kpg,&
                ksp, r8dummy, iret_steel)
    if (iret_steel .eq. 0) then
        meta_id = 1
        nb_phasis = 5
    else
        call rcvarc(' ', zirc, '+', fami, kpg,&
                    ksp, r8dummy, iret_zirc)
        if (iret_zirc .eq. 0) then
            meta_id = 2
            nb_phasis = 3
        endif
    endif

end subroutine
