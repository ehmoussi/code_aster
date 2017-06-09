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

subroutine detlsp(matasz, solvez)
!
    implicit      none
#include "jeveux.h"
#include "asterfort/amumph.h"
#include "asterfort/crsmsp.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: matasz, solvez
!
! ----------------------------------------------------------------------
!
!  DETRUIRE LES INSTANCES MUMPS DU PRECONDITIONNEUR LDLT_SP
!  ***                                              *    **
!
! ----------------------------------------------------------------------
!
! IN  MATASS : MATRICE ASSEMBLEE
! IN  SOLVEU : SD SOLVEUR
!
!
!
!
    character(len=19) :: solveu, matass
    character(len=24) :: metres, precon, solvbd, usersmbd
    integer ::  iret, pcpivbd
    real(kind=8) :: r8bid=0.d0
    complex(kind=8) :: c16bid=dcmplx(0.d0,0.d0)
    character(len=24), pointer :: slvk(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    solveu = solvez
    matass = matasz
!
    call jeveuo(solveu//'.SLVK', 'L', vk24=slvk)
    metres = slvk(1)
    if (metres .eq. 'PETSC' .or. metres .eq. 'GCPC') then
        precon = slvk(2)
        if (precon .eq. 'LDLT_SP') then
            solvbd = slvk(3)
            pcpivbd = 0
            usersmbd = 'XXXX'
            call crsmsp(solvbd, matass, pcpivbd, usersmbd)
            call amumph('DETR_MAT', solvbd, matass, [r8bid], [c16bid],&
                        ' ', 0, iret, .true._1)
            call detrsd('SOLVEUR', solvbd)
        endif
    endif
!
    call jedema()
!
end subroutine
