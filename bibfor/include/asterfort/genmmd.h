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
    subroutine genmmd(neqns, neqp1, nadj, xadj, adjncy,&
                      maxint, delta, invp, perm, nbsn,&
                      supnd, adress, parent, gssubs, fctnzs,&
                      fctops, dhead, qsize, llist, marker)
        integer :: nadj
        integer :: neqp1
        integer :: neqns
        integer :: xadj(neqp1)
        integer :: adjncy(nadj)
        integer :: maxint
        integer :: delta
        integer :: invp(neqns)
        integer :: perm(neqns)
        integer :: nbsn
        integer :: supnd(neqp1)
        integer :: adress(neqp1)
        integer :: parent(neqns)
        integer :: gssubs
        integer :: fctnzs
        real(kind=8) :: fctops
        integer :: dhead(neqns)
        integer :: qsize(neqns)
        integer :: llist(neqns)
        integer :: marker(neqns)
    end subroutine genmmd
end interface
