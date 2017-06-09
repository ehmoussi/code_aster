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

subroutine te0142(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
!
    integer :: nbcomp
    parameter (nbcomp=3)
    integer :: igeom, i, j
    integer :: ndim, npg1, kpg, spt
    integer :: imate, ival
    integer :: mater, nnos
    real(kind=8) :: valres(nbcomp)
    integer :: icodre(nbcomp), ndim2
    character(len=8) :: fami, poum
    character(len=16) :: nomres(nbcomp)
    character(len=8) :: nompar(3)
    real(kind=8) :: valpar(3)
!     ------------------------------------------------------------------
!
    if (option .eq. 'MATE_ELGA')then
        fami = 'RIGI'
    elseif (option .eq. 'MATE_ELEM')then
        fami = 'FPG1'
    else
        ASSERT(.false.)
    endif
    call elrefe_info(fami=fami,ndim=ndim,nnos=nnos, npg=npg1)
!
    call jevech('PMATERC', 'L', imate)
    call jevech('PMATERR', 'E', ival)
!
    mater=zi(imate)
    nomres(1)='E'
    nomres(2)='NU'
    nomres(3) = 'RHO'
    spt=1
    poum='+'

    if (lteatt('ABSO','OUI')) then
        fami='FPG1'
        kpg=1
!
        nompar(1) = 'X'
        nompar(2) = 'Y'
        nompar(3) = 'Z'
        ndim2 = ndim + 1
!   coordonnées du barycentre de l'élément
        call jevech('PGEOMER', 'L', igeom)
        valpar(:) = 0.d0
        do i = 1, nnos
            do j = 1, ndim2
                valpar(j) = valpar(j) + zr(igeom-1+(i-1)*ndim2+j)/nnos
            enddo
        enddo
!
        call rcvalb(fami, kpg, spt, poum, mater,&
                        ' ', 'ELAS', ndim2, nompar, valpar,&
                        3, nomres, valres, icodre, 1)
        do kpg = 1, npg1
            zr(ival-1+(kpg-1)*nbcomp+1) = valres(1)
            zr(ival-1+(kpg-1)*nbcomp+2) = valres(2)
            zr(ival-1+(kpg-1)*nbcomp+3) = valres(3)
        enddo
    else
        do kpg = 1, npg1
            call rcvalb(fami, kpg, spt, poum, mater,&
                        ' ', 'ELAS', 0, ' ', [0.d0],&
                        3, nomres, valres, icodre, 1)
            zr(ival-1+(kpg-1)*nbcomp+1) = valres(1)
            zr(ival-1+(kpg-1)*nbcomp+2) = valres(2)
            zr(ival-1+(kpg-1)*nbcomp+3) = valres(3)
        enddo
    endif
!
end subroutine
