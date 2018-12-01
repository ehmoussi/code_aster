! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmdorc(model, chmate, l_etat_init, compor, carcri, mult_comp_, l_implex_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmdocc.h"
#include "asterfort/nmdocm.h"
#include "asterfort/nmdocr.h"
#include "asterfort/utmess.h"
#include "asterfort/infniv.h"
!
character(len=*), intent(in) :: model
character(len=*), intent(in) :: chmate
aster_logical, intent(in) :: l_etat_init
character(len=*), intent(in) :: compor
character(len=*), intent(out) :: carcri
character(len=*), optional, intent(in) :: mult_comp_
aster_logical, optional, intent(in) :: l_implex_
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Read objects for constitutive laws
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  chmate           : name of material field
! In  l_etat_init      : .true. if initial state is defined
! In  compor           : name of <CARTE> COMPOR
! Out carcri           : name of <CARTE> CARCRI
! In  mult_comp        : name of <CARTE> MULT_COMP
! In  l_implex         : .true. if IMPLEX method
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_implex
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE12_2')
    endif
!
! - Initialisations
!
    l_implex    = ASTER_FALSE
    if (present(l_implex_)) then
        l_implex = l_implex_
    endif
!
! - Get parameters from COMPORTEMENT keyword and prepare COMPOR <CARTE>
!
    call nmdocc(model, chmate, l_etat_init, l_implex, compor)
!
! - Get parameters from COMPORTEMENT keyword and prepare CARCRI <CARTE>
!
    call nmdocr(model, carcri, l_implex)
!
! - Get parameters from COMPORTEMENT keyword and prepare MULT_COMP <CARTE> (for crystals)
!
    if (present(mult_comp_)) then
        call nmdocm(model, mult_comp_)
    endif
!
end subroutine
