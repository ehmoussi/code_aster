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

subroutine prmadj(nbnd, neq, n2, adjncy, xadj,&
                  xadjd, liste, q, noeud)
! person_in_charge: olivier.boiteau at edf.fr
    implicit none
#include "asterf_types.h"
#include "asterfort/prmade.h"
#include "asterfort/prmadl.h"
    integer :: nbnd, neq, n2
    integer :: adjncy(*), xadj(neq+1), xadjd(*), liste(neq), q(n2)
    integer :: noeud(*), nbnoeu, ndi, ndj, deb, fin, deblis, i, j, ndsuiv
    aster_logical :: vider
    vider = .false.
    nbnoeu = 0
    deblis=0
    do 50 i = 1, nbnd
        xadjd(i)=1
 50 continue
    do 100 i = 1, n2
        ndi = noeud(q(i))
        deb = xadj(i)
        fin = xadj(i+1)-1
        do 120 j = deb, fin
            ndj = noeud(q(adjncy(j)))
            if (ndi .ne. ndj) then
!     ON MET  NDJ DANS  LA LISTE
                call prmadl(ndj, deblis, liste)
            endif
120     continue
!     ON ECRIT LA LISTE DANS ADJNCY,XADJD ET ON LA REMET A ZERO
        if (i .eq. n2) then
            vider = .true.
        else
            ndsuiv = noeud(q(i+1))
            if (ndsuiv .ne. ndi) then
                nbnoeu = nbnoeu + 1
                vider = .true.
            endif
        endif
        if (vider) then
            call prmade(deblis, liste, adjncy, xadjd, ndi)
            vider = .false.
        endif
100 continue
end subroutine
