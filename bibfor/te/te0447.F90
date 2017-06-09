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

subroutine te0447(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/nmgeom.h"
#include "asterfort/r8inir.h"
#include "asterfort/lteatt.h"
    character(len=16) :: option, nomte
!
!
!     BUT: CALCUL DES DEFORMATIONS AUX POINTS DE GAUSS
!          DES ELEMENTS INCOMPRESSIBLES 2D
!
!          OPTION : 'EPSI_ELGA'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!              ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
    aster_logical :: axi, grand
    integer :: kpg, ksig, nno, nnos, npg, ipoids, ivf, ndim, ncmp
    integer :: idfde, idepl, igeom, idefo, kk, jgano
    real(kind=8) :: poids, dfdi(81), f(3, 3), r, eps(6), vpg(36)
    real(kind=8) :: tmp
! ......................................................................
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    ncmp = 2*ndim
    axi = lteatt('AXIS','OUI')
    grand = .false.
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PDEPLAR', 'L', idepl)
    call jevech('PDEFOPG', 'E', idefo)
!
    call r8inir(6, 0.d0, eps, 1)
    call r8inir(36, 0.d0, vpg, 1)
!
    do 10 kpg = 1, npg
!
        call nmgeom(ndim, nno, axi, grand, zr(igeom),&
                    kpg, ipoids, ivf, idfde, zr(idepl),&
                    .true._1, poids, dfdi, f, eps,&
                    r)
!
!       RECUPERATION DE LA DEFORMATION
        do 20 ksig = 1, ncmp
            if (ksig .le. 3) then
                tmp=1.d0
            else
                tmp = sqrt(2.d0)
            endif
            vpg(ncmp*(kpg-1)+ksig)=eps(ksig)/tmp
 20     continue
 10 end do
!
!     AFFECTATION DU VECTEUR EN SORTIE
    do 30 kk = 1, npg*ncmp
        zr(idefo+kk-1)= vpg(kk)
 30 end do
!
end subroutine
