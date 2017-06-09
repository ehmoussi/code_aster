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

subroutine te0309(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES VECTEURS ELEMENTAIRES DE FLUX FLUIDE EN MECANIQUE
!          ELEMENTS ISOPARAMETRIQUES 1D
!
!          OPTION : 'FLUX_FLUI_X 'OU 'FLUX_FLUI_Y 'OU 'FLUX_FLUI_Z '
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
!
    character(len=16) :: nomte, option
    real(kind=8) :: jac, nx, ny, nz, sx(9, 9), sy(9, 9), sz(9, 9)
    real(kind=8) :: norm(3)
    integer :: ipoids, ivf, idfdx, idfdy, igeom
    integer :: ndim, nno, ipg, npg1
    integer :: idec, jdec, kdec, ldec, nnos, jgano
!
!
!-----------------------------------------------------------------------
    integer :: i, ij, imattt, ino, j, jno
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg1,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfdx, jgano=jgano)
    idfdy = idfdx + 1
!
    call jevech('PGEOMER', 'L', igeom)
!
!
    call jevech('PMATTTR', 'E', imattt)
!
    do i = 1, ndim
        zr(imattt + i -1) = 0.0d0
    end do
!
!
!     CALCUL DES PRODUITS VECTORIELS OMI X OMJ
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
!
!     BOUCLE SUR LES POINTS DE GAUSS
!
    do ipg = 1, npg1
        kdec=(ipg-1)*nno*ndim
        ldec=(ipg-1)*nno
!
!
        nx = 0.0d0
        ny = 0.0d0
        nz = 0.0d0
!
! ON CALCULE LA NORMALE AU POINT DE GAUSS
!
!
!
!
        do i = 1, nno
            idec = (i-1)*ndim
            do j = 1, nno
                jdec = (j-1)*ndim
!
                nx = nx + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sx(i,j)
                ny = ny + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sy(i,j)
                nz = nz + zr(idfdx+kdec+idec) * zr(idfdy+kdec+jdec) * sz(i,j)
!
!
!
            end do
        end do
!
!        CALCUL DU JACOBIEN AU POINT DE GAUSS IPG
!
        jac = sqrt (nx*nx + ny*ny + nz*nz)
!
        norm(1) = nx/jac
        norm(2) = ny/jac
        norm(3) = nz/jac
!
        if (option(11:11) .eq. 'X') then
            do i = 1, nno
                do j = 1, i
                    ij = (i-1)*i/2 +j
                    zr(imattt + ij -1) = zr(imattt + ij -1) +jac*zr( ipoids+ipg-1)*norm(1)* zr(iv&
                                         &f+ldec+i-1)*zr(ivf+ ldec+j-1)
                end do
            end do
        else
!
            if (option(11:11) .eq. 'Y') then
!
                do i = 1, nno
                    do j = 1, i
                        ij = (i-1)*i/2 +j
                        zr(imattt + ij -1) = zr(imattt + ij -1) +jac*zr(ipoids+ipg-1)*norm(2)* zr&
                                             &(ivf+ldec+i- 1)*zr(ivf+ldec+j-1)
                    end do
                end do
!
            else
                if (option(11:11) .eq. 'Z') then
!
                    do i = 1, nno
                        do j = 1, i
                            ij = (i-1)*i/2 +j
                            zr(imattt + ij -1) = zr(imattt + ij -1) +jac*zr(ipoids+ipg-1)*norm(3)&
                                                 &* zr(ivf+ ldec+i-1)*zr(ivf+ldec+j-1)
                        end do
                    end do
!
                endif
            endif
        endif
!
    end do
!
end subroutine
