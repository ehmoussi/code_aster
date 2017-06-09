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

subroutine casurf(ndim, nno, geom, surff)
    implicit none
    integer :: ndim, nno
    real(kind=8) :: geom(ndim, nno), surff
!
! ROUTINE CASURF : CALCUL DE LA SURFACE DE L ELEMENT 2D
! GEOM CONTIENT LES COORDONN2ES DES NOEUDS
!
!
! ----------------------------------------------------------------------
!
    integer :: maxfa1, maxdi1
    parameter    (maxfa1=6,maxdi1=3)
!
    real(kind=8) :: t(maxdi1, maxfa1)
    integer :: ifa, i, ideb, ifin
    real(kind=8) :: vol, pdvd2, pdvd1
!
! ----------------------------------------------------------------------
!
    do 2 ifa = 1, nno
!
        ideb=ifa
        ifin=ifa+1
        if (ifin .gt. nno) then
            ifin=ifin-nno
        endif
        do 2 i = 1, ndim
            t(i,ifa)=geom(i,ifin)-geom(i,ideb)
!
 2      continue
!
    if (nno .eq. 3) then
        vol=abs(t(1,1)*t(2,2)-t(2,1)*t(1,2))/2.d0
    else
        pdvd1 = t(1,1)*t(2,4)-t(2,1)*t(1,4)
        pdvd2 = t(1,3)*t(2,2)-t(2,3)*t(1,2)
        vol = (abs(pdvd1)+abs(pdvd2))/2.d0
    endif
!
    surff=vol
!
end subroutine
