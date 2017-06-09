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

subroutine ulclos()
    implicit   none
! person_in_charge: j-pierre.lefebvre at edf.fr
!     ------------------------------------------------------------------
!     FERMETURE DE TOUS LES FICHIERS OUVERTS REFERENCES PAR ULDEFI
!     SAUF UNITES 6 ET 8 POUR POUVOIR ENCORE LES UTILISER EN PYTHON
!     ELLES SERONT FERMEES PAR APPEL PYTHON A ULOPEN(-6/-8)
!
!     ------------------------------------------------------------------
    integer :: mxf
    parameter       (mxf=100)
    character(len=1) :: typefi(mxf), accefi(mxf), etatfi(mxf), modifi(mxf)
    character(len=16) :: ddname(mxf)
    character(len=255) :: namefi(mxf)
    integer :: first, unitfi(mxf), nbfile
    common/ asgfi1 / first, unitfi      , nbfile
    common/ asgfi2 / namefi,ddname,typefi,accefi,etatfi,modifi
!     ------------------------------------------------------------------
    integer :: i, unit
!
    do 10 i = 1, nbfile
        unit = unitfi(i)
        if ((unit.gt.0) .and. (unit.ne.6) .and. (unit.ne.8)) then
            if (etatfi(i) .eq. 'O') then
                close ( unit=unit )
            endif
            namefi(i) = ' '
            ddname(i) = ' '
            unitfi(i) = -1
            typefi(i) = '?'
            accefi(i) = '?'
            etatfi(i) = 'F'
            modifi(i) = ' '
        endif
10  end do
!
end subroutine
