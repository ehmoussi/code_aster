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

subroutine romSolveDOMSystSolve(solver, ds_solve)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/preres.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/resoud.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: solver
    type(ROM_DS_Solve), intent(in) :: ds_solve
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Solve system (DOM)
!
! --------------------------------------------------------------------------------------------------
!
! In  solver           : name of datastructure for solver
! In  ds_solve         : datastructure to solve systems
!
! --------------------------------------------------------------------------------------------------
!
    complex(kind=8), parameter :: c16bid =(0.d0,0.d0)
    integer :: icode, ibid, ifm, niv
    character(len=19) :: maprec, crgc, vect_zero
    character(len=19) :: syst_matr, syst_2mbr, syst_solu
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_65')
    endif
!
! - Initializations
! 
    maprec         = '&&OP0053.MAPREC'
    crgc           = '&&OP0053.GCPC'
!
! - Get parameters
!
    vect_zero      = ds_solve%vect_zero
    syst_solu      = ds_solve%syst_solu
    syst_matr      = ds_solve%syst_matr
    syst_2mbr      = ds_solve%syst_2mbr
!
! - Factor matrix
!
    call preres(solver, 'V', icode, maprec, syst_matr,&
                ibid, -9999)
    if ((icode .eq. 1) .or. (icode .eq. 2)) then
        call utmess('I', 'ROM2_18')
    endif
!
! - Solve system
!
    call resoud(syst_matr, maprec    , solver, vect_zero, 0       ,&
                syst_2mbr, syst_solu , 'V'   , [0.d0]   , [c16bid],&
                crgc     , .true._1  , 0     , icode)
!
end subroutine
