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

subroutine ulposi(unit, posi, ierr)
! person_in_charge: j-pierre.lefebvre at edf.fr
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
    character(len=*) :: posi
    integer :: unit, ierr
!     ------------------------------------------------------------------
!
!     POSITIONNEMENT DANS UN FICHIER ET VERIFICATION DE L'ETAT
!     APRES OPEN
!
! IN  : UNIT   : NUMERO D'UNITE LOGIQUE
!       POSI   : N = LE FICHIER EST ECRASE (NEW)
!                O = ON NE FAIT RIEN (ASSIS/OLD)
!                A = ON SE PLACE EN FIN DE FICHIER (APPEND)
! OUT : IERR   : CODE RETOUR D'ERREUR (OK  = 0)
!
!     ------------------------------------------------------------------
    character(len=16) :: kacc
    character(len=4) :: k4b
    character(len=1) :: k1
    character(len=24) :: valk(2)
    integer :: ios, iend
    aster_logical :: lop, lnom
!     ------------------------------------------------------------------
!
    ierr = 100
    k1 = posi
    write(k4b,'(I2)') unit
!
    inquire(unit=unit, opened=lop, named=lnom, access=kacc)
    if (lop) then
        if (kacc .ne. 'SEQUENTIAL') then
            ierr=101
            valk(1) = kacc
            valk(2) = k4b
            call utmess('E', 'UTILITAI5_24', nk=2, valk=valk)
        else
            if (.not. lnom) then
                ierr=102
                call utmess('E', 'UTILITAI5_25', sk=k4b)
            endif
        endif
    else
        ierr=103
        call utmess('E', 'UTILITAI5_26', sk=k4b)
    endif
!
    if (posi .eq. 'N') then
        rewind (unit=unit, iostat=ios)
        if (ios .eq. 0) then
            ierr = 0
        else
            ierr = 104
            call utmess('E', 'UTILITAI5_27', sk=k4b)
        endif
    else if (posi .eq. 'O') then
        ierr = 0
    else if (posi .eq. 'A') then
!       POSITIONNEMENT EN FIN DE FICHIER
!
201     continue
        iend=0
        if (iend .le. 0) then
            read (unit,*,end=301)
            goto 201
        endif
301     continue
        ierr = 0
        backspace unit
    else
        ierr = 105
        valk(1) = k1
        valk(2) = k4b
        call utmess('E', 'UTILITAI5_28', nk=2, valk=valk)
    endif
!
end subroutine
