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

!
!
#include "asterf_types.h"
!
interface
    subroutine nmvccc(model    , nbin     , nbout    , lpain    , lchin,&
                      lpaout   , lchout   , exis_temp, exis_hydr, exis_ptot,&
                      exis_sech, exis_epsa, calc_meta, base     , vect_elem)
        character(len=8), intent(in) :: model
        integer, intent(in) :: nbout
        integer, intent(in) :: nbin
        character(len=8), intent(in) :: lpain(nbin)
        character(len=19), intent(in) :: lchin(nbin)
        character(len=8), intent(in) :: lpaout(nbout)
        character(len=19), intent(inout) :: lchout(nbout)
        aster_logical, intent(in) :: exis_temp
        aster_logical, intent(in) :: exis_hydr
        aster_logical, intent(in) :: exis_ptot
        aster_logical, intent(in) :: exis_sech
        aster_logical, intent(in) :: exis_epsa
        aster_logical, intent(in) :: calc_meta
        character(len=1), intent(in) :: base
        character(len=19), intent(in) :: vect_elem
    end subroutine nmvccc
end interface
