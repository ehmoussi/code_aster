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

function pbflkz(i, z, long, ln, kcalcu)
    implicit none
! COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
! RESOLUTION DU PROBLEME FLUIDE INSTATIONNAIRE : CALCUL DE LA VALEUR EN
! Z DE LA SOLUTION PARTICULIERE CORRESPONDANT A LA IEME LIGNE DE LA
! MATRICE KCALCU(3,4), DANS LE CAS OU UMOY <> 0
! APPELANT : PBFLGA, PBFLSO
!-----------------------------------------------------------------------
!  IN : I      : INDICE DE LIGNE DE LA MATRICE KCALCU
!  IN : Z      : COTE
!  IN : LONG   : LONGUEUR DU DOMAINE DE RECOUVREMENT DES DEUX COQUES
!  IN : LN     : NOMBRE D'ONDES
!  IN : KCALCU : MATRICE RECTANGULAIRE A COEFFICIENTS CONSTANTS
!                PERMETTANT DE CALCULER UNE SOLUTION PARTICULIERE DU
!                PROBLEME FLUIDE INSTATIONNAIRE, LORSQUE UMOY <> 0
!-----------------------------------------------------------------------
!
    complex(kind=8) :: pbflkz
    integer :: i
    real(kind=8) :: z, long, ln
    complex(kind=8) :: kcalcu(3, 4)
!
    complex(kind=8) :: j, ju
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    real(kind=8) :: u
!-----------------------------------------------------------------------
    j = dcmplx(0.d0,1.d0)
    u = z*ln/long
    ju = j*u
    pbflkz = kcalcu(i,1) * dcmplx(exp(ju)) + kcalcu(i,2) * dcmplx(exp(-1.d0*ju)) + kcalcu(i,3) * &
             &dcmplx(exp(u)) + kcalcu(i,4) * dcmplx(exp(-1.d0*u))
!
end function
