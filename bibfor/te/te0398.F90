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

subroutine te0398(option, nomte)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
!
    character(len=16) :: nomte, option
! ----------------------------------------------------------------------
! FONCTION REALISEE:  CALCUL DU GRADIENT AUX NOEUDS D'UN CHAMP SCALAIRE
!                      AUX NOEUDS A 9 COMPOSANTES
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
!.......................................................................
!
!
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), jac, gradx, grady, gradz
!
    integer :: ndim, nno, nnos, npg
    integer :: ipoids, ivf, idfde, jgano, igeom, ineut, igr
    integer :: i, kp, ino
!
!
!
! DEB ------------------------------------------------------------------
!
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PNEUTER', 'L', ineut)
    call jevech('PGNEUTR', 'E', igr)
!
!   C'EST SUREMENT MIEUX D'INVERSER LES BOUCLES !!
!
!     BOUCLE SUR LES 9 CHAMPS SCALAIRES D'ENTREE
    do 100 i = 1, 9
!
!       BOUCLE SUR LES POINTS DE GAUSS
        do 200 kp = 1, npg
            call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                        jac, dfdx, dfdy, dfdz)
            gradx = 0.0d0
            grady = 0.0d0
            gradz = 0.0d0
            do 210 ino = 1, nno
                gradx = gradx + zr(ineut-1+9*(ino-1)+i) * dfdx(ino)
                grady = grady + zr(ineut-1+9*(ino-1)+i) * dfdy(ino)
                gradz = gradz + zr(ineut-1+9*(ino-1)+i) * dfdz(ino)
210          continue
            zr(igr-1+27*(kp-1)+3*(i-1)+1)= gradx
            zr(igr-1+27*(kp-1)+3*(i-1)+2)= grady
            zr(igr-1+27*(kp-1)+3*(i-1)+3)= gradz
200      continue
!
100  end do
!
!
! FIN ------------------------------------------------------------------
end subroutine
