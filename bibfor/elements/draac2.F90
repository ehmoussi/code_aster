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

subroutine draac2(a, b, c, x1, x2,&
                  kode)
!
    implicit none
!
!     EVALUE LES RACINES DU POLYNOME DU SECOND DEGRE Y=A X**2 + B X + C
!
! IN  A : COEFFICIENT DU POLYNOME
! IN  B : COEFFICIENT DU POLYNOME
! IN  C : COEFFICIENT DU POLYNOME
!
! OUT X1 : RACINE DU POLYNOME
! OUT X2 : RACINE DU POLYNOME
! OUT KODE : NOMBRE DE RACINES
!          = 0 : PAS DE RACINE REELLE
!          = 1 : UNE RACINE REELLE
!          = 2 : DEUX RACINES REELLES
!
    integer :: kode
!
    real(kind=8) :: a, b, c, x1, x2
    real(kind=8) :: delta, epsi, x0, deuza, asup
!
    x1 = 0.0d0
    x2 = 0.0d0
    kode = 0
    delta = 0.0d0
    epsi = 1.0d-8 * max(abs(a),abs(b),abs(c))
    x0 = 0.0d0
    deuza = 0.0d0
    asup = 0.0d0
!
    if (abs(a) .gt. epsi) then
        x1 = b * b
        x2 = 4.0d0 * a * c
        delta = x1 - x2
        asup = 1.0d-8 * max(x1,abs(x2))
        deuza = 2.0d0 * a
        x0 = -b / deuza
!
        if (delta .lt. -asup) then
!     CAS OU ON A DEUX RACINES IMAGINAIRES
            kode = 0
            x1 = 0.0d0
            x2 = 0.0d0
        else if (delta.lt.asup) then
!     CAS OU ON A UNE RACINE REELE DOUBLE
            kode = 1
            x1 = x0
            x2 = x0
        else
!     CAS OU ON A DEUX RACINES
            kode = 2
            x2 = sqrt(delta)/abs(deuza)
            x1 = x0 - x2
            x2 = x0 + x2
        endif
    else if (abs(b).le.epsi) then
!     CAS OU LE POLYNOME DU SECOND DEGRE
!     S APPARENTE A UNE CONSTANTE
        kode = 0
        x1 = 0.0d0
        x2 = 0.0d0
    else
!     CAS OU LE POLYNOME DU SECOND DEGRE
!     S APPARENTE A UN POLYNOME DU PREMIER DEGRE
        kode = 1
        x1 = - c / b
        x2 = x1
    endif
!
end subroutine
