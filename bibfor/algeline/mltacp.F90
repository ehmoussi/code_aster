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

subroutine mltacp(n, ncol, adper, matper, matfi,&
                  local)
! person_in_charge: olivier.boiteau at edf.fr
! VERSION COMPLEXE DE MLTAFP
! aslint: disable=W1304
    implicit none
    integer(kind=4) :: local(*)
    integer :: n, ncol, adper(*)
    complex(kind=8) :: matper(*), matfi(*)
!     VARIABLES LOCALES
    integer :: decp1, decp2, decf1, decf2, j, i, ni, decp
    integer :: ip
    decf1 = 1
    decf2 = n
    if (mod(ncol,2) .eq. 0) then
        do 120 i = 1, ncol, 2
            decp1 = adper(local(i))
            matper(decp1) = matper(decp1) + matfi(decf1)
            decp1 = decp1 - local(i)
            decp2 = adper(local(i+1)) - local(i+1)
            ni = n - i
            do 110 j = 1, ni
!             ID1 = DECP1 + LOCAL(J+I)
!             ID2 = DECP2 + LOCAL(J+I)
!             JD1 = DECF1+J
!             JD2 = DECF2 +J
                matper(decp1+local(j+i)) = matper( decp1+local(j+i)) + matfi(decf1+j)
                matper(decp2+local(j+i)) = matper( decp2+local(j+i)) + matfi(decf2+j)
110          continue
            decf1 = decf1 + 2*ni + 1
            decf2 = decf2 + 2*ni - 1
120      end do
    else
        do 140 i = 1, ncol-1, 2
            decp1 = adper(local(i))
            matper(decp1) = matper(decp1) + matfi(decf1)
            decp1 = decp1 - local(i)
            decp2 = adper(local(i+1)) - local(i+1)
            ni = n - i
            do 150 j = 1, ni
!             ID1 = DECP1 + LOCAL(J+I)
!             ID2 = DECP2 + LOCAL(J+I)
!             JD1 = DECF1+J
!             JD2 = DECF2 +J
                matper(decp1+local(j+i)) = matper( decp1+local(j+i)) + matfi(decf1+j)
                matper(decp2+local(j+i)) = matper( decp2+local(j+i)) + matfi(decf2+j)
150          continue
            decf1 = decf1 + 2*ni + 1
            decf2 = decf2 + 2*ni - 1
140      continue
!       TRAVAIL SUR LA COLONNE RESTANTE
        decp = adper(local(ncol)) - local(ncol)
        do 130 i = ncol, n
            ip = decp + local(i)
            matper(ip) = matper(ip) + matfi(decf1+i-ncol)
130      continue
    endif
end subroutine
