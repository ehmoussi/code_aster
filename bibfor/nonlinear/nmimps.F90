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

subroutine nmimps(ds_print, ds_conv, sderro)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmerge.h"
#include "asterfort/GetResi.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Print), intent(in) :: ds_print
    type(NL_DS_Conv), intent(in) :: ds_conv
    character(len=24), intent(in) :: sderro
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Print residuals summary at end of step
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_print         : datastructure for printing parameters
! In  ds_conv          : datastructure for convergence management
! In  sderro           : name of datastructure for error management (events)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_resi, nb_resi
    real(kind=8) :: valr(2)
    character(len=16) :: valk(2)
    aster_logical :: lprint, l_swap_rela_maxi, l_swap_comp_rela
!
! --------------------------------------------------------------------------------------------------
!
    nb_resi = ds_conv%nb_resi
!
! - Messages from convergence swapping
!
    call nmerge(sderro, 'RESI_MAXR', l_swap_rela_maxi)
    call nmerge(sderro, 'RESI_MAXN', l_swap_comp_rela)
!
! - Print for this step ?
!
    lprint = ds_print%l_print
!
! - Print residuals summary
!
    if (lprint) then
        call utmess('I', 'MECANONLINE6_60')
        if (l_swap_comp_rela) then
            call utmess('I', 'MECANONLINE6_61')
            call utmess('I', 'MECANONLINE2_96')
        endif
        if (l_swap_rela_maxi) then
            call utmess('I', 'MECANONLINE6_62')
            call GetResi(ds_conv, type = 'RESI_GLOB_MAXI' , user_para_ = valr(2))
            valr(1) = ds_conv%swap_trig
            call utmess('I', 'MECANONLINE2_98', nr=2, valr=valr)
        endif
        do i_resi = 1, nb_resi
            if (ds_conv%l_resi_test(i_resi)) then
                valk(1) = ds_conv%list_resi(i_resi)%type
                valk(2) = ds_conv%list_resi(i_resi)%locus_calc
                valr(1) = ds_conv%list_resi(i_resi)%vale_calc
                call utmess('I', 'MECANONLINE6_70', nk=2, valk=valk, sr=valr(1))
            endif
        end do
    endif
!
end subroutine
