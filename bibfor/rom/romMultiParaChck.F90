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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romMultiParaChck(ds_multipara, l_base_ifs)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
#include "asterc/indik8.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnom.h"
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
aster_logical, intent(in) :: l_base_ifs
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Check data for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara     : datastructure for multiparametric problems
! In  l_base_ifs       : flag for IFS stabilization
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: syme, gran_name
    integer :: nb_matr, nb_vari_para, nb_vale_para
    integer :: nb_equa_int, nb_cmp_maxi, nume_cmp
    integer :: i_matr, i_vari_para, i_equa
    character(len=24) :: nume_dof_ref, nume_dof
    character(len=19) :: prof_chno
    integer, pointer :: v_deeq(:) => null()
    integer :: indx_cmp_p, indx_cmp_phi
    aster_logical :: present_p, present_phi
    character(len=8), pointer :: v_list_cmp(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_matr      = ds_multipara%nb_matr
    nb_vari_para = ds_multipara%nb_vari_para
!
! - Check numbering
!
    if (ds_multipara%matr_name(1) .ne. ' ') then
        call dismoi('NOM_NUME_DDL', ds_multipara%matr_name(1), 'MATR_ASSE', repk=nume_dof_ref)
        do i_matr = 2, nb_matr
            call dismoi('NOM_NUME_DDL', ds_multipara%matr_name(i_matr), 'MATR_ASSE', repk=nume_dof)
            if (nume_dof .ne. nume_dof_ref) then
                call utmess('F','ROM2_21')
            endif
        end do
    endif
!
! - Only symmetric matrix
!
    if (ds_multipara%matr_name(1) .ne. ' ') then
        do i_matr = 1, nb_matr
            call dismoi('TYPE_MATRICE', ds_multipara%matr_name(i_matr), 'MATR_ASSE', repk=syme)
            if (syme .eq. 'NON_SYM') then
                call utmess('F','ROM2_22')
            endif
        end do
    endif
!
! - If no definition of variation => no functions !
!
    if (nb_vari_para .eq. 0) then
        do i_matr = 1, nb_matr
            if (ds_multipara%matr_coef(i_matr)%l_func) then
                call utmess('F','ROM2_25', sk = ds_multipara%matr_name(i_matr))
            endif
        end do
        if (ds_multipara%vect_coef%l_func) then
            call utmess('F','ROM2_31')
        endif
    endif
!
! - Same number of values for each parameter
!
    if (nb_vari_para .ne. 0) then
        nb_vale_para = ds_multipara%vari_para(1)%nb_vale_para
        do i_vari_para = 2, nb_vari_para
            if (ds_multipara%vari_para(i_vari_para)%nb_vale_para .ne. nb_vale_para) then
                call utmess('F','ROM2_29')
            endif
        end do
    endif
!
! - Check composant PRES and PHI is in the model if we active l_base_ifs  
!    
    if (l_base_ifs) then 
! ----- Find index composant of PRES and PHI
        call dismoi('NOM_GD',     ds_multipara%vect_name, 'CHAM_NO', repk = gran_name)
        call dismoi('PROF_CHNO' , ds_multipara%vect_name, 'CHAM_NO', repk = prof_chno)
        call jeveuo(prof_chno//'.DEEQ', 'L', vi = v_deeq)
        call jeveuo(jexnom('&CATA.GD.NOMCMP', gran_name), 'L', vk8 = v_list_cmp)
        call jelira(jexnom('&CATA.GD.NOMCMP', gran_name), 'LONMAX', nb_cmp_maxi)
        indx_cmp_p   = indik8(v_list_cmp, 'PRES', 1, nb_cmp_maxi) 
        indx_cmp_phi = indik8(v_list_cmp, 'PHI', 1, nb_cmp_maxi) 
        call dismoi('NB_EQUA',    ds_multipara%matr_name(1), 'MATR_ASSE', repi = nb_equa_int)
! ----- Check composant PRES and PHI in the problem
        present_p   = ASTER_FALSE
        present_phi = ASTER_FALSE
        do i_equa = 1, nb_equa_int
            nume_cmp = v_deeq(2*(i_equa-1)+2)
            if (nume_cmp .eq. indx_cmp_p) then 
                present_p = ASTER_TRUE
            else if (nume_cmp .eq. indx_cmp_phi) then
                present_phi = ASTER_TRUE
            end if 
        end do
        if (.not. present_p .and. .not. present_phi) then
            call utmess('F', 'ROM2_30')
        endif
    end if 
!
end subroutine
