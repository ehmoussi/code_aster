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
subroutine dfllty(sdlist, list_method, dtmin)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/dfllli.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ltnotb.h"
#include "asterfort/nmarnr.h"
#include "asterfort/tbexip.h"
#include "asterfort/tbexve.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: sdlist
character(len=16), intent(out) :: list_method
real(kind=8), intent(out) :: dtmin
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST - Read parameters
!
! Keyword DEFI_LIST 
!
! --------------------------------------------------------------------------------------------------
!
! In  sdlist           : name of datastructure
! Out list_method      : method to define list of time steps
! Out dtmin            : minimum of increment between time steps
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywfact
    character(len=16) :: modetp
    character(len=24) :: sdlist_linfor
    real(kind=8), pointer :: v_sdlist_linfor(:) => null()
    character(len=19) :: list_inst
    real(kind=8), pointer :: v_list_inst(:) => null()
    character(len=19) :: list_resu
    real(kind=8), pointer :: v_list_resu(:) => null()
    character(len=24) :: sdlist_ditr
    real(kind=8), pointer :: v_sdlist_ditr(:) => null()
    character(len=19) :: tablpc
    integer :: n1, n2, nb_inst, iret, n3, i_inst, i_subd
    real(kind=8) :: step_mini, step_maxi, step_init, dt
    integer :: nb_pas_maxi, subd_pas
    integer :: numrep, nb_adap
    character(len=8) :: resu
    character(len=2) :: type
    aster_logical :: exist
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    keywfact    = 'DEFI_LIST'
    list_method = ' '
    dtmin       = 0.d0
!
! - Create datastructure
!
    sdlist_linfor = sdlist(1:8)//'.LIST.INFOR'
    call wkvect(sdlist_linfor, 'G V R', SIZE_LLINR, vr = v_sdlist_linfor)
!
! - Get method
!
    call getvtx(' ', 'METHODE', iocc=1, scal=list_method)
    if (list_method .eq. 'MANUEL') then
        v_sdlist_linfor(1) = 1.d0
    else if (list_method.eq.'AUTO') then
        v_sdlist_linfor(1) = 2.d0
    else
        ASSERT(.false.)
    endif
!
! - Get list of time steps
!
    call getvid(keywfact, 'LIST_INST', iocc=1, scal=list_inst, nbret=n1)
    call getvr8(keywfact, 'VALE'     , iocc=1, nbval=0       , nbret=n2)
    call getvid(keywfact, 'RESULTAT' , iocc=1, scal=resu     , nbret=n3)
!
! - Direct list
!
    if (n2 .ne. 0) then
        list_inst = '&&DFLLTY.LIST_INST'
        nb_inst = -n2
        call wkvect(list_inst//'.VALE', 'V V R', nb_inst, vr = v_list_inst)
        call getvr8(keywfact, 'VALE', iocc=1, nbval=nb_inst, vect=v_list_inst, nbret=n2)
    endif
!
! - From previous results datastructure
!
    if (n3 .ne. 0) then
! ----- Check table
        call ltnotb(resu, 'PARA_CALC', tablpc)
        call tbexip(tablpc, 'INST', exist, type)
        if (.not.exist .or. type .ne. 'R') then
            call utmess('F', 'DISCRETISATION_3', sk=resu)
        endif
        call nmarnr(resu, 'PARA_CALC', numrep)
        if (numrep .gt. 1) then
            call utmess('F', 'DISCRETISATION_4', sk=resu)
        endif
! ----- Get column
        list_resu = '&&DFLLTY.RESU_INST'
        call tbexve(tablpc, 'INST', list_resu, 'V', nb_inst, type)
        call jeveuo(list_resu, 'L', vr = v_list_resu)
! ----- Get parameter
        call getvis(keywfact, 'SUBD_PAS', iocc=1, scal=subd_pas, nbret=iret)
        ASSERT(iret.ne.0)
        ASSERT(subd_pas.gt.0)
! ----- Create list
        list_inst = '&&DFLLTY.LIST_INST'
        call wkvect(list_inst//'.VALE', 'V V R', subd_pas*(nb_inst-1)+1, vr = v_list_inst)
        do i_inst = 1, nb_inst-1
            do i_subd = 1, subd_pas
                dt = v_list_resu(i_inst+1)-v_list_resu(i_inst)
                v_list_inst(subd_pas*(i_inst-1)+i_subd) = v_list_resu(i_inst) +&
                                                          dt*(i_subd-1)/ subd_pas
            end do
        end do
        v_list_inst(subd_pas*(nb_inst-1)+1) = v_list_resu(nb_inst)
    endif
!
! - Check list of time steps
!
    call dfllli(list_inst, dtmin, nb_inst)
!
! - Create list in datastructure
!
    call jeveuo(list_inst//'.VALE', 'L', vr = v_list_inst)
    sdlist_ditr = sdlist//'.LIST.DITR'
    call wkvect(sdlist_ditr, 'G V R', nb_inst, vr = v_sdlist_ditr)
    v_sdlist_ditr(1:nb_inst) = v_list_inst(1:nb_inst)
!
! - Set parameters
!
    v_sdlist_linfor(5) = dtmin
    v_sdlist_linfor(8) = nb_inst
!
! - Parameters for automatic case
!
    if (list_method .eq. 'AUTO') then
        call getfac('ADAPTATION', nb_adap)
        call getvtx('ADAPTATION', 'MODE_CALCUL_TPLUS', iocc=nb_adap, scal=modetp)
! ----- PAS_MAXI
        call getvr8(keywfact, 'PAS_MAXI', iocc=1, scal=step_maxi, nbret=iret)
        if (iret .eq. 0) then
            step_maxi = v_sdlist_ditr(nb_inst) - v_sdlist_ditr(1)
        endif
        if (modetp .eq. 'IMPLEX') then
            step_init = v_list_inst(2)-v_list_inst(1)
            if (iret .eq. 0) then
                step_maxi = step_init*10
            endif
        else
            if (iret .eq. 0) then
                step_maxi = v_sdlist_ditr(nb_inst) - v_sdlist_ditr(1)
            endif
        endif
! ----- PAS_MINI
        call getvr8(keywfact, 'PAS_MINI', iocc=1, scal=step_mini, nbret = iret)
        if (modetp .eq. 'IMPLEX') then
            step_mini = step_init/1000
        else
            step_mini = 1.d-12
        endif
        if (step_mini .gt. dtmin) then
            call utmess('F', 'DISCRETISATION_1')
        endif
! ----- NB_PAS_MAXI
        call getvis(keywfact, 'NB_PAS_MAXI', iocc=1, scal=nb_pas_maxi, nbret = iret)
        v_sdlist_linfor(2) = step_mini
        v_sdlist_linfor(3) = step_maxi
        v_sdlist_linfor(4) = nb_pas_maxi
    endif
!
    call jedema()
end subroutine

