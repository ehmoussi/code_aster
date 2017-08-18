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

subroutine thmGetParaBehaviour(compor,&
                               meca_ , thmc_, ther_, hydr_,&
                               nvim_ , nvic_, nvit_, nvih_,&
                               nume_meca_, nume_thmc_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/Behaviour_type.h"
!
character(len=16), intent(in) :: compor(*)
character(len=16), optional, intent(out) :: meca_
character(len=16), optional, intent(out) :: thmc_
character(len=16), optional, intent(out) :: ther_
character(len=16), optional, intent(out) :: hydr_
integer, optional, intent(out) :: nvim_
integer, optional, intent(out) :: nvit_
integer, optional, intent(out) :: nvih_
integer, optional, intent(out) :: nvic_
integer, optional, intent(out) :: nume_meca_
integer, optional, intent(out) :: nume_thmc_
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Get behaviours parameters from COMPOR field
!
! --------------------------------------------------------------------------------------------------
!
! In  compor          : behaviour
! Out meca            : behaviour name for mechanic
! Out thmc            : behaviour name for coupling law
! Out ther            : behaviour name for thermic
! Out hydr            : behaviour name for hydraulic
! Out nvim            : number of internal variables for mechanic
! Out nvic            : number of internal variables for coupling law
! Out nvit            : number of internal variables for thermic
! Out nvih            : number of internal variables for hydraulic
! Out nume_meca       : index for mechanic behaviour
! Out nume_thmc       : index for coupling behaviour
!
! --------------------------------------------------------------------------------------------------
!
    if (present(thmc_)) thmc_ = compor(THMC_NAME)
    if (present(ther_)) ther_ = compor(THER_NAME)
    if (present(hydr_)) hydr_ = compor(HYDR_NAME)
    if (present(meca_)) meca_ = compor(MECA_NAME)
    if (present(nvic_)) read (compor(THMC_NVAR),'(I16)') nvic_
    if (present(nvit_)) read (compor(THER_NVAR),'(I16)') nvit_
    if (present(nvih_)) read (compor(HYDR_NVAR),'(I16)') nvih_
    if (present(nvim_)) read (compor(MECA_NVAR),'(I16)') nvim_
    if (present(nume_meca_)) read (compor(MECA_NUME),'(I16)') nume_meca_
    if (present(nume_thmc_)) read (compor(THMC_NUME),'(I16)') nume_thmc_
!
end subroutine
