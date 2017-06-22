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

subroutine mmdint(neqns, xadj, dhead, dforw, dbakw,&
                  qsize, llist, marker)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
!
!--- SPARSPAK-A (ANSI FORTRAN) RELEASE III --- NAME = MMDINT
!  (C)  UNIVERSITY OF WATERLOO   JANUARY 1984
!***************************************************************
!***************************************************************
!***     MMDINT ..... MULT MINIMUM DEGREE INITIALIZATION     ***
!***************************************************************
!***************************************************************
!
!     PURPOSE - THIS ROUTINE PERFORMS INITIALIZATION FOR THE
!        MULTIPLE ELIMINATION VERSION OF THE MINIMUM DEGREE
!        ALGORITHM.
!
!     INPUT PARAMETERS -
!        NEQNS  - NUMBER OF EQUATIONS.
!        XADJ   - ADJACENCY STRUCTURE.
!
!     OUTPUT PARAMETERS -
!        (DHEAD,DFORW,DBAKW) - DEGREE DOUBLY LINKED STRUCTURE.
!        QSIZE  - SIZE OF SUPERNODE (INITIALIZED TO ONE).
!        LLIST  - LINKED LIST.
!        MARKER - MARKER VECTOR.
!
!***************************************************************
!
    integer :: dbakw(*), dforw(*), dhead(*), llist(*), marker(*), qsize(*)
    integer :: xadj(*)
    integer :: fnode, ndeg, neqns, node
!
!***************************************************************
!
    do 100 node = 1, neqns
        dhead(node) = 0
        qsize(node) = 1
        marker(node) = 0
        llist(node) = 0
100  continue
!        ------------------------------------------
!        INITIALIZE THE DEGREE DOUBLY LINKED LISTS.
!        ------------------------------------------
    do 200 node = 1, neqns
        ndeg = xadj(node+1) - xadj(node) + 1
        fnode = dhead(ndeg)
        dforw(node) = fnode
        dhead(ndeg) = node
        if (fnode .gt. 0) dbakw(fnode) = node
        dbakw(node) = - ndeg
200  continue
    goto 9999
!
9999  continue
end subroutine
