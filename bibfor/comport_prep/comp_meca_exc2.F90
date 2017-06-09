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

subroutine comp_meca_exc2(l_cristal, l_prot_comp, l_pmf, &
                          l_excl   , vari_excl)
!
implicit none
!
#include "asterf_types.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    aster_logical, intent(in) :: l_cristal
    aster_logical, intent(in) :: l_prot_comp
    aster_logical, intent(in) :: l_pmf
    aster_logical, intent(out) :: l_excl
    character(len=16), intent(out) :: vari_excl
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Exception for name of internal variables
!
! --------------------------------------------------------------------------------------------------
!
! In  l_cristal        : .true. if *CRISTAL comportment
! In  l_prot_comp      : .true. if external computing for comportment (MFront, UMAT)
! In  l_pmf            : .true. if PMF
! Out l_excl           : .true. if exception case (no names for internal variables)
! Out vari_excl        : name of internal variables if l_excl
!
! --------------------------------------------------------------------------------------------------
!
    l_excl    = .false.
    vari_excl = ' '
!
! - Multiple comportment (PMF)
!
    if (l_pmf) then
        l_excl    = .true.
        vari_excl = '&&MULT_COMP'
    endif
!
! - Multiple comportment
!
    if (l_cristal) then
        l_excl    = .true.
        vari_excl = '&&MULT_COMP'
    endif
!
! - External comportment
!
    if (l_prot_comp) then
        l_excl    = .true.
        vari_excl = '&&PROT_COMP'
    endif
!
end subroutine
