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

subroutine te0479(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/vff2dn.h"
!
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
!     CALCUL DES COORDONNEES DES POINTS DE GAUSS
!     POUR LES ELEMENTS ISOPARAMETRIQUES 2D ET LEURS ELEMENTS DE PEAU
!
!
!
!
    integer :: ndim, nno, nnos, npg, jgano, kp, icopg, ino
    integer :: idfde, ipoids, ivf, igeom
    real(kind=8) :: xx, yy, rbid81(81), poids
    aster_logical :: laxi
! DEB ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
! ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES
!      ----------------------------------------------
    call jevech('PGEOMER', 'L', igeom)
!
    call jevech('PCOORPG', 'E', icopg)
!
    do 100 kp = 1, npg
        xx=0.d0
        yy=0.d0
        do 50 ino = 1, nno
            xx=xx+zr(igeom+2*(ino-1)+0)*zr(ivf+(kp-1)*nno+ino-1)
            yy=yy+zr(igeom+2*(ino-1)+1)*zr(ivf+(kp-1)*nno+ino-1)
 50     continue
!
        zr(icopg+3*(kp-1)+0)=xx
        zr(icopg+3*(kp-1)+1)=yy
!
        if (ndim .eq. 2) then
!         -- CAS DES ELEMENTS 2D
            call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                        poids, rbid81, rbid81)
        else if (ndim.eq.1) then
!         -- CAS DES ELEMENTS PEAU
            call vff2dn(ndim, nno, kp, ipoids, idfde,&
                        zr(igeom), rbid81(1), rbid81(1), poids)
        else
            ASSERT(.false.)
        endif
!
!       EN AXI R C'EST XX
        if (laxi) poids=poids*xx
!
        zr(icopg+3*(kp-1)+2)=poids
100 end do
!
end subroutine
