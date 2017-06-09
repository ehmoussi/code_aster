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
    subroutine xdecqu(nnose, it, ndim, cnset, jlsn,&
                      igeom, pinter, ninter, npts, ainter,&
                      pmilie, nmilie, mfis, tx, txlsn,&
                      pintt, pmitt, ifiss, nfiss, fisco,&
                      nfisc, cut, coupe, exit, joncno)
        integer :: ndim
        integer :: nnose
        integer :: it
        integer :: cnset(*)
        integer :: jlsn
        integer :: igeom
        real(kind=8) :: pinter(*)
        integer :: ninter
        integer :: npts
        real(kind=8) :: ainter(*)
        real(kind=8) :: pmilie(*)
        integer :: nmilie
        integer :: mfis
        real(kind=8) :: tx(3, 7)
        real(kind=8) :: txlsn(28)
        real(kind=8) :: pintt(*)
        real(kind=8) :: pmitt(*)
        integer :: ifiss
        integer :: nfiss
        integer :: fisco(*)
        integer :: nfisc
        aster_logical :: cut
        integer :: coupe(nfiss)
        integer :: exit(2)
        integer :: joncno
    end subroutine xdecqu
end interface
