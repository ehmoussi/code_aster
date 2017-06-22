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

subroutine me2mme_evol(model_    , cara_elem_, mate_      , nharm    , base_    ,&
                       i_load    , load_name , ligrel_calc, inst_prev, inst_curr,&
                       inst_theta, resu_elem , vect_elem)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/load_neum_prep.h"
#include "asterfort/load_neum_evcd.h"
#include "asterfort/inical.h"
!
!
    character(len=*), intent(in) :: model_
    character(len=*), intent(in) :: cara_elem_
    character(len=*), intent(in) :: mate_
    integer, intent(in) :: nharm
    character(len=*), intent(in) :: base_
    integer, intent(in) :: i_load
    character(len=8), intent(in) :: load_name
    character(len=19), intent(in) :: ligrel_calc
    real(kind=8), intent(in) :: inst_prev 
    real(kind=8), intent(in) :: inst_curr
    real(kind=8), intent(in) :: inst_theta 
    character(len=19), intent(inout) :: resu_elem
    character(len=19), intent(in) :: vect_elem
!
! --------------------------------------------------------------------------------------------------
!
! CALC_VECT_ELEM
! 
! EVOL_CHAR loads
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_in_maxi, nbout
    parameter (nb_in_maxi = 42, nbout = 1)
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
!
    integer :: nb_in_prep
    character(len=1) :: stop, base
    character(len=24) :: model, cara_elem, mate
!
! --------------------------------------------------------------------------------------------------
!
    stop      = 'S'
    base      = base_
    model     = model_
    cara_elem = cara_elem_
    mate      = mate_
!
! - Init fields
!
    call inical(nb_in_maxi, lpain, lchin, nbout, lpaout,&
                lchout)
!
! - Preparing input fields
!
    call load_neum_prep(model    , cara_elem , mate      , 'Dead'      , inst_prev,&
                        inst_curr, inst_theta, nb_in_maxi, nb_in_prep  , lchin    ,&
                        lpain    , nharm = nharm)
!
! - Compute composite dead Neumann loads (EVOL_CHAR)
!
    call load_neum_evcd(stop      , inst_prev , load_name, i_load, ligrel_calc,&
                        nb_in_maxi, nb_in_prep, lpain    , lchin , base       ,&
                        resu_elem , vect_elem)

end subroutine
