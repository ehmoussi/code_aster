! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine hujmat(fami, kpg, ksp, mod, imat,&
                  tempf, materf, ndt, ndi, nvi)
    implicit none
! HUJEUX  : RECUPERATION DU MATERIAU A T(TEMPD) ET T+DT(TEMPF)
!           NB DE CMP DIRECTES/CISAILLEMENT , NB VAR. INTERNES
!           MATER(*,1) = E , NU , ALPHA
!           MATER(*,2) = N, BETA, D, M, PCO , PREF,
!                        ACYC, AMON, CCYC, CMON,
!                        RD_ELA, RI_ELA, RHYS, RMOB, XM
!           VARIABLES INTERNES : R1, R2, R3, R4, EPSI_VOLU_P,
!                                IND1, IND2, IND3, IND4
!           1, 2, 3 = DEVIATOIRE ; 4 = ISOTROPE ;
!           ( SIGNE = SIGNE(S:DEPSDP) )
!           ( IND = 0: MECANISME INACTIF, = 1: MECANISME ACTIF )
!    ------------------------------------------------------------
!    IN  FAMI     :  FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!        KPG,KSP  :  NUMERO DU (SOUS)POINT DE GAUSS
!        IMAT     :  ADRESSE DU MATERIAU CODE
!        MOD      :  TYPE DE MODELISATION
!        TEMPF    :  TEMPERATURE  A T+DT
!    OUT MATERF   :  COEFFICIENTS MATERIAU A T+DT
!                    MATER(*,1) = CARACTERISTIQUES   ELASTIQUES
!                    MATER(*,2) = CARACTERISTIQUES   PLASTIQUES
!        NDT      :  NB TOTAL DE COMPOSANTES TENSEURS
!        NDI      :  NB DE COMPOSANTES DIRECTES  TENSEURS
!        NVI      :  NB DE VARIABLES INTERNES
!    ------------------------------------------------------------
#include "asterfort/hujnvi.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvalb.h"
    integer :: ndt, ndi, nvi, imat, i, kpg, ksp
    real(kind=8) :: materf(22, 2), tempf, nu21, nu31, nu32
    character(len=16) :: phenom
    character(len=8) :: mod, nomc(24)
    character(len=*) :: fami
    integer :: icodre(1)
    integer :: cerr(24)
!
!
! ---- RECUPERATION DU TYPE DU MATERIAU DANS PHENOM
!      --------------------------------------------
    call rccoma(imat, 'ELAS', 1, phenom, icodre(1))
!
! -  NB DE COMPOSANTES / VARIABLES INTERNES
    call hujnvi(mod, ndt, ndi, nvi)
!
! -  RECUPERATION MATERIAU DES VARIABLES HUJEUX
!
    nomc(1) = 'E       '
    nomc(2) = 'NU      '
    nomc(3) = 'ALPHA   '
    nomc(4) = 'N       '
    nomc(5) = 'BETA    '
    nomc(6) = 'D       '
    nomc(7) = 'B       '
    nomc(8) = 'PHI     '
    nomc(9) = 'ANGDIL  '
    nomc(10)= 'PCO     '
    nomc(11)= 'PREF    '
    nomc(12)= 'ACYC    '
    nomc(13)= 'AMON    '
    nomc(14)= 'CCYC    '
    nomc(15)= 'CMON    '
    nomc(16)= 'RD_ELA  '
    nomc(17)= 'RI_ELA  '
    nomc(18)= 'RHYS    '
    nomc(19)= 'RMOB    '
    nomc(20)= 'XM      '
!af 30/04/07 debut
    nomc(21)= 'RD_CYC  '
    nomc(22)= 'RI_CYC  '
    nomc(23)= 'DILA    '
    nomc(24)= 'PTRAC   '
!af fin
!
    do i = 1, 22
        materf(i,1)=0.d0
        materf(i,2)=0.d0
    enddo
!
!
! --- RECUPERATION DES PROPRIETES DE LA LOI DE HUJEUX
    call rcvalb(fami, kpg, ksp, '+', imat,&
                ' ', 'HUJEUX', 0, '   ', [tempf],&
                21, nomc(4), materf(1, 2), cerr(4), 2)
!
!
    if (phenom .eq. 'ELAS') then
!
! --- RECUPERATION DES PROPRIETES ELASTIQUES
        call rcvalb(fami, kpg, ksp, '+', imat,&
                    ' ', phenom, 0, '   ', [tempf],&
                    3, nomc(1), materf(1, 1), cerr(1), 0, nan='NON')
!
        materf(17,1) =1.d0
!
    else if (phenom.eq.'ELAS_ORTH') then
!
        nomc(1) = 'E_L     '
        nomc(2) = 'E_T     '
        nomc(3) = 'E_N     '
        nomc(4) = 'NU_LT   '
        nomc(5) = 'NU_LN   '
        nomc(6) = 'NU_TN   '
        nomc(7) = 'G_LT    '
        nomc(8) = 'G_LN    '
        nomc(9) = 'G_TN    '
        nomc(10)= 'ALPHA_L '
        nomc(11)= 'ALPHA_T '
        nomc(12)= 'ALPHA_N '
!
! ----   RECUPERATION DES CARACTERISTIQUES MECANIQUES
!        -----------
!        E1   = MATERF(1,1)
!        E2   = MATERF(2,1)
!        E3   = MATERF(3,1)
!        NU12 = MATERF(4,1)
!        NU13 = MATERF(5,1)
!        NU23 = MATERF(6,1)
!        G1   = MATERF(7,1)
!        G2   = MATERF(8,1)
!        G3   = MATERF(9,1)
!        ALPHA1= MATERF(7,1)
!        ALPHA2= MATERF(8,1)
!        ALPHA3= MATERF(9,1)
        call rcvalb(fami, kpg, ksp, '+', imat,&
                    ' ', phenom, 0, '   ', [tempf],&
                    12, nomc(1), materf(1, 1), cerr(1), 0, nan='NON')
!
        nu21 = materf(2,1)*materf(4,1)/materf(1,1)
        nu31 = materf(3,1)*materf(5,1)/materf(1,1)
        nu32 = materf(3,1)*materf(6,1)/materf(2,1)
!
        materf(13,1) =nu21
        materf(14,1) =nu31
        materf(15,1) =nu32
        materf(16,1) =1.d0 - materf(6,1)*nu32 - nu31*materf(5,1)&
        - nu21*materf(4,1) - 2.d0*materf(6,1)*nu31*materf(4,1)
        materf(17,1) =2.d0
!
    endif
!
end subroutine
