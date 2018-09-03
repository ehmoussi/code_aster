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
subroutine romAlgoNLCheck(phenom        , model_algoz, mesh_algoz, ds_algorom,&
                          l_line_search_)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/jeexin.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
!
character(len=4), intent(in) :: phenom
character(len=*), intent(in) :: model_algoz
character(len=*), intent(in) :: mesh_algoz
type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
aster_logical, intent(in), optional :: l_line_search_
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Check ROM algorithm datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom           : phenomenon (MECA/THER)
! In  model_algo       : model from *_non_line
! In  mesh_algo        : mesh from *_non_line
! In  ds_algorom       : datastructure for ROM parameters
! In  l_line_search    : .true. if line search
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: iret, nb_mode
    character(len=8) :: mesh_base = ' ', model_base = ' '
    character(len=8) :: mesh_algo = ' ', model_algo = ' '
    character(len=24) :: field_name = ' '
    character(len=24) :: grnode_int
    aster_logical :: l_hrom
    type(ROM_DS_Empi) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_30')
    endif
!
! - Get parameters
!
    mesh_algo  = mesh_algoz
    model_algo = model_algoz
    ds_empi    = ds_algorom%ds_empi
    l_hrom     = ds_algorom%l_hrom
    grnode_int = ds_algorom%grnode_int 
!
! - Check mesh
!
    mesh_base = ds_empi%ds_mode%mesh
    if (mesh_base .ne. mesh_algo) then
        call utmess('F', 'ROM5_31')
    endif
!
! - Check model
!
    model_base = ds_empi%ds_mode%model
    if (model_base .ne. model_algo) then
        call utmess('F', 'ROM5_49')
    endif
!
! - Check field in base
!
    field_name = ds_empi%ds_mode%field_name
    if (phenom .eq. 'THER') then
        if (field_name .ne. 'TEMP') then
            call utmess('F', 'ROM5_32')
        endif
    elseif (phenom .eq. 'MECA') then
        if (field_name .ne. 'DEPL') then
            call utmess('F', 'ROM5_32')
        endif
    else
        ASSERT(.false.)
    endif
!
! - Check group of nodes
!
    if (l_hrom) then
        call jeexin(mesh_algo//'.GROUPENO', iret)
        if (iret .eq. 0) then
            call utmess('F', 'ROM5_33', sk = grnode_int)
        else
            call jenonu(jexnom(mesh_algo//'.GROUPENO', grnode_int), iret)
            if (iret .eq. 0) then
                call utmess('F', 'ROM5_33', sk = grnode_int)
            endif
        endif
    endif
!
! - Check empiric base
!
    nb_mode = ds_empi%nb_mode
    if (nb_mode .lt. 1) then
        call utmess('F', 'ROM5_35')
    endif
!
! - Function exclusion
!
    if (phenom .eq. 'THER') then
        if (l_line_search_) then
            call utmess('F', 'ROM5_34')
        endif
    elseif (phenom .eq. 'MECA') then
!
    else
        ASSERT(.false.)
    endif   
!
end subroutine
