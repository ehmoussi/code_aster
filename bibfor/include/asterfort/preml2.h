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
    subroutine preml2(n1, diag, col, delg, xadj1,&
                      adjnc1, estim, adress, parend, fils,&
                      frere, anc, nouv, supnd, dhead,&
                      qsize, llist, marker, invsup, local,&
                      global, lfront, nblign, decal, lgsn,&
                      debfac, debfsn, seq, lmat, adpile,&
                      chaine, suiv, place, nbass, ncbloc,&
                      lgbloc, nbloc, lgind, nbsnd, ier)
        integer :: n1
        integer :: diag(0:n1)
        integer :: col(*)
        integer :: delg(*)
        integer :: xadj1(n1+1)
        integer :: adjnc1(*)
        integer :: estim
        integer :: adress(*)
        integer :: parend(*)
        integer :: fils(n1)
        integer :: frere(n1)
        integer :: anc(n1)
        integer :: nouv(n1)
        integer :: supnd(n1)
        integer :: dhead(*)
        integer :: qsize(*)
        integer :: llist(*)
        integer :: marker(*)
        integer :: invsup(n1)
        integer(kind=4) :: local(*)
        integer(kind=4) :: global(*)
        integer :: lfront(n1)
        integer :: nblign(n1)
        integer :: decal(*)
        integer :: lgsn(n1)
        integer :: debfac(n1+1)
        integer :: debfsn(n1)
        integer :: seq(n1)
        integer :: lmat
        integer :: adpile(n1)
        integer :: chaine(n1)
        integer :: suiv(n1)
        integer :: place(n1)
        integer :: nbass(n1)
        integer :: ncbloc(*)
        integer :: lgbloc(*)
        integer :: nbloc
        integer :: lgind
        integer :: nbsnd
        integer :: ier
    end subroutine preml2
end interface
