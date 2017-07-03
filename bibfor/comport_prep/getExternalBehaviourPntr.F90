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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine getExternalBehaviourPntr(comp_exte,&
                                    cptr_fct_ldc ,&
                                    cptr_nbvarext, cptr_namevarext,&
                                    cptr_nbprop  , cptr_nameprop)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/umat_get_function.h"
#include "asterc/mfront_get_pointers.h"
#include "asterfort/assert.h"
!
type(NL_DS_ComporExte), intent(in) :: comp_exte
integer, intent(out) :: cptr_fct_ldc
integer, intent(out) :: cptr_nbvarext
integer, intent(out) :: cptr_namevarext
integer, intent(out) :: cptr_nbprop
integer, intent(out) :: cptr_nameprop
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get pointers for external programs (MFRONT/UMAT)
!
! --------------------------------------------------------------------------------------------------
!
! In  comp_exte        : values defining external behaviour
! Out cptr_fct_ldc     : pointer to behaviour law
! Out cptr_nbvarext    : pointer to number of external state variables
! Out cptr_namevarext  : pointer to name of external state variables
! Out cptr_nbprop      : pointer to number of material properties
! Out cptr_nameprop    : pointer to name of material properties
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_mfront_proto, l_mfront_offi, l_umat
    character(len=255) :: libr_name, subr_name
    character(len=16) :: model_mfront
!
! --------------------------------------------------------------------------------------------------
!
    cptr_fct_ldc    = 0
    cptr_nbvarext   = 0
    cptr_namevarext = 0
    cptr_nbprop     = 0
    cptr_nameprop   = 0
!
! - Get parameters
!
    l_mfront_offi   = comp_exte%l_mfront_offi
    l_mfront_proto  = comp_exte%l_mfront_proto
    l_umat          = comp_exte%l_umat
    libr_name       = comp_exte%libr_name 
    subr_name       = comp_exte%subr_name
    model_mfront    = comp_exte%model_mfront
!
! - Get pointers
!
    if ( l_mfront_offi .or. l_mfront_proto) then
        call mfront_get_pointers(libr_name, subr_name, model_mfront,&
                                 cptr_nbvarext, cptr_namevarext,&
                                 cptr_fct_ldc  ,&
                                 cptr_nameprop, cptr_nbprop)
    elseif ( l_umat ) then
        call umat_get_function(libr_name, subr_name, cptr_fct_ldc)
    else
        ASSERT(.false.)
    endif
!
end subroutine
