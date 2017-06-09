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
    subroutine xalg42(ndim, elrefp, it, nnose, cnset, typma, ndime,&
                      geom, lsnelp, pmilie, ninter, ainter, ar, npts, nptm, &
                      pmmax, nmilie, mfis, lonref, pinref, pintt, pmitt, jonc, exit)
        integer :: ndim
        integer :: it
        integer :: nnose
        integer :: cnset(*)
        integer :: ndime
        real(kind=8) :: geom(81)
        integer :: ninter
        integer ::  ar(12, 3)
        integer :: npts
        integer :: nptm
        integer :: nbar
        integer :: pmmax
        integer :: nmilie
        integer :: mfis
        character(len=8) :: typma
        character(len=8) :: elrefp
        real(kind=8) :: lonref
        real(kind=8) :: ainter(*)
        real(kind=8) :: pmilie(*)
        real(kind=8) :: pinref(*)  
        real(kind=8) :: lsnelp(*)
        real(kind=8) :: pintt(*)
        real(kind=8) :: pmitt(*)
        aster_logical :: jonc
        integer :: exit(2)
    end subroutine xalg42
end interface 
