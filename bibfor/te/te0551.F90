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

subroutine te0551(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/rcvalb.h"
    character(len=16) :: option, nomte
!
!     BUT:
!       CALCUL DE LA DURETE ASSOCIEE A LA METALLURGIE
!       OPTION : 'DURT_ELNO'
!
! ----------------------------------------------------------------------
!
!
!
    integer :: i, idfde, idurt, iphasi, ivf, ndim, nnos
    integer :: jgano, nno, ipoids, matos, imate, kn
    integer :: npg, icodre(5), kpg, spt
!
    real(kind=8) :: phase(5), valres(5), zalpha, durtno
!
    character(len=8) :: fami, poum
    character(len=24) :: nomres(5)
!
!-----------------------------------------------------------------------
!
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    call jevech('PMATERC', 'L', imate)
    call jevech('PPHASIN', 'L', iphasi)
    call jevech('PDURT_R', 'E', idurt)
    matos = zi(imate)
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
!
! --- RECUPERATION DES CARACTERISTIQUES
    nomres(1) = 'F1_DURT'
    nomres(2) = 'F2_DURT'
    nomres(3) = 'F3_DURT'
    nomres(4) = 'F4_DURT'
    nomres(5) = 'C_DURT'
!
    call rcvalb(fami, kpg, spt, poum, matos,&
                ' ', 'DURT_META', 1, 'TEMP', [0.d0],&
                5, nomres, valres, icodre, 2)
!
    do 10 kn = 1, nno
        zalpha = 0.d0
!
! ----- RECUPERATION Z POUR CHAQUE PHASE
        do 20 i = 1, 4
            phase(i) = zr(iphasi+7*(kn-1)+i-1)
            zalpha = zalpha + phase(i)
20      continue
        phase(5) = 1 - zalpha
!
! ---- CALCUL DE LA DURETE
        durtno = 0.d0
        do 30 i = 1, 5
            durtno = durtno + phase(i) * valres(i)
30      continue
!
        zr(idurt+(kn-1)) = durtno
!
10  end do
!
!
end subroutine
