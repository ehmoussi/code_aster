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
    subroutine xdecqv(nnose, it, cnset, heavt, lsn, igeom,&
                      ninter, npts, ndim, ainter, nse, cnse,&
                      heav, nsemax, pinter, pmilie, pintt, pmitt, cut,&
                      ncomp, nfisc, nfiss, ifiss, elp, fisco,&
                      lonref, txlsn, tx)
        integer :: nnose
        integer :: it
        integer :: cnset(*)
        real(kind=8) :: lsn(*)
        integer :: igeom
        integer :: ninter
        integer :: npts
        integer :: ndim
        real(kind=8) :: ainter(*)
        real(kind=8) :: pinter(*)
        real(kind=8) :: pmilie(*)
        real(kind=8) :: pintt(*)
        real(kind=8) :: pmitt(*)
        integer :: nse
        integer :: cnse(6, 10)
        real(kind=8) :: heav(*)
        integer :: nsemax
        aster_logical :: cut
        integer :: heavt(*)
        integer :: ncomp
        integer :: nfisc
        integer :: nfiss
        integer :: ifiss
        integer :: fisco(*)
        character(len=8) :: elp
        real(kind=8) :: lonref
        real(kind=8) :: txlsn(28)
        real(kind=8) :: tx(3, 7)
    end subroutine xdecqv
end interface
