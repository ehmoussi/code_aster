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

subroutine nmimrv(ds_print, list_func_acti, iter_newt, line_sear_coef, line_sear_iter,&
                  eta)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/isfonc.h"
#include "asterfort/nmimci.h"
#include "asterfort/nmimck.h"
#include "asterfort/nmimcr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Print), intent(inout) :: ds_print
    integer, intent(in) :: list_func_acti(*)
    integer, intent(in) :: iter_newt
    real(kind=8), intent(in) :: line_sear_coef
    integer, intent(in) :: line_sear_iter
    real(kind=8), intent(in) :: eta
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Print management
!
! Set value of informations in convergence table (residuals are in nmimre)
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_print         : datastructure for printing parameters
! In  list_func_acti   : list of active functionnalities
! In  iter_newt        : index of current Newton iteration
! In  line_sear_coef   : coefficient for line search
! In  line_sear_iter   : number of iterations for line search
! In  eta              : coefficient for pilotage (continuation)
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_line_search, l_pilo, l_deborst
!
! --------------------------------------------------------------------------------------------------
!
    l_deborst     = isfonc(list_func_acti,'DEBORST')
    l_pilo        = isfonc(list_func_acti,'PILOTAGE')
    l_line_search = isfonc(list_func_acti,'RECH_LINE')
!
! - Set values for line search
!
    if (l_line_search .and. (iter_newt.ne.0)) then
        call nmimci(ds_print, 'RELI_NBIT', line_sear_iter, .true._1)
        call nmimcr(ds_print, 'RELI_COEF', line_sear_coef, .true._1)
    endif
!
! - Set value for pilotage
!
    if (l_pilo) then
        call nmimcr(ds_print, 'PILO_COEF', eta, .true._1)
    endif
!
! - Set value for De Borst method (plane stress)
!
    if (l_deborst) then
        call nmimck(ds_print, 'DEBORST  ', 'DE BORST...', .true._1)
    endif
!
end subroutine
