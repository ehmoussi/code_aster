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

function sgmxve(nbterm, vect)
    implicit none
    real(kind=8) :: sgmxve
    integer :: nbterm
    real(kind=8) :: vect(*)
!
!              SIGNE DE LA VALEUR ABSOLUE MAXIMALE
!
!  IN
!     NBTERM   :  NOMBRE DE VALEURS
!     VECT     :  TABLEAU
!  OUT
!     SGMXVE   : 1.0D0 OU -1.0D0
!
! --- ------------------------------------------------------------------
!
    integer :: ii
    real(kind=8) :: vmax
! --- ------------------------------------------------------------------
!
    vmax = vect(1)
    do 10 ii = 2, nbterm
        if (abs(vect(ii)) .ge. abs(vmax)) vmax = vect(ii)
10  end do
    if (vmax .ge. 0.0d0) then
        sgmxve = 1.0d0
    else
        sgmxve = -1.0d0
    endif
end function
