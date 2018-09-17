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

subroutine delete_matrix(matas)
use elim_lagr_data_module
!
#include "asterf_types.h"
!
! person_in_charge: nicolas.sellenet at edf.fr
!
    implicit none
    character(len=19) :: matas
!
#include "jeveux.h"
#include "asterfort/jeexin.h"
#include "asterfort/dismoi.h"
#include "asterfort/amumph.h"
#include "asterfort/apetsc.h"
    integer :: iexi, ibid, iret
    complex(kind=8) :: cbid
    character(len=8) :: metres
    aster_logical :: lbid
    cbid = dcmplx(0.d0, 0.d0)
!
!----------------------------------------------------------------
!
!  DELETE MATRIX FOR MUMPS AND PETSC
!
!----------------------------------------------------------------
!
    call jeexin(matas//'.REFA', iexi)
    if (iexi .gt. 0) then
        call dismoi('METH_RESO', matas, 'MATR_ASSE', repk=metres)
        if (metres .eq. 'MUMPS') then
            call amumph('DETR_MAT', ' ', matas, [0.d0], [cbid],&
                        ' ', 0, ibid, lbid)
        else if (metres.eq.'PETSC') then
            call apetsc('DETR_MAT', ' ', matas, [0.d0], ' ',&
                        0, ibid, iret)
        endif
        call elg_gest_data('EFFACE', ' ', matas, ' ')
    endif
!
end subroutine
