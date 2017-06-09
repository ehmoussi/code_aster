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

subroutine cfpost(mesh, disp_iter, ds_contact, ctccvg)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfjefi.h"
#include "asterfort/copisd.h"
#include "asterfort/infdbg.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=19), intent(in) :: disp_iter
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: ctccvg
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Discrete methods - Post-treatment of contact solving
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  disp_iter        : displacement iteration
! In  ds_contact       : datastructure for contact management
! In  ctccvg           : output code for contact algorithm
!                        -1 - No solving
!                         0 - OK
!                        +1 - Maximum contact iteration
!                        +2 - Singular contact matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: sdcont_delc
    aster_logical :: l_pena_cont, l_gcp
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> ...... POST-TRAITEMENT DU CALCUL'
    endif
!
! - Get contact parameters
!
    l_pena_cont = cfdisl(ds_contact%sdcont_defi,'CONT_PENA')
    l_gcp       = cfdisl(ds_contact%sdcont_defi,'CONT_GCP' )
!
! - Error management
!
    if (ctccvg .ne. 0) then
        if (.not.l_gcp) then
            if (niv .ge. 2) then
                write (ifm,*) '<CONTACT> ...... SORTIE DIRECTE CAR ERREUR'
            endif
            goto 999
        endif
    endif
!
! - Copy contact solution
!
    sdcont_delc = ds_contact%sdcont_solv(1:14)//'.DELC'
    if ((.not.l_pena_cont) .and. (ctccvg.eq.0)) then
        call copisd('CHAMP_GD', 'V', sdcont_delc, disp_iter)
    endif
!
! - Compute final gaps
!
    call cfjefi(mesh, disp_iter, ds_contact)
!
999 continue
!
end subroutine
