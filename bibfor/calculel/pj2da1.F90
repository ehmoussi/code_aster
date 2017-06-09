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

subroutine pj2da1(ino2, geom2, i, geom1, tria3,&
                  cobar2, ok)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: cobar2(3), geom1(*), geom2(*)
    integer :: i, tria3(*), ino2
    aster_logical :: ok

!     BUT :
!       DETERMINER SI LE TRIA3 I CONTIENT LE NOEUD INO2
!       SI OUI :
!       DETERMINER LES COORDONNEES BARYCENTRIQUES DE INO2 DANS CE TRIA3

!  IN   INO2       I  : NUMERO DU NOEUD DE M2 CHERCHE
!  IN   GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
!  IN   GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
!  IN   I          I  : NUMERO DU TRIA3 CANDIDAT
!  IN   TRIA3(*)   I  : OBJET '&&PJXXCO.TRIA3'
!  OUT  COBAR2(3)  R  : COORDONNEES BARYCENTRIQUES DE INO2 DANS I
!  OUT  OK         L  : .TRUE. : INO2 APPARTIENT AU TRIA3 I


! ----------------------------------------------------------------------
    real(kind=8) :: x1, y1, x2, y2, x3, y3, xp, yp
    real(kind=8) :: l1, l2, l3, s
    real(kind=8) :: v2(2), v3(2), p(2), epsi
! DEB ------------------------------------------------------------------
    xp=geom2(3*(ino2-1)+1)
    yp=geom2(3*(ino2-1)+2)

    x1=geom1(3*(tria3(1+4*(i-1)+1)-1)+1)
    y1=geom1(3*(tria3(1+4*(i-1)+1)-1)+2)
    x2=geom1(3*(tria3(1+4*(i-1)+2)-1)+1)
    y2=geom1(3*(tria3(1+4*(i-1)+2)-1)+2)
    x3=geom1(3*(tria3(1+4*(i-1)+3)-1)+1)
    y3=geom1(3*(tria3(1+4*(i-1)+3)-1)+2)

    v2(1)=x2-x1
    v2(2)=y2-y1
    v3(1)=x3-x1
    v3(2)=y3-y1
    s=v2(1)*v3(2)-v2(2)*v3(1)
    if (s .eq. 0) then
        ok=.false.
        goto 9999
    endif

    p(1)=xp-x1
    p(2)=yp-y1
    l3=(v2(1)*p(2)-v2(2)*p(1))/s
    l2=(p(1)*v3(2)-p(2)*v3(1))/s
    l1=1.d0-l2-l3

!     -- TOLERANCE EPSI POUR EVITER DES DIFFERENCES ENTRE
!        LES VERSIONS DEBUG ET NODEBUG
    epsi=1.d-10
    if ((l1.ge.-epsi) .and. (l1.le.1.d0+epsi ) .and. (l2.ge.-epsi) .and. (l2.le.1.d0+epsi )&
        .and. (l3.ge.-epsi) .and. (l3.le.1.d0+epsi )) then
        ok=.true.
        cobar2(1)=l1
        cobar2(2)=l2
        cobar2(3)=l3
    else
        ok=.false.
    endif


9999 continue
end subroutine
