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

subroutine hujopt(fami, kpg, ksp, mod, angmas,&
                  imat, nmat, mater, nvi, vinf,&
                  nr, drdy, sigf, dsde, iret)
! person_in_charge: alexandre.foucault at edf.fr
!     ----------------------------------------------------------------
!     CALCUL DU JACOBIEN DU SYSTEME NL A RESOUDRE = DRDY(DY)
!     POUR LE MODELE HUJEUX
!     IN  MOD    :  TYPE DE MODELISATIONS
!         ANGMAS :  ANGLE NAUTIQUE (AFFE_CARA_ELEM)
!         NVI    :  NOMBRE DE VARIABLES INTERNES
!         NMAT   :  DIMENSION TABLEAU DES DONNEES MATERIAU
!         MATER  :  COEFFICIENTS MATERIAU
!         VINF   :  VARIABLES INTERNES A T+DT
!         NR     :  DIMENSION MATRICE JACOBIENNE
!         DRDY   :  MATRICE JACOBIENNE
!     OUT DSDE   :  MATRICE TANGENTE EN VITESSE
!     ----------------------------------------------------------------
    implicit none
!     ----------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterc/r8vide.h"
#include "asterfort/hujori.h"
#include "asterfort/hujtel.h"
#include "asterfort/hujtid.h"
#include "asterfort/lceqma.h"
#include "asterfort/lcinma.h"
#include "asterfort/lcprmm.h"
#include "asterfort/mgauss.h"
#include "asterfort/promat.h"
#include "asterfort/r8inir.h"
#include "asterfort/trace.h"
#include "asterfort/utmess.h"
    integer :: nmat, nr, nvi, iret, imat, kpg, ksp
    real(kind=8) :: drdy(nr, nr), dsde(6, 6), mater(nmat, 2), vinf(nvi)
    real(kind=8) :: angmas(3), sigf(6)
    character(len=*) :: fami
    character(len=8) :: mod
!
    integer :: nbmeca, norm, i, j, ndt, ndi, nz
    real(kind=8) :: hook(6, 6), un, zero, deux, trois, matert(22, 2)
    real(kind=8) :: e, nu, al, demu, la, e1, e2, e3, nu12, nu13, nu23, g1, g2
    real(kind=8) :: g3
    real(kind=8) :: nu21, nu31, nu32, denom, i1f, hooknl(6, 6), pref, ne
    real(kind=8) :: coef0
    real(kind=8) :: y0(6, 6), y1(6, 9), y2(9, 6), y3(9, 9)
    real(kind=8) :: y4(6, 6), y5(6, 6), det, maxi, mini
    real(kind=8) :: dsdeb(6, 6), bid16(6), bid66(6, 6)
    real(kind=8) :: ccond
    character(len=4) :: cargau
    aster_logical :: reorie
!
    parameter (ndt   = 6   )
    parameter (ndi   = 3   )
    parameter (zero  = 0.d0)
    parameter (un    = 1.d0)
    parameter (deux  = 2.d0)
    parameter (trois = 3.d0)
! === =================================================================
! --- RECHERCHE DU MAXIMUM DE DRDY
! === =================================================================
!
    norm=0
    if (norm .eq. 0) goto 5
!
    maxi = 0.d0
    do i = 1, nr
        do j = 1, nr
            if(abs(drdy(i,j)).gt.maxi)maxi = abs(drdy(i,j))
        end do
    end do
!
! === =================================================================
! --- DIMENSIONNEMENT A R8PREM
! === =================================================================
    mini = r8prem()*maxi
    do i = 1, nr
        do j = 1, nr
            if(abs(drdy(i,j)).lt.mini)drdy(i,j) = 0.d0
        end do
    end do
!
  5 continue
!
! === =================================================================
! --- SEPARATION DES TERMES DU JACOBIEN
! === =================================================================
! --- DETERMINATION DU NOMBRE DE MECANISMES ACTIFS - NBMECA
    nbmeca = 0
    do i = 1, 8
        if (vinf(23+i) .eq. un) nbmeca = nbmeca + 1
    enddo
!
    nz = 1+2*nbmeca
!
! === ==============================================================
! --- REDIMENSIONNEMENT DU JACOBIEN
! === ==============================================================
    ccond = mater(1,1)
    pref = mater(8,2)
!
! --- DLEDR
    do i = 1, nbmeca
        do j = 1, ndt
            drdy(j,ndt+1+i) = drdy(j,ndt+1+i)*abs(pref)
        enddo
    end do
!
! --- DLEDLA
    do i = 1, nbmeca
        do j = 1, ndt
            drdy(j,ndt+1+nbmeca+i) = drdy(j,ndt+1+nbmeca+i)*ccond
        enddo
    end do
!
! --- DLRDLA
    do i = 1, nbmeca
        drdy(ndt+1+i,ndt+1+nbmeca+i) = drdy(ndt+1+i,ndt+1+nbmeca+i) *ccond/abs(pref)
    end do
!
! --- DLRDEVP
    do i = 1, nbmeca
        drdy(ndt+1+i,ndt+1) = drdy(ndt+1+i,ndt+1)*ccond/abs(pref)
    end do
!
! --- DLEVPDS
    do i = 1, ndt
        drdy(ndt+1,i) = drdy(ndt+1,i)*ccond
    end do
!
! --- DLEVPDR
    do i = 1, nbmeca
        drdy(ndt+1,ndt+1+i) = drdy(ndt+1,ndt+1+i)/ccond*abs(pref)
    end do
!
! --- DLFDR
    do i = 1, nbmeca
        drdy(ndt+1+nbmeca+i,ndt+1+i) = drdy(ndt+1+nbmeca+i,ndt+1+i) *abs(pref)
    end do
!
! --- DLFDEVP
    do i = 1, nbmeca
        drdy(ndt+1+nbmeca+i,ndt+1) = drdy(ndt+1+nbmeca+i,ndt+1) *ccond
    end do
!
! ----------------------------------------------
! --- CONSTRUCTION DE L'OPERATEUR CONSISTANT ---
! ----------------------------------------------
    call lcinma(zero, y0)
    do i = 1, 9
        do j = 1, ndt
            y1(j,i) = zero
            y2(i,j) = zero
        enddo
        do j = 1, 9
            y3(i,j) = zero
        enddo
    end do
!
    do i = 1, ndt
        do j = 1, ndt
            y0(i,j) = drdy(i,j)
        enddo
        do j = 1, nz
            y1(i,j) = drdy(i,j+ndt)
        enddo
    end do
!
    do i = 1, nz
        do j = 1, ndt
            y2(i,j) = drdy(i+ndt,j)
        enddo
        do j = 1, nz
            y3(i,j) = drdy(i+ndt,j+ndt)
        enddo
    enddo
!
! === =================================================================
! --- CONSTRUCTION TENSEUR RIGIDITE ELASTIQUE A T+DT
! === =================================================================
! ====================================================================
! --- OPERATEURS ELASTICITE LINEAIRES---------------------------------
! ====================================================================
    call lcinma(zero, hook)
!
    if ((mod(1:2) .eq. '3D') .or. (mod(1:6) .eq. 'D_PLAN')) then
!
        if (mater(17,1) .eq. un) then
!
            e = mater(1,1)
            nu = mater(2,1)
            al = e*(un-nu) /(un+nu) /(un-deux*nu)
            demu = e /(un+nu)
            la = e*nu/(un+nu)/(un-deux*nu)
!
            do i = 1, ndi
                do j = 1, ndi
                    if (i .eq. j) hook(i,j) = al
                    if (i .ne. j) hook(i,j) = la
                enddo
            enddo
            do i = ndi+1, ndt
                hook(i,i) = demu
            enddo
!
        else if (mater(17,1).eq.deux) then
!
            e1 = mater(1,1)
            e2 = mater(2,1)
            e3 = mater(3,1)
            nu12 = mater(4,1)
            nu13 = mater(5,1)
            nu23 = mater(6,1)
            g1 = mater(7,1)
            g2 = mater(8,1)
            g3 = mater(9,1)
            nu21 = mater(13,1)
            nu31 = mater(14,1)
            nu32 = mater(15,1)
            denom= mater(16,1)
!
            hook(1,1) = (un - nu23*nu32)*e1/denom
            hook(1,2) = (nu21 + nu31*nu23)*e1/denom
            hook(1,3) = (nu31 + nu21*nu32)*e1/denom
            hook(2,2) = (un - nu13*nu31)*e2/denom
            hook(2,3) = (nu32 + nu31*nu12)*e2/denom
            hook(3,3) = (un - nu21*nu12)*e3/denom
            hook(2,1) = hook(1,2)
            hook(3,1) = hook(1,3)
            hook(3,2) = hook(2,3)
            hook(4,4) = g1
            hook(5,5) = g2
            hook(6,6) = g3
!
        else
            call utmess('F', 'COMPOR1_38')
        endif
    else if (mod(1:6) .eq. 'C_PLAN' .or. mod(1:2) .eq. '1D') then
        call utmess('F', 'COMPOR1_4')
    endif
! ====================================================================
! --- OPERATEUR ELASTICITE NON LINEAIRE ------------------------------
! ====================================================================
    i1f = trace(ndi,sigf)/trois
    ne = mater(1,2)
    if ((i1f/pref) .lt. 1.d-6) i1f = 1.d-6*pref
!
    coef0 = (i1f/pref) ** ne
    do i = 1, ndt
        do j = 1, ndt
            hooknl(i,j) = coef0*hook(i,j)
        enddo
    enddo
!
!     CHOIX DES PARAMETRES DE LANCEMENT DE MGAUSS
!     METHODE 'S' : SURE
    cargau = 'NCSP'
!     METHODE 'W' : RATEAU
!      CARGAU = 'NCWP'
! === =================================================================
! --- CONSTRUCTION TENSEUR CONSTITUTIF TANGENT DSDE
! === =================================================================
!     Y2=INVERSE(Y3)*Y2
    call mgauss(cargau, y3, y2, 9, nz,&
                ndt, det, iret)
    if (iret .gt. 1) then
        call lceqma(hook, dsde)
        goto 9999
    endif
!
! --- PRODUIT DU TERME Y1 * (Y3)^-1 * Y2 = Y4
    call promat(y1, ndt, ndt, 9, y2,&
                9, 9, ndt, y4)
!
! --- DIFFERENCE DE MATRICE (DR1DY1 - Y4) = Y5
    do i = 1, ndt
        do j = 1, ndt
            y5(i,j)=y0(i,j)-y4(i,j)
        enddo
    end do
!
! --- INVERSION DU TERME Y5
    call r8inir(ndt*ndt, 0.d0, dsdeb, 1)
    do i = 1, ndt
        dsdeb(i,i) = un
    end do
    call mgauss(cargau, y5, dsdeb, ndt, ndt,&
                ndt, det, iret)
!
    if (iret .gt. 1) then
        call lceqma(hook, dsde)
    else
        call lcinma(zero, dsde)
        call lcprmm(dsdeb, hooknl, dsde)
    endif
!
9999 continue
    if (angmas(1) .eq. r8vide()) then
        call utmess('F', 'ALGORITH8_20')
    endif
    reorie =(angmas(1).ne.zero) .or. (angmas(2).ne.zero)&
     &         .or. (angmas(3).ne.zero)
    if (iret .ne. 0) then
        iret = 0
        call hujori('LOCAL', 1, reorie, angmas, sigf,&
                    bid66)
        call hujtid(fami, kpg, ksp, mod, imat,&
                    sigf, vinf, dsde, iret)
        call hujori('GLOBA', 1, reorie, angmas, sigf,&
                    bid66)
        if (iret .ne. 0) then
            iret = 0
            do i = 1, 22
                matert(i,1) = mater(i,1)
                matert(i,2) = mater(i,2)
            enddo
            call hujtel(mod, matert, sigf, dsde)
        endif
    endif
    call hujori('GLOBA', 2, reorie, angmas, bid16,&
                dsde)
!
end subroutine
