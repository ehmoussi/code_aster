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

subroutine romSolveROMSystSolve(ds_solve, size_to_solve_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/zgauss.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_Solve), intent(in) :: ds_solve
    integer, optional, intent(in) :: size_to_solve_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Solve system (ROM)
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_solve         : datastructure to solve systems (ROM)
! In  size_to_solve    : current size of system to solve
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=19) :: syst_matr, syst_2mbr, syst_solu
    character(len=1) :: syst_type
    integer :: nhrs, syst_size, size_to_solve
    complex(kind=8), pointer :: v_syst_matr(:) => null()
    complex(kind=8), pointer :: v_syst_2mbr(:) => null()
    complex(kind=8), pointer :: v_syst_solu(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_44')
    endif
!
! - Initializations
!   
    nhrs    = 1
!
! - Get parameters
!
    syst_solu      = ds_solve%syst_solu
    syst_matr      = ds_solve%syst_matr
    syst_2mbr      = ds_solve%syst_2mbr
    syst_size      = ds_solve%syst_size
    syst_type      = ds_solve%syst_matr_type
    if (present(size_to_solve_)) then
        size_to_solve = size_to_solve_
    else
        size_to_solve = syst_size
    endif
    ASSERT(size_to_solve .le. syst_size)
!
! - Access to objects
!
    if (syst_type .eq. 'C') then
        call jeveuo(syst_matr, 'L', vc = v_syst_matr)
        call jeveuo(syst_2mbr, 'L', vc = v_syst_2mbr)
        call jeveuo(syst_solu, 'E', vc = v_syst_solu)
    else
        ASSERT(.false.)
    endif
!
! - Solve system
!
    if (syst_type .eq. 'C') then
        call zgauss(v_syst_matr, v_syst_2mbr, size_to_solve, nhrs, v_syst_solu)
    else
        ASSERT(.false.)
    endif
!
end subroutine
