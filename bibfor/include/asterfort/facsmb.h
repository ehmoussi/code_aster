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
    subroutine facsmb(nbnd, nbsn, supnd, invsup, parent,&
                      xadj, adjncy, anc, nouv, fils,&
                      frere, local, global, adress, lfront,&
                      nblign, lgsn, debfac, debfsn, chaine,&
                      place, nbass, delg, lgind, ier)
        integer :: lgind
        integer :: nbsn
        integer :: nbnd
        integer :: supnd(nbsn+1)
        integer :: invsup(nbnd)
        integer :: parent(nbsn)
        integer :: xadj(nbnd+1)
        integer :: adjncy(*)
        integer :: anc(nbnd)
        integer :: nouv(nbnd)
        integer :: fils(nbsn)
        integer :: frere(nbsn)
        integer(kind=4) :: local(lgind)
        integer(kind=4) :: global(lgind)
        integer :: adress(nbsn+1)
        integer :: lfront(nbsn)
        integer :: nblign(nbsn)
        integer :: lgsn(nbsn)
        integer :: debfac(nbnd+1)
        integer :: debfsn(nbsn+1)
        integer :: chaine(nbnd)
        integer :: place(nbnd)
        integer :: nbass(nbsn)
        integer :: delg(nbnd)
        integer :: ier
    end subroutine facsmb
end interface
