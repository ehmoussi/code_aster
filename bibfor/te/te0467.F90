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

subroutine te0467(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/dfdm1d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
    character(len=16) :: option, nomte
! ----------------------------------------------------------------------
!     CALCUL DE L OPTION COOR_ELGA
!     POUR LES ELEMENTS 1D SEG2
!
!     POUR CHAQUE POINT DE GAUSS :
!     1) COORDONNEES DU POINT DE GAUSS
!     2) POIDS X JACOBIEN AU POINT DE GAUSS
!
!
!
!
    integer :: ndim, nno, nnos, npg, jgano, kp, icopg, ino
    integer :: idfde, ipoids, ivf, igeom
    real(kind=8) :: xx, yy, poids, jacp, rbid, rbid2(2)
    aster_logical :: laxi
!
    call elrefe_info(elrefe='SE2', fami='RIGI', ndim=ndim, nno=nno, nnos=nnos,&
                     npg=npg, jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCOORPG', 'E', icopg)
!
    do 100 kp = 1, npg
        xx=0.d0
        yy=0.d0
        do 50 ino = 1, nno
            xx=xx+zr(igeom+2*(ino-1)+0)*zr(ivf+(kp-1)*nno+ino-1)
            yy=yy+zr(igeom+2*(ino-1)+1)*zr(ivf+(kp-1)*nno+ino-1)
 50     continue
        zr(icopg+3*(kp-1)+0)=xx
        zr(icopg+3*(kp-1)+1)=yy
        poids=zr(ipoids-1+kp)
        call dfdm1d(nno, poids, zr(idfde), zr(igeom), rbid2,&
                    rbid, jacp, rbid, rbid)
!       EN AXI R C'EST XX
        if (laxi) jacp=jacp*xx
        zr(icopg+3*(kp-1)+2)=jacp
100 end do
!
end subroutine
