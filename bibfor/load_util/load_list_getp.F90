! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine load_list_getp(phenom     , l_load_user , v_llresu_info, v_llresu_name,&
                          v_list_dble, load_keyword, i_load       , nb_load      ,&
                          i_excit    , load_name   , load_type    , ligrch       ,&
                          load_apply_)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
character(len=4), intent(in) :: phenom
aster_logical, intent(in) :: l_load_user
character(len=8), pointer :: v_list_dble(:)
integer, pointer :: v_llresu_info(:)
character(len=24), pointer :: v_llresu_name(:)
character(len=16), intent(in) :: load_keyword
integer, intent(in) :: i_load
integer, intent(in) :: nb_load
integer, intent(inout) :: i_excit
character(len=8), intent(out) :: load_name
character(len=8), intent(out) :: load_type
character(len=19), intent(out) :: ligrch
character(len=16), optional, intent(out) :: load_apply_
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Get parameters for construct list of loads
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom         : phenomenon (MECA/THER/ACOU)
! In  l_load_user    : .true. if loads come from user (EXCIT)
! In  v_llresu_info  : pointer for loads infos for list of loads from result datastructure
! In  v_llresu_name  : pointer for loads names for list of loads from result datastructure
! In  v_list_dble    : pointer to list of loads (to avoid same loads)
! In  load_keyword   : factor keyword to read loads
!                      'None' => no load to read
!                      'EXCIT' or ' ' => depending on command
! In  i_load         : index in list of loads
! In  nb_load        : number of loads for list of loads
! IO  i_excit        : index in factor keyword for current load
! Out load_name      : name of load
! Out load_type      : type of load
! Out load_apply     : how to apply load
! Out ligrch         : LIGREL (list of elements) where apply load
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: load_apply, load_pheno
    integer :: i_load_dble, nocc
    character(len=8), pointer :: list_load(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    load_name  = ' '
    load_type  = ' '
    load_apply = 'FIXE_CSTE'
    ligrch     = ' '
    ASSERT(load_keyword .ne. 'None')
!
! - Current index to read load
!
    if (l_load_user) then
        i_excit = i_excit + 1
30      continue
        call getvid(load_keyword, 'CHARGE', iocc = i_excit, nbval=0, nbret=nocc)
        if (nocc .eq. 0) then
            i_excit = i_excit + 1
            goto 30
        endif
    endif
!
! - Get name of current load
!
    if (l_load_user) then
        if (load_keyword .eq. ' ') then
            AS_ALLOCATE(vk8 = list_load, size = nb_load)
            call getvid(load_keyword, 'CHARGE', nbval = nb_load, vect=list_load)
            load_name = list_load(i_load)
            AS_DEALLOCATE(vk8 = list_load)
        else
            call getvid(load_keyword, 'CHARGE', iocc = i_excit, scal=load_name)
        endif
    else
        load_name = v_llresu_name(i_load)(1:8)
    endif
!
! - Only one load in the list
!
    do i_load_dble = 1, nb_load
        if (load_name .eq. v_list_dble(i_load_dble)) then
            call utmess('F', 'CHARGES_1', sk=load_name)
        endif
    end do
!
! - Save load name
!
    v_list_dble(i_load) = load_name
!
! - Get LIGREL
!
    if (phenom.eq.'MECA') then
        ligrch = load_name//'.CHME.LIGRE'
    elseif (phenom.eq.'THER') then
        ligrch = load_name//'.CHTH.LIGRE'
    else
        ASSERT(.false.)
    endif
!
! - Type of load
!
    call dismoi('TYPE_CHARGE', load_name, 'CHARGE', repk=load_type)
!
! - Check phenomenon
!
    call dismoi('PHENOMENE'  , load_name, 'CHARGE', repk=load_pheno)
    if (phenom.eq.'MECA') then
        if (load_pheno.ne.'MECANIQUE') then
            call utmess('F', 'CHARGES_22', sk=load_name)
        endif
    elseif (phenom.eq.'THER') then        
        if (load_pheno.ne.'THERMIQUE') then
            call utmess('F', 'CHARGES_21', sk=load_name)
        endif
    else
        ASSERT(.false.)
    endif
!
! - Type of applying load
!
    if (phenom.eq.'MECA') then
        ASSERT(present(load_apply_))
        if (l_load_user) then
            if (getexm(load_keyword,'TYPE_CHARGE') .eq. 1) then            
                call getvtx(load_keyword, 'TYPE_CHARGE', iocc=i_excit, scal=load_apply)
            else
                load_apply = 'FIXE_CSTE'
            endif
        else
            if (load_keyword .eq. ' ') then
                load_apply = 'FIXE_CSTE'
            else
                if (v_llresu_info(i_load+1) .eq. 4 .or.&
                    v_llresu_info(1+nb_load+i_load) .eq. 4) then
                    load_apply = 'SUIV'
                elseif (v_llresu_info(i_load+1) .eq. 5 .or.&
                        v_llresu_info(1+nb_load+i_load) .eq. 5) then
                    load_apply = 'FIXE_PILO'
                else if (v_llresu_info(1+3*nb_load+2+i_load) .eq. 1) then
                    load_apply = 'DIDI'
                else
                    load_apply = 'FIXE_CSTE'
                endif
            endif
        endif
    elseif (phenom.eq.'THER') then
        ASSERT(.not.present(load_apply_))        
    else
        ASSERT(.false.)
    endif
    if (present(load_apply_)) then
        load_apply_ = load_apply
    endif
!
end subroutine
