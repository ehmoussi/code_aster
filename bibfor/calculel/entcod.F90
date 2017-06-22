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

function entcod(admodl, lcmodl, nec, mode, k,&
                l)
    implicit none
    integer :: entcod
!     IN:
!     MODE: MODE_LOCAL DE TYPE CHNO,VECT,OU MATR.
!     NEC : NBRE D ENTIERS POUR LA GRANDEUR
!     K : NUMERO DE NOEUD ( LOCAL ) ; L : NUMERO D ENTIER CODE
!     OUT:
!     ENTCOD: KEME ENTIER CODE.
!
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/utmess.h"
    integer :: admodl, lcmodl, mode, m1, m2, code, code1
    character(len=8) :: k8b1, k8b2, k8b3, k8b4
    character(len=24) :: valk(4)
!
!
!
!-----------------------------------------------------------------------
    integer :: iad, iadm, iadm1, k, l, n1, n2
    integer :: nec
!-----------------------------------------------------------------------
    iadm = admodl + zi(lcmodl+mode-1) - 1
    code = zi(iadm)
    if (code .gt. 3) then
        if (code .eq. 4) then
            m1 = zi(iadm+3)
        else if (code.eq.5) then
            m1 = zi(iadm+3)
            m2 = zi(iadm+4)
            if (m1 .ne. m2) then
                call codent(m1, 'D', k8b1)
                call codent(m2, 'D', k8b2)
                valk(1) = k8b1
                valk(2) = k8b2
                call utmess('F', 'CALCULEL2_46', nk=2, valk=valk)
            endif
        endif
        iadm1 = admodl + zi(lcmodl+m1-1) - 1
        code1 = zi(iadm1)
        if (code1 .gt. 3) then
            call codent(mode, 'D', k8b1)
            call codent(code, 'D', k8b2)
            call codent(m1, 'D', k8b3)
            call codent(code1, 'D', k8b4)
            valk(1) = k8b1
            valk(2) = k8b2
            valk(3) = k8b3
            valk(4) = k8b4
            call utmess('F', 'CALCULEL2_47', nk=4, valk=valk)
        endif
    else
        iadm1 = iadm
        m1 = mode
    endif
    n1 = zi(iadm1+3)
!
    if (n1 .gt. 10000) then
        n2 = n1 - 10000
        if (k .gt. n2) then
            call codent(m1, 'D', k8b1)
            call codent(n2, 'D', k8b2)
            call codent(k, 'D', k8b3)
            valk(1) = k8b1
            valk(2) = k8b2
            valk(3) = k8b3
            call utmess('F', 'CALCULEL2_48', nk=3, valk=valk)
        endif
        iad = 4 + nec* (k-1) + l
    else
        iad = 4 + l
    endif
    entcod = zi(iadm1+iad-1)
!
end function
