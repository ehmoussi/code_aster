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

subroutine dgelas(eb, nub, h, b, a, em, num, ef, nuf, icisai)
!
    implicit   none
!
    integer :: icisai
!
    real(kind=8) :: eb, nub, b, a, h
    real(kind=8) :: em, num, ef, nuf
!
! person_in_charge: sebastien.fayolle at edf.fr
! ----------------------------------------------------------------------
!
! BUT : DETERMINATION DES PARAMETRES ELASTIQUES
!
! IN:
!       EB     : MODULE D YOUNG DU BETON
!       NUB    : COEFF DE POISSON DU BETON
!       H      : EPAISSEUR DE LA PLAQUE
!       B      : SECTIONS DES ACIERS
!       A      :
! OUT:
!       EM     : MODULE D YOUNG EN MEMBRANE
!       EF     : MODULE D YOUNG EN FLEXION
!       EMC    : MODULE D YOUNG EN MEMBRANE POUR LE CISAILLEMENT
!       NUM    : COEFF DE POISSON EN MEMBRANE
!       NUF    : COEFF DE POISSON EN FLEXION
!       NUMC   : COEFF DE POISSON EN MEMBRANE POUR LE CISAILLEMENT
! ----------------------------------------------------------------------
!
! - DETERMINATION DES PARAMETRES ELASTIQUES EN MEMBRANE
    if (icisai .eq. 0) then
! - PAR ESSAI DE TRACTION
        em = b/h + eb*(b+eb*h)/((1.d0-nub**2)*b+eb*h)
        num = nub*eb*h/((1.d0-nub**2)*b+eb*h)
    else
! - PAR ESSAI DE CISAILLEMENT PUR DANS LE PLAN
        em = eb + b*(1.d0-nub)/h
        num = nub + b*(1.d0-nub**2)/eb/h
    endif
!
! - DETERMINATION DES PARAMETRES ELASTIQUES EN FLEXION
    ef = eb*(eb*h+12.d0*a)/(eb*h+12.d0*a*(1.d0-nub**2))+12.d0*a/h
    nuf = nub*eb*h/(eb*h+12.d0*a*(1.d0-nub**2))
!
end subroutine
