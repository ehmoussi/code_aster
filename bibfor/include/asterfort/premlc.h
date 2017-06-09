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
    subroutine premlc(n1, diag, col, parent, parend,&
                      anc, nouv, supnd, supnd2, nouvsn,&
                      ancsn, p, q, lbd1, lbd2,&
                      rl, rl1, rl2, nrl, invp,&
                      perm, lgind, ddlmoy, nbsnd)
        integer :: n1
        integer :: diag(0:*)
        integer :: col(*)
        integer :: parent(*)
        integer :: parend(*)
        integer :: anc(n1)
        integer :: nouv(n1)
        integer :: supnd(n1)
        integer :: supnd2(n1)
        integer :: nouvsn(0:n1)
        integer :: ancsn(*)
        integer :: p(*)
        integer :: q(*)
        integer :: lbd1(n1)
        integer :: lbd2(n1)
        integer :: rl(4, *)
        integer :: rl1(*)
        integer :: rl2(*)
        integer :: nrl
        integer :: invp(n1)
        integer :: perm(n1)
        integer :: lgind
        integer :: ddlmoy
        integer :: nbsnd
    end subroutine premlc
end interface
