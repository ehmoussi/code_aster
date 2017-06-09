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

subroutine ReadContact(ds_contact,it_maxi)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/getvid.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(inout) :: ds_contact
    integer,   intent(in),  optional   :: it_maxi 
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Contact management
!
! Read parameters for contact management
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nocc
    character(len=8) :: sdcont
    character(len=16) :: keyw
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Read parameters contact management'
    endif
!
! - Initializations
!
    keyw = 'CONTACT'
!
! - Get name of datastructure from DEFI_CONTACT
!
    call getvid(' ', keyw, scal=sdcont, nbret=nocc)
    ds_contact%l_contact = nocc .gt. 0
    if (nocc .ne. 0) then   
        ds_contact%sdcont = sdcont
        if (present(it_maxi)) then
!            ds_contact%iteration_cycl_maxi = it_maxi
            ds_contact%it_cycl_maxi = 6
        endif
    endif
!
end subroutine
