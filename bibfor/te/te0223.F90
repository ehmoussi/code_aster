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

subroutine te0223(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/dfdm1d.h"
#include "asterfort/elref1.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          COQUE 1D
!                          OPTION : 'CHAR_MECA_FRCO2D  '
!                          ELEMENT: MECXSE3
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
    character(len=8) :: elrefe
    real(kind=8) :: poids, r, fx, fy, mz, f1, f3, m2, nx, ny, cour, dfdx(3)
    integer :: nno, nddl, kp, npg, ipoids, ivf, idfdk, igeom
    integer :: ivectu, k, i, l, iforc
    aster_logical :: global
!
!
!-----------------------------------------------------------------------
    integer :: jgano, ndim, nnos
!-----------------------------------------------------------------------
    call elref1(elrefe)
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfdk, jgano=jgano)
!
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PFRCO2D', 'L', iforc)
    call jevech('PVECTUR', 'E', ivectu)
    nddl = 3
    global = abs(zr(iforc+5)) .lt. 1.d-3
!
    do  kp = 1, npg
        k = (kp-1)*nno
        call dfdm1d(nno, zr(ipoids+kp-1), zr(idfdk+k), zr(igeom), dfdx,&
                    cour, poids, nx, ny)
        r = 0.d0
        fx = 0.d0
        fy = 0.d0
        mz = 0.d0
        do i = 1, nno
            l = (kp-1)*nno + i
            if (global) then
                fx = fx + zr(iforc-1+6* (i-1)+1)*zr(ivf+l-1)
                fy = fy + zr(iforc-1+6* (i-1)+2)*zr(ivf+l-1)
                mz = mz + zr(iforc-1+6* (i-1)+5)*zr(ivf+l-1)
            else
                f1 = zr(iforc+6* (i-1))
!-----------------------------------------------------
!  LE SIGNE AFFECTE A F3 A ETE CHANGE PAR AFFE_CHAR_MECA SI PRES
!  POUR RESPECTER LA CONVENTION
!      UNE PRESSION POSITIVE PROVOQUE UN GONFLEMENT
!-----------------------------------------------------
                f3 = zr(iforc+6* (i-1)+2)
                m2 = zr(iforc+6* (i-1)+3)
                fx = fx + (nx*f3-ny*f1)*zr(ivf+l-1)
                fy = fy + (ny*f3+nx*f1)*zr(ivf+l-1)
                mz = mz + m2*zr(ivf+l-1)
            endif
            r = r + zr(igeom+2* (i-1))*zr(ivf+l-1)
        end do
        if (nomte .eq. 'MECXSE3') then
            poids = poids*r
        endif
        do  i = 1, nno
            l = (kp-1)*nno + i
            zr(ivectu+nddl* (i-1)) = zr(ivectu+nddl* (i-1)) + fx*zr( ivf+l-1 )*poids
            zr(ivectu+nddl* (i-1)+1) = zr(ivectu+nddl* (i-1)+1) + fy*zr(ivf+l-1 )*poids
            zr(ivectu+nddl* (i-1)+2) = zr(ivectu+nddl* (i-1)+2) + mz*zr(ivf+l-1 )*poids
      end do
  end do
end subroutine
