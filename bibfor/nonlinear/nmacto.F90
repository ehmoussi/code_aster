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

subroutine nmacto(sddisc, i_echec_acti)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/dieven.h"
#include "asterfort/utdidt.h"
    character(len=19), intent(in) :: sddisc
    integer, intent(out) :: i_echec_acti
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! RECHERCHE DES EVENEMENTS ACTIVES
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization
! Out i_echec_acti     : Index of echec
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_echec, i_echec
    aster_logical :: lacti
!
! ----------------------------------------------------------------------
!
    call utdidt('L', sddisc, 'LIST', 'NECHEC',&
                vali_ = nb_echec)
    lacti = .false.
!
! --- BOUCLE SUR LES EVENT-DRIVEN
! --- DES QU'UN EVENT-DRIVEN EST SATISFAIT, ON SORT
! --- ON NE CHERCHE PAS A VERIFIER LES AUTRES EVENEMENTS
! --- ATTENTION, L'ORDRE D'EVALUATION A DONC UNE IMPORTANCE !
!
    i_echec_acti = 0
    do i_echec = 1, nb_echec
        call dieven(sddisc, i_echec, lacti)
        if (lacti) then
            i_echec_acti = i_echec
            goto 99
        endif
    end do
!
99  continue
!
end subroutine
