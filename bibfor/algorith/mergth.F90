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

subroutine mergth(model    , lload_name, lload_info, cara_elem, mate,&
                  time_curr, time      , varc_curr , matr_elem)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/ther_mrig.h"
#include "asterfort/gcnco2.h"
#include "asterfort/inical.h"
#include "asterfort/jeexin.h"
#include "asterfort/jedetr.h"
#include "asterfort/memare.h"
#include "asterfort/load_list_info.h"
#include "asterfort/load_neut_comp.h"
#include "asterfort/load_neut_prep.h"
!
!
    character(len=24), intent(in) :: model
    character(len=24), intent(in) :: lload_name
    character(len=24), intent(in) :: lload_info
    real(kind=8), intent(in) :: time_curr
    character(len=24), intent(in) :: time
    character(len=24), intent(in) :: mate
    character(len=24), intent(in) :: cara_elem
    character(len=19), intent(in) :: varc_curr
    character(len=24), intent(inout) :: matr_elem
!
! --------------------------------------------------------------------------------------------------
!
! Thermic
! 
! Rigidity matrix - Volumic and surfacic terms
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  mate             : name of material characteristics (field)
! In  lload_name       : name of object for list of loads name
! In  lload_info       : name of object for list of loads info
! In  time_curr        : current time
! In  time             : time (<CARTE>)
! In  cara_elem        : name of elementary characteristics (field)
! In  varc_curr        : command variable for current time
! IO  matr_elem        : name of matr_elem result
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_in_maxi, nbout
    parameter (nb_in_maxi = 16, nbout = 1)
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
!
    character(len=1) :: base, stop_calc
    character(len=8) :: load_name, newnom
    integer :: iret
    character(len=19) :: resu_elem
    integer :: load_nume
    aster_logical :: load_empty
    integer :: i_load, nb_load, nb_in_prep
    character(len=24), pointer :: v_load_name(:) => null()
    integer, pointer :: v_load_info(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Initializations
!
    resu_elem   = '&&MERGTH.0000000'
    stop_calc   = 'S'
    base        = 'V'
!
! - Prepare MATR_ELEM
!
    call jeexin(matr_elem(1:19)//'.RELR', iret)
    if (iret .eq. 0) then
        call memare('V', matr_elem, model, mate, cara_elem,&
                    'RIGI_THER')
    else
        call jedetr(matr_elem(1:19)//'.RELR')
    endif
!
! - Generate new RESU_ELEM name
!
    newnom = resu_elem(10:16)
    call gcnco2(newnom)
    resu_elem(10:16) = newnom(2:8)
!
! - Rigidity matrix - Volumic terms
!
    call ther_mrig(model    , mate     , time, cara_elem, varc_curr,&
                   resu_elem, matr_elem)
!
! - Init fields
!
    call inical(nb_in_maxi, lpain, lchin, nbout, lpaout,&
                lchout)
!
! - Loads
!
    call load_list_info(load_empty, nb_load   , v_load_name, v_load_info,&
                        lload_name, lload_info)
!
! - Preparing input fields
!
    call load_neut_prep(model, nb_in_maxi, nb_in_prep, lchin, lpain, &
                        varc_curr_ = varc_curr)
!
! - Computation
!
    do i_load = 1, nb_load
        load_name = v_load_name(i_load)(1:8)
        load_nume = v_load_info(nb_load+i_load+1)
        if (load_nume .gt. 0) then
            call load_neut_comp('MRIG'   , stop_calc, model     , time_curr , time ,&
                                load_name, load_nume, nb_in_maxi, nb_in_prep, lpain,&
                                lchin    , base     , resu_elem , matr_elem )
        endif
    end do
!
end subroutine
