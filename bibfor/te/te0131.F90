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

subroutine te0131(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES MATRICES TANGENTES ELEMENTAIRES EN THERMIQUE
!          CORRESPONDANT AU TERME D'ECHANGE
!          (LE COEFFICIENT D'ECHANGE EST UNE FONCTION DU TEMPS ET DE
!           L'ESPACE)
!          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 3D
!
!          OPTION : 'MTAN_THER_COEF_F'
!          OPTION : 'MTAN_THER_RAYO_F'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
#include "jeveux.h"
#include "asterc/r8t0.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
!
    character(len=8) :: nompar(4)
    character(len=16) :: nomte, option
    real(kind=8) :: nx, ny, nz, sx(9, 9), sy(9, 9), sz(9, 9), jac, theta
    real(kind=8) :: valpar(4), echan, xx, yy, zz
    integer :: ipoids, ivf, idfdx, idfdy, igeom
    integer :: ier, ndim, nno, ndi, ipg, npg2, imattt, iech
    integer :: iray, itemp, nnos, jgano
    integer :: idec, jdec, kdec, ldec
    real(kind=8) :: sigma, epsil, tpg, tz0
!
!-----------------------------------------------------------------------
    integer :: i, ij, ino, itemps, j, jno
!-----------------------------------------------------------------------
    tz0 = r8t0()
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg2,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfdx, jgano=jgano)
    idfdy = idfdx + 1
    ndi = nno*(nno+1)/2
!
    if (option(11:14) .eq. 'COEF') then
        call jevech('PCOEFHF', 'L', iech)
    else if (option(11:14).eq.'RAYO') then
        call jevech('PRAYONF', 'L', iray)
        call jevech('PTEMPEI', 'L', itemp)
    endif
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PMATTTR', 'E', imattt)
!
    theta = zr(itemps+2)
    nompar(1) = 'X'
    nompar(2) = 'Y'
    nompar(3) = 'Z'
    nompar(4) = 'INST'
!
    do i = 1, ndi
        zr(imattt+i-1) = 0.0d0
    end do
!
!    CALCUL DES PRODUITS VECTORIELS OMI X OMJ
!
    do ino = 1, nno
        i = igeom + 3*(ino-1) -1
        do jno = 1, nno
            j = igeom + 3*(jno-1) -1
            sx(ino,jno) = zr(i+2) * zr(j+3) - zr(i+3) * zr(j+2)
            sy(ino,jno) = zr(i+3) * zr(j+1) - zr(i+1) * zr(j+3)
            sz(ino,jno) = zr(i+1) * zr(j+2) - zr(i+2) * zr(j+1)
        end do
    end do
!
!    BOUCLE SUR LES POINTS DE GAUSS
!
    do ipg = 1, npg2
        kdec = (ipg-1)*nno*ndim
        ldec = (ipg-1)*nno
!
        nx = 0.0d0
        ny = 0.0d0
        nz = 0.0d0
        do i = 1, nno
            idec = (i-1)*ndim
            do j = 1, nno
                jdec = (j-1)*ndim
                nx = nx + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sx(i,j)
                ny = ny + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sy(i,j)
                nz = nz + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sz(i,j)
            end do
        end do
        jac = sqrt(nx*nx + ny*ny + nz*nz)
!
        xx = 0.d0
        yy = 0.d0
        zz = 0.d0
        do i = 1, nno
            xx = xx + zr(igeom+3*i-3) * zr(ivf+ldec+i-1)
            yy = yy + zr(igeom+3*i-2) * zr(ivf+ldec+i-1)
            zz = zz + zr(igeom+3*i-1) * zr(ivf+ldec+i-1)
        end do
        valpar(1) = xx
        valpar(2) = yy
        valpar(3) = zz
        valpar(4) = zr(itemps)
        if (option(11:14) .eq. 'COEF') then
            call fointe('A', zk8(iech), 4, nompar, valpar,&
                        echan, ier)
            ASSERT(ier.eq.0)
!
            do i = 1, nno
                do j = 1, i
                    ij = (i-1)*i/2 + j
!
                    zr(imattt+ij-1) = zr(imattt+ij-1) + jac * theta * zr(ipoids+ipg-1) * echan * &
                                      &zr(ivf+ldec+i-1) * zr( ivf+ldec+j-1)
!
                end do
            end do
        else if (option(11:14).eq.'RAYO') then
            call fointe('A', zk8(iray), 4, nompar, valpar,&
                        sigma, ier)
            ASSERT(ier .eq. 0)
            call fointe('A', zk8(iray+1), 4, nompar, valpar,&
                        epsil, ier)
            ASSERT(ier .eq. 0)
!
            tpg = 0.d0
            do i = 1, nno
                tpg = tpg + zr(itemp+i-1) * zr(ivf+ldec+i-1)
            end do
            do i = 1, nno
                do j = 1, i
                    ij = (i-1)*i/2 + j
!
                    zr(imattt+ij-1) = zr(imattt+ij-1) + jac * theta * zr(ivf+ldec+i-1) * zr(ivf+l&
                                      &dec+j-1) * zr(ipoids+ ipg-1) * sigma * epsil * 4.d0 * (tpg&
                                      &+tz0)**3
!
                end do
            end do
        endif
!
    end do
end subroutine
