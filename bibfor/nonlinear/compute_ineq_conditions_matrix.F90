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

subroutine compute_ineq_conditions_matrix(enat  , nbliai, japptr, &
                                          japcoe, jjeux , jtacf , &
                                          njeux , ztacf )
!
!
    implicit     none
#include "jeveux.h"
!
#include "asterc/r8prem.h"
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/r8inir.h"
#include "blas/daxpy.h"
    character(len=24) :: enat
    integer :: nbliai
    integer :: japptr, japcoe, jjeux, jtacf, njeux, ztacf
!
! ----------------------------------------------------------------------
!
    integer :: ndlmax
    parameter   (ndlmax = 30)
    real(kind=8) :: jeuini
    real(kind=8) :: coefpn, xmu
    integer :: iliai
    integer :: jenat
    integer :: nbddl, jdecal
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- CALCUL DE LA MATRICE DE CONTACT PENALISEE
!
    do iliai = 1, nbliai
        jdecal = zi(japptr+iliai-1)
        nbddl = zi(japptr+iliai) - zi(japptr+iliai-1)
        jeuini = zr(jjeux+njeux*(iliai-1)+1-1)
        coefpn = zr(jtacf+ztacf*(iliai-1)+1)
        call jeveuo(jexnum(enat, iliai), 'E', jenat)
        call r8inir(ndlmax, 0.d0, zr(jenat), 1)
        if (jeuini .lt. r8prem()) then
            xmu = sqrt(coefpn)
            call daxpy(nbddl, xmu, zr(japcoe+jdecal), 1, zr(jenat),&
                       1)
        endif
        call jelibe(jexnum(enat, iliai))
     enddo
!
    call jedema()
!
end subroutine
