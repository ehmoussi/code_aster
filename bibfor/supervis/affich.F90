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

subroutine affich(nomfic, texte)
!
    implicit none
#include "asterf_types.h"
#include "asterc/isjvup.h"
#include "asterfort/iunifi.h"
#include "asterfort/uldefi.h"
    character(len=*) :: texte
    character(len=*) :: nomfic
    integer :: ifm, ier
    aster_logical :: ouvert
!     ----------------------------------------------------------------
    ouvert = .true.
    ifm = iunifi (nomfic)
!
! --- SI JEVEUX N'EST PAS DISPONIBLE (PAS INITIALISE OU FERME)
!     ON SE CONTENTE DU WRITE BRUT
!
    if (isjvup() .eq. 0) then
!
        write(ifm,'(A)') texte
!
    else
!        LE FICHIER EST-IL OUVERT ?
        inquire ( unit=ifm, opened=ouvert, iostat=ier)
        if (ier .eq. 0 .and. .not.ouvert) then
            call uldefi(ifm, ' ', ' ', 'A', 'A',&
                        'O')
        endif
!
        write(ifm,'(A)') texte
!
        if (.not. ouvert) then
            call uldefi(-ifm, ' ', ' ', 'A', 'A',&
                        'O')
        endif
    endif
!
end subroutine
