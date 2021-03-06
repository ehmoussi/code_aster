! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine fin999(isave)
    implicit none
! person_in_charge: mathieu.courtois at edf.fr
!-----------------------------------------------------------------------
!
!     MENAGE DANS :
!        * LES BIBLIOTHEQUES
!        * LES ALARMES/ERREURS
!        * LES COMMUNICATEURS MPI
!
!-----------------------------------------------------------------------
#include "asterf.h"
#include "asterc/chkmsg.h"
#include "asterc/dllcls.h"
#include "asterc/lcdiscard.h"
#include "asterfort/apetsc.h"
#include "asterfort/asmpi_checkalarm.h"
    integer, intent(in) :: isave

    integer :: ichk
#ifdef _HAVE_PETSC
    integer :: iret
#endif
!-----------------------------------------------------------------------
!
! --- FERMETURE DE PETSC
!
#ifdef _HAVE_PETSC
    call apetsc('FIN', ' ', ' ', [0.d0], ' ',&
                0, 0, iret)
#endif

! --- LIBERATION DE TOUS LES COMPOSANTS CHARGES DYNAMIQUEMENT
    call dllcls()

    if ( isave .eq. 1 ) then
        ! --- VERIFICATION DES ALARMES EN PARALLELE
        call asmpi_checkalarm()

        ! --- TEST ERREUR E SANS ERREUR F
        call chkmsg(1, ichk)
    endif

!   call lcdiscard(" ")

end subroutine
