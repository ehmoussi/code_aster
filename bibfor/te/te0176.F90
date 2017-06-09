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

subroutine te0176(option, nomte)
!.......................................................................
!
!     BUT: CALCUL DES MATRICES DE RIGIDITE ELEMENTAIRES EN ACOUSTIQUE
!          ELEMENTS ISOPARAMETRIQUES 2D
!
!          OPTION : 'RIGI_ACOU '
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!              ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
!
    character(len=16) :: nomte, option
    real(kind=8) :: dfdx(9), dfdy(9), poids
    integer :: ipoids, ivf, idfde, igeom, ij
    integer :: nno, kp, npg1, i, j, imattt, ndi
    integer :: ndim, nnos, jgano
!
!
!
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    ndi = nno*(nno+1)/2
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATTTC', 'E', imattt)
!
    do 111 i = 1, ndi
        zc(imattt+i-1) =(0.0d0 ,0.0d0 )
111  end do
!
!    BOUCLE SUR LES POINTS DE GAUSS
!
    do 101 kp = 1, npg1
!
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy)
!
        ij=imattt - 1
        do 106 i = 1, nno
            do 107 j = 1, i
                ij = ij + 1
                zc(ij) = zc(ij) + poids * (dfdx(i) * dfdx(j) + dfdy(i) * dfdy(j) )
107          continue
106      continue
!
101  end do
!
end subroutine
