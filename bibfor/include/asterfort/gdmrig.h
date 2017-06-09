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
    subroutine gdmrig(kp, nno, ajacob, pjacob, en,&
                      enprim, x0pg, rot0, rotk, granc,&
                      pn, pm, rigi)
        integer :: kp
        integer :: nno
        real(kind=8) :: ajacob
        real(kind=8) :: pjacob
        real(kind=8) :: en(3, 2)
        real(kind=8) :: enprim(3, 2)
        real(kind=8) :: x0pg(3)
        real(kind=8) :: rot0(3, 3)
        real(kind=8) :: rotk(3, 3)
        real(kind=8) :: granc(6)
        real(kind=8) :: pn(3)
        real(kind=8) :: pm(3)
        real(kind=8) :: rigi(18, 18)
    end subroutine gdmrig
end interface
