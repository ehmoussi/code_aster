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

subroutine fclose(unit)
! aslint: disable=
    implicit none
#include "asterfort/utmess.h"
    integer :: unit
!
!     FERMETURE DE L'UNITE LOGIQUE fort.UNIT
!     UTILE POUR APPEL DEPUIS PYTHON UNE FOIS LES BASES JEVEUX FERMEES
!     CAR ULOPEN N EST ALORS PLUS UTILISABLE (CONFER E_JDC.py)
!
! IN  : UNIT   : NUMERO D'UNITE LOGIQUE
!     ------------------------------------------------------------------
    integer :: ierr
    character(len=4) :: k4b
!     ------------------------------------------------------------------
!
    close (unit=unit, iostat=ierr)
    if (ierr .gt. 0) then
        write(k4b,'(I3)') unit
        call utmess('F', 'UTILITAI_77', sk=k4b)
    endif
!
end subroutine
