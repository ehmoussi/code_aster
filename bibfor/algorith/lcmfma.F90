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

subroutine lcmfma(mat, fami, kpg, ksp, poum)
    implicit none
#include "asterfort/rcvalb.h"
    integer,intent(in) :: mat, kpg, ksp
    character(len=1),intent(in):: poum
    character(len=*),intent(in) :: fami
! --------------------------------------------------------------------------------------------------
!   ENDOMMAGEMENT FRAGILE A GRADIENT DE VARIABLE INTERNE ENDO_SCALAIRE
!            LECTURE DES PARAMETRES DU CRITERE EXPONENTIEL
! --------------------------------------------------------------------------------------------------
! IN  MAT    ADRESSE DU MATERIAU
! IN  FAMI   FAMILLE DE POINTS D'INTEGRATION (SI 'NONE', PAS DE TEMP.)
! IN  KPG    NUMERO DU POINT D'INTEGRATION
! IN  KSP    NUMERO DU SOUS-POINT
! IN  POUM   LECTURE DES PARAMETRES EN DEBUT '-' OU FIN '+' DU PAS
! --------------------------------------------------------------------------------------------------
    integer,parameter :: nber=9
! --------------------------------------------------------------------------------------------------
    integer :: iok(nber)
    real(kind=8) :: valer(nber),rdum(1)
    character(len=8):: nomdum(1)
    character(len=16):: nomer(nber)
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: lambda, deuxmu, troisk, gamma, rigmin, pc, pr, epsth
    common /lcee/ lambda,deuxmu,troisk,gamma,rigmin,pc,pr,epsth
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: pk, pm, pp, pq
    common /lces/ pk,pm,pp,pq
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: tau, sig0, beta
    common /lcmmf/ tau,sig0,beta
! --------------------------------------------------------------------------------------------------
    data nomer /'K','M','P','Q','COEF_RIGI_MINI','TAU','SIG0','BETA','REST_RIGIDITE'/
! --------------------------------------------------------------------------------------------------
!
    call rcvalb(fami, kpg, ksp, poum, mat, ' ', 'ENDO_FISS_EXP', 0, nomdum(1), rdum(1),&
                nber, nomer, valer, iok, 2)
    pk = valer(1)
    pm = valer(2)
    pp = valer(3)
    pq = valer(4)
    rigmin = valer(5)
    tau = valer(6)
    sig0 = valer(7)
    beta = valer(8)
    gamma = valer(9)
!
end subroutine
