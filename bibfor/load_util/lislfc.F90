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
subroutine lislfc(list_load_resu, i_load      , i_excit   , l_load_user,&
                  l_func_c      , load_keyword, const_func, load_func)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterc/getexm.h"
#include "asterfort/codent.h"
#include "asterfort/focstc.h"
#include "asterfort/focste.h"
#include "asterfort/getvc8.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
!
character(len=19), intent(in) :: list_load_resu
integer, intent(in) :: i_load, i_excit
aster_logical, intent(in) :: l_load_user, l_func_c
character(len=16), intent(in) :: load_keyword
character(len=8), intent(inout) :: const_func
character(len=8), intent(out) :: load_func
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Get function applied to load
!
! --------------------------------------------------------------------------------------------------
!
! In  list_load_resu : name of datastructure for list of loads from result datastructure
! In  i_load         : index in list of loads
! In  i_excit        : index in factor keyword for current load
! In  l_load_user    : .true. if loads come from user (command file)
! In  l_func_c       : .true. if loads must been complex
! In  load_keyword   : factor keyword to read loads
!                      'None' => no load to read
!                      'EXCIT' or ' ' => depending on command
! IO  const_func     : constant function
! Out load_func      : name of function
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_func_c, nb_func_r
    integer :: nb_coef_c, nb_coef_r
    integer :: i_coef_a
    character(len=4) :: knum
    complex(kind=8) :: coef_c
    real(kind=8) :: coef_r, coef_imag
    character(len=19) :: nomf19
    integer :: iret
    aster_logical :: l_func_r
    integer, pointer :: v_llresu_info(:) => null()
    character(len=24), pointer :: v_llresu_name(:) => null()
    character(len=24), pointer :: v_llresu_func(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    load_func = ' '
    l_func_r  = .not. l_func_c
!
! - Access to saved list of loads datastructure
!
    if (.not.l_load_user) then
        call jeveuo(list_load_resu(1:19)//'.INFC', 'L', vi   = v_llresu_info)
        call jeveuo(list_load_resu(1:19)//'.LCHA', 'L', vk24 = v_llresu_name)
        call jeveuo(list_load_resu(1:19)//'.FCHA', 'L', vk24 = v_llresu_func)
    endif
!
! - For complex function
!
    if (l_func_c) then
        call getvid(load_keyword, 'FONC_MULT_C', iocc=i_load, scal=load_func, nbret=nb_func_c)
        call getvid(load_keyword, 'FONC_MULT'  , iocc=i_load, scal=load_func, nbret=nb_func_r)
        if ((nb_func_c.eq.0) .and. (nb_func_r.eq.0)) then
            call codent(i_load, 'D0', knum)
            load_func = '&&NC'//knum
            call getvc8(load_keyword, 'COEF_MULT_C', iocc=i_load, scal=coef_c, nbret=nb_coef_c)
            if (nb_coef_c .eq. 0) then
                call getvr8(load_keyword, 'COEF_MULT', iocc=i_load, scal=coef_r, nbret=nb_coef_r)
                ASSERT(nb_coef_r.eq.0)
                call focste(load_func, 'TOUTRESU', coef_r, 'V')
            else
                coef_r    = dble ( coef_c )
                coef_imag = dimag( coef_c )
                call focstc(load_func, 'TOUTRESU', coef_r, coef_imag, 'V')
            endif
        endif
    endif
!
! - For real function
!
    if (l_func_r) then
! ----- Detect real coefficient for function
        nb_func_r = 0
        if (l_load_user) then
            if (getexm(load_keyword,'FONC_MULT') .eq. 1) then
                call getvid(load_keyword, 'FONC_MULT', iocc=i_excit, nbval = 0, nbret=nb_func_r)
            endif
        else
            if (v_llresu_func(i_load)(1:1) .eq. '&') then
                nb_func_r = 0
            else
                nb_func_r = 1
            endif
        endif
! ----- Detect 'ACCE' coefficient for function
        i_coef_a = 0
        if (l_load_user) then
            if (getexm(load_keyword,'ACCE') .eq. 1) then
                call getvid(load_keyword, 'ACCE', iocc=i_excit, nbval = 0, nbret=i_coef_a)
            endif
        endif
! ----- Create constant function
        if (nb_func_r .eq. 0 .and. i_coef_a .eq. 0) then
            nomf19 = const_func
            call jeexin(nomf19//'.PROL', iret)
            if (iret .eq. 0) then
                coef_r = 1.d0
                call focste(const_func, 'TOUTRESU', coef_r, 'V')
            endif
            load_func = const_func
        else
            if (nb_func_r .ne. 0) then
                if (l_load_user) then
                    if (getexm(load_keyword,'FONC_MULT') .eq. 1) then
                        call getvid(load_keyword, 'FONC_MULT',iocc=i_excit, scal=load_func)
                    endif
                else
                    load_func = v_llresu_func(i_load)(1:8)
                endif
            endif
            if (i_coef_a .ne. 0) then
                call getvid(load_keyword, 'ACCE', iocc=i_excit, scal=load_func)
            endif
        endif
    endif
!
end subroutine
