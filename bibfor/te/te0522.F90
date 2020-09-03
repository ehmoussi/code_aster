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
!
subroutine te0522(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/ntfcma.h"
#include "asterfort/rcfodi.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: THER_3D
!
! Options: RIGI_THER_CONV_T
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: npgmax = 40
    real(kind=8) :: dfdx(27), dfdy(27), dfdz(27), poids
    real(kind=8) :: dni(3, 27, npgmax), uloc(3, 27), ul(3, npgmax)
    real(kind=8) :: jacob(npgmax), umi(3), um, aire, rr, cc
    real(kind=8) :: xr, xrr, xaux, rbid, s, xma, xm, coef, cmin, alfa, aksi
    integer :: nno, kp, npg, i, j, k, ij, itemps, imattt
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: ifon(6), ivite, itempi
    integer :: nbvf, jvalf, idim, jdim
    aster_logical :: aniso
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', nno=nno, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVITESR', 'L', ivite)
    call jevech('PMATERC', 'L', imate)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PTEMPEI', 'L', itempi)
    call jevech('PMATTTR', 'E', imattt)
!
    aniso = .false.
    call ntfcma(' ', zi(imate), aniso, ifon)
    nbvf = zi(ifon(1))
    jvalf = zi(ifon(1)+2)
    xr = 0.d0
    do i = 1, nbvf
        xaux = zr(jvalf+i-1)
        call rcfodi(ifon(1), xaux, rbid, xrr)
        if (xrr .gt. xr) then
            xr = xrr
        endif
    end do
    rr = 0.6d0/xr
!
    k = 0
    do i = 1, nno
        do idim = 1, 3
            k = k + 1
            uloc(idim,i) = zr(ivite+k-1)
        end do
    end do
!
    aire = 0.d0
    umi  = 0.d0
!
    do kp = 1, npg
        ul(1,kp) = 0.d0
        ul(2,kp) = 0.d0
        ul(3,kp) = 0.d0
        k = (kp-1)*nno
        call dfdm3d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids, dfdx, dfdy, dfdz)
        do i = 1, nno
            ul(1,kp) = ul(1,kp) + uloc(1,i)*zr(ivf+k+i-1)
            ul(2,kp) = ul(2,kp) + uloc(2,i)*zr(ivf+k+i-1)
            ul(3,kp) = ul(3,kp) + uloc(3,i)*zr(ivf+k+i-1)
        end do
!
        aire = aire + poids
        do i = 1, nno
            dni(1,i,kp) = dfdx(i)
            dni(2,i,kp) = dfdy(i)
            dni(3,i,kp) = dfdz(i)
        end do
!
        jacob(kp) = poids
!
        umi(1) = umi(1) + ul(1,kp)*poids
        umi(2) = umi(2) + ul(2,kp)*poids
        umi(3) = umi(3) + ul(3,kp)*poids
    end do
!
    umi(1) = umi(1)/aire
    umi(2) = umi(2)/aire
    umi(3) = umi(3)/aire
!
    ij = imattt - 1
!
    do i = 1, nno
        do j = 1, nno
            s = 0.d0
            do kp = 1, npg
                k = (kp-1)*nno
                s = s + zr(ivf+k+i-1)*dni(1,j,kp)*ul(1,kp)*jacob(kp)*rr +&
                    &   zr(ivf+k+i-1)*dni(2,j,kp)*ul(2,kp)*jacob(kp)*rr +&
                    &   zr(ivf+k+i-1)*dni(3,j,kp)*ul(3,kp)*jacob(kp)*rr
            end do
            ij = ij + 1
            zr(ij) = zr(ij) + s
        end do
    end do
!
!
!- DECENTREMENT HUGUES-BROOKS SU2
!
    um = umi(1)*umi(1) + umi(2)*umi(2) + umi(3)*umi(3)
    um = sqrt(um)
    if (um .lt. 1.d-10) goto 170
    umi(1) = umi(1)/um
    umi(2) = umi(2)/um
    umi(3) = umi(3)/um
!
    xma = aire**(1.d0/3)
!
    do i = 2, nno
        xm = 0.d0
        xm = xm +&
             &(zr(igeom)  -zr(igeom+3*i-3))*(zr(igeom)  -zr(igeom+3*i-3))+&
             &(zr(igeom+1)-zr(igeom+3*i-2))*(zr(igeom+1)-zr(igeom+3*i-2))+&
             &(zr(igeom+2)-zr(igeom+3*i-1))*(zr(igeom+2)-zr(igeom+3*i-1))
        xm = sqrt(xm)
        if (xm .gt. xma) xma = xm
    end do
!
    ij = imattt - 1
!
    do i = 1, nno
        do j = 1, nno
            s = 0.d0
            do kp = 1, npg
                do idim = 1, 3
                    do jdim = 1, 3
!
                        coef = rr
                        cmin = 1.d0
                        alfa = um*xma/cmin*coef
                        aksi = alfa/3.d0
                        if (alfa .gt. 3.d0) aksi = 1.d0
                        cc = aksi*um*xma
!
                        s = s +&
                            &(dni(idim,i,kp)*dni(jdim,j,kp)*ul(idim,kp)*ul(jdim,kp)*&
                            & jacob(kp)/(um*um))*&
                            &coef*cc
!
                    end do
                end do
            end do
            ij = ij + 1
            zr(ij) = zr(ij) + s
        end do
    end do
!
170 continue
end subroutine
