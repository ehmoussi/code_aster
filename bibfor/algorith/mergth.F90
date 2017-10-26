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
subroutine mergth(model_    , list_load_, cara_elem_, mate_, chtime_,&
                  matr_elem , base,&
                  time_curr , varc_curr_, nh_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calcul.h"
#include "asterfort/ther_mrig.h"
#include "asterfort/gcnco2.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/memare.h"
#include "asterfort/vrcins.h"
#include "asterfort/load_list_info.h"
#include "asterfort/load_neut_comp.h"
#include "asterfort/load_neut_prep.h"
!
    character(len=*), intent(in) :: model_
    character(len=*), intent(in) :: list_load_
    character(len=*), intent(in) :: cara_elem_
    character(len=*), intent(in) :: mate_
    character(len=*), intent(in) :: chtime_
    character(len=24), intent(in) :: matr_elem
    character(len=1), intent(in) :: base
    real(kind=8), intent(in) :: time_curr
    character(len=19), optional, intent(in) :: varc_curr_
    integer, optional, intent(in) :: nh_
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
! In  list_load        : name of datastructure for list of loads
! In  cara_elem        : name of elementary characteristics (field)
! In  mate             : name of material characteristics (field)
! In  chtime           : time (<CARTE>)
! In  matr_elem        : name of matr_elem result
! In  base             : JEVEUX base to create matr_elem
! In  varc_curr        : command variable for current time
! In  time_curr        : current time
! In  nh               : Fourier mode
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_in_maxi = 16
    integer, parameter :: nbout = 1
    character(len=8) :: lpain(nb_in_maxi), lpaout(nbout)
    character(len=19) :: lchin(nb_in_maxi), lchout(nbout)
    character(len=24) :: cara_elem, mate, chtime, model
    character(len=1) :: stop_calc
    character(len=8) :: load_name, newnom
    integer :: iret, nh
    character(len=19) :: resu_elem, varc_curr
    integer :: load_nume
    aster_logical :: load_empty
    integer :: i_load, nb_load, nb_in_prep
    character(len=24) :: lload_name
    character(len=24), pointer :: v_load_name(:) => null()
    character(len=24) :: lload_info
    integer, pointer :: v_load_info(:) => null()
    character(len=2) :: codret
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    model     = model_
    cara_elem = cara_elem_
    mate      = mate_
    chtime    = chtime_
    resu_elem = matr_elem(1:8)//'.0000000'
    stop_calc = 'S'
    nh        = -1
    if (present(nh_)) then
        nh = nh_
    endif
!
! - Prepare external state variables
!
    if (present(varc_curr_)) then
        varc_curr = varc_curr_
    else
        varc_curr = '&&VARC_CURR'
        call vrcins(model, mate, ' ', time_curr, varc_curr, codret)
    endif
!
! - Prepare MATR_ELEM
!
    call jeexin(matr_elem(1:19)//'.RELR', iret)
    if (iret .eq. 0) then
        call memare(base, matr_elem, model, mate, cara_elem, 'RIGI_THER')
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
    call ther_mrig(model, mate     , chtime   , cara_elem, varc_curr, nh,&
                   base , resu_elem, matr_elem)
!
! - Init fields
!
    call inical(nb_in_maxi, lpain, lchin, nbout, lpaout,&
                lchout)
!
! - Loads
!
    lload_name = list_load_(1:19)//'.LCHA'
    lload_info = list_load_(1:19)//'.INFC'
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
            call load_neut_comp('MRIG'   , stop_calc, model     , time_curr , chtime,&
                                load_name, load_nume, nb_in_maxi, nb_in_prep, lpain ,&
                                lchin    , base     , resu_elem , matr_elem )
        endif
    end do
!
    call jedema()
!
end subroutine
