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
! --------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romAlgoNLCorrEFMatrixModify(nume_dof, matr_asse, ds_algorom)
!
use Rom_Datastructure_type
!
implicit none
!
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mtdsc2.h"
!
    character(len=24)    , intent(in) :: nume_dof
    character(len=19)    , intent(in) :: matr_asse
    type(ROM_DS_AlgoPara), intent(in) :: ds_algorom
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Solving non-linear problem
!
! Modification of matrix for EF correction
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_dof         : numbering dof
! In  matr_asse        : global matrix
! In  ds_algorom       : datastructure for ROM parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_equa
    integer :: nb_equa_init, nb_equa
    character(len=8) :: kmatd
    integer :: jv_sxdi
    real(kind=8) :: vale_pena
    integer, pointer :: v_int(:) => null()
    real(kind=8), pointer :: v_valm(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get parameters
!
    call dismoi('MATR_DISTR', matr_asse, 'MATR_ASSE', repk=kmatd)
    call dismoi('NB_EQUA'   , nume_dof , 'NUME_DDL' , repi=nb_equa_init)
    vale_pena = ds_algorom%vale_pena
!
! - Get diagonal
!
    call mtdsc2(matr_asse, 'SXDI', 'L', jv_sxdi)
!
! - Total number of equation
!
    if (kmatd .eq. 'OUI') then
        call jeveuo(matr_asse//'.&INT', 'L', vi = v_int)
        nb_equa = v_int(6)
    else
        nb_equa = nb_equa_init
    endif
!
! - Access to values
!
    call jeveuo(jexnum(matr_asse//'.VALM', 1), 'E', vr = v_valm)
    do i_equa = 1, nb_equa
        if (ds_algorom%v_equa_sub(i_equa) .eq. 1) then
            if (ds_algorom%v_equa_int(i_equa) .eq. 1) then
                v_valm(zi(jv_sxdi-1+i_equa)) = vale_pena*v_valm(zi(jv_sxdi-1+i_equa))
            else
                v_valm(zi(jv_sxdi-1+i_equa)) = sqrt(vale_pena)*v_valm(zi(jv_sxdi-1+i_equa))
            endif
        endif
    enddo
!
end subroutine
