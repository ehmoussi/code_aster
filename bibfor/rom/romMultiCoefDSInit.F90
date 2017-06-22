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

subroutine romMultiCoefDSInit(object_type, ds_multicoef)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=1), intent(in)       :: object_type
    type(ROM_DS_MultiCoef), intent(out) :: ds_multicoef
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialisation of datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
! In  object_type      : type of object (VECT or MATR)
! Out ds_multicoef     : datastructure for multiparametric problems - Coefficients
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        if (object_type .eq. 'V') then
            call utmess('I', 'ROM5_90')
        elseif (object_type .eq. 'M') then
            call utmess('I', 'ROM5_91')
        else
            ASSERT(.false.)
        endif
    endif
!
    ds_multicoef%l_func         = .false.
    ds_multicoef%l_cste         = .false.
    ds_multicoef%l_cplx         = .false.
    ds_multicoef%l_real         = .false.
    ds_multicoef%func_name      = ' '
    ds_multicoef%coef_cste_cplx = dcmplx(0.d0, 0.d0)
    ds_multicoef%coef_cste_real = 0.d0
    ds_multicoef%coef_cplx      => null()
    ds_multicoef%coef_real      => null()
!
end subroutine
