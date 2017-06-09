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

subroutine mltafp(n, ncol, adper, matper, matfi,&
                  local)
! person_in_charge: olivier.boiteau at edf.fr
! ASSEMBLAGE DES MATRICES FRONTALES VERSION SIMPLIFIEE
!  LA VERSION PRECEDENTE ASSEMBLAIT PAR 2 COLONES
! POUR UNE MEILLEURE UTILISATION DES REGISTRES SUR CRAY
! aslint: disable=W1304
    implicit none
    integer(kind=4) :: local(*)
    integer :: n, ncol, adper(*)
    real(kind=8) :: matper(*), matfi(*)
!     VARIABLES LOCALES
    integer :: decp1, decf1, j, i, ni
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    decf1 = 1
    do 120 i = 1, ncol, 1
        decp1 = adper(local(i))
        matper(decp1) = matper(decp1) + matfi(decf1)
        decp1 = decp1 - local(i)
        ni = n - i
        decf1 = decf1 + 1
        do 110 j = 1, ni
            matper(decp1+local(j+i)) = matper(decp1+local(j+i)) + matfi(decf1)
            decf1 = decf1 + 1
110      continue
120  end do
!
end subroutine
