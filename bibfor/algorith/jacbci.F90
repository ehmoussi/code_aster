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

subroutine jacbci(np3, rc, vloc, xloc, kn,&
                  cn, ic, jacobc, jacobk)
    implicit none
! DESCRIPTION : CALCUL DES MATRICES JACOBIENNES LIEES A LA FORCE
! -----------   NON-LINEAIRE DE CHOC F(X,DX)
!
!               CAS DE LA BUTEE CIRCULAIRE
!
!               APPELANT : CALJAC
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
! ARGUMENTS
! ---------
    integer :: np3
    real(kind=8) :: rc(np3, *), vloc(*), xloc(*), kn, cn
    integer :: ic
    real(kind=8) :: jacobc(3, *), jacobk(3, *)
!
! VARIABLES LOCALES
! -----------------
    real(kind=8) :: r, ri, cost, sint, c2, cs, s2
!
! FONCTIONS INTRINSEQUES
! ----------------------
!     INTRINSIC  SQRT
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
!  1. RECUPERATION DE R DANS LE TABLEAU RC
!     ------------------------------------
    r = rc(1,ic)
!
!  2. MATRICE JACOBIENNE DE RAIDEUR
!     -----------------------------
    jacobk(1,1) = 0.0d0
    jacobk(1,2) = 0.0d0
    jacobk(1,3) = 0.0d0
    jacobk(2,1) = 0.0d0
    jacobk(3,1) = 0.0d0
!
    ri = sqrt( xloc(2)*xloc(2) + xloc(3)*xloc(3) )
    cost = -xloc(2) / ri
    sint = -xloc(3) / ri
    c2 = cost * cost
    cs = cost * sint
    s2 = sint * sint
!
!.... SI LE PRODUIT SCALAIRE ENTRE LA NORMALE A L'OBSTACLE ET LA VITESSE
!.... EST POSITIF, ON NE TIENT PAS COMPTE DES TERMES EN CN
!
    if ((cost*vloc(2)+sint*vloc(3)) .ge. 0.0d0) then
!
        jacobk(2,2) = kn*(r/ri*s2-1.0d0)
        jacobk(2,3) = - kn*r/ri*cs
        jacobk(3,2) = - kn*r/ri*cs
        jacobk(3,3) = kn*(r/ri*c2-1.0d0)
!
    else
!
        jacobk(2,2) = kn*(r/ri*s2-1.0d0) + cn/ri*sint * (2.0d0*vloc(2) *cs + vloc(3)*(1.0d0-2.0d0&
                      &*c2))
        jacobk(2,3) = - kn*r/ri*cs - cn/ri*cost * ( 2.0d0*vloc(2)*cs + vloc(3)*(1.0d0-2.0d0*c2))
        jacobk(3,2) = - kn*r/ri*cs + cn/ri*sint * ( vloc(2)*(1.0d0- 2.0d0*c2) - 2.0d0*vloc(3)*cs)
        jacobk(3,3) = kn*(r/ri*c2-1.0d0) - cn/ri*cost * (vloc(2)*( 1.0d0-2.0d0*c2) - 2.0d0*vloc(3&
                      &)*cs)
!
    endif
!
!  3. MATRICE JACOBIENNE D'AMORTISSEMENT
!     ----------------------------------
    jacobc(1,1) = 0.0d0
    jacobc(1,2) = 0.0d0
    jacobc(1,3) = 0.0d0
    jacobc(2,1) = 0.0d0
    jacobc(3,1) = 0.0d0
!
    jacobc(2,2) = - cn * c2
    jacobc(2,3) = - cn * cs
    jacobc(3,2) = - cn * cs
    jacobc(3,3) = - cn * s2
!
! --- FIN DE JACBCI.
end subroutine
