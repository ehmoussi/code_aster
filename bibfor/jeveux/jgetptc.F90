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

subroutine jgetptc(jad, pteur_c, vl, vi, vi4,&
                   vr, vc, vk8, vk16, vk24,&
                   vk32, vk80)
! person_in_charge: jacques.pellet at edf.fr
!
!-----------------------------------------------------------------------
!     But : masquer la non presence de "target" sur zi, zr, ...
!-----------------------------------------------------------------------
    use iso_c_binding, only: c_loc, c_ptr
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    integer :: jad
    type(c_ptr) :: pteur_c
!
    aster_logical , optional, target :: vl(*)
    integer, optional, target :: vi(*)
    integer(kind=4), optional, target :: vi4(*)
    real(kind=8), optional, target :: vr(*)
    complex(kind=8), optional, target :: vc(*)
    character(len=8), optional, target :: vk8(*)
    character(len=16), optional, target :: vk16(*)
    character(len=24), optional, target :: vk24(*)
    character(len=32), optional, target :: vk32(*)
    character(len=80), optional, target :: vk80(*)
!
!
!---------------------------------------------------------------------------
!
!
    if (present(vl)) then
        pteur_c=c_loc(vl(jad))
    else if (present(vi)) then
        pteur_c=c_loc(vi(jad))
    else if (present(vi4)) then
        pteur_c=c_loc(vi4(jad))
    else if (present(vr)) then
        pteur_c=c_loc(vr(jad))
    else if (present(vc)) then
        pteur_c=c_loc(vc(jad))
    else if (present(vk8)) then
        pteur_c=c_loc(vk8(jad))
    else if (present(vk16)) then
        pteur_c=c_loc(vk16(jad))
    else if (present(vk24)) then
        pteur_c=c_loc(vk24(jad))
    else if (present(vk32)) then
        pteur_c=c_loc(vk32(jad))
    else if (present(vk80)) then
        pteur_c=c_loc(vk80(jad))
!
    else
        ASSERT(.false.)
    endif
!
end
