! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine ssdmu1(dref, crit, prec, geo1, geo2,&
                  iconf)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
character(len=*) :: crit
real(kind=8) :: prec, geo1(3), geo2(3), dref
character(len=8) :: crit2
real(kind=8) :: dist, a1, a2, a3
integer :: iconf
!
! ----------------------------------------------------------------------
!     BUT:
!        - DETERMINER SI DEUX NOEUDS DE COORDONEES GEO1 ET GEO2
!          SONT CONFONDUS GEOMETRIQUEMENT.
!
!     IN:
!        DREF : DISTANCE DE REFERENCE POUR LE CRITERE RELATIF
!      CRIT : CRITERE : 'RELATIF' OU 'ABSOLU'
!      PREC : PRECISION
!      GEO1 : GEOMETRIE DU 1ER NOEUD
!      GEO2 : GEOMETRIE DU 2EM NOEUD
!
!     OUT:
!       ICONF: 0 --> LES 2 NOEUDS SONT CONFONDUS. (1 SINON)
! ----------------------------------------------------------------------
!
    crit2=crit
    a1= geo1(1)-geo2(1)
    a2= geo1(2)-geo2(2)
    a3= geo1(3)-geo2(3)
    dist= sqrt(a1**2+a2**2+a3**2)
!
    iconf=1
    if (crit2(1:6) .eq. 'ABSOLU') then
        if (dist .le. prec) iconf=0
    else if (crit2(1:7).eq.'RELATIF') then
        if (dist .le. prec*dref) iconf=0
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
