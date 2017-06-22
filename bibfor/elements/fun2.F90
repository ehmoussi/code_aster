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

subroutine fun2(xi1, xi2, p, xkk, q,&
                vt, n)
    implicit none
    integer :: n
    real(kind=8) :: xi1, xi2, p, xkk, q, vt
!         CALCULE LE MOMENT D'INERTIE EQUIVALENT D'UNE POUTRE DROITE A
!      SECTION VARIABLE SOUS L'HYPOTHESE DE VARIATION LINEAIRE DES
!      COORDONNEES
!     ------------------------------------------------------------------
!                        LISTE DES ARGUMENTS
!    -------------------------------------------------------------------
!    TYPE  !   NOM  !  TABLEAU  !             SIGNIFICATION
!    -------------------------------------------------------------------
! IN R*8   !  XI1   !     -     ! MOMENT D INERTIE SECTION INITIALE
! IN R*8   !  XI2   !     -     ! MOMENT D INERTIE SECTION FINALE
! IN R*8   !   P    !     -     ! COEFF. DE CISAILLEMENT DEPENDANT DU
! IN       !        !           !  MATERIAU (P = E/(G*AS*L*L) )
! IN  I    !   N    !     -     ! TYPE DE CALCUL  (N =1  3 OU 4)
! IN       !        !           !  DEGRE DU POLYNOME DU DENOMINATEUR
! OUT R*8  !  XKK   !     -     ! L'ELEMENT DIAGONAL A E/L3 PRES
! OUT R*8  !   Q    !     -     !
! OUT R*8  !   VT   !     -     !
!    -------------------------------------------------------------------
    real(kind=8) :: alg, di, phi, a, a2, a3, rho, c
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (xi1 .eq. xi2) then
        q = 0.5d0
        xkk = 12.d0*xi1/(1.d0+p*(12.d0*xi1))
        vt = xi1
    else
        if (n .le. 1) then
            alg = log(xi2/xi1)
            di = xi2-xi1
            phi = p*di
            q = 1.d0/alg - xi1/di
            xkk = di /( (xi2+xi1)/(2.0d0*di)-1.d0/alg+phi)
            vt = di/alg
        else if (n.eq. 2) then
!            ERREUR
        else if (n.eq. 3) then
            a = (xi2/xi1)**(1.d0/3)
            q = 1.d0/(a+1.d0)
            a3 = (a-1.d0)**3
            phi = p*xi1*a3
            rho = log(a)-2.d0*q*(a-1.d0)+phi
            xkk = xi1*a3/rho
            vt = 2.d0*xi1*a*a/(a+1.d0)
        else if (n.ge. 4) then
            a = (xi2/xi1)**0.25d0
            a3 = a*a*a
            a2 = (a-1.d0)**2
            phi = p*xi1*a2
            c = a3-3.d0*a+2.d0
            q = c/(2.d0*(a-1.d0)*(a3-1.d0))
            rho = a2/(3.d0*a3)-c*q/(6.d0*a3)+phi
            xkk = a2*xi1/rho
            vt = 3.d0*xi1*a3/(a*a + a + 1.d0)
        endif
    endif
end subroutine
