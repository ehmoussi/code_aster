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

subroutine rslcvx(fami, kpg, ksp, imat, nmat,&
                  mater, sig, vin, seuil)
    implicit none
!       ROUSSELIER : CONVEXE ELASTO PLASTIQUE POUR (MATER,TEMP,SIG,B,P)
!                    SEUIL    F    = S - R(P) + D S1 F EXP(SIGM/S1)
!                                                T  1/2
!                       AVEC  S    = (3/2 SIGDV SIGDV)
!                             SIGDV  = SIG -1/3 TR(SIG)I
!                             R(P) = FCT DE P PAR POINTS
!                             SIGM  = 1/3 TR(SIG) I
!       ----------------------------------------------------------------
!       IN  FAMI   :  FAMILLE DES POINTS DE GAUSS
!       IN  KPG    :  NUMERO DU POINT DE GAUSS
!       IN  KSP    :  NUMERO DU SOUS POINT DE GAUSS
!       IN  SIG    :  CONTRAINTE
!       IN  VIN    :  VARIABLES INTERNES
!       IN  IMAT   :  ADRESSE DU MATERIAU CODE
!       IN  NMAT   :  DIMENSION MATER
!       IN  MATER  :  COEFFICIENTS MATERIAU A T+DT
!       OUT SEUIL  :  SEUIL  ELASTICITE
!       ----------------------------------------------------------------
#include "asterfort/lchydr.h"
#include "asterfort/lcnrts.h"
#include "asterfort/lcprsv.h"
#include "asterfort/lcsomh.h"
#include "asterfort/rsliso.h"
    integer :: nmat, imat, kpg, ksp
    character(len=*) :: fami
!
    real(kind=8) :: mater(nmat, 2), seuil
    real(kind=8) :: sig(6), rig(6), rigdv(6), rigm, vin(3)
    real(kind=8) :: unrho, d, s1, p, f, f0, rp, drdp
    real(kind=8) :: un, argmax
!
    parameter       ( un     = 1.d0   )
!       ----------------------------------------------------------------
    d = mater(1,2)
    s1 = mater(2,2)
    f0 = mater(3,2)
    p = vin(1)
    f = vin(2)
    argmax = 200.d0
!
! --    MATERIAU CASSE
    if (f .ge. mater(6,2)) then
        seuil = un
!
! --    MATERIAU SAIN
    else
        unrho = (un-f0)/(un-f)
        call lcprsv(unrho, sig, rig)
        call lchydr(rig, rigm)
        call lcsomh(rig, -rigm, rigdv)
        call rsliso(fami, kpg, ksp, '+', imat,&
                    p, rp, drdp)
        seuil = lcnrts(rigdv) - rp
        if ((rigm/s1) .gt. (argmax)) then
            seuil = seuil + d*s1*f*exp(argmax)
        else
            seuil = seuil + d*s1*f*exp(rigm/s1)
        endif
    endif
!
end subroutine
