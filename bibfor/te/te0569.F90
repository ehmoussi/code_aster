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
subroutine te0569(option, nomte)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/assert.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: 3D_ABSO
!
! Options: FULL_MECA_*, RIGI_MECA_*, RAPH_MECA
!          AMOR_MECA
!          RIGI_MECA
!          FORC_NODA
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ipoids, ivf, idfdx, idfdy, igeom, i, j
    integer :: ndim, nno, kpg, npg, ino, jno, ij
    integer :: idec, jdec, kdec, ldec, imate, imatuu
    integer :: mater, ll, k, l, nnos
    integer :: ideplm, ideplp, ivectu
    real(kind=8) :: jac, nx, ny, nz, sx(9, 9), sy(9, 9), sz(9, 9)
    real(kind=8) :: valres(5), e, nu, lambda, mu, rho, coef_amor
    real(kind=8) :: rhocp, rhocs, l0, usl0
    real(kind=8) :: taux, tauy, tauz
    real(kind=8) :: nux, nuy, nuz, scal, vnx, vny, vnz
    real(kind=8) :: vituni(3, 3), vect(9, 3, 27)
    real(kind=8) :: matr(27, 27), depla(27)
    real(kind=8) :: vtx, vty, vtz
    integer :: icodre(5), ndim2
    character(len=8) :: fami, poum
    character(len=16), parameter :: nomres(5) = (/'E        ', 'NU       ',&
                                                  'RHO      ',&
                                                  'COEF_AMOR', 'LONG_CARA'/)
    character(len=8) :: nompar(3)
    aster_logical :: lDamp, lMatr, lVect
    real(kind=8) :: xyzgau(3)
    integer :: idecpg, idecno
!
! --------------------------------------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
                      npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfdx)
    idfdy = idfdx + 1
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
!
    mater = zi(imate)
    fami='RIGI'
    poum='+'
    ASSERT(ndim .ne. 3)
    ndim2=ndim+1
!
    nompar(1) = 'X'
    nompar(2) = 'Y'
    nompar(3) = 'Z'
    lDamp = option .eq. 'AMOR_MECA'
    lVect = L_VECT(option)
    lMatr = L_MATR(option)
!
!     VITESSE UNITAIRE DANS LES 3 DIRECTIONS
!
    vituni(1,1) = 1.d0
    vituni(1,2) = 0.d0
    vituni(1,3) = 0.d0
    vituni(2,1) = 0.d0
    vituni(2,2) = 1.d0
    vituni(2,3) = 0.d0
    vituni(3,1) = 0.d0
    vituni(3,2) = 0.d0
    vituni(3,3) = 1.d0
!
    vect = 0.d0
!
!     --- CALCUL DES PRODUITS VECTORIELS OMI X OMJ ---
!
    do ino = 1, nno
        i = igeom + 3*(ino-1) -1
        do jno = 1, nno
            j = igeom + 3*(jno-1) -1
            sx(ino,jno) = zr(i+2)*zr(j+3) - zr(i+3)*zr(j+2)
            sy(ino,jno) = zr(i+3)*zr(j+1) - zr(i+1)*zr(j+3)
            sz(ino,jno) = zr(i+1)*zr(j+2) - zr(i+2)*zr(j+1)
        end do
    end do
!
!     --- BOUCLE SUR LES POINTS DE GAUSS ---
!
    do kpg = 1, npg
!
! - Get material properties
!
        idecpg = nno* (kpg-1) - 1
! ----- Coordinates for current Gauss point
        xyzgau(:) = 0.d0
        do i = 1, nno
            idecno = ndim2* (i-1) - 1
            do j = 1, ndim2
                xyzgau(j) = xyzgau(j) + zr(ivf+i+idecpg)*zr(igeom+j+idecno)
            enddo
        end do
!
        call rcvalb(fami, kpg, 1, poum, mater,&
                    ' ', 'ELAS', 3, nompar, xyzgau,&
                    4, nomres, valres, icodre, 1)
!       appel LONG_CARA en iarret = 0
        call rcvalb(fami, kpg, 1, poum, mater,&
                    ' ', 'ELAS', 3, nompar, xyzgau,&
                    1, nomres(5), valres(5), icodre(5), 0)
!
        e = valres(1)
        nu = valres(2)
        rho = valres(3)
        coef_amor = valres(4)
    !
        usl0 = 0.d0    
        if (icodre(5) .eq. 0) then
            l0 = valres(5)
            usl0=1.d0/l0
        endif
        lambda = e*nu/ (1.d0+nu)/ (1.d0-2.d0*nu)
        mu = e/2.d0/ (1.d0+nu)
        if (lDamp) then
            rhocp = coef_amor*sqrt((lambda+2.d0*mu)*rho)
            rhocs = coef_amor*sqrt(mu*rho)
        else
            rhocp = (lambda+2.d0*mu)*usl0
            rhocs = mu*usl0
        endif
    !
!
        kdec = (kpg-1)*nno*ndim
        ldec = (kpg-1)*nno
!
        nx = 0.0d0
        ny = 0.0d0
        nz = 0.0d0
!
!        --- CALCUL DE LA NORMALE AU POINT DE GAUSS IPG ---
!
        do i = 1, nno
            idec = (i-1)*ndim
            do j = 1, nno
                jdec = (j-1)*ndim
                nx = nx + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sx(i,j)
                ny = ny + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sy(i,j)
                nz = nz + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sz(i,j)
            end do
        end do
!
!        --- LE JACOBIEN EST EGAL A LA NORME DE LA NORMALE ---
!
        jac = sqrt(nx*nx + ny*ny + nz*nz)
!
!        --- CALCUL DE LA NORMALE UNITAIRE ---
!
        nux = nx / jac
        nuy = ny / jac
        nuz = nz / jac
!
!        --- CALCUL DE V.N ---
!
        do i = 1, nno
            do j = 1, 3
                scal = nux*zr(ivf+ldec+i-1)*vituni(j,1)
                scal = scal + nuy*zr(ivf+ldec+i-1)*vituni(j,2)
                scal = scal + nuz*zr(ivf+ldec+i-1)*vituni(j,3)
!
!        --- CALCUL DE LA VITESSE NORMALE ET DE LA VITESSE TANGENCIELLE
!
                vnx = nux*scal
                vny = nuy*scal
                vnz = nuz*scal
                vtx = zr(ivf+ldec+i-1)*vituni(j,1)
                vty = zr(ivf+ldec+i-1)*vituni(j,2)
                vtz = zr(ivf+ldec+i-1)*vituni(j,3)
                vtx = vtx - vnx
                vty = vty - vny
                vtz = vtz - vnz
!
!        --- CALCUL DU VECTEUR CONTRAINTE
!
                taux = rhocp*vnx + rhocs*vtx
                tauy = rhocp*vny + rhocs*vty
                tauz = rhocp*vnz + rhocs*vtz
!
!        --- CALCUL DU VECTEUR ELEMENTAIRE
!
                do l = 1, nno
                    ll = 3*l - 2
                    vect(i,j,ll) = vect(i,j,ll) + taux*zr(ivf+ldec+l- 1)*jac*zr(ipoids+kpg-1)
                    vect(i,j,ll+1) = vect(i,j,ll+1) + tauy*zr(ivf+ ldec+l-1)*jac*zr(ipoids+kpg-1)
                    vect(i,j,ll+2) = vect(i,j,ll+2) + tauz*zr(ivf+ ldec+l-1)*jac*zr(ipoids+kpg-1)
                end do
            end do
        end do
    end do
!
    do i = 1, nno
        do j = 1, 3
            do k = 1, 3*nno
                matr(3*(i-1)+j,k) = vect(i,j,k)
            end do
        end do
    end do
!
! - Get output fields
!
    if (lMatr .or. lDamp) then
        call jevech('PMATUUR', 'E', imatuu)
    endif
    if (lVect) then
        call jevech('PVECTUR', 'E', ivectu)
    endif
!
!       --- PASSAGE AU STOCKAGE TRIANGULAIRE
!
    if (lMatr .or. lDamp) then
        do i = 1, 3*nno
            do j = 1, i
                ij = (i-1)*i/2 + j
                zr(imatuu+ij-1) = matr(i,j)
            end do
        end do
    endif
    if (lVect) then
        call jevech('PDEPLMR', 'L', ideplm)
        call jevech('PDEPLPR', 'L', ideplp)
        do i = 1, 3*nno
            depla(i) = zr(ideplm+i-1) + zr(ideplp+i-1)
            zr(ivectu+i-1) = 0.d0
        end do
        do i = 1, 3*nno
            do j = 1, 3*nno
                zr(ivectu+i-1) = zr(ivectu+i-1) + matr(i,j)*depla(j)
            end do
        end do
    endif
!
end subroutine
