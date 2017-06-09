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

subroutine ccchcf(name_form, nb_val_in, val_in, cmp_in, nb_cmp_out,&
                  val_out, ichk)
!
    implicit none
!
#include "asterfort/fointe.h"
!
! person_in_charge: mathieu.courtois at edf.fr
!
    integer, intent(in) :: nb_cmp_out
    character(len=8), intent(in) :: name_form(nb_cmp_out)
    integer, intent(in) :: nb_val_in
    real(kind=8), intent(in) :: val_in(nb_val_in)
    character(len=8), intent(in) :: cmp_in(nb_val_in)
    real(kind=8), intent(out) :: val_out(nb_cmp_out)
    integer, intent(out) :: ichk
!
! --------------------------------------------------------------------------------------------------
!
! CALC_CHAMP - CHAM_UTIL
!
! Compute FORMULE
!
! --------------------------------------------------------------------------------------------------
!
! In  name_form  : names of formulas
! In  nb_val_in  : number of input values
! In  val_in     : input values
! In  cmp_in     : name of input components
! In  nb_cmp_out : number of output values
! Out val_out    : output values
! Out ichk       : 0 if OK
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i
    character(len=1) :: codmes
    character(len=8) :: nomf
!
! --------------------------------------------------------------------------------------------------
!
!
! - Initializations
!
    ichk = 1
!     METTRE 'A' POUR DEBUG, ' ' EN PROD
    codmes = 'A'
    if (nb_val_in .eq. 0) goto 999
!
! - Evaluate formulas
!
    do i = 1, nb_cmp_out
        nomf = name_form(i)
        call fointe(codmes, nomf, nb_val_in, cmp_in, val_in,&
                    val_out(i), ichk)
        if (ichk .ne. 0) goto 999
    end do
!
999 continue
!
end subroutine
