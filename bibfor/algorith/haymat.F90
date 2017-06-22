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

subroutine haymat(fami, kpg, ksp, mod, imat,&
                  nmat, poum, coefel, coefpl, nvi,&
                  nr)
    implicit none
!     HAYHURST   : RECUPERATION DU MATERIAU A T ET T+DT
!                  NB DE CMP DIRECTES/CISAILLEMENT , NB VAR. INTERNES
!                  MATER(*,1) = E , NU , ALPHA
!                  MATER(*,2) = EPS0 , K , H1 , H2 , DELTA1 , DELTA2 ,
!                               H1ST , H2ST , KC , BIGS , SMALLS ,
!                               EPSC
!                  VARIABLES INTERNES :
!     ----------------------------------------------------------------
!     IN  FAMI   :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!         KPG,KSP:  NUMERO DU (SOUS)POINT DE GAUSS
!         MOD    :  TYPE DE MODELISATION
!         IMAT   :  ADRESSE DU MATERIAU CODE
!         NMAT   :  DIMENSION  DE MATER
!         POUM   :  '+' OU '-'
!     OUT COEFEL :  COEFFICIENTS MATERIAU POUR LA PARTIE ELASTIQUE
!         COEFPL :  COEFFICIENTS MATERIAU POUR LA PARTIE NON LINEAIRE
!         NDT    :  NB TOTAL DE COMPOSANTES TENSEURS
!         NDI    :  NB DE COMPOSANTES DIRECTES  TENSEURS
!         NR     :  NB DE COMPOSANTES SYSTEME NL
!         NVI    :  NB DE VARIABLES INTERNES
!     ----------------------------------------------------------------
#include "asterfort/rcvalb.h"
    integer :: kpg, ksp, nmat, nvi, imat, cerr(16), nr, ndt, ndi
    real(kind=8) :: coefel(nmat), coefpl(nmat)
    character(len=*) :: fami, poum
    character(len=8) :: mod, nomc(16)
!     ----------------------------------------------------------------
    common /tdim/   ndt  , ndi
!     ----------------------------------------------------------------
!
! -   RECUPERATION MATERIAU -----------------------------------------
!
    nomc(1) = 'E'
    nomc(2) = 'NU'
    nomc(3) = 'ALPHA'
    nomc(4) = 'EPS0'
    nomc(5) = 'K'
    nomc(6) = 'H1'
    nomc(7) = 'H2'
    nomc(8) = 'DELTA1'
    nomc(9) = 'DELTA2'
    nomc(10) = 'H1ST'
    nomc(11) = 'H2ST'
    nomc(12) = 'BIGA'
    nomc(13) = 'SIG0'
    nomc(14) = 'KC'
    nomc(15) = 'ALPHAD'
    nomc(16) = 'S_EQUI_D'
!
!
! -   RECUPERATION MATERIAU A (T)
!
    call rcvalb(fami, kpg, ksp, poum, imat,&
                ' ', 'ELAS', 0, ' ', [0.d0],&
                3, nomc(1), coefel, cerr(1), 0)
!
    if (cerr(3) .ne. 0) coefel(3) = 0.d0
!
    call rcvalb(fami, kpg, ksp, poum, imat,&
                ' ', 'HAYHURST', 0, ' ', [0.d0],&
                13, nomc(4), coefpl, cerr(4), 1)
!
!     NOMBRE DE COEF MATERIAU
    coefpl(nmat)=15
!
    if (mod(1:2) .eq. '3D') then
! =================================================================
! - MODELISATION DE TYPE 3D ---------------------------------------
! =================================================================
        ndt = 6
        ndi = 3
        else if ( mod(1:6).eq.'D_PLAN'.or. mod(1:4).eq.'AXIS' .or.&
    mod(1:6).eq.'C_PLAN' ) then
! =================================================================
! - D_PLAN AXIS C_PLAN --------------------------------------------
! =================================================================
!         ON DEVRAIT AVOIR NDT=4 MAIS PB DANS LCJACP
        ndt = 6
        ndi = 3
    endif
! =================================================================
! - NOMBRE DE VARIABLES INTERNES
! =================================================================
    nvi = 12
    nr=ndt+4
!     ON PEUT DIMINUER : NR=NDT+2
!
end subroutine
