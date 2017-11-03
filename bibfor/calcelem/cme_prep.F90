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

subroutine cme_prep(option, model, time_curr, time_incr, chtime)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mecact.h"
!
character(len=16), intent(in) :: option
character(len=8), intent(in) :: model
real(kind=8), intent(in) :: time_curr
real(kind=8), intent(in) :: time_incr
character(len=24), intent(out) :: chtime
!
! --------------------------------------------------------------------------------------------------
!
! CALC_MATR_ELEM
!
! Preparation
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  model            : name of the model
! In  time_curr        : current time
! In  time_incr        : time step
! Out chtime           : time parameters (field)
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_cmp = 6
    character(len=8), parameter :: list_cmp(nb_cmp) = (/'INST    ','DELTAT  ','THETA   ',&
                                                        'KHI     ','R       ','RHO     '/)
    real(kind=8) :: list_vale(nb_cmp)   = (/0.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
!
! --------------------------------------------------------------------------------------------------
!
    chtime       = '&&CHTIME'
    list_vale(1) = time_curr
    list_vale(2) = time_incr
!
    if ((option.eq.'RIGI_THER') .or. (option.eq.'MASS_THER')) then
        call mecact('V', chtime, 'MODELE', model//'.MODELE', 'INST_R',&
                    ncmp=nb_cmp, lnomcmp=list_cmp, vr=list_vale)
    endif
!
end subroutine
