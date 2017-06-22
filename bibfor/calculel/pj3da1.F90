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

subroutine pj3da1(ino2, geom2, i, geom1, tetr4,&
                  cobar2, ok)
    implicit none
#include "asterf_types.h"
    real(kind=8) :: cobar2(4), geom1(*), geom2(*), epsi
    integer :: i, tetr4(*), ino2
    aster_logical :: ok
!     BUT :
!       DETERMINER SI LE TETR4 I CONTIENT LE NOEUD INO2
!       SI OUI :
!       DETERMINER LES COORDONNEES BARYCENTRIQUES DE INO2 DANS CE TETR4

!  IN   INO2       I  : NUMERO DU NOEUD DE M2 CHERCHE
!  IN   GEOM2(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M2
!  IN   GEOM1(*)   R  : COORDONNEES DES NOEUDS DU MAILLAGE M1
!  IN   I          I  : NUMERO DU TETR4 CANDIDAT
!  IN   TETR4(*)   I  : OBJET '&&PJXXCO.TETR4'
!  OUT  COBAR2(4)  R  : COORDONNEES BARYCENTRIQUES DE INO2 DANS I
!  OUT  OK         L  : .TRUE. : INO2 APPARTIENT AU TETR4 I


! ----------------------------------------------------------------------
    integer :: perm(4), lino(4), k, p
    real(kind=8) :: p1(3), p2(3), p3(3), p4(3), pp(3), n(3), v12(3), v13(3)
    real(kind=8) :: v14(3)
    real(kind=8) :: vol, volp, v1p(3)
    data perm/2,3,4,1/
! DEB ------------------------------------------------------------------
    pp(1)=geom2(3*(ino2-1)+1)
    pp(2)=geom2(3*(ino2-1)+2)
    pp(3)=geom2(3*(ino2-1)+3)

    lino(1)=4
    lino(2)=1
    lino(3)=2
    lino(4)=3

    do 10 p = 1, 4
!       -- ON PERMUTE LES 4 NOEUDS DU TETRAEDRE :
        do 11 k = 1, 4
            lino(k)=perm(lino(k))
 11     continue

        do 1 k = 1, 3
            p1(k)= geom1(3*(tetr4(1+6*(i-1)+lino(1))-1)+k)
            p2(k)= geom1(3*(tetr4(1+6*(i-1)+lino(2))-1)+k)
            p3(k)= geom1(3*(tetr4(1+6*(i-1)+lino(3))-1)+k)
            p4(k)= geom1(3*(tetr4(1+6*(i-1)+lino(4))-1)+k)
  1     continue

        do 2 k = 1, 3
            v12(k)= p2(k)-p1(k)
            v13(k)= p3(k)-p1(k)
            v14(k)= p4(k)-p1(k)
            v1p(k)= pp(k)-p1(k)
  2     continue

        n(1)= v12(2)*v13(3)-v12(3)*v13(2)
        n(2)= v12(3)*v13(1)-v12(1)*v13(3)
        n(3)= v12(1)*v13(2)-v12(2)*v13(1)

        vol =n(1)*v14(1)+n(2)*v14(2)+n(3)*v14(3)
        if (vol .eq. 0.d0) then
            ok=.false.
            goto 9999
        endif
        volp=n(1)*v1p(1)+n(2)*v1p(2)+n(3)*v1p(3)
        cobar2(lino(4))=volp/vol
 10 end do


    ok =.true.

!     -- TOLERANCE EPSI POUR EVITER DES DIFFERENCES ENTRE
!        LES VERSIONS DEBUG ET NODEBUG
    epsi=1.d-10
    do 30 k = 1, 4
        if ((cobar2(k).lt.-epsi) .or. (cobar2(k).gt.1.d0+epsi)) ok= .false.
 30 end do

9999 continue
end subroutine
