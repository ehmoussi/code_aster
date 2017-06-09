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

subroutine mmdnum(neqns, perm, invp, qsize)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
!
!--- SPARSPAK-A (ANSI FORTRAN) RELEASE III --- NAME = MMDNUM
!  (C)  UNIVERSITY OF WATERLOO   JANUARY 1984
!***************************************************************
!***************************************************************
!*****     MMDNUM ..... MULTI MINIMUM DEGREE NUMBERING     *****
!***************************************************************
!***************************************************************
!
!     PURPOSE - THIS ROUTINE PERFORMS THE FINAL STEP IN
!        PRODUCING THE PERMUTATION AND INVERSE PERMUTATION
!        VECTORS IN THE MULTIPLE ELIMINATION VERSION OF THE
!        MINIMUM DEGREE ORDERING ALGORITHM.
!
!     INPUT PARAMETERS -
!        NEQNS  - NUMBER OF EQUATIONS.
!        QSIZE  - SIZE OF SUPERNODES AT ELIMINATION.
!
!     UPDATED PARAMETERS -
!        INVP   - INVERSE PERMUTATION VECTOR.  ON INPUT,
!                 IF QSIZE(NODE)=0, THEN NODE HAS BEEN MERGED
!                 INTO THE NODE -INVP(NODE), OTHERWISE,
!                 -INVP(NODE) IS ITS INVERSE LABELLING.
!
!     OUTPUT PARAMETERS -
!        PERM   - THE PERMUTATION VECTOR.
!
!***************************************************************
!
    integer :: invp(*), perm(*), qsize(*)
    integer :: father, neqns, nextf, node, nqsize, num, root
!
!***************************************************************
!
    do 100 node = 1, neqns
        nqsize = qsize(node)
        if (nqsize .le. 0) perm(node) = invp(node)
        if (nqsize .gt. 0) perm(node) = - invp(node)
100  continue
!        ------------------------------------------------------
!        FOR EACH NODE WHICH HAS BEEN MERGED, DO THE FOLLOWING.
!        ------------------------------------------------------
    do 500 node = 1, neqns
        if (perm(node) .gt. 0) goto 500
!                -----------------------------------------
!                TRACE THE MERGED TREE UNTIL ONE WHICH HAS
!                NOT BEEN MERGED, CALL IT ROOT.
!                -----------------------------------------
        father = node
200      continue
        if (perm(father) .gt. 0) goto 300
        father = - perm(father)
        goto 200
300      continue
!                -----------------------
!                NUMBER NODE AFTER ROOT.
!                -----------------------
        root = father
        num = perm(root) + 1
        invp(node) = - num
        perm(root) = num
!                ------------------------
!                SHORTEN THE MERGED TREE.
!                ------------------------
        father = node
400      continue
        nextf = - perm(father)
        if (nextf .le. 0) goto 500
        perm(father) = - root
        father = nextf
        goto 400
500  continue
!        ----------------------
!        READY TO COMPUTE PERM.
!        ----------------------
    do 600 node = 1, neqns
        num = - invp(node)
        invp(node) = num
        perm(num) = node
600  continue
    goto 9999
!
9999  continue
end subroutine
