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
!
subroutine dsipdp(nume_thmc,&
                  adcome, addep1, addep2  ,&
                  dimcon, dimdef, dsde    ,&
                  dspdp1, dspdp2, l_dspdp2)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
!
integer, intent(in) :: nume_thmc
integer, intent(in) :: adcome, addep1, addep2
integer, intent(in) :: dimdef, dimcon
real(kind=8), intent(in) :: dsde(dimcon, dimdef)
real(kind=8), intent(out) :: dspdp1, dspdp2
aster_logical, intent(out) :: l_dspdp2
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Preparation for HOEK_BROWN_TOT
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_thmc        : index of coupling law for THM
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  adcome           : adress of mechanic stress in generalized stresses vector
! In  addep1           : adress of p1 dof in vector and matrix (generalized quantities)
! In  addep2           : adress of p2 dof in vector and matrix (generalized quantities)
! In  dsde             : derivative matrix
! Out dspdp1           : derivative of stress by p1
! Out dspdp2           : derivative of stress by p2
! Out l_dspdp2         : .true. if dspdp2 exists
!
! --------------------------------------------------------------------------------------------------
!
    dspdp1   = 0.d0
    dspdp2   = 0.d0
    l_dspdp2 = ASTER_FALSE
!
    if (ds_thm%ds_behaviour%nb_pres .eq. 1) then
        if (nume_thmc .eq. 2) then
            dspdp1   = 0.d0
            dspdp2   = dspdp2+dsde(adcome+6,addep1)
            l_dspdp2 = ASTER_TRUE
        else
            dspdp1   = dspdp1+dsde(adcome+6,addep1)
            dspdp2   = 0.d0
            l_dspdp2 = ASTER_FALSE
        endif
    endif
    if (ds_thm%ds_behaviour%nb_pres .eq. 2) then
        dspdp1   = dspdp1+dsde(adcome+6,addep1)
        dspdp2   = dspdp2+dsde(adcome+6,addep2)
        l_dspdp2 = ASTER_TRUE
    endif
!
end subroutine
