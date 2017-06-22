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

subroutine te0024(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
!
    character(len=16) :: nomte, option
! FONCTION REALISEE:  CALCUL DU GRADIENT AUX NOEUDS D'UN CHAMP SCALAIRE
!                      AUX NOEUDS
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!.......................................................................
!
!
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), jac
    real(kind=8) :: gradx, grady, gradz
    character(len=8) :: elp
    integer :: ndim, nno, nnos, npg
    integer :: ino, i
    integer :: ipoids, ivf, idfde, jgan, igeom, ineut
    integer :: igr
!
!
! DEB ------------------------------------------------------------------
!
!
    call elref1(elp)
!
!     ON CALCULE LES GRADIENTS SUR TOUS LES NOEUDS DE L'ELEMENT DE REF
    call elrefe_info(elrefe=elp,fami='NOEU',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgan)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PNEUTER', 'L', ineut)
    call jevech('PGNEUTR', 'E', igr)
!
!     BOUCLE SUR LES NOEUDS
    do 100 ino = 1, nno
        if (ndim .eq. 3) then
            call dfdm3d(nno, ino, ipoids, idfde, zr(igeom),&
                        jac, dfdx, dfdy, dfdz)
        else if (ndim .eq. 2) then
            call dfdm2d(nno, ino, ipoids, idfde, zr(igeom),&
                        jac, dfdx, dfdy)
        endif
!
        gradx = 0.0d0
        grady = 0.0d0
        gradz = 0.0d0
!
        do 110 i = 1, nno
!
            gradx = gradx + dfdx(i)*zr(ineut+i-1)
            grady = grady + dfdy(i)*zr(ineut+i-1)
            if (ndim .eq. 3) gradz = gradz + dfdz(i)*zr(ineut+i-1)
!
110      continue
        zr(igr-1+(ino-1)*ndim+1)= gradx
        zr(igr-1+(ino-1)*ndim+2)= grady
        if (ndim .eq. 3) zr(igr-1+(ino-1)*ndim+3)= gradz
!
100  end do
!
!
! FIN ------------------------------------------------------------------
end subroutine
