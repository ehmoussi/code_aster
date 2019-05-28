! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine crcoch_getloads(list_load, nb_load, nb_ondp, v_ondp)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/getvid.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/jeexin.h"
#include "asterfort/lisccr.h"
#include "asterfort/liscad.h"
#include "asterfort/lislfc.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/loadGetNeumannType.h"
#include "asterfort/focste.h"
!
character(len=19), intent(in) :: list_load
integer, intent(out) :: nb_ondp, nb_load
character(len=8), pointer :: v_ondp(:)
!
! --------------------------------------------------------------------------------------------------
!
! CREA_RESU /CONV_CHAR
!
! Get loads
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load      : name of datastructure for list of loads
! Out nb_load        : number of loads
! Out nb_ondp        : number of ONDE_PLANE loads
! PTR v_ondp         : pointer to list of ONDE_PLANE loads
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_info_maxi = 99
    character(len=24) :: list_info_type(nb_info_maxi)
    character(len=16) :: load_keyword, load_apply
    real(kind=8) ::  coef_r
    aster_logical ::  l_stat
    integer :: iocc, nocc, iret, i_neum_lapl
    integer :: i_load, i_load_dble
    integer :: nb_info_type
    character(len=8) :: load_name, load_type, load_func, const_func = '&&NMDOME'
    character(len=19) :: ligrch, lchin, nomf19
    character(len=8), pointer :: v_list_dble(:) => null()
    character(len=8), pointer :: v_list_load(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Output parameters
!
    nb_ondp      = 0
    nb_load      = 0
!
! - General parameters for loads
!
    l_stat       = ASTER_FALSE
    load_keyword = 'CONV_CHAR'
    load_apply   = 'FIXE_CSTE'
!
! - Get loads for loads datastructure
!
    iocc = 1
    call getvid(load_keyword, 'CHARGE', iocc=iocc, nbval=0, nbret=nocc)
    nb_load = -nocc
    AS_ALLOCATE(vk8 = v_list_load, size = nb_load)
    call getvid(load_keyword, 'CHARGE', iocc=iocc, nbval = nb_load, vect = v_list_load)
!
! - Create load datastructure
!
    call lisccr('MECA', list_load, nb_load, 'V')
    AS_ALLOCATE(vk8 = v_ondp, size = nb_load)
!
! - Count loads and sort by type
!
    if (nocc .ne. 0) then
        nb_load = -nocc
! ----- List of loads to avoid same loads
        AS_ALLOCATE(vk8 = v_list_dble, size = nb_load)
! ----- Analyze list of loads
        do i_load = 1, nb_load
            nb_info_type      = 0
            list_info_type(:) = ' '
! --------- Get load
            load_name = v_list_load(i_load)
            call dismoi('TYPE_CHARGE', load_name, 'CHARGE', repk=load_type)
            ligrch = load_name//'.CHME.LIGRE'
! --------- Only one load in the list
            do i_load_dble = 1, nb_load
                if (load_name .eq. v_list_dble(i_load_dble)) then
                    call utmess('F', 'CHARGES_1', sk=load_name)
                endif
            end do
! --------- No CHAR_CINE
            if (load_type(1:5) .eq. 'CIME_') then
                call utmess('A', 'CREARESU1_1')
            endif
! --------- NO CHAR_MECA with Dirichlet
            lchin = ligrch(1:13)//'.CIMPO'
            call jeexin(lchin//'.DESC', iret)
            if (iret .ne. 0) then
                call utmess('A', 'CREARESU1_2')
            endif
! --------- Detect ONDE_PLANE loads
            lchin = ligrch(1:13)//'.ONDPL'
            call jeexin(lchin//'.DESC', iret)
            if (iret .ne. 0) then
                nb_ondp  = nb_ondp + 1
                v_ondp(nb_ondp) = load_name
            endif
! --------- Get NEUMANN loads
            call loadGetNeumannType(l_stat      , load_name   , ligrch        ,&
                                    load_apply  , load_type   ,&
                                    nb_info_type, nb_info_maxi, list_info_type,&
                                    i_neum_lapl )
! --------- Create constant function
            nomf19 = const_func
            call jeexin(nomf19//'.PROL', iret)
            if (iret .eq. 0) then
                coef_r = 1.d0
                call focste(const_func, 'TOUTRESU', coef_r, 'V')
            endif
            load_func = const_func
            load_func = ' '
! --------- Add new load(s) in list
            if (nb_info_type .gt. 0) then
                call liscad('MECA'      , list_load     , i_load, load_name, load_func,&
                            nb_info_type, list_info_type, i_neum_laplz = i_neum_lapl)
            endif
        end do
    endif
!
! - Clean
!
    AS_DEALLOCATE(vk8 = v_list_dble)
    AS_DEALLOCATE(vk8 = v_list_load)
!
    call jedema()
end subroutine
