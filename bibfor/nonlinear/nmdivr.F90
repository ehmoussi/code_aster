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

subroutine nmdivr(sddisc, sderro, iter_newt)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmcrel.h"
#include "asterfort/nmlere.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: sddisc
    character(len=24), intent(in) :: sderro
    integer, intent(in) :: iter_newt
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Events
!
! Check if RESI_GLOB_MAXI increase
!
! --------------------------------------------------------------------------------------------------
!
! EVALUATION DE LA DIVERGENCE DU RESIDU :
!    ON DIT QU'IL Y A DIVERGENCE DU RESIDU SSI :
!       MIN[ R(I), R(I-1) ] > R(I-2), A PARTIR DE I=3 (COMME ABAQUS)
!
!    OU R(I)   EST LE RESIDU A L'ITERATION COURANTE
!       R(I-1) EST LE RESIDU A L'ITERATION MOINS 1
!       R(I-2) EST LE RESIDU A L'ITERATION MOINS 2
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for discretization
! In  sderro           : datastructure for error management (events)
! In  iter_newt        : index of current Newton iteration
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: r(1), rm1(1), rm2(1)
    aster_logical :: l_resi_dive
!
! --------------------------------------------------------------------------------------------------
!
    l_resi_dive = .false.
!
    if (iter_newt .ge. 3) then
!
! ----- Get RESI_GLOB_MAXI
!
        call nmlere(sddisc, 'L', 'VMAXI', iter_newt, r(1))
        call nmlere(sddisc, 'L', 'VMAXI', iter_newt-1, rm1(1))
        call nmlere(sddisc, 'L', 'VMAXI', iter_newt-2, rm2(1))
!
! ----- Check evolution of RESI_GLOB_MAXI
!
        if (min(r(1),rm1(1)) .gt. rm2(1)) then
            l_resi_dive = .true.
        endif
    endif
!
! - Save event
!
    call nmcrel(sderro, 'DIVE_RESI', l_resi_dive)
!
end subroutine
