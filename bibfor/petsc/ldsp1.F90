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

subroutine ldsp1(pc, ierr)
!
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr

use petsc_data_module
use lmp_module, only : lmp_destroy

    implicit none

!----------------------------------------------------------------
!
!  PRECONDITIONNEUR ISSU D'UNE FACTORISATION SIMPLE PRECISION
!
!----------------------------------------------------------------
#include "asterf.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/pcmump.h"
#ifdef _HAVE_PETSC
!----------------------------------------------------------------
!     Variables PETSc
! because of conditional (if _HAVE_PETSC) and external types
     PC, intent(inout)           :: pc
     PetscErrorCode, intent(out) :: ierr
!----------------------------------------------------------------
!     VARIABLES LOCALES
    integer :: jrefa, iret
    aster_logical :: new_facto
    PC :: pc_lmp
!----------------------------------------------------------------
!
    call jemarq()
!
! --  LA MATRICE A ETE TRAITEE PAR PETSC DONC ELLE EST CONSIDEREE
! --  COMME FACTORISEE, SI ON LA LAISSE COMME CA MUMPH VA LA
! --  CONSIDERER COMME TELLE ET NE FERA PAS DE FACTO SP
    call jeveuo(spmat//'.REFA', 'E', jrefa)
    zk24(jrefa-1+8) = ' '
!
! --  APPEL A LA ROUTINE DE FACTO SP POUR LE PRECONDITIONNEMENT
    call pcmump(spmat, spsolv, iret, new_facto )
!
! -- SI LE PRECONDITIONNEUR DE SECOND NIVEAU EST ACTIVE, ON DOIT LE DETRUIRE
!    A CHAQUE RECONSTRUCTION DU LDLT_SP
    if ( new_facto ) then
       call lmp_destroy( pc_lmp, ierr )
       ASSERT( ierr == 0 )
    endif
    ierr = iret
!
    call jedema()
!
#else
!
!      DECLARATION BIDON POUR ASSURER LA COMPILATION
    integer :: pc, ierr
    ierr = -1
    pc = -1
!
#endif
!
end subroutine
