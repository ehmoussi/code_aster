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

subroutine resrot(rota, coor, ff, rho, nno,&
                  npg, frx, fry)
    implicit none
!
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DE LA FORCE 2D DUE A UN TERME DE
!                          ROTATION
!                          POUR L'OPTION : 'ERME_ELEM'
!                             (ESTIMATEUR EN RESIDU)
!
!    - ARGUMENTS:
!        DONNEES:
!                  ROTA      -->  TABLEAU OME , AR , BR , CR
!                  COOR      -->  COORDONNEES DES NOEUDS
!                  FF        -->  FONCTIONS DE FORME AUX POINTS DE GAUSS
!                  RHO       -->  DENSITE
!                  NNO       -->  NOMBRE DE NOEUDS
!                  NPG       -->  NOMBRE DE POINTS DE GAUSS
!
!        SORTIE :  FRX       -->  FORCE AU POINT DE GAUSS EN X
!                  FRY       -->  FORCE AU POINT DE GAUSS EN Y
! ......................................................................
!
    real(kind=8) :: rota(3), coor(18), ff(81)
    real(kind=8) :: fx(9), fy(9), frx(9), fry(9)
    real(kind=8) :: omo, omm, om1, om2
    integer :: npg, nno, i, k, kp
!
!-----------------------------------------------------------------------
    real(kind=8) :: rho
!-----------------------------------------------------------------------
    omm = rota(1) ** 2
    om1 = rota(1) * rota(2)
    om2 = rota(1) * rota(3)
    do 100 i = 1, nno
        omo = om1 * coor(2*i-1) + om2 * coor(2*i)
        fx(i) = omm * coor(2*i-1) - omo * om1
        fy(i) = omm * coor(2*i) - omo * om2
100  end do
!
    do 200 kp = 1, npg
        k=(kp-1)*nno
        frx(kp) = 0.d0
        fry(kp) = 0.d0
        do 150 i = 1, nno
            frx(kp) = frx(kp) + fx(i) * ff(k+i)
            fry(kp) = fry(kp) + fy(i) * ff(k+i)
150      continue
        frx(kp) = rho * frx(kp)
        fry(kp) = rho * fry(kp)
200  end do
end subroutine
