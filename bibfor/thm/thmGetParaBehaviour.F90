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
                               nume_meca_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
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
!
! --------------------------------------------------------------------------------------------------
!
    if (present(thmc_)) thmc_ = compor( 8)
    if (present(ther_)) ther_ = compor( 9)
    if (present(hydr_)) hydr_ = compor(10)
    if (present(meca_)) meca_ = compor(11)
    if (present(nvic_)) read (compor(17),'(I16)') nvic_
    if (present(nvit_)) read (compor(18),'(I16)') nvit_
    if (present(nvih_)) read (compor(19),'(I16)') nvih_
    if (present(nvim_)) read (compor(20),'(I16)') nvim_
    if (present(nume_meca_)) read (compor(15),'(I16)') nume_meca_
!
end subroutine
