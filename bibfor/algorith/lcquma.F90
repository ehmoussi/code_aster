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

subroutine lcquma(mat, fami, kpg, ksp, poum)
    implicit none
#include "asterfort/rcvalb.h"
    integer,intent(in) :: mat, kpg, ksp
    character(len=1),intent(in) :: poum
    character(len=*),intent(in) :: fami
! --------------------------------------------------------------------------------------------------
!   ENDOMMAGEMENT FRAGILE A GRADIENT DE VARIABLE INTERNE ENDO_SCALAIRE
!            LECTURE DES PARAMETRES DU CRITERE QUADRATIQUE
! --------------------------------------------------------------------------------------------------
! IN  MAT    ADRESSE DU MATERIAU
! IN  FAMI   FAMILLE DE POINTS D'INTEGRATION (SI 'NONE', PAS DE TEMP.)
! IN  KPG    NUMERO DU POINT D'INTEGRATION
! IN  KSP    NUMERO DU SOUS-POINT
! IN  POUM   LECTURE DES PARAMETRES EN DEBUT '-' OU FIN '+' DU PAS
! --------------------------------------------------------------------------------------------------
    integer         :: iok(7)
    real(kind=8)    :: valer(7), coef, cc, cv, e, nu,rdum(1)
    character(len=8):: nomdum(1)
    character(len=16):: nomer(7)
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: lambda, deuxmu, troisk, gamma, rigmin, pc, pr, epsth
    common /lcee/ lambda,deuxmu,troisk,gamma,rigmin,pc,pr,epsth
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: pk, pm, pp, pq
    common /lces/ pk,pm,pp,pq
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: pct, pch, pcs
    common /lcmqu/ pch,pct,pcs
! --------------------------------------------------------------------------------------------------
    data nomer /'K','M','P','Q','COEF_RIGI_MINI','C_VOLU','C_COMP'/
! --------------------------------------------------------------------------------------------------

    call rcvalb(fami, kpg, ksp, poum, mat,' ', 'ENDO_SCALAIRE', 0, nomdum, rdum, &
                7, nomer, valer, iok, 2)
!
    pk     = valer(1)
    pm     = valer(2)
    pp     = valer(3)
    pq     = valer(4)
    rigmin = valer(5)
    cv     = valer(6)
    cc     = valer(7)
!
    coef   = troisk/(2*deuxmu)
    nu     = (2*coef-1)/(4*coef+1)
    e      = deuxmu*(1+nu)
!
    pcs    = 0.5d0*e / ( (1-2*nu)*cc + sqrt(coef*cv*(1-2*nu)**2 + (1+nu)**2) )**2
    pch    = cv*coef*pcs
    pct    = cc*sqrt(pcs)
!
end subroutine
