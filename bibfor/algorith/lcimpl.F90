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

subroutine lcimpl(fami, kpg, ksp, imate, em,&
                  ep, sigm, tmoins, tplus, deps,&
                  vim, option, sigp, vip, dsde)
!
!
!
!
    implicit none
!     ------------------------------------------------------------------
!     ARGUMENTS
!     ------------------------------------------------------------------
#include "asterfort/rcvalb.h"
#include "asterfort/verift.h"
    real(kind=8) :: em, ep, et, sigy, tmoins, tplus
    real(kind=8) :: sigm, deps, pm, vim(*), vip(*), dt, p
    real(kind=8) :: sigp, dsde
    character(len=16) :: option
    character(len=*) :: fami
    integer :: kpg, ksp, imate
!     ------------------------------------------------------------------
!     VARIABLES LOCALES
!     ------------------------------------------------------------------
    real(kind=8) :: rprim, rm, sige, valres(2), depsth
    real(kind=8) :: sieleq, rp, dp
    integer :: codres(2)
    character(len=16) :: nomecl(2)
    data nomecl/'D_SIGM_EPSI','SY'/
!
!
    pm = vim(1)
    dt = tplus-tmoins
!
!
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ECRO_LINE', 0, ' ', [0.d0],&
                1, nomecl, valres, codres, 1)
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'ECRO_LINE', 0, ' ', [0.d0],&
                1, nomecl(2), valres(2), codres(2), 0)
!
    if (codres(2) .ne. 0) valres(2) = 0.d0
    et = valres(1)
    sigy = valres(2)
    rprim = ep*et/ (ep-et)
    rm = rprim*vim(1) + sigy
!
!     ------------------------------------------------------------------
!     ESTIMATION ELASTIQUE
!     ------------------------------------------------------------------
    call verift(fami, kpg, ksp, 'T', imate,&
                epsth_=depsth)
    sige = ep* (sigm/em+deps-depsth)
    sieleq = abs(sige)
!     ------------------------------------------------------------------
!     CALCUL EPSP, P , SIG
!     ------------------------------------------------------------------
    if (option .eq. 'RAPH_MECA') then
        if (sieleq .le. rm) then
            dp=0.d0
            sigp = sige
            dsde = ep
            vip(1) = vim(1)
        else
            dp = abs(sige) - rm
            dp = dp/ (rprim+ep)
            rp = sigy + rprim* (pm+dp)
            vip(1) = vim(1) + dp
            sigp = sige/ (1.d0+ep*dp/rp)
        endif
        vip(2) = dp/dt
    endif
    if (option(1:16) .eq. 'RIGI_MECA_IMPLEX') then
!    EXTRAPOLATION
        dp=max(vim(2)*dt,0.d0)
        p= vim(1) + dp
!    MISE A JOUR DE LA VARIABLE INTERNE
        rp=sigy+rprim*(p)
!    CONTRAINTES
        sigp=sige/(1.d0+(ep*dp/rp))
!    MATRICE
        dsde = ep
    endif
!
end subroutine
