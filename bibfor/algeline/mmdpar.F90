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

subroutine mmdpar(nd, nbsn, nbsn1, supnd, nouv,&
                  parent, prov, invsup)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
    integer :: nd, nbsn, nbsn1, supnd(nbsn1), nouv(nd)
    integer :: parent(nd), prov(nd), invsup(nd)
    integer :: i, j, snjp, snj
!     CALCUL DE PARENT EN FONCTION DES SUPERNOEUDS
!
!     SAUVEGARDE DE PARENT NODAL
    do 110 i = 1, nd
        prov(i) = parent(i)
110  end do
!     CALCUL DE INVSUP
    do 130 i = 1, nbsn
        do 120 j = supnd(i), supnd(i+1) - 1
            invsup(j) = i
120      continue
130  end do
    do 140 i = 1, nd
        parent(i) = 0
140  end do
    do 150 i = 1, nd
        if (prov(i) .ne. 0) then
            snjp = invsup(nouv(prov(i)))
            snj = invsup(nouv(i))
            parent(snj) = snjp
        endif
150  end do
end subroutine
