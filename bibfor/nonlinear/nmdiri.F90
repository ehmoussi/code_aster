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
subroutine nmdiri(model  , ds_material, cara_elem, list_load,&
                  disp   , vediri     , nume_dof , cndiri   ,&
                  sddyna_, vite_      , acce_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/ndynin.h"
#include "asterfort/ndynlo.h"
#include "asterfort/vebtla.h"
#include "asterfort/assvec.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtzero.h"
!
character(len=24), intent(in) :: model
type(NL_DS_Material), intent(in) :: ds_material
character(len=24), intent(in) :: cara_elem
character(len=19), intent(in) :: list_load
character(len=19), intent(in) :: disp
character(len=19), intent(in) :: vediri
character(len=24), intent(in) :: nume_dof
character(len=19), intent(in) :: cndiri
character(len=19), optional, intent(in) :: sddyna_
character(len=19), optional, intent(in) :: vite_, acce_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  cara_elem        : name of elementary characteristics (field)
! In  ds_material      : datastructure for material parameters
! In  list_load        : name of datastructure for list of loads
! In  disp             : displacement
! In  vediri           : name of elementary vectors
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  cndiri           : name of assembled vector
! In  sddyna           : datastructure for dynamic
! In  vite             : speed
! In  acce             : acceleration
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_disp, l_vite, l_acce, l_dyna
    character(len=19) :: veclag
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) &
        '<MECANONLINE> ... Compute force for Dirichlet boundary conditions (dualized) - BT.LAMBDA'
    endif
!
! - Get type of unknowns
!
    l_disp = ASTER_TRUE
    l_vite = ASTER_FALSE
    l_acce = ASTER_FALSE
    if (present(sddyna_)) then
        l_dyna  = ndynlo(sddyna_,'DYNAMIQUE')
        if (l_dyna) then
            l_disp = ndynin(sddyna_,'FORMUL_DYNAMIQUE') .eq. 1
            l_vite = ndynin(sddyna_,'FORMUL_DYNAMIQUE') .eq. 2
            l_acce = ndynin(sddyna_,'FORMUL_DYNAMIQUE') .eq. 3
        endif
    endif
!
! - Which unknowns for Lagrange multipliers ?
!
    if (l_disp) then
        veclag = disp
    else if (l_vite) then
        veclag = vite_
!       VILAINE GLUTE POUR L'INSTANT
        veclag = disp
    else if (l_acce) then
        if (present(acce_)) then
            veclag = acce_
        else
            veclag = disp
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Elementary vectors
!
    call vebtla('V'      , model, ds_material%field_mate, cara_elem, veclag,&
                list_load, vediri)
!
! - Assembling
!
    call vtzero(cndiri)
    call assvec('V', cndiri, 1, vediri, [1.d0],&
                nume_dof, ' ', 'ZERO', 1)
!
! - Print
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cndiri, 6)
    endif
!
end subroutine
