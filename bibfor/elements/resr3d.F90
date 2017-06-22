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

subroutine resr3d(rota, coor, ff, rho, nno,&
                  npg, frx, fry, frz)
    implicit none
!
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DE LA FORCE 3D DUE A UN TERME DE
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
!                  FRZ       -->  FORCE AU POINT DE GAUSS EN Z
! ......................................................................
!
    real(kind=8) :: rota(*), coor(1), ff(1)
    real(kind=8) :: fx(27), fy(27), fz(27)
    real(kind=8) :: frx(27), fry(27), frz(27)
    real(kind=8) :: omo, omm, om1, om2, om3
    integer :: npg, nno, i, k, kp
!
!-----------------------------------------------------------------------
    real(kind=8) :: rho
!-----------------------------------------------------------------------
    omm = rota(1) * rota(1)
    om1 = rota(1) * rota(2)
    om2 = rota(1) * rota(3)
    om3 = rota(1) * rota(4)
    do 100 i = 1, nno
        omo = om1 * coor(3*i-2) + om2 * coor(3*i-1)+ om3 * coor(3*i)
        fx(i) = omm * coor(3*i-2) - omo * om1
        fy(i) = omm * coor(3*i-1) - omo * om2
        fz(i) = omm * coor(3*i) - omo * om3
100  end do
!
    do 200 kp = 1, npg
        k=(kp-1)*nno
        frx(kp) = 0.d0
        fry(kp) = 0.d0
        frz(kp) = 0.d0
        do 150 i = 1, nno
            frx(kp) = frx(kp) + fx(i) * ff(k+i)
            fry(kp) = fry(kp) + fy(i) * ff(k+i)
            frz(kp) = frz(kp) + fz(i) * ff(k+i)
150      continue
        frx(kp) = rho * frx(kp)
        fry(kp) = rho * fry(kp)
        frz(kp) = rho * frz(kp)
200  end do
end subroutine
