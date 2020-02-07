! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine loadGetNeumannType(l_stat      , load_name   , ligrch        ,&
                              load_apply  , load_type   ,&
                              nb_info_type, nb_info_maxi, list_info_type,&
                              i_neum_lapl)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeexin.h"
#include "asterfort/utmess.h"
#include "asterfort/dismoi.h"
#include "asterfort/codent.h"
!
aster_logical, intent(in) :: l_stat
character(len=8), intent(in) :: load_name
character(len=19), intent(in) :: ligrch
character(len=16), intent(in) :: load_apply
character(len=8), intent(in) :: load_type
integer, intent(inout) :: nb_info_type
integer, intent(in) :: nb_info_maxi
character(len=24), intent(inout)  :: list_info_type(nb_info_maxi)
integer, intent(out) :: i_neum_lapl
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Get type of Neumann load
!
! --------------------------------------------------------------------------------------------------
!
! In  l_stat         : flag for static computation
! In  load_name      : name of load
! In  ligrch         : LIGREL (list of elements) where apply load
! IO  nb_info_type   : number of type of loads to assign (list)
! IO  list_info_type : list of type of loads to assign (list)
! Out i_neum_lapl    : special index for Laplace load
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_lapl_maxi = 99
    integer, parameter :: nb_type_neum = 20
    character(len=6), parameter :: ligr_name(nb_type_neum) = (/'.FORNO','.F3D3D','.F2D3D','.F1D3D',&
                                                               '.F2D2D','.F1D2D','.F1D1D','.PESAN',&
                                                               '.ROTAT','.PRESS','.FELEC','.FCO3D',&
                                                               '.FCO2D','.EPSIN','.FLUX ','.VEASS',&
                                                               '.ONDPL','.SIINT','.ETHM ','.VNOR '/)
    integer :: i_type_neum, iret, iret_cable_cine, infc, i_lapl
    character(len=5) :: suffix, para_inst, para_vite
    character(len=24) :: info_type, lchin
    aster_logical :: l_para_inst, l_para_vite
    aster_logical :: l_func_inst(99), l_func_vite(99)
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    ASSERT(nb_info_maxi .eq. 99)
    l_func_inst(:)    = ASTER_FALSE
    l_func_vite(:)    = ASTER_FALSE
!
    do i_type_neum = 1, nb_type_neum
        if (ligr_name(i_type_neum) .eq. '.VEASS') then
            suffix = '     '
        else
            suffix = '.DESC'
        endif
        lchin = ligrch(1:13)//ligr_name(i_type_neum)//suffix
        call jeexin(lchin, iret)
        info_type = 'RIEN'
        if (iret .ne. 0) then
! --------- Parameter dependence
            if (ligr_name(i_type_neum) .eq. '.VEASS') then
                para_inst = 'NON'
                para_vite = 'NON'
            else
                call dismoi('PARA_INST', lchin, 'CARTE', repk=para_inst)
                call dismoi('PARA_VITE', lchin, 'CARTE', repk=para_vite)
            endif
            if (ligr_name(i_type_neum) .eq. '.ETHM') then
              if (.not.(load_apply .eq. 'SUIV')) then
                  call utmess('F', 'CHARGES5_13', sk=load_name)
              endif
            endif
            l_para_inst = para_inst .eq. 'OUI'
            l_para_vite = para_vite .eq. 'OUI'
! --------- Identification
            if (ligr_name(i_type_neum) .eq. '.ONDPL') then
                info_type = 'NEUM_ONDE'
            else if (ligr_name(i_type_neum) .eq. '.SIINT') then
                info_type = 'NEUM_SIGM_INT'
            else if (load_apply .eq. 'FIXE_PILO') then
                if (ligr_name(i_type_neum) .eq. '.VEASS') then
                    info_type = 'NEUM_PILO'
                else
                    if (load_type(5:7) .eq. '_FO') then
                        info_type = 'NEUM_PILO_F'
                        if (l_para_inst) then
                            call utmess('F', 'CHARGES_28', sk=load_name)
                        endif
                    else
                        info_type = 'NEUM_PILO'
                    endif
                endif
            else if (load_apply .eq. 'SUIV_PILO') then
                if (ligr_name(i_type_neum) .eq. '.VEASS') then
                    info_type = 'NEUM_SUIP'
                else
                    if (load_type(5:7).eq.'_FO') then
                        info_type = 'NEUM_SUIP_F'
                        if (l_para_inst) then
                            call utmess('F', 'CHARGES_28', sk=load_name)
                        endif
                    else
                        info_type = 'NEUM_SUIP'
                    endif
                endif
            else if (load_apply .eq. 'SUIV') then
                info_type = 'NEUM_SUIV'
            else if (load_apply .eq. 'FIXE_CSTE') then
                if (load_type(5:7) .eq. '_FO') then
                    if (l_para_inst) then
                        info_type = 'NEUM_FT'
                    else
                        info_type = 'NEUM_FO'
                    endif
                else
                    info_type = 'NEUM_CSTE'
                endif
            else if (load_apply .eq. 'DIDI') then
                call jeexin(load_name//'.CHME.CIMPO.DESC', iret_cable_cine)
                if (iret_cable_cine .eq. 0 ) then
                    call utmess('F', 'CHARGES_31', sk=load_name)
                endif
                if (load_type(5:7) .eq. '_FO') then
                    if (para_inst(1:3) .eq. 'OUI') then
                        info_type = 'NEUM_FT'
                    else
                        info_type = 'NEUM_FO'
                    endif
                else
                    info_type = 'NEUM_CSTE'
                endif
            else
                ASSERT(ASTER_FALSE)
            endif
            if (l_para_vite) then
                if (load_apply .ne. 'SUIV') then
                    call utmess('F', 'CHARGES_55', sk=load_name)
                endif
                if (l_stat) then
                    call utmess('F', 'CHARGES_56', sk=load_name)
                endif
            endif
        endif
! ----- Add load
        if (info_type .ne. 'RIEN') then
            nb_info_type = nb_info_type + 1
            ASSERT(nb_info_type.lt.nb_info_maxi)
            list_info_type(nb_info_type) = info_type
        endif
! ----- For EVOL_CHAR case
        info_type = 'RIEN'
        lchin = ligrch(1:13)//'.EVOL.CHAR'
        call jeexin(lchin, iret)
        if (iret .ne. 0) then
            if (load_apply .eq. 'SUIV') then
                info_type = 'NEUM_SUIV'
            else if (load_apply .eq. 'FIXE_CSTE') then
                info_type = 'NEUM_CSTE'
            else if (load_apply .eq. 'FIXE_PILO') then
                call utmess('F', 'CHARGES_34', sk=load_name)
            else if (load_apply .eq. 'DIDI') then
                call utmess('F', 'CHARGES_31', sk=load_name)
            else if (load_apply .eq. 'SUIV_PILO') then
                call utmess('F', 'CHARGES_34', sk=load_name)
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
! ----- Add load
        if (info_type .ne. 'RIEN') then
            nb_info_type = nb_info_type + 1
            ASSERT(nb_info_type.lt.nb_info_maxi)
            list_info_type(nb_info_type) = info_type
        endif
! ----- For EXCIT_SOL case
        info_type = 'RIEN'
        lchin = ligrch(1:13)//'.VEISS'
        call jeexin(lchin, iret)
        if (iret .ne. 0) then
            if (l_stat) then
                call utmess('F', 'CHARGES_50', sk=load_name)
            endif
            if (load_apply .eq. 'SUIV') then
                call utmess('F', 'CHARGES_51', sk=load_name)
            elseif (load_apply .eq. 'DIDI') then
                call utmess('F', 'CHARGES_52', sk=load_name)
            else if (load_apply .eq. 'FIXE_PILO') then
                call utmess('F', 'CHARGES_34', sk=load_name)
            else if (load_apply .eq. 'FIXE_CSTE') then
                if (load_type(5:6) .eq. '_F') then
                    call utmess('F', 'CHARGES_53', sk=load_name)
                endif
                info_type = 'EXCIT_SOL'
            else if (load_apply .eq. 'SUIV_PILO') then
                call utmess('F', 'CHARGES_34', sk=load_name)
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
! ----- Add load
        if (info_type .ne. 'RIEN') then
            nb_info_type = nb_info_type + 1
            ASSERT(nb_info_type.lt.nb_info_maxi)
            list_info_type(nb_info_type) = info_type
        endif
! ----- For LAPLACE case
        infc = 0
        info_type = 'RIEN'
        do i_lapl = 1, nb_lapl_maxi
            lchin(1:17) = ligrch(1:13)//'.FL1'
            call codent(i_lapl, 'D0', lchin(18:19))
            lchin = lchin(1:19)//'.DESC'
            call jeexin(lchin, iret)
            if (iret .ne. 0) then
                infc = infc + 1
            else
                exit
            endif
        end do
        if (infc .ne. 0) then
            i_neum_lapl = max(0, infc)
            info_type   = 'NEUM_LAPL'
        endif
! ----- Add load
        if (info_type .ne. 'RIEN') then
            nb_info_type = nb_info_type + 1
            ASSERT(nb_info_type.lt.nb_info_maxi)
            list_info_type(nb_info_type) = info_type
        endif
    end do
!
    call jedema()
end subroutine
