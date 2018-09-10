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
!
subroutine nmnkft(solver, sddisc, iterat_)
!
implicit none
!
#include "asterfort/jeveuo.h"
#include "asterfort/nmlere.h"
#include "asterfort/nmlerr.h"
!
character(len=19), intent(in) :: solver, sddisc
integer, optional, intent(in) :: iterat_
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE POUR METHODE DE NEWTON INEXACTE
!
! CALCUL DE LA PRECISION DE LA RESOLUTION DU SYSTEME LINEAIRE A CHAQUE
! ITERATION DE NEWTON POUR NEWTON-KRYLOV APPELEE FORCING TERM
!
! --------------------------------------------------------------------------------------------------
!
!
! SCHEMA DE CALCUL INPIRE DE "SOLVING NONLINEAR EQUATION WITH
!     NEWTON'S METHOD", C.T. KELLEY, SIAM, PAGE 62-63
! IN  SDDISC : SD DISCRETISATION
! IN  ITERAT : NUMERO ITERATION NEWTON
!
! --------------------------------------------------------------------------------------------------
!
    integer ::  ibid, iterat
    real(kind=8) :: epsi, epsold, resnew(1), resold(1), epsmin
    real(kind=8), pointer :: slvr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jeveuo(solver//'.SLVR', 'E', vr=slvr)
    if (.not. present(iterat_)) then
        call nmlerr(sddisc, 'L', 'INIT_NEWTON_KRYLOV', epsi, ibid)
    else
        iterat = iterat_
        if (iterat .eq. 0) then
            call nmlere(sddisc, 'L', 'VCHAR', iterat, resold(1))
        else
            call nmlere(sddisc, 'L', 'VMAXI', iterat-1, resold(1))
        endif
        call nmlerr(sddisc, 'L', 'ITER_NEWTON_KRYLOV', epsold, ibid)
        call nmlere(sddisc, 'L', 'VMAXI', iterat, resnew(1))
        if (resold(1) .eq. 0.d0) then
            epsi=epsold
            goto 10
        endif
        if ((0.9d0*epsold**2) .gt. 0.2d0) then
            epsi=min(max(0.1d0*resnew(1)**2/resold(1)**2,0.9d0*epsold**2),4.d-1*epsold)
        else
            epsmin = slvr(1)
            epsi=max(min(0.1d0*resnew(1)**2/resold(1)**2,4.d-1*epsold),epsmin)
        endif
    endif
!
10  continue
!
! --- STOCKAGE DE LA PRECISION CALCULEE POUR ITERATION SUIVANTE
!
    call nmlerr(sddisc, 'E', 'ITER_NEWTON_KRYLOV', epsi, ibid)
!
! --- COPIE DE LA PRECISION CALCULEE DANS LA SD SOLVEUR
!
    slvr(2)=epsi
!
end subroutine
