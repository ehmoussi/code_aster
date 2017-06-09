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

subroutine te0085(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvalb.h"
!
    character(len=16) :: option, nomte, phenom
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES TERMES ELEMENTAIRES EN MECANIQUE
!                          OPTION : 'CHAR_MECA_PESA_R'
!                          2D PLAN ET AXISYMETRIQUE
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    integer :: icodre(1)
    real(kind=8) :: poids, rx
    integer :: nno, kp, k, npg, i, ivectu, ipesa
    integer :: ipoids, ivf, idfde, igeom, imate
!
!
!-----------------------------------------------------------------------
    integer :: jgano, ndim, nnos
    real(kind=8) :: rho(1)
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PPESANR', 'L', ipesa)
    call jevech('PVECTUR', 'E', ivectu)
!
    call rccoma(zi(imate), 'ELAS', 1, phenom, icodre(1))
    call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                ' ', phenom, 0, ' ', [0.d0],&
                1, 'RHO', rho, icodre(1), 1)
!
    do kp = 1, npg
        k = nno*(kp-1)
        call dfdm2d(nno, kp, ipoids, idfde, zr(igeom),&
                    poids)
        poids = poids * rho(1) * zr(ipesa)
        if (lteatt('AXIS','OUI')) then
            rx= 0.d0
            do i = 1, nno
                rx= rx+ zr(igeom+2*i-2)*zr(ivf+k+i-1)
            end do
            poids = poids*rx
            do i = 1, nno
                zr(ivectu+2*i-1) = zr(ivectu+2*i-1) + poids*zr(ipesa+ 2)*zr(ivf+k+i-1)
            end do
        else
            do i = 1, nno
                zr(ivectu+2*i-2) = zr(ivectu+2*i-2) + poids*zr(ipesa+ 1)*zr(ivf+k+i-1)
                zr(ivectu+2*i-1) = zr(ivectu+2*i-1) + poids*zr(ipesa+ 2)*zr(ivf+k+i-1)
            end do
        endif
    end do
end subroutine
