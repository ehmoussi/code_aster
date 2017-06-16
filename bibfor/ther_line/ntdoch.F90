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
subroutine ntdoch(list_load, l_load_user_, list_load_resu)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/focste.h"
#include "asterfort/liscad.h"
#include "asterfort/lisccr.h"
#include "asterfort/nmdoch_nbload.h"
#include "asterfort/jeexin.h"
#include "asterfort/load_list_getp.h"
#include "asterfort/lislfc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/load_neut_iden.h"
#include "asterfort/load_neut_data.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
character(len=19), intent(in) :: list_load
aster_logical, optional, intent(in) :: l_load_user_
character(len=19), optional, intent(in) :: list_load_resu
!
! --------------------------------------------------------------------------------------------------
!
! Thermics - Read parameters
!
! Get loads information and create datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load_resu : name of datastructure for list of loads from result datastructure
! In  l_load_user    : .true. if loads come from user (EXCIT)
! In  list_load      : name of datastructure for list of loads
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_info_maxi = 99
    character(len=24) :: list_info_type(nb_info_maxi)
    integer, parameter :: nb_type_neum  = 10
    aster_logical :: list_load_keyw(nb_type_neum)
    aster_logical :: l_func_mult, l_load_user, l_zero_allowed
    aster_logical :: l_func_c
    integer :: nb_info_type
    character(len=24) :: info_type
    integer :: nb_load, i_load, i_type_neum, iret, i_excit
    character(len=24) :: ligrch
    character(len=10) :: load_obje(2)
    character(len=19) :: cart_name
    character(len=8) :: load_name, const_func, load_func
    character(len=16) :: load_keyword
    character(len=24) :: load_type, load_para, load_keyw
    character(len=16) :: load_opti_f
    integer, pointer :: v_llresu_info(:) => null()
    character(len=24), pointer :: v_llresu_name(:) => null()
    character(len=24), pointer :: v_llresu_func(:) => null()
    character(len=8), pointer :: v_list_dble(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_load        = 0
    i_excit        = 0
    const_func     = '&&NTDOCH'
    l_func_c       = .false.
    l_load_user    = .true.
    l_zero_allowed = .true.
    if (present(l_load_user_)) then
        l_load_user = l_load_user_
    endif
!
! - Get number of loads for loads datastructure
!
    call nmdoch_nbload(l_load_user , list_load_resu, l_zero_allowed, nb_load,&
                       load_keyword)
!
! - Access to saved list of loads datastructure
!
    if (.not.l_load_user) then
        call jeveuo(list_load_resu(1:19)//'.INFC', 'L', vi   = v_llresu_info)
        call jeveuo(list_load_resu(1:19)//'.LCHA', 'L', vk24 = v_llresu_name)
        call jeveuo(list_load_resu(1:19)//'.FCHA', 'L', vk24 = v_llresu_func)
    endif
!
    if (nb_load .ne. 0) then
        ASSERT(load_keyword .ne. 'None')
!
! ----- Create list of loads 
!
        call lisccr('THER', list_load, nb_load, 'V')
!
! ----- List of loads to avoid same loads
!
        AS_ALLOCATE(vk8 = v_list_dble, size = nb_load)
!
! ----- Loop on loads
!
        do i_load = 1 , nb_load
!
! --------- Get parameters for construct list of loads
!
            call load_list_getp('THER'      , l_load_user , v_llresu_info, v_llresu_name,&
                                v_list_dble , load_keyword, i_load       , nb_load      ,&
                                i_excit     , load_name   , load_type    , ligrch)
!
! --------- Dirichlet loads (AFFE_CHAR_CINE)
!
            nb_info_type = 0
            info_type    = 'RIEN'
            if (load_type(1:5) .eq. 'CITH_') then
                if (load_type(5:7) .eq. '_FT') then
                    info_type = 'CINE_FT'
                else if (load_type(5:7).eq.'_FO') then
                    info_type = 'CINE_FO'
                else
                    info_type = 'CINE_CSTE'
                endif
            endif
            if (info_type .ne. 'RIEN') then
                nb_info_type = nb_info_type + 1
                ASSERT(nb_info_type.lt.nb_info_maxi)
                list_info_type(nb_info_type) = info_type
            endif
!
! --------- Dirichlet loads (AFFE_CHAR_THER)
!
            info_type = 'RIEN'
            cart_name = ligrch(1:13)//'.CIMPO'
            call jeexin(cart_name//'.DESC', iret)
            if (iret .ne. 0) then
                if (load_type(5:7) .eq. '_FO') then
                    info_type = 'DIRI_FO'
                    call dismoi('PARA_INST', cart_name, 'CARTE', repk=load_para)
                    if (load_para(1:3) .eq. 'OUI') then
                        info_type = 'DIRI_FT'
                    endif
                else
                    info_type = 'DIRI_CSTE'
                endif
            endif
            if (info_type .ne. 'RIEN') then
                nb_info_type = nb_info_type + 1
                ASSERT(nb_info_type.lt.nb_info_maxi)
                list_info_type(nb_info_type) = info_type
            endif
!
! --------- Get function applied to load
!
            call lislfc(list_load_resu, i_load      , i_excit   , l_load_user,&
                        l_func_c      , load_keyword, const_func, load_func)
            ASSERT(load_func .ne. ' ')
            l_func_mult = load_func(1:2) .ne. '&&'
!
! --------- Identify type of Neumann loads 
!
            call load_neut_iden(nb_type_neum, load_name, list_load_keyw)
!
! --------- Add Neuman loads
!
            do i_type_neum = 1, nb_type_neum
                info_type = 'RIEN'
                if (list_load_keyw(i_type_neum)) then
                    call load_neut_data(i_type_neum, nb_type_neum, '2MBR',&
                                        load_opti_f_ = load_opti_f,&
                                        load_obje_   = load_obje,&
                                        load_keyw_   = load_keyw)
                    cart_name  = load_name(1:8)//'.CHTH'//load_obje(1)
                    if ((load_opti_f .eq. 'No_load') .and. l_func_mult) then
                        call utmess('F', 'CHARGES_20', sk=load_name)
                    endif
                    if (load_keyw.eq.'ECHANGE') then
                        if (l_func_mult) then
                            call utmess('F', 'CHARGES_32', sk=load_name)
                        endif
                    endif
                    if (load_keyw.eq.'EVOL_CHAR') then
                        ASSERT (load_type(5:7) .ne. '_FO')
                        info_type = 'NEUM_CSTE'
                    else
                        if (load_type(5:7) .eq. '_FO') then
                            info_type = 'NEUM_FO'
                            call dismoi('PARA_INST', cart_name, 'CARTE', repk=load_para)
                            if (load_para(1:3) .eq. 'OUI') then
                                info_type = 'NEUM_FT'
                            endif
                        else
                           info_type = 'NEUM_CSTE'
                        endif
                    endif
                endif
                if (info_type .ne. 'RIEN') then
                    nb_info_type = nb_info_type + 1
                    ASSERT(nb_info_type.lt.nb_info_maxi)
                    list_info_type(nb_info_type) = info_type
                endif
            end do
!
! --------- Add new load(s) in list
!
            if (nb_info_type .gt. 0) then
                call liscad('THER'      , list_load     , i_load, load_name, load_func, &
                            nb_info_type, list_info_type)
            endif
        end do
    endif
!
    AS_DEALLOCATE(vk8 = v_list_dble)

end subroutine
