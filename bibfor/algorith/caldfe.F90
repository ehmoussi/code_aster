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

subroutine caldfe(df, nr, nvi, vind, dfpds,&
                  fe, dfpdbs, msdgdt, drdy)
!
    implicit none
! person_in_charge: jean-michel.proix at edf.fr
!     ----------------------------------------------------------------
!
!     MONOCRISTAL : calcul des derivees de Fe en GDEF
!     IN  DF     :  GRADIENT DF
!         NR     :  DIMENSION DECLAREE DRDY
!         VIND   :  VARIABLES INTERNES A L'INSTANT PRECEDENT
!         DFPDS  :  DERIVEE DE FP PAR RAPPORT A S
!         FE     :  GRADIENT ELASTIQUE FE
!         DFPDBS :  DERIVEE DE FP PAR RAPPORT A BETA_S
!         MSDGDT :  SOMME DES MUS(I)*MUS(J)*DGAMMAS/DTAUS
!       OUT DRDY :  BLOC ((1-6),(7-NS)) JACOBIEN DU SYSTEME NON LINEAIRE
!
#include "asterfort/pmat.h"
#include "asterfort/r8inir.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/dscal.h"
    integer :: nr, ndt, ndi, ns, i, j, k, l, m, ind(3, 3), nvi
    real(kind=8) :: fe(3, 3), df(3, 3), dfpds(3, 3, 3, 3), msdgdt(6, 6)
    real(kind=8) :: dfefdt(3, 3, 3, 3)
    real(kind=8) :: vind(*), dfeds(3, 3, 3, 3), dfefds(3, 3, 3, 3), dffe(3, 3)
    real(kind=8) :: fem(3, 3)
    real(kind=8) :: id(3, 3), drdy(nr, nr)
    real(kind=8) :: dfpdbs(3, 3, 30), dfedbs(3, 3, 30), dfefdb(3, 3, 30)
!     ----------------------------------------------------------------
    common /tdim/   ndt , ndi
!     ----------------------------------------------------------------
    data id/1.d0,0.d0,0.d0, 0.d0,1.d0,0.d0, 0.d0,0.d0,1.d0/
    data ind/1,4,5,4,2,6,5,6,3/
!     ----------------------------------------------------------------
!
    ns=nr-6
!
    call dcopy(9, vind(nvi-3-18+10), 1, fem, 1)
    call daxpy(9, 1.d0, id, 1, fem,&
               1)
    call pmat(3, df, fem, dffe)
!
!     on calcule dFe/dS
    call r8inir(81, 0.d0, dfeds, 1)
    do 1004 i = 1, 3
        do 1004 j = 1, 3
            do 1004 k = 1, 3
                do 1004 l = 1, 3
                    do 1004 m = 1, 3
                        dfeds(i,j,k,l)=dfeds(i,j,k,l)+dffe(i,m)*dfpds(&
                        m,j,k,l)
1004                  continue
!
    call r8inir(81, 0.d0, dfefds, 1)
    do 1005 i = 1, 3
        do 1005 j = 1, 3
            do 1005 k = 1, 3
                do 1005 l = 1, 3
                    do 1005 m = 1, 3
                        dfefds(i,j,k,l)=dfefds(i,j,k,l)+dfeds(m,i,k,l)&
                        *fe(m,j)
1005                  continue
!
    call r8inir(81, 0.d0, dfefdt, 1)
    do 1006 i = 1, 3
        do 1006 j = 1, 3
            do 1006 k = 1, 3
                do 1006 l = 1, 3
                    do 1006 m = 1, 3
                        dfefdt(i,j,k,l)=dfefdt(i,j,k,l)+dfeds(m,j,k,l)&
                        *fe(m,i)
1006                  continue
!
    call daxpy(81, 1.d0, dfefds, 1, dfefdt,&
               1)
    call dscal(81, -0.5d0, dfefdt, 1)
!
    do 1007 i = 1, 3
        do 1007 j = 1, 3
            do 1007 k = 1, 3
                do 1007 l = 1, 3
                    msdgdt(ind(i,j),ind(k,l))=dfefdt(i,j,k,l)
1007              continue
!
!
!     on calcule dFe/dbetas
    call r8inir(3*3*ns, 0.d0, dfedbs, 1)
    do 1014 i = 1, 3
        do 1014 j = 1, 3
            do 1014 k = 1, ns
                do 1014 m = 1, 3
                    dfedbs(i,j,k)=dfedbs(i,j,k)+dffe(i,m)*dfpdbs(m,j,&
                    k)
1014              continue
!
    call r8inir(3*3*ns, 0.d0, dfefdb, 1)
    do 1015 i = 1, 3
        do 1015 j = 1, 3
            do 1015 k = 1, ns
                do 1015 m = 1, 3
                    dfefdb(i,j,k)=dfefdb(i,j,k)+dfedbs(m,i,k)*fe(m,j)&
                    +dfedbs(m,j,k)*fe(m,i)
1015              continue
!
    call dscal(3*3*ns, -0.5d0, dfefdb, 1)
!
    do 1018 i = 1, 3
        do 1018 j = 1, 3
            do 1018 k = 1, ns
                drdy(ind(i,j),6+k)=dfefdb(i,j,k)
1018          continue
end subroutine
