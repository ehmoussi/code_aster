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

subroutine te0228(option, nomte)
    implicit   none
#include "jeveux.h"
#include "asterfort/dfdm1d.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/ppgan2.h"
    character(len=16) :: option, nomte
! ......................................................................
! .  - FONCTION REALISEE:  CALCUL  DEFORMATIONS GENERALISEES AUX NOEUDS
! .                        COQUE 1D
! .
! .                        OPTIONS : 'DEGE_ELNO  '
! .                        ELEMENT: MECXSE3
! .
! .  - ARGUMENTS:
! .      DONNEES:      OPTION       -->  OPTION DE CALCUL
! .                    NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
    integer :: i, k, kp, igeom, idepl, idefor, nno, nnos, jgano, ndim, npg
    integer :: ivf, idfdk, ipoids, idefpg
    character(len=8) :: elrefe
    real(kind=8) :: dfdx(3), degepg(24)
    real(kind=8) :: cosa, sina, cour, r, zero, jac
    real(kind=8) :: eps(5), e11, e22, k11, k22
!
!
    call elref1(elrefe)
    zero = 0.0d0
!
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfdk,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PDEPLAR', 'L', idepl)
!
    if (option .eq. 'DEGE_ELNO') then
        call jevech('PDEFOGR', 'E', idefor)
    endif
!
    if (option .eq. 'DEGE_ELGA') then
        call jevech('PDEFOPG', 'E', idefpg)
    endif
!
    do  kp = 1, npg
        k = (kp-1)*nno
        call dfdm1d(nno, zr(ipoids+kp-1), zr(idfdk+k), zr(igeom), dfdx,&
                    cour, jac, cosa, sina)
        do  i = 1, 5
            eps(i) = zero
        end do
        r = zero
        do  i = 1, nno
            eps(1) = eps(1) + dfdx(i)*zr(idepl+3*i-3)
            eps(2) = eps(2) + dfdx(i)*zr(idepl+3*i-2)
            eps(3) = eps(3) + dfdx(i)*zr(idepl+3*i-1)
            eps(4) = eps(4) + zr(ivf+k+i-1)*zr(idepl+3*i-3)
            eps(5) = eps(5) + zr(ivf+k+i-1)*zr(idepl+3*i-1)
            r = r + zr(ivf+k+i-1)*zr(igeom+2* (i-1))
      end do
        e11 = eps(2)*cosa - eps(1)*sina
        k11 = eps(3)
        e22 = eps(4)/r
        k22 = -eps(5)*sina/r

!
        degepg(6* (kp-1)+1) = e11
        degepg(6* (kp-1)+2) = e22
        degepg(6* (kp-1)+3) = zero
        degepg(6* (kp-1)+4) = k11
        degepg(6* (kp-1)+5) = k22
        degepg(6* (kp-1)+6) = zero
        if (option .eq. 'DEGE_ELGA') then
            zr(idefpg-1+6*(kp-1)+1) = e11
            zr(idefpg-1+6*(kp-1)+2) = e22
            zr(idefpg-1+6*(kp-1)+3) = zero
            zr(idefpg-1+6*(kp-1)+4) = k11
            zr(idefpg-1+6*(kp-1)+5) = k22
            zr(idefpg-1+6*(kp-1)+6) = zero
        endif
  end do
!
!
!     -- PASSAGE GAUSS -> NOEUDS :
    if (option .eq. 'DEGE_ELNO') then
        call ppgan2(jgano, 1, 6, degepg, zr(idefor))
    endif
end subroutine
