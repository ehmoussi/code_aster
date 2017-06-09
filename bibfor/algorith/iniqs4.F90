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

subroutine iniqs4(nno, sdfde, sdfdk, poipg, coopg)
    implicit none
#include "jeveux.h"
#include "asterfort/elraga.h"
#include "asterfort/elrefe_info.h"
    integer :: nno
    real(kind=8) :: sdfde(4, 4), sdfdk(4, 4), coopg(8), poipg(4)
!
!   BUT : RECUPERER TOUS LES INDICES DU VECTEUR ZR DANS LEQUEL
!         SE TROUVE LES COORD., LES DFDE et DFDK, LE POIDS DE
!         LA DEUXIEMME FAMILLE DE PT DE GAUSS DE QUAS4.
!
!        IN   :  NNO  NOMBRE DE NOEUDS
!        OUT  :  DFDE   DERIVEE DES FF DANS REP DE REF
!        OUT  :  DFDK   DERIVEE DES FF DANS REP DE REF
!        OUT  :  POIDS  POIDS DES PTS DE GAUSS
!        OUT  :  COOPG  COORD.DES PTS DE GAUSS
!
! =============================================================
!
    integer :: i, j, k, ndim, nnos, npg, ipoids, ivf, idfde, jgano, nbpg
    character(len=8) :: elrefe, famil
!     ------------------------------------------------------------------
!
!
    elrefe = 'QU4     '
    famil = 'FPG4    '
!
    call elraga(elrefe, famil, ndim, nbpg, coopg,&
                poipg)
!
    call elrefe_info(elrefe=elrefe,fami='MASS',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
    do 40 i = 1, npg
        k = 2*nno*(i-1)
        do 30 j = 1, nno
            sdfde(i,j) = zr(idfde+k+2*(j-1)-1+1)
            sdfdk(i,j) = zr(idfde+k+2*(j-1)-1+2)
30      continue
40  end do
!
end subroutine
