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

subroutine divgra(e1, e2, dfde, dfdk, vibarn,&
                  divsig)
    implicit none
!...............................................................
!
! BUT: CALCUL DE LA DIVERGENCE SURFACIQUE DU GRADIENT DE PHIBARRE
!
!     ENTREES  ---> DERIVEES DE FONCTIONS DE FORME
!...............................................................
!
#include "jeveux.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/subacv.h"
#include "asterfort/sumetr.h"
    real(kind=8) :: dfde(9, 9), dfdk(9, 9), vibarn(2, 9)
    real(kind=8) :: divsig(9)
    real(kind=8) :: cova(3, 3), metr(2, 2), a(2, 2), jc, cnva(3, 3)
    real(kind=8) :: dvibar(2, 9), e1(3, 9), e2(3, 9)
    integer :: i, j, itemp, ipg, kdec, idec, idir, jdir
    integer :: ndim, nno, nnos, npg1, ipoids, ivf, idfdx, idfdy, jgano
!-----------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfdx,jgano=jgano)
    idfdy = idfdx + 1
!
    call jevech('PTEMPER', 'L', itemp)
!
! --- CALCUL DE VITESSE PERMANENTE FLUIDE AUX NOEUDS
!
    do 10 i = 1, nno
        vibarn(1,i)=0.0d0
        vibarn(2,i)=0.0d0
        do 20 j = 1, nno
            vibarn(1,i)=vibarn(1,i)+(zr(itemp+j-1)*dfde(j,i))
            vibarn(2,i)=vibarn(2,i)+(zr(itemp+j-1)*dfdk(j,i))
20      continue
10  end do
!
! --- CALCUL DE LA DERIVEE DE LA COMPOSANTE DE VITESSE COVARIANTE
!     AU POINT DE GAUSS
    do 30 ipg = 1, npg1
        kdec=(ipg-1)*nno*ndim
        dvibar(1,ipg)=0.0d0
        dvibar(2,ipg)=0.0d0
        do 31 i = 1, nno
            idec=(i-1)*ndim
!
            dvibar(1,ipg)=dvibar(1,ipg)+vibarn(1,i)*zr(idfdx+kdec+&
            idec)
            dvibar(2,ipg)=dvibar(2,ipg)+vibarn(2,i)*zr(idfdy+kdec+&
            idec)
!
31      continue
30  end do
!
! --- CALCUL  DE LA DIVERGENCE SURFACIQUE
!     DU GRADIENT DU POTENTIEL PERMANENT EVALUE AU NOEUD
!
    do 40 ipg = 1, npg1
        divsig(ipg)=0.d0
        do 41 i = 1, 3
            cova(i,1)=e1(i,ipg)
            cova(i,2)=e2(i,ipg)
41      continue
!
!        KDEC=(IPG-1)*NNO*NDIM
!
! ------ ON CALCULE LE TENSEUR METRIQUE AU POINT DE GAUSS
!
        call sumetr(cova, metr, jc)
!
! ------ CALCUL DE LA BASE CONTRAVARIANTE AU POINT DE GAUSS
!
        call subacv(cova, metr, jc, cnva, a)
!
        do 51 idir = 1, 2
            do 61 jdir = 1, 2
                divsig(ipg)= divsig(ipg)+a(idir,jdir)*dvibar(idir,ipg)
61          continue
51      continue
40  end do
!
end subroutine
