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

subroutine te0256(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
!          ELEMENTS ISOPARAMETRIQUES 1D
!
!          OPTION : 'CHAR_MECA_VNOR_F '
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/fointe.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/rcvalb.h"
#include "asterfort/vff2dn.h"
!
    integer :: icodre(1)
    character(len=8) :: nompar(2), fami, poum
    character(len=16) :: nomte, option
    real(kind=8) :: poids, nx, ny, valpar(2)
    integer :: ipoids, ivf, idfde, igeom, ivnor, kpg, spt
    integer :: nno, kp, npg, ivectu, imate, ldec
    aster_logical :: laxi
!
!-----------------------------------------------------------------------
    integer :: i, ier, ii, jgano, n, ndim, nnos
!
    real(kind=8) :: r, rho(1), vnorf, x, y
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PVECTUR', 'E', ivectu)
    call jevech('PMATERC', 'L', imate)
    call jevech('PSOURCF', 'L', ivnor)
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
    call rcvalb(fami, kpg, spt, poum, zi(imate),&
                ' ', 'FLUIDE', 0, ' ', [0.d0],&
                1, 'RHO', rho, icodre, 1)
!
    do 10 i = 1, 2*nno
        zr(ivectu+i-1) = 0.0d0
 10 end do
!
!     BOUCLE SUR LES POINTS DE GAUSS
!
    nompar(1) = 'X'
    nompar(2) = 'Y'
    do 50 kp = 1, npg
        ldec = (kp-1)*nno
!
!        COORDONNEES DU POINT DE GAUSS
        x = 0.d0
        y = 0.d0
        do 20 n = 0, nno - 1
            x = x + zr(igeom+2*n)*zr(ivf+ldec+n)
            y = y + zr(igeom+2*n+1)*zr(ivf+ldec+n)
 20     continue
!
!        VALEUR DE LA VITESSE
        valpar(1) = x
        valpar(2) = y
        call fointe('FM', zk8(ivnor), 2, nompar, valpar,&
                    vnorf, ier)
        nx = 0.0d0
        ny = 0.0d0
!
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
!
        if (laxi) then
            r = 0.d0
            do 30 i = 1, nno
                r = r + zr(igeom+2* (i-1))*zr(ivf+ldec+i-1)
 30         continue
            poids = poids*r
        endif
!
        do 40 i = 1, nno
            ii = 2*i
            zr(ivectu+ii-1) = zr(ivectu+ii-1) - poids*vnorf*rho(1)*zr( ivf+ldec+i-1)
 40     continue
!
 50 end do
!
end subroutine
