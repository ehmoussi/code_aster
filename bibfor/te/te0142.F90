! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
use calcul_module, only : ca_jvcnom_, ca_nbcvrc_
!
implicit none
!
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
    integer :: igeom, i, j, nbpar, ipar
    integer :: ndim, npg1, kpg, spt
    integer :: imate, ival, ivf, idecpg, idecno
    integer :: mater, nnos, nno, indir(3)
    real(kind=8) :: valres(nbcomp)
    integer :: icodre(nbcomp), ndim2
    character(len=8) :: fami, poum, novrc
    character(len=16) :: nomres(nbcomp)
    character(len=8) :: nompar(3),nompar0(3)
    real(kind=8) :: valpar(3), valpar0(3), xyzgau(3), xyzgau0(3)
    aster_logical::lfound
!     ------------------------------------------------------------------
!
    if (option .eq. 'MATE_ELGA')then
        fami = 'RIGI'
    elseif (option .eq. 'MATE_ELEM')then
        fami = 'FPG1'
    else
        ASSERT(.false.)
    endif
    call elrefe_info(fami=fami,ndim=ndim,nno=nno, nnos=nnos, npg=npg1, jvf=ivf)
!
    call jevech('PMATERC', 'L', imate)
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERR', 'E', ival)
!
    mater=zi(imate)
    nomres(1)='E'
    nomres(2)='NU'
    nomres(3) = 'RHO'
    spt=1
    poum='+'
!
    nompar0(1) = 'X'
    nompar0(2) = 'Y'
    nompar0(3) = 'Z'

!   check if X, Y or Z are present in the command variables and store indirection in indir
    nbpar = 0
    do i=1, 3
        lfound=.false.
        do ipar=1,ca_nbcvrc_
            novrc=zk8(ca_jvcnom_-1+ipar)
            if (novrc .eq. nompar0(i)) then
                lfound=.true.
                cycle
            endif
        enddo
        if (.not. lfound) then
            nbpar=nbpar+1
            indir(nbpar)=i
        endif
    enddo
!   only use parameters in indir
    do i=1,nbpar
        nompar(i) = nompar0(indir(i))
    enddo


    if (lteatt('ABSO','OUI')) then
        fami='FPG1'
        kpg=1
!
        ndim2 = ndim + 1
        valpar0(:) = 0.d0
        do i = 1, nnos
            do j = 1, ndim2
                valpar0(j) = valpar0(j) + zr(igeom-1+(i-1)*ndim2+j)/nnos
            enddo
        enddo
!       only use parameters in indir
        do i=1,nbpar
            valpar(i) = valpar0(indir(i))
        enddo
    
!
        call rcvalb(fami, kpg, spt, poum, mater,&
                        ' ', 'ELAS', nbpar, nompar, valpar,&
                        3, nomres, valres, icodre, 1)
        do kpg = 1, npg1
            zr(ival-1+(kpg-1)*nbcomp+1) = valres(1)
            zr(ival-1+(kpg-1)*nbcomp+2) = valres(2)
            zr(ival-1+(kpg-1)*nbcomp+3) = valres(3)
        enddo
    else
        do kpg = 1, npg1
            idecpg = nno* (kpg-1) - 1
            ! ----- Coordinates for current Gauss point
            xyzgau0(:) = 0.d0
            do i = 1, nno
                idecno = 3* (i-1) - 1
                xyzgau0(1) = xyzgau0(1) + zr(ivf+i+idecpg)*zr(igeom+1+idecno)
                xyzgau0(2) = xyzgau0(2) + zr(ivf+i+idecpg)*zr(igeom+2+idecno)
                xyzgau0(3) = xyzgau0(3) + zr(ivf+i+idecpg)*zr(igeom+3+idecno)
            end do
!           only use parameters in indir
            do i=1,nbpar
                xyzgau(i) = xyzgau0(indir(i))
            enddo
                    
            call rcvalb(fami, kpg, spt, poum, mater,&
                        ' ', 'ELAS', nbpar, nompar, xyzgau,&
                        3, nomres, valres, icodre, 1)
            zr(ival-1+(kpg-1)*nbcomp+1) = valres(1)
            zr(ival-1+(kpg-1)*nbcomp+2) = valres(2)
            zr(ival-1+(kpg-1)*nbcomp+3) = valres(3)
        enddo
    endif
!
end subroutine
