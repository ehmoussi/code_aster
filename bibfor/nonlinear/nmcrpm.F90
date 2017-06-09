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

subroutine nmcrpm(list, nbinst, dtmin)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
    real(kind=8) :: list(*), dtmin
    integer :: nbinst
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (UTILITAIRE)
!
! CALCUL DU DELTA TEMPS MINIMUM
!
! ----------------------------------------------------------------------
!
!
! IN  LIST   : LISTE DES INSTANTS
! IN  NBINST : NOMBRE D'INSTANTS DANS LA LISTE
! OUT DTMIN  : INCREMENT DE TEMPS MINIMUM DANS LA LISTE
!
! ----------------------------------------------------------------------
!
    integer :: i
    real(kind=8) :: deltat
!
! ----------------------------------------------------------------------
!
!
!
! --- INITIALISATIONS
!
    dtmin = 0.d0
    if (nbinst .eq. 1) goto 99
!
! --- DELTA MINIMUM
!
    dtmin = list(2)-list(1)
    do 10 i = 2, nbinst-1
        deltat = list(i+1-1) - list(i-1)
        dtmin = min(deltat,dtmin )
10  end do
99  continue
!
end subroutine
