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
#include "asterf_types.h"
!
interface
    subroutine xtedd2(ndim, jnne, ndeple, jnnm, nddl,&
                      option, lesclx, lmaitx, lcontx, stano,&
                      lact, jddle, jddlm, nfhe, nfhm,&
                      lmulti, heavno, mmat, vtmp)
        integer, intent(in) :: ndim
        integer, intent(in) :: jnne(3)
        integer, intent(in) :: ndeple
        integer, intent(in) :: jnnm(3)
        integer, intent(in) :: nddl
        character(len=16), intent(in) :: option
        aster_logical, intent(in) :: lesclx
        aster_logical, intent(in) :: lmaitx
        aster_logical, intent(in) :: lcontx
        integer, intent(in) :: stano(*)
        integer, intent(in) :: lact(8)
        integer, intent(in) :: jddle(2)
        integer, intent(in) :: jddlm(2)
        integer, intent(in) :: nfhe
        integer, intent(in) :: nfhm
        aster_logical, intent(in) :: lmulti
        integer, intent(in) :: heavno(8)
        real(kind=8), optional, intent(out) :: mmat(336, 336)
        real(kind=8), optional, intent(out) :: vtmp(336)
    end subroutine xtedd2
end interface
