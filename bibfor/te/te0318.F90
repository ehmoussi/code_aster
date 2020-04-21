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
!
subroutine te0318(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
! CALCUL DU FLUX AU CARRE AUX POINTS DE GAUSS
! ELEMENTS ISOPARAMETRIQUES 2D/2D AXI  OPTION : 'SOUR_ELGA '
!
!
! IN  OPTION : OPTION DE CALCUL
! IN  NOMTE  : NOM DU TYPE ELEMENT
!
!
!
    integer :: icodre(2), kpg, spt
    character(len=8) :: fami, poum
    character(len=16) :: nomres(2)
    character(len=32) :: phenom
    real(kind=8) :: dfdx(9), dfdy(9), tpg, poids, lambda, a, b
    real(kind=8) :: valres(2), fluxx, fluxy
    integer :: ndim, nno, nnos, kp, j, k, itempe, itemp, iflux
    integer :: ipoids, ivf, idfde, igeom, imate, npg, jgano
! DEB ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemp)
    call jevech('PTEMPER', 'L', itempe)
    call jevech('PSOUR_R', 'E', iflux)
!
    call rccoma(zi(imate), 'THER', 1, phenom, icodre(1))
!
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
    if (phenom .eq. 'THER') then
        nomres(1) = 'LAMBDA'
        call rcvalb(fami, kpg, spt, poum, zi(imate),&
                    ' ', phenom, 1, 'INST', [zr(itemp)],&
                    1, nomres, valres, icodre, 1)
        lambda = valres(1)
    else if (phenom.eq.'THER_ORTH') then
        call utmess('F', 'ELEMENTS2_67')
    else if (phenom.eq.'THER_NL_ORTH') then
        call utmess('F', 'ELEMENTS2_67')
    else if (phenom.ne.'THER_NL') then
        call utmess('F', 'ELEMENTS2_63')
    endif
!
    a = 0.d0
    b = 0.d0
!
    do kp = 1, npg
        k=(kp-1)*nno
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy)
        tpg = 0.0d0
        fluxx = 0.0d0
        fluxy = 0.0d0
!
        do j = 1, nno
            tpg = tpg + zr(itempe+j-1)*zr(ivf+k+j-1)
            fluxx = fluxx + zr(itempe+j-1)*dfdx(j)
            fluxy = fluxy + zr(itempe+j-1)*dfdy(j)
        end do
!
        if (phenom .eq. 'THER_NL') then
            call rcvalb(fami, kpg, spt, poum, zi(imate),&
                        ' ', phenom, 1, 'TEMP', [tpg],&
                        1, 'LAMBDA', valres, icodre, 1)
            lambda = valres(1)
        endif
!
        a = a - lambda*fluxx / npg
        b = b - lambda*fluxy / npg
    end do
    do kp = 1, npg
        zr(iflux+(kp-1)) = ( a**2 + b**2 ) / lambda
    end do
end subroutine
