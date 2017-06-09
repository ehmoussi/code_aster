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

subroutine te0362(option, nomte)
!
! person_in_charge: jerome.laverne at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm1d.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/r8inir.h"
#include "asterfort/subaco.h"
#include "asterfort/sumetr.h"
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
!     CALCUL DES COORDONNEES DES POINTS DE GAUSS
!     POUR LES ELEMENTS D'INTERFACE
! ----------------------------------------------------------------------
!
!
!
!
    character(len=8) :: lielrf(10)
    integer :: jgn, nno, g, iw, ivf, igeom, ntrou
    integer :: npg, nnos, icopg, ndim, idf, i, n
!
    real(kind=8) :: cova(3, 3), metr(2, 2), jac, x(3)
    real(kind=8) :: wg, dfdx(9), cour, cosa, sina, wref
! DEB ------------------------------------------------------------------
!
    call elref2(nomte, 2, lielrf, ntrou)
    call elrefe_info(elrefe=lielrf(2),fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=iw,jvf=ivf,jdfde=idf,jgano=jgn)
    ndim = ndim + 1
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCOORPG', 'E', icopg)
!
    do 20 g = 1, npg
        call r8inir(ndim, 0.d0, x, 1)
        do 10 n = 1, nno
            do 12 i = 1, ndim
                x(i) = x(i) + zr(igeom+ndim*(n-1)+i-1)*zr(ivf+(g-1)* nno+n-1)
12          continue
10      continue
!
        wref = zr(iw+g-1)
        if (ndim .eq. 3) then
            call subaco(nno, zr(idf+(g-1)*(ndim-1)*nno), zr(igeom), cova)
            call sumetr(cova, metr, jac)
            wg = wref*jac
        else if (ndim.eq.2) then
            call dfdm1d(nno, wref, zr(idf+(g-1)*(ndim-1)*nno), zr(igeom), dfdx,&
                        cour, wg, cosa, sina)
        endif
!
        do 15 i = 1, ndim
            zr(icopg+(ndim+1)*(g-1)+i-1) = x(i)
15      continue
        zr(icopg+(ndim+1)*(g-1)+ndim) = wg
!
20  end do
!
end subroutine
