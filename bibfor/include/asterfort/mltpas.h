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
    subroutine mltpas(nbnd, nbsn, supnd, xadj, adjncy,&
                      anc, nouv, seq, global, adress,&
                      nblign, lgsn, nbloc, ncbloc, lgbloc,&
                      diag, col, lmat, place)
        integer :: nbsn
        integer :: nbnd
        integer :: supnd(nbsn+1)
        integer :: xadj(nbnd+1)
        integer :: adjncy(*)
        integer :: anc(nbnd)
        integer :: nouv(nbnd)
        integer :: seq(nbsn)
        integer(kind=4) :: global(*)
        integer :: adress(nbsn+1)
        integer :: nblign(nbsn)
        integer :: lgsn(nbsn)
        integer :: nbloc
        integer :: ncbloc(*)
        integer :: lgbloc(*)
        integer :: diag(0:nbnd)
        integer :: col(*)
        integer :: lmat
        integer :: place(nbnd)
    end subroutine mltpas
end interface
