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
    subroutine eccook(acook, bcook, ccook, npuis, mpuis,&
                      epsp0, troom, tmelt, tp, dinst,&
                      pm, dp, rp, rprim)
        real(kind=8) :: acook
        real(kind=8) :: bcook
        real(kind=8) :: ccook
        real(kind=8) :: npuis
        real(kind=8) :: mpuis
        real(kind=8) :: epsp0
        real(kind=8) :: troom
        real(kind=8) :: tmelt
        real(kind=8) :: tp
        real(kind=8) :: dinst
        real(kind=8) :: pm
        real(kind=8) :: dp
        real(kind=8) :: rp
        real(kind=8) :: rprim
    end subroutine eccook
end interface
