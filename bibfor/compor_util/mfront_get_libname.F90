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

subroutine mfront_get_libname(libname)
    implicit none
    character(len=*), intent(out) :: libname
!
! Retourne le chemin vers la bibliothèque MFront officielle
!       out  libname: chemin
!
! for define
! aslint: disable=C1510
#include "asterf_config.h"
#include "asterfort/utmess.h"
#include "asterfort/lxlgut.h"
!
! aslint: disable=W1303
! for the path name
! person_in_charge: mathieu.courtois@edf.fr
!
    character(len=512) :: dir, nom512
    integer :: nchar
!
    libname = ' '
    call get_environment_variable('ASTER_LIBDIR', dir, nchar)
    if (nchar > len(libname) - 21) then
        call utmess('F', 'RUNTIME_2', sk='ASTER_LIBDIR', si=len(libname) - 21)
    else if (nchar == 0) then
        call utmess('F', 'RUNTIME_1', sk='ASTER_LIBDIR')
    endif
    libname = dir(1:lxlgut(dir))//'/lib'//ASTERBEHAVIOUR//'.so'
!
end
