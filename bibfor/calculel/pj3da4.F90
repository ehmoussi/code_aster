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

subroutine pj3da4(m, a, b, la, lb,&
                  d2)
    implicit none
    real(kind=8) :: m(3), a(3), b(3), d2, la, lb
! BUT :
!   TROUVER LES COORDONNEES BARYCENTRIQUES (LA,LB) DU POINT P
!   LE PLUS PROCHE DE M SUR UN SEGMENT (A,B) .

!  IN   M(3)    R : COORDONNEES DE M
!  IN   A(3)    R : COORDONNEES DE A
!  IN   B(3)    R : COORDONNEES DE B

!  OUT  D2      R  : CARRE DE LA DISTANCE ENTRE M ET P
!  OUT  LA,LB   R  : COORDONNEES BARYCENTRIQUES DE P SUR AB


! ----------------------------------------------------------------------
    integer :: k
    real(kind=8) :: p(3), a1, a2
    real(kind=8) :: ab(3), am(3)
! DEB ------------------------------------------------------------------
    do 1,k=1,3
    ab(k)=b(k)-a(k)
    am(k)=m(k)-a(k)
    1 end do

    a1= am(1)*ab(1)+am(2)*ab(2)+am(3)*ab(3)
    a2= ab(1)*ab(1)+ab(2)*ab(2)+ab(3)*ab(3)

!     -- CAS DU SEGMENT DE LONGUEUR NULLE :
    if (a2 .eq. 0.d0) then
        lb=0.5d0
    else
        lb=a1/a2
    endif


    if (lb .lt. 0.d0) lb=0.d0
    if (lb .gt. 1.d0) lb=1.d0

    la=1.d0-lb
    do 2,k=1,3
    p(k)=la*a(k)+lb*b(k)
    p(k)=m(k)-p(k)
    2 end do
    d2=p(1)*p(1)+p(2)*p(2)+p(3)*p(3)
end subroutine
