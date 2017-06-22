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

subroutine te0317(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES VECTEURS ELEMENTAIRES DE FLUX FLUIDE EN MECANIQUE
!          ELEMENTS ISOPARAMETRIQUES 1D
!
!          OPTION : 'FLUX_FLUI_Y '
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/vff2dn.h"
    character(len=16) :: nomte, option
    real(kind=8) :: poids, nx, ny, norm(2)
    integer :: ipoids, ivf, idfde, igeom
    integer :: ndi, nno, kp, npg
    integer :: ldec
    aster_logical :: laxi
!
!
!-----------------------------------------------------------------------
    integer :: i, ij, imattt, j, jgano, ndim, nnos
!
    real(kind=8) :: r
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    ndi = nno* (nno+1)/2
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATTTR', 'E', imattt)
    do 10 i = 1, ndi
        zr(imattt+i-1) = 0.0d0
 10 end do
!
!     BOUCLE SUR LES POINTS DE GAUSS
!
    do 50 kp = 1, npg
        ldec = (kp-1)*nno
        nx = 0.0d0
        ny = 0.0d0
! ON CALCULE L ACCEL AU POINT DE GAUSS
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
        norm(1) = nx
        norm(2) = ny
!
! CAS AXISYMETRIQUE
!
        if (laxi) then
            r = 0.d0
            do 20 i = 1, nno
                r = r + zr(igeom+2* (i-1))*zr(ivf+ldec+i-1)
 20         continue
            poids = poids*r
        endif
!
        do 40 i = 1, nno
            do 30 j = 1, i
                ij = (i-1)*i/2 + j
                zr(imattt+ij-1) = zr(imattt+ij-1) + poids*norm(2)*zr( ivf+ldec+i-1)* zr(ivf+ldec+&
                                  &j-1)
 30         continue
 40     continue
 50 end do
end subroutine
