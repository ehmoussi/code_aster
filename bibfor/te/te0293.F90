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

subroutine te0293(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
!
    character(len=16) :: option, nomte
! person_in_charge: josselin.delmas at edf.fr
!
!     BUT:
!         CALCUL DES VECTEURS ELEMENTAIRES
!         OPTION : 'SECM_ZZ1'
!
! ......................................................................
!
!
!
!
    integer :: i, ij, j, k, kp, nno, nnos, npg, ndim
    integer :: ipoids, ivf, idfde, jgano, igeom, imattt
!
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), poids, r
!
    aster_logical :: laxi
!
! ----------------------------------------------------------------------
!
    call elrefe_info(fami='MASS', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATZZR', 'E', imattt)
!
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
    do 10 kp = 1, npg
        k=(kp-1)*nno
        if (ndim .eq. 2) then
            call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy)
        else
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, dfdx, dfdy, dfdz)
        endif
!
        if (laxi) then
            r = 0.d0
            do 20 i = 1, nno
                r = r + zr(igeom+2*(i-1))*zr(ivf+k+i-1)
 20         continue
            poids = poids*r
        endif
!
        ij = imattt - 1
        do 30 i = 1, nno
            do 30 j = 1, i
                ij = ij + 1
                zr(ij) = zr(ij) + poids * zr(ivf+k+i-1) * zr(ivf+k+j- 1)
 30         continue
 10 end do
!
end subroutine
