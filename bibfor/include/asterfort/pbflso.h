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
    subroutine pbflso(umoy, rmoy, long, icoq, imod,&
                      nbm, rkip, tcoef, harm, lambda,&
                      kcalcu, passag, condit, gamma, d,&
                      ysol)
        integer :: nbm
        real(kind=8) :: umoy
        real(kind=8) :: rmoy
        real(kind=8) :: long
        integer :: icoq
        integer :: imod
        real(kind=8) :: rkip
        real(kind=8) :: tcoef(10, nbm)
        real(kind=8) :: harm(6)
        complex(kind=8) :: lambda(3)
        complex(kind=8) :: kcalcu(3, 4)
        complex(kind=8) :: passag(3, 3)
        real(kind=8) :: condit(3)
        complex(kind=8) :: gamma(3)
        real(kind=8) :: d(6)
        complex(kind=8) :: ysol(3, 101)
    end subroutine pbflso
end interface
