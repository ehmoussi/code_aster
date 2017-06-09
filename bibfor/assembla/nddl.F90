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

function nddl(ili, nunoel, nec, idprn1, idprn2)
! aslint: disable=
    implicit none
    integer :: nddl
#include "jeveux.h"
    integer :: ili, nunoel
! IN  ILI    I : NUMERO DU GROUPE DANS LE LIGREL
! IN  NUNOEL I : NUMERO DU NOEUD
! OUT NDDL   I : NOMBRE DE DDLS DE CE NOEUD
!----------------------------------------------------------------------
!     FONCTION D ACCES A PRNO
!----------------------------------------------------------------------
    integer ::  idprn1, idprn2, iec, j, k, nec, lshift
!
!-----------------------------------------------------------------------
#define zzprno(ili,nunoel,l)   zi( idprn1-1+zi(idprn2+ili-1)+ (nunoel-1)* (nec+2)+l-1)
!---- DEBUT
    nddl = 0
    do 100 iec = 1, nec
        do 10 j = 1, 30
            k = iand(zzprno(ili,nunoel,iec+2),lshift(1,j))
            if (k .gt. 0) then
                nddl = nddl + 1
!
            endif
10      continue
100  end do
end function
