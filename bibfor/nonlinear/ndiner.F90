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
subroutine ndiner(nb_equa, sddyna, hval_incr, hval_measse, cniner)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
#include "asterfort/ndynre.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtzero.h"
#include "blas/dscal.h"
!
integer, intent(in) :: nb_equa
character(len=19), intent(in) :: sddyna
character(len=19), intent(in) :: hval_incr(*), hval_measse(*)
character(len=19), intent(in) :: cniner
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute inertial force
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_equa          : total number of equations
! In  sddyna           : datastructure for dynamic
! In  hval_incr        : hat-variable for incremental values fields
! In  hval_measse      : hat-variable for matrix
! In  cniner           : name of field for inertia force
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: jv_matr_mass
    real(kind=8) :: coef_iner
    character(len=19) :: vite_curr, matr_mass
    real(kind=8), pointer :: v_iner(:) => null()
    real(kind=8), pointer :: v_vite_prev(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> CALCUL DES FORCES D''INERTIE'
    endif
!
! - Get hat variables
!
    call nmchex(hval_incr  , 'VALINC', 'VITPLU', vite_curr)
    call nmchex(hval_measse, 'MEASSE', 'MEMASS', matr_mass)
!
! - Initializations
!
    call vtzero(cniner)
    coef_iner = ndynre(sddyna,'COEF_FORC_INER')
!
! --- ACCES SD
!
    call jeveuo(matr_mass(1:19)//'.&INT', 'L', jv_matr_mass)
    call jeveuo(cniner(1:19)//'.VALE'   , 'E', vr=v_iner)
    call jeveuo(vite_curr(1:19)//'.VALE', 'L', vr=v_vite_prev)
!
! - Compute
!
    call mrmult('ZERO', jv_matr_mass, v_vite_prev, v_iner, 1, ASTER_TRUE)
    call dscal(nb_equa, coef_iner, v_iner, 1)
!
! - Debug
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cniner, ifm)
    endif
!
end subroutine
