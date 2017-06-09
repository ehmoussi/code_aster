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
    subroutine mattge(nomte, dtild, sina, cosa, r,&
                      jacp, vf, dfds, rtangi)
        character(len=16) :: nomte
        real(kind=8) :: dtild(5, 5)
        real(kind=8) :: sina
        real(kind=8) :: cosa
        real(kind=8) :: r
        real(kind=8) :: jacp
        real(kind=8) :: vf(*)
        real(kind=8) :: dfds(*)
        real(kind=8) :: rtangi(9, 9)
    end subroutine mattge
end interface
