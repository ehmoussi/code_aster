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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine dbr_calcpod_rate(s, nb_sing, rate)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/utmess.h"
#include "asterc/r8prem.h"
!
real(kind=8), pointer, intent(in) :: s(:)
integer, intent(in) :: nb_sing
real(kind=8), intent(out) :: rate
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Compute singular value decay rate
!
! --------------------------------------------------------------------------------------------------
!
! In  field_iden       : identificator of field (name in results datastructure)
! In  ds_para_pod      : datastructure for parameters (POD)
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
real(kind=8), dimension(nb_sing):: N, Y
integer :: i, nb_pos
!
!
!

i = 1
do while ( i<=nb_sing .and. s(i)> r8prem())
    N(i) = log(real(i))
    Y(i) = log(s(i))
    i = i + 1
end do
nb_pos = i - 1

!

rate = ( nb_sing * dot_product(Y(1:nb_pos),N(1:nb_pos)) - sum(Y(1:nb_pos)) * sum(N(1:nb_pos)) ) /&
       ( nb_sing * dot_product(N(1:nb_pos),N(1:nb_pos)) - sum(N(1:nb_pos))**2 )

call utmess('I', 'ROM7_33' , sr = rate)

!
end subroutine
