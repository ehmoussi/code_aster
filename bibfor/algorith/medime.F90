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
subroutine medime(base, cumul, model, list_load, matr_elem)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/exisd.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/load_list_info.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
!
character(len=1), intent(in) :: base
character(len=4), intent(in) :: cumul
character(len=24), intent(in) :: model
character(len=19), intent(in) :: list_load
character(len=19), intent(in) :: matr_elem
!
! --------------------------------------------------------------------------------------------------
!
! Mechanics - Load
!
! Elementary matrix for Dirichlet BC
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : JEVEUX base to create vect_elem
! In  cumul            : option to add/erase matr_elem
!                      'ZERO' - Erase old matr_elem
!                      'CUMU' - Add matr_elem to old ones
! In  model            : name of model
! In  list_load        : name of datastructure for list of loads
! In  matr_elem        : elementary matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nbin = 1
    integer, parameter :: nbout = 1
    character(len=8) :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchout(nbout), lchin(nbin)
!
    character(len=8) :: load_name
    character(len=16) :: option
    character(len=19) :: ligrch, resu_elem
    integer :: iret, i_resu_elem, load_nume
    integer :: nb_load, i_load
    character(len=24), pointer :: v_load_name(:) => null()
    integer, pointer :: v_load_info(:) => null()
    aster_logical :: load_empty
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    option    = 'MECA_DDLM_R'
    resu_elem = matr_elem(1:8)//'.???????'
!
! - Init fields
!
    call inical(nbin, lpain, lchin, nbout, lpaout, lchout)
!
! - Loads
!
    call load_list_info(load_empty, nb_load    , v_load_name, v_load_info,&
                        list_load_ = list_load)
    if (load_empty) then
        goto 99
    endif
!
! - Prepare MATR_ELEM
!
    if (cumul .eq. 'ZERO') then
        call jedetr(matr_elem(1:19)//'.RELR')
        call memare(base, matr_elem, model, ' ', ' ', 'RIGI_MECA')
        call reajre(matr_elem, ' ', base)
    endif
!
! - Prepare RESU_ELEM
!
    if (cumul .eq. 'ZERO') then
        i_resu_elem = 0
    else if (cumul.eq.'CUMU') then
        call jelira(matr_elem(1:19)//'.RELR', 'LONUTI', i_resu_elem)
        i_resu_elem = i_resu_elem + 1
    else
        ASSERT(.false.)
    endif
!
! - Output field
!
    lpaout(1) = 'PMATUUR'
!
! - Loop on loads
!
    do i_load = 1, nb_load
        load_name = v_load_name(i_load)(1:8)
        load_nume = v_load_info(i_load+1) 
        if (load_nume .ne. 0) then
            ligrch = load_name(1:8)//'.CHME.LIGRE'
            call jeexin(ligrch(1:19)//'.LIEL', iret)
            if (iret .le. 0) cycle
            call exisd('CHAMP_GD', load_name(1:8)//'.CHME.CMULT', iret)
            if (iret .le. 0) cycle
!
! --------- Input field
!
            lpain(1) = 'PDDLMUR'
            lchin(1) = load_name//'.CHME.CMULT'
!
! --------- Generate new RESU_ELEM name
!
            ASSERT(i_resu_elem.le.9999999)
            call codent(i_resu_elem, 'D0', resu_elem(10:16))
            lchout(1) = resu_elem
!
! --------- Computation
!
            call calcul('S'  , option, ligrch, nbin, lchin,&
                        lpain, nbout, lchout, lpaout, base,&
                        'OUI')
!
! --------- Save RESU_ELEM
!
            call reajre(matr_elem, lchout(1), base)
            i_resu_elem = i_resu_elem + 1
        endif
    end do
 99 continue
!
    call jedema()
end subroutine
