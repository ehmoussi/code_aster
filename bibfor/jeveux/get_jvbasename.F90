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

subroutine get_jvbasename(bas_, numext, path)
    implicit none
!
    character(len=*), intent(in) :: bas_
    integer, intent(in) :: numext
    character(len=*), intent(out) :: path
! aslint: disable=W1303
! for the path name
! person_in_charge: j-pierre.lefebvre at edf.fr
!
! Return the path name to the file of the base of class `bas_`
! `bas_` is one of 'globale', 'volatile', 'elembase'
!
! ----------------------------------------------------------------------
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/lxlgut.h"
#include "asterfort/lxmins.h"
#include "asterfort/utmess.h"
!
    character(len=128) :: repglo, repvol
    common /banvje/ repglo, repvol
    integer :: lrepgl, lrepvo
    common /balvje/ lrepgl,lrepvo
!
    integer :: nchar
    character(len=4) :: base
    character(len=8) :: fname
    character(len=512) :: dir, nom512
!
    base = bas_
    call lxmins(base)
    fname = base//'.'

    ASSERT(numext >= -2)
    if (numext > 0) then
        call codent(numext, 'G', fname(6:7))
    elseif (numext == -1) then
        fname(6:7) = '?'
    elseif (numext == -2) then
        fname(6:7) = '*'
    endif

!TODO Use environment variables for glob & vola directories
    dir = '.'
    if (base .eq. 'glob') then
        dir = repglo(1:lrepgl)
    else if (base .eq. 'vola') then
        dir = repvol(1:lrepvo)
    else if (base .eq. 'elem') then
        call get_environment_variable('ASTER_ELEMENTSDIR', dir, nchar)
        if (nchar > 512 - 9) then
            call utmess('F', 'JEVEUX_3', sk='ASTER_ELEMENTSDIR', si=512 - 9)
        elseif (nchar == 0) then
            dir = '.'
            nchar = 1
        endif
    endif
    nom512 = dir(1:lxlgut(dir))//'/'//fname
    ASSERT(len(path) >= lxlgut(nom512))
    path = nom512
end subroutine
