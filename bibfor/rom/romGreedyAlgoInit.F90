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

subroutine romGreedyAlgoInit(syst_type , nb_mode   , nb_vari_coef,&
                             vect_refe , ds_para_rb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_allocate.h"
#include "asterfort/infniv.h"
#include "asterfort/copisd.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=1), intent(in) :: syst_type
    integer, intent(in) :: nb_mode
    integer, intent(in) :: nb_vari_coef
    character(len=19), intent(in) :: vect_refe
    type(ROM_DS_ParaDBR_RB), intent(inout) :: ds_para_rb
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Init algorithm
!
! --------------------------------------------------------------------------------------------------
!
! In  syst_type        : global type of system (real or complex)
! In  nb_mode          : number of empirical modes
! In  nb_vari_coef     : number of coefficients to vary
! In  vect_refe        : reference vector to create residual vector
! IO  ds_para_rb       : datastructure for parameters (RB)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: jv_dummy
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_42')
    endif
!
    ds_para_rb%coef_redu  = '&&OP0053.COEF_REDU'
    ds_para_rb%resi_type  = syst_type
    ds_para_rb%resi_vect  = '&&OP0053.RESI_VECT'
    call wkvect(ds_para_rb%coef_redu, 'V V '//syst_type, nb_mode * nb_vari_coef, jv_dummy)
    call copisd('CHAMP_GD', 'V', vect_refe, ds_para_rb%resi_vect)
    call copisd('CHAMP_GD', 'V', vect_refe, ds_para_rb%vect_2mbr_init)
    AS_ALLOCATE(vr = ds_para_rb%resi_norm, size = nb_vari_coef+1)
!
end subroutine
