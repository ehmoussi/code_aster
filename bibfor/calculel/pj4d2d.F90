! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine pj4d2d(tria3, itr, geom1, coorno, nbno, nunos, cooele, xg)
    implicit none
#include "blas/ddot.h"
    real(kind=8), intent(in)  :: geom1(*), coorno(3)
    real(kind=8), intent(out) ::  cooele(*), xg(2)
    integer, intent(in) :: tria3(*), itr, nbno, nunos(*)
!  but :
!    convertir les coordonnées du noeud à projeter ainsi que les noeuds
!    de la maille selectionnée dans un repère du plan de la maille 2d

!  in   tria3(*)   i  : objet '&&pjxxco.tria3'
!  in   itr        i  : numero du tria3 sélectionné
!  in   geom1(*)   r  : coordonnees des noeuds du maillage m1
!  in   coorno     r  : coordonnees du noeud de m2 à projeter
!  in   nbno       i  : nombre de noeuds de la maille de m1
!  in   nunos(*)   i  : numéros des points

!  out  cooele     r  : coordonnees des noeuds de la maille dans son plan
!  out  xg         r  : coordonnées du noeud de m2 dans le plan

! ----------------------------------------------------------------------
    integer :: k, ino, nuno
    real(kind=8) :: a(3), b(3), c(3), ab(3), ac(3), v(3), norm
! DEB ------------------------------------------------------------------

    do k = 1, 3
        a(k)=geom1(3*(tria3(1+4*(itr-1)+1)-1)+k)
        b(k)=geom1(3*(tria3(1+4*(itr-1)+2)-1)+k)
        c(k)=geom1(3*(tria3(1+4*(itr-1)+3)-1)+k)
        ab(k)=b(k)-a(k)
        ac(k)=c(k)-a(k)
    end do

!   calcul du vecteur normal
!   ------------------------
    v(1)=ab(2)*ac(3)-ab(3)*ac(2)
    v(2)=ab(3)*ac(1)-ab(1)*ac(3)
    v(3)=ab(1)*ac(2)-ab(2)*ac(1)
    norm=sqrt(ddot(3,v,1,v,1))
    v(:)=v(:)/norm

!   premier vecteur du plan
    norm=sqrt(ddot(3,ab,1,ab,1))
    ab(:)=ab(:)/norm

!   deuxième vecteur du plan
    ac(1)=v(2)*ab(3)-v(3)*ab(2)
    ac(2)=v(3)*ab(1)-v(1)*ab(3)
    ac(3)=v(1)*ab(2)-v(2)*ab(1)
    
!   changement de repère
    xg(1) = ddot(3,coorno,1,ab,1)
    xg(2) = ddot(3,coorno,1,ac,1)
    
    do ino = 1, nbno
        nuno = nunos(ino)
        cooele(2*(ino-1)+1) = ddot(3,geom1(3*(nuno-1)+1),1,ab,1)
        cooele(2*(ino-1)+2) = ddot(3,geom1(3*(nuno-1)+1),1,ac,1)
    enddo

end subroutine
