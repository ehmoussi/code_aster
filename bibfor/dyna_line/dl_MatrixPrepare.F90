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
!
subroutine dl_MatrixPrepare(l_harm    , l_damp    , l_damp_modal, l_impe    , resu_type,&
                            matr_mass_, matr_rigi_, matr_damp_  , matr_impe_,&
                            nb_matr   , matr_list , coef_type   , coef_vale ,&
                            matr_resu)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mtdefs.h"
#include "asterfort/mtdscr.h"
!
aster_logical, intent(in) :: l_harm, l_damp, l_damp_modal, l_impe
character(len=1), intent(in) :: resu_type
character(len=*), intent(in) :: matr_mass_, matr_rigi_, matr_damp_, matr_impe_
integer, intent(out) :: nb_matr
character(len=24), intent(out) :: matr_list(*)
character(len=1), intent(out) :: coef_type(*)
real(kind=8), intent(out) :: coef_vale(*)
character(len=8), intent(out) :: matr_resu
!
! --------------------------------------------------------------------------------------------------
!
! Linear dynamic (DYNA_VIRA)
!
! Prepare matrix container (linear combination)
!
! --------------------------------------------------------------------------------------------------
!
! In  l_harm           : flag for harmonic analysis
! In  l_damp           : flag if damping
! In  l_damp_modal     : flag if modal damping
! In  l_impe           : flag for impedance
! In  resu_type        : type of resultant matrix
! In  matr_rigi        : matrix of rigidity
! In  matr_mass        : matrix of mass
! In  matr_damp        : matrix of damping
! In  matr_impe        : matrix of impedance
! Out nb_matr          : number of matrixes in linear combination
! Out matr_list        : list of matrixes in linear combination
! Out coef_type        : type of coefficient (R ou C) for each matrix in linear combination
! Out coef_vale        : value of coefficient for each matrix in linear combination
! Out matr_resu        : resultant matrix of linear combination
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: matr_refe
    character(len=24), pointer :: v_refa(:) => null()
    aster_logical :: l_syme
    character(len=19) :: matr_mass, matr_rigi, matr_damp, matr_impe
!
! --------------------------------------------------------------------------------------------------
!
    matr_resu = '&&KTILD'
    nb_matr   = 0
    matr_mass = matr_mass_
    matr_rigi = matr_rigi_
    matr_damp = matr_damp_
    matr_impe = matr_impe_
!
! - Symmetric or not ?
!
    l_syme    = ASTER_TRUE
    matr_refe = matr_rigi
    if (l_damp) then
        call mtdscr(matr_damp)
        call jeveuo(matr_damp//'.REFA', 'L', vk24 = v_refa)
        if (v_refa(9) .eq. 'MR') then
            l_syme    = ASTER_FALSE
            matr_refe = matr_damp
        endif
    endif
!
    if (l_impe) then
        call mtdscr(matr_impe)
        call jeveuo(matr_impe//'.REFA', 'L', vk24 = v_refa)
        if (v_refa(9) .eq. 'MR') then
            l_syme    = ASTER_FALSE
            matr_refe = matr_impe
        endif
    endif
!
    call jeveuo(matr_rigi//'.REFA', 'L', vk24 = v_refa)
    call mtdscr(matr_rigi)
    if (v_refa(9) .eq. 'MR') then
        l_syme    = ASTER_FALSE
        matr_refe = matr_rigi
    endif
!
    call jeveuo(matr_mass//'.REFA', 'L', vk24 = v_refa)
    call mtdscr(matr_mass)
    if (v_refa(9) .eq. 'MR') then
        l_syme    = ASTER_FALSE
        matr_refe = matr_mass
    endif
!
! - Prepare matrix container
!
    call mtdefs(matr_resu, matr_refe, 'V', resu_type)
    call mtdscr(matr_resu)
!
! - Prepare linear combination
!
    if (l_harm) then
        matr_list(1) = matr_rigi
        coef_type(1) = 'R'
        coef_vale(1) = 1.d0
        nb_matr  = nb_matr + 1
        matr_list(2) = matr_mass
        coef_type(2) = 'R'
        coef_vale(2) = 0.d0
        nb_matr  = nb_matr + 1
        if (l_damp .or. l_damp_modal) then
            nb_matr  = nb_matr + 1
            matr_list(nb_matr) = matr_damp
            coef_type(nb_matr) = 'C'
            coef_vale(nb_matr) = 0.d0
        endif
        if (l_impe) then
            nb_matr  = nb_matr + 1
            matr_list(nb_matr) = matr_impe
            coef_type(nb_matr) = 'C'
            coef_vale(nb_matr) = 0.d0
        endif
    else
        coef_type(1) = 'R'
        coef_vale(1) = 1.d0
        matr_list(1) = matr_rigi
        coef_type(2) = 'R'
        coef_vale(2) = 0.d0
        matr_list(2) = matr_mass
        nb_matr  = 2
        if (l_damp) then
            coef_type(3) = 'R'
            coef_vale(3) = 0.d0
            matr_list(3) = matr_damp
            nb_matr = 3
        endif
        ASSERT(.not.l_impe)
        ASSERT(.not.l_damp_modal)
    endif
!
end subroutine
