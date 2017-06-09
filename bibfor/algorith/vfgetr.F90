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

subroutine vfgetr(maxdim, ndim, nbnos, xs, t,&
                  xg, surf, norm, xgf, d)
!  CALCUL DES ELEMENTS GEOMETRIQUES D UNE FACE TRIANGULAIRE
!
! IDIM ( : 1,NDIM
! IN
!     MAXDIM
!     NDIM
!     NBNOS NBRE DE SOMMETS = NOMBRE DE ARETE
!     XS(1:MAXDIM,J) COORD SOMMET J
!     T(1:MAXDIM,2)  COORD DU VECTEUR DES DEUX PREMIRES ARETES
!     XG  COORD D UN POINT QUI PEMET D ORIENTER LA FACE
!        (XGF-XG).N >0
! OUT
!     SURF SURFACE DE LA FACE
!     NORM NORMALE
!     XGF BARYCENTRE FACE
!     D = (XGF-XG).N
    implicit none
#include "asterfort/assert.h"
#include "asterfort/provec.h"
    integer :: maxdim, ndim, nbnos, idim, is
    real(kind=8) :: xs(1:maxdim, nbnos), t(1:maxdim, 2)
    real(kind=8) :: xg(1:maxdim), surf, norm(1:maxdim), xgf(1:maxdim), d
    real(kind=8) :: xnorm
    ASSERT(ndim.eq.3)
    ASSERT(maxdim.ge.3)
    ASSERT(nbnos.eq.3)
    do 10 idim = 1, ndim
        xgf(idim)=0.d0
        do 11 is = 1, nbnos
            xgf(idim)=xgf(idim)+xs(idim,is)
11      continue
        xgf(idim)=xgf(idim)/nbnos
10  end do
!
    call provec(t(1, 1), t(1, 2), norm)
    xnorm=sqrt(norm(1)**2+norm(2)**2+norm(3)**2)
    norm(1)=norm(1)/xnorm
    norm(2)=norm(2)/xnorm
    norm(3)=norm(3)/xnorm
    surf=xnorm/2.d0
    d =(xgf(1)-xg(1))*norm(1)+&
     &   (xgf(2)-xg(2))*norm(2)+&
     &   (xgf(3)-xg(3))*norm(3)
    if (d .lt. 0.d0) then
        d=-d
        norm(1)=-norm(1)
        norm(2)=-norm(2)
        norm(3)=-norm(3)
    endif
end subroutine
