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
interface 
    subroutine dhrc_jacob(eps, vint, c, bp1,&
                      cp1, bp2, cp2, as1, bs1,&
                      cs1, as2, bs2, cs2, indi,&
                      neta1, neta2, cstseu, jacob)
        real(kind=8), intent(in) :: eps(8)
        real(kind=8), intent(in) :: vint(*)
        real(kind=8), intent(in) :: c(2, 2, 2)
        real(kind=8), intent(in) :: bp1(6, 2)
        real(kind=8), intent(in) :: cp1(2, 2)
        real(kind=8), intent(in) :: bp2(6, 2)
        real(kind=8), intent(in) :: cp2(2, 2)
        real(kind=8), intent(in) :: as1(6, 6)
        real(kind=8), intent(in) :: bs1(6, 2)
        real(kind=8), intent(in) :: cs1(2, 2)
        real(kind=8), intent(in) :: as2(6, 6)
        real(kind=8), intent(in) :: bs2(6, 2)
        real(kind=8), intent(in) :: cs2(2, 2)
        integer, intent(in) :: indi(6)
        real(kind=8), intent(in) :: neta1(2)
        real(kind=8), intent(in) :: neta2(2)
        real(kind=8), intent(in) :: cstseu(6)
        real(kind=8), intent(out) :: jacob(6, 6)
    end subroutine dhrc_jacob
end interface 
