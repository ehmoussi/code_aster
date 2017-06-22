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

subroutine lc0026(fami, kpg, ksp, ndim, imate,&
                  compor, crit, instam, instap, epsm,&
                  deps, sigm, vim, option, angmas,&
                  sigp, vip, typmod, icomp,&
                  nvi, dsidep, codret)
! aslint: disable=W1504,W0104
    implicit none
#include "asterfort/nmgran.h"
#include "asterfort/rcvarc.h"
    integer :: imate, ndim, kpg, ksp, codret, icomp, nvi, iret
    real(kind=8) :: crit(*), angmas(*)
    real(kind=8) :: instam, instap
    real(kind=8) :: epsm(6), deps(6)
    real(kind=8) :: sigm(6), sigp(6)
    real(kind=8) :: vim(*), vip(*), tm, tp, tref
    real(kind=8) :: dsidep(6, 6)
    character(len=16) :: compor(*), option
    character(len=8) :: typmod(*)
    character(len=*) :: fami
!
!     GRANGER*
! APPEL DE RCVARC POUR LE CALCUL DE LA TEMPERATURE
! RAISON: CETTE ROUTINE EST APPELEE PAR NMCPLA AVEC COMME
! TEMPERATURE LES VALEURS MIN ET MAX... IL FAUT DONC LAISSER
! L ARGUMENT
    call rcvarc(' ', 'TEMP', '-', fami, kpg,&
                ksp, tm, iret)
    call rcvarc(' ', 'TEMP', '+', fami, kpg,&
                ksp, tp, iret)
    call rcvarc(' ', 'TEMP', 'REF', fami, kpg,&
                ksp, tref, iret)
    call nmgran(fami, kpg, ksp, typmod, imate,&
                compor, instam, instap, tm, tp,&
                deps, sigm, vim, option, sigp,&
                vip, dsidep)
end subroutine
