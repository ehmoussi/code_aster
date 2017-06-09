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

subroutine pj6da2(ino2, geom2, i, geom1, seg2,&
                  cobary, d2, long)
    implicit none
#include "asterc/r8maem.h"
#include "asterfort/pj3da4.h"
    real(kind=8) :: cobary(2), geom1(*), geom2(*), d2, long
    integer :: ino2, i, seg2(*)
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
!  but :
!    determiner la distance d entre le noeud ino2 et le seg2 i.
!    determiner les coordonnees barycentriques
!    du point de i le plus proche de ino2.

!  in   ino2       i  : numero du noeud de m2 cherche
!  in   geom2(*)   r  : coordonnees des noeuds du maillage m2
!  in   geom1(*)   r  : coordonnees des noeuds du maillage m1
!  in   i          i  : numero du seg2 candidat
!  in   seg2(*)    i  : objet '&&pjxxco.seg2'
!  out  cobary(2)  r  : coordonnees barycentriques de ino2 projete sur i
!  out  d2         r  : carre de la distance entre i et ino2
!  out  long       r  : longueur du seg2 i

! ----------------------------------------------------------------------
    integer :: k
    real(kind=8) :: dp, l1, l2, la, lb
    real(kind=8) :: a(3), b(3), m(3), ab(3)
! DEB ------------------------------------------------------------------

    do k=1,3
        m(k)=geom2(3*(ino2-1)+k)
        a(k)=geom1(3*(seg2(1+3*(i-1)+1)-1)+k)
        b(k)=geom1(3*(seg2(1+3*(i-1)+2)-1)+k)
        ab(k)=b(k)-a(k)
    end do

    d2=r8maem()
    dp=r8maem()


!   1. on cherche le point le plus proche de ab :
!   -------------------------------------------------------------
    call pj3da4(m, a, b, l1, l2,&
                dp)
    if (dp .lt. d2) then
        d2=dp
        la=l1
        lb=l2
    endif


!   2. on calcule long :
!   --------------------
    long=sqrt(ab(1)**2+ab(2)**2+ab(3)**2)

    cobary(1)=la
    cobary(2)=lb

end subroutine
