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

subroutine nmmess(code, dp0, dp1, dp, func,&
                  nit, nitmax, iret)
!
!
! aslint: disable=W0307
    implicit none
#include "jeveux.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
    interface
        function func(x)
            real(kind=8) :: x
            real(kind=8) :: func
        end function
    end interface
    integer :: nit, nitmax, iret
    real(kind=8) :: dp0, dp1, dp
    character(len=1) :: code
!
! ......................................................................
!    - FONCTION REALISEE: MESSAGE D'ERREUR DETAILLE EN CAS DE NON
!                         CONVERGENCE DANS LES ROUTINES DE RECHERCHE
!                         DE ZERO DE func(DP)
!
!    - ARGUMENTS:
!        DONNEES:     CODE    : 'A', 'E' OU 'F' PASSE A UTMESG
!                     DP0     : DP INITIAL (0 EN GENERAL)
!                     DP1     : DP MAXI ESTIME
!                     DP      : DERNIER DP CALCULE
!                     func       : NOM DE LA FONCTION
!                     NIT     : NOMBRE D'ITERATIONS ATTEINT
!                     NITMAX  : NOMBRE D'ITERATIONS MAXIMUM
!                     IRET    : CODE RETOUR DE L'ALGO DE RECHERCHE
!                               IRET = 0 : OK
!                               IRET = 1 : ON NE TROUVE PAS DPMAX
!                               IRET = 2 : NITER INSUFFISANT
!                               IRET = 3 : func(XMIN) > 0
! ......................................................................
!
    character(len=8) :: nomail
    character(len=24) :: valk
!
    integer :: iadzi, iazk24, nbp, i
    integer :: vali(2)
    real(kind=8) :: dpi, f0, f1, fp, fi
    real(kind=8) :: valr(2)
!
    if (iret .eq. 0) goto 999
!
    call tecael(iadzi, iazk24)
    nomail= zk24(iazk24-1+3)(1:8)
!
!
    if (iret .eq. 1) then
        call utmess(code//'+', 'ALGORITH15_45')
    else if (iret.eq.2) then
        call utmess(code//'+', 'ALGORITH15_46')
    else if (iret.eq.3) then
        call utmess(code//'+', 'ALGORITH15_47')
    endif
!
    valk = nomail
    vali (1) = nit
    vali (2) = nitmax
    call utmess(code//'+', 'ALGORITH15_48', sk=valk, ni=2, vali=vali)
    fp = func(dp)
    valr (1) = dp
    valr (2) = fp
    call utmess(code//'+', 'ALGORITH15_49', nr=2, valr=valr)
    f0 = func(dp0)
    valr (1) = dp0
    valr (2) = f0
    call utmess(code//'+', 'ALGORITH15_50', nr=2, valr=valr)
    f1 = func(dp1)
    valr (1) = dp1
    valr (2) = f1
    call utmess(code//'+', 'ALGORITH15_51', nr=2, valr=valr)
    nbp=100
!
    vali (1) = nbp
    call utmess(code//'+', 'ALGORITH15_52', si=vali(1))
    do i = 1, nbp
        dpi=dp0+i*(dp1-dp0)/nbp
        fi = func(dpi)
        valr (1) = dpi
        valr (2) = fi
        call utmess(code//'+', 'ALGORITH15_53', nr=2, valr=valr)
    end do
!
    call utmess(code, 'VIDE_1')
999 continue
end subroutine
