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
subroutine romGreedyAlgoInit(nb_mode, nb_vari_coef, vect_refe, ds_algoGreedy)
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
integer, intent(in) :: nb_mode, nb_vari_coef
character(len=19), intent(in) :: vect_refe 
type(ROM_DS_AlgoGreedy), intent(in) :: ds_algoGreedy
!
! --------------------------------------------------------------------------------------------------
!
! Greedy algorithm
!
! Init algorithm
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_mode          : number of empirical modes
! In  nb_vari_coef     : number of coefficients to vary
! In  vect_refe        : reference vector to create residual vector
! In  ds_algoGreedy    : datastructure for Greedy algorithm
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
    call wkvect(ds_algoGreedy%coef_redu, 'V V '//ds_algoGreedy%resi_type, nb_mode*nb_vari_coef,&
                jv_dummy)
    call copisd('CHAMP_GD', 'V', vect_refe, ds_algoGreedy%resi_vect)
    AS_ALLOCATE(vr = ds_algoGreedy%resi_norm, size = nb_vari_coef+1)
!
end subroutine
