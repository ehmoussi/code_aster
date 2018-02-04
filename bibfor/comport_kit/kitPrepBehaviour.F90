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

subroutine kitPrepBehaviour(compor, compor_creep, compor_plas)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: compor(*)
character(len=16), intent(out) :: compor_creep(*)
character(len=16), intent(out) :: compor_plas(*)
!
! --------------------------------------------------------------------------------------------------
!
! KIT_DDI
!
! Prepare fields for behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  compor          : behaviour
! Out compor_creep    : behaviour for creep
! Out compor_plas     : behaviour for plasticity
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nume_plas, nume_flua
    integer :: nvi_tot, nvi_flua, nvi_plas
!
! --------------------------------------------------------------------------------------------------
!
    read (compor(NVAR),'(I16)') nvi_tot
    read (compor(CREEP_NVAR),'(I16)') nvi_flua
    read (compor(PLAS_NVAR),'(I16)') nvi_plas
    read (compor(PLAS_NUME),'(I16)') nume_plas
    read (compor(CREEP_NUME),'(I16)') nume_flua
!
! - Check number of internal variables
!
    ASSERT(nvi_tot .eq. (nvi_flua + nvi_plas))
!
! - Prepare COMPOR <CARTE> for creeping
!
    compor_creep(RELA_NAME) = compor(CREEP_NAME)
    write (compor_creep(NVAR),'(I16)') nvi_flua
    compor_creep(DEFO) = compor(DEFO)
    write (compor_creep(NUME),'(I16)') nume_flua
!
! - Prepare COMPOR <CARTE> for plasticity
!
    compor_plas(RELA_NAME) = compor(PLAS_NAME)
    write (compor_plas(NVAR),'(I16)') nvi_plas
    compor_plas(DEFO) = compor(DEFO)
    write (compor_plas(NUME),'(I16)') nume_plas
!
end subroutine
