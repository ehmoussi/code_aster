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

subroutine splin2(x, d2y, n, ptx, d2yptx,&
                  iret)
    implicit none
! DESCRIPTION : INTERPOLATION SPLINE CUBIQUE
! -----------
!               ETANT DONNEE LA TABULATION DE LA FONCTION Y(I) = F(X(I))
!               EN N POINTS DE DISCRETISATION X(I)
!               ETANT DONNEE LA TABULATION DE LA DERIVEE SECONDE DE LA
!               FONCTION INTERPOLEE D2Y(I), CALCULEE EN AMONT PAR LA
!               ROUTINE SPLINE
!               ETANT DONNE UN POINT PTX
!               CETTE ROUTINE CALCULE LA VALEUR D2YPTX DE
!               L'INTERPOLATION SPLINE CUBIQUE DE LA DERIVEE
!               SECONDE DE LA FONCTION AU POINT PTX
!
! IN     : X      : REAL*8 , VECTEUR DE DIMENSION N
!                   CONTIENT LES POINTS DE DISCRETISATION X(I)
! IN     : D2Y    : REAL*8 , VECTEUR DE DIMENSION N
!                   CONTIENT LES VALEURS DE LA DERIVEE SECONDE DE LA
!                   FONCTION INTERPOLEE AUX POINTS X(I)
! IN     : N      : INTEGER , SCALAIRE
!                   NOMBRE DE POINTS DE DISCRETISATION
! IN     : PTX    : REAL*8 , SCALAIRE
!                   VALEUR DU POINT OU L'ON SOUHAITE CALCULER LA DERIVEE
!                   SECONDE DE LA FONCTION INTERPOLEE
! OUT    : D2YPTX : REAL*8 , SCALAIRE
!                   VALEUR DE LA DERIVEE SECONDE DE LA FONCTION
!                   INTERPOLEE AU POINT PTX
! OUT    : IRET   : INTEGER , SCALAIRE , CODE RETOUR
!                   IRET = 0  OK
!                   IRET = 1  DEUX POINTS CONSECUTIFS DE LA
!                             DISCRETISATION X(I) SONT EGAUX
!
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
! ARGUMENTS
! ---------
!
    real(kind=8) :: x(*), d2y(*), ptx, d2yptx
    integer :: n, iret
!
! VARIABLES LOCALES
! -----------------
    integer :: k, kinf, ksup
    real(kind=8) :: a, b, h
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
    iret = 0
!
    kinf = 1
    ksup = n
10  continue
    if (ksup-kinf .gt. 1) then
        k = (ksup+kinf)/2
        if (x(k) .gt. ptx) then
            ksup = k
        else
            kinf = k
        endif
        goto 10
    endif
!
    h = x(ksup)-x(kinf)
    if (h .eq. 0.0d0) then
        iret = 1
        goto 9999
    endif
    a = (x(ksup)-ptx)/h
    b = (ptx-x(kinf))/h
    d2yptx = a * d2y(kinf) + b * d2y(ksup)
!
9999  continue
!
! --- FIN DE SPLIN2.
end subroutine
