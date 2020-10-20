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

subroutine ap_on_off(action, option)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
! aslint: disable=C1308
!
use aster_petsc_module
use petsc_data_module
use elg_module
!
    implicit none
!
#include "jeveux.h"
#include "asterc/aster_petsc_initialize.h"
#include "asterc/aster_petsc_finalize.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
!
    character(len=*), intent(in) :: action
    character(len=*), intent(in) :: option
!-----------------------------------------------------------------------
! BUT : ROUTINE POUR INITIALISER OU STOPPER PETSC AVEC OPTIONS
!
! IN  : ACTION
!     /'ON'  : DEMARRER
!     /'OFF' : STOPPER
!     : OPTIONS
!-----------------------------------------------------------------------
!
#ifdef _HAVE_PETSC
!
!     VARIABLES LOCALES
    integer :: iprem, k, ier2, jerr
    integer :: np
    real(kind=8) :: r8
!
!----------------------------------------------------------------
!
!     Variables PETSc
    PetscErrorCode :: ierr
    PetscScalar :: sbid
    PetscOffset :: offbid
    PetscReal :: rbid
    PetscBool :: done

!----------------------------------------------------------------
!
!   0. FERMETURE DE PETSC DANS FIN
!   ------------------------------
    if (action .eq. 'OFF') then
!       petsc a-t-il ete initialise ?
        call PetscInitialized(done, ierr)
        ASSERT(ierr.eq.0)
        if (done) then
            call aster_petsc_finalize()
!           on ne verifie pas le code retour car on peut
!           se retrouver dans fin suite a une erreur dans l'initialisation
            iprem = 0
        endif
    endif
!
!
    if (action .eq. 'ON') then
!     --------------------
!        -- quelques verifications sur la coherence Aster / Petsc :
        ASSERT(kind(rbid).eq.kind(r8))
        ASSERT(kind(sbid).eq.kind(r8))
        ASSERT(kind(offbid).eq.kind(np))
!
        ier2 = 0
        call aster_petsc_initialize(option, ier2)
        ierr = to_petsc_int(ier2)
        if (ierr .ne. 0) call utmess('F', 'PETSC_1')
        ASSERT(ierr .eq. 0)
        do k = 1, nmxins
            ap(k) = PETSC_NULL_MAT
            kp(k) = PETSC_NULL_KSP
            nomats(k) = ' '
            nosols(k) = ' '
            nonus(k) = ' '
            tblocs(k) = -1
        enddo
!
        xlocal = PETSC_NULL_VEC
        xglobal = PETSC_NULL_VEC
        xscatt = PETSC_NULL_VECSCATTER
        spsomu = ' '
        spmat = ' '
        spsolv = ' '
        iprem = 1
    endif

999 continue
#else
    call utmess('F', 'FERMETUR_10')
#endif
end subroutine
