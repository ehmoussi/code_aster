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

subroutine te0550(option, nomte)
!.......................................................................
    implicit none
!
!     BUT: CALCUL DES MATRICES ELEMENTAIRES EN MECANIQUE
!          CORRESPONDANT A UNE IMPEDANCE IMPOSEE
!          SUR DES FACES D'ELEMENTS ISOPARAMETRIQUES 2D
!
!          OPTION : 'IMPE_ABSO'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/matini.h"
#include "asterfort/rcvalb.h"
#include "asterfort/vff2dn.h"
!
    integer :: icodre(1)
    character(len=8) :: fami, poum
    character(len=16) :: nomte, option
    real(kind=8) :: nx, ny, poids, a(6, 6)
    real(kind=8) :: vites(6)
    integer :: ipoids, ivf, idfde, igeom, imate
    integer :: ndi, nno, kp, npg
    integer :: ldec, kpg, spt
    aster_logical :: laxi
!
!
!-----------------------------------------------------------------------
    integer :: i, ii, ivectu, ivien, ivite, j, jgano
    integer :: jj, ndim, nnos
    real(kind=8) :: celer(1), r
!-----------------------------------------------------------------------
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
    ndi = 2*nno
    laxi = .false.
    if (lteatt('AXIS','OUI')) laxi = .true.
!
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PMATERC', 'L', imate)
    call jevech('PVITPLU', 'L', ivite)
    call jevech('PVITENT', 'L', ivien)
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    call rcvalb(fami, kpg, spt, poum, zi(imate),&
                ' ', 'FLUIDE', 0, ' ', [0.d0],&
                1, 'CELE_R', celer, icodre, 1)
    if (celer(1) .lt. 1.d-1) goto 110
!
    call jevech('PVECTUR', 'E', ivectu)
!
! --- INITIALISATION DU VECTEUR DE CORRECTION
    do 10 i = 1, ndi
        zr(ivectu+i-1) = 0.d0
 10 end do
!
! --- INITIALISATION DE LA MATRICE D'IMPEDANCE
    call matini(6, 6, 0.d0, a)
!
!     BOUCLE SUR LES POINTS DE GAUSS
!
    do 100 kp = 1, npg
        ldec = (kp-1)*nno
        nx = 0.0d0
        ny = 0.0d0
        call vff2dn(ndim, nno, kp, ipoids, idfde,&
                    zr(igeom), nx, ny, poids)
!%
        if (laxi) then
            r = 0.d0
            do 40 i = 1, nno
                r = r + zr(igeom+2* (i-1))*zr(ivf+ldec+i-1)
 40         continue
            poids = poids*r
        endif
!%
        do 60 i = 1, nno
!
            do 50 j = 1, nno
                ii = 2*i
                jj = 2*j - 1
!
                a(ii,jj) = a(ii,jj) - poids/celer(1)*zr(ivf+ldec+i-1)* zr(ivf+ldec+j-1)
!
 50         continue
 60     continue
!
!     CALCUL DE LA VITESSE ABSOLUE
        do 70 i = 1, ndi
            vites(i) = zr(ivite+i-1) + zr(ivien+i-1)
 70     continue
!
        do 90 i = 1, ndi
            do 80 j = 1, ndi
                zr(ivectu+i-1) = zr(ivectu+i-1) - a(i,j)*vites(j)
 80         continue
 90     continue
!
100 end do
110 continue
!
end subroutine
