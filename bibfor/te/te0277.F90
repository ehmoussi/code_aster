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

subroutine te0277(option, nomte)
! ......................................................................
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/elref2.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/vff2dn.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          OPTION : 'RESI_THER_PARO_F'
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
!-----------------------------------------------------------------------
    integer :: icode, itemp, itemps, jgano, nbres, ndim, nnos
!
    real(kind=8) :: z1, z2
!-----------------------------------------------------------------------
    parameter (nbres=3)
    character(len=8) :: nompar(nbres)
    real(kind=8) :: valpar(nbres), poids, poids1, poids2, r, r1, r2
    real(kind=8) :: z, hechp, nx, ny, tpg, theta
    integer :: nno, kp, npg, ipoids, ivf, idfde, igeom
    integer :: iveres, i, l, li, ihechp
    aster_logical :: laxi
!
!-----------------------------------------------------------------------
!
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos,&
                     npg=npg, jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PTEMPSR', 'L', itemps)
    call jevech('PHECHPF', 'L', ihechp)
    call jevech('PTEMPEI', 'L', itemp)
    call jevech('PRESIDU', 'E', iveres)
!
    theta = zr(itemps+2)
!
    do 30 kp = 1, npg
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids1)
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom+2*nno), nx, ny, poids2)
        r1 = 0.d0
        r2 = 0.d0
        z1 = 0.d0
        z2 = 0.d0
        tpg = 0.d0
        do 10 i = 1, nno
            l = (kp-1)*nno + i
            r1 = r1 + zr(igeom+2*i-2)*zr(ivf+l-1)
            r2 = r2 + zr(igeom+2* (nno+i)-2)*zr(ivf+l-1)
            z1 = z1 + zr(igeom+2*i-1)*zr(ivf+l-1)
            z2 = z2 + zr(igeom+2* (nno+i)-1)*zr(ivf+l-1)
            tpg = tpg + (zr(itemp+nno+i-1)-zr(itemp+i-1))*zr(ivf+l-1)
 10     continue
        if (laxi) then
            poids1 = poids1*r1
            poids2 = poids2*r2
        endif
        r = (r1+r2)/2.0d0
        z = (z1+z2)/2.0d0
        poids = (poids1+poids2)/2
        valpar(1) = r
        valpar(2) = z
        valpar(3) = zr(itemps)
        nompar(1) = 'X'
        nompar(2) = 'Y'
        nompar(3) = 'INST'
        call fointe('A', zk8(ihechp), 3, nompar, valpar,&
                    hechp, icode)
        ASSERT(icode.eq.0)
        do 20 i = 1, nno
            li = ivf + (kp-1)*nno + i - 1
            zr(iveres+i-1) = zr(iveres+i-1) - poids*zr(li)*hechp* theta*tpg
            zr(iveres+i-1+nno) = zr(iveres+i-1+nno) + poids*zr(li)* hechp*theta*tpg
 20     continue
 30 end do
end subroutine
