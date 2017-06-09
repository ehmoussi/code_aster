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

subroutine lcrkbo(a, b, l0, l1, etamin,&
                  etamax, vide, nsol, sol, sgn)
    implicit none
#include "asterf_types.h"
#include "asterfort/lcvpbo.h"
#include "asterfort/utmess.h"
    real(kind=8), intent(in) :: a, b, l0, l1, etamin, etamax
    aster_logical,intent(out) :: vide
    integer, intent(out) :: nsol, sgn(2)
    real(kind=8), intent(out) :: sol(2)
!
! --------------------------------------------------------------------------------------------------
!  SOLUTION Q(ETA) := (POS(A*ETA+B))**2 + L0 + ETA*L1 = 0
! --------------------------------------------------------------------------------------------------
!  IN  A,B    COMPOSANTES DU TERME QUADRATIQUE
!  IN  L0,L1  COMPOSANTES DU TERME AFFINE
!  IN  ETAMIN BORNE MIN
!  IN  ETAMAX BORNE MAX
!  OUT VIDE   .TRUE. SI Q TJRS POSITIF DANS L'INTERVALLE
!  OUT NSOL   NOMBRE DE SOLUTIONS (0, 1 OU 2)
!  OUT SOL    VALEURS DES SOLUTIONS
!  OUT SGN    SIGNE DE DQ/DETA EN CHAQUE SOLUTION
! --------------------------------------------------------------------------------------------------
    real(kind=8), parameter :: zero=0.d0
! --------------------------------------------------------------------------------------------------
    aster_logical :: vide1, vide2
    integer :: i, nsol1, nsol2, sgn1(2), sgn2(2), ptr
    real(kind=8) :: smin, smax, etas, sol1(2), sol2(2)
! --------------------------------------------------------------------------------------------------
!
!
! INITIALISATION
    smin = a*etamin+b
    smax = a*etamax+b
!
!
!  TERME QUADRATIQUE NUL PARTOUT
    if (smin .le. 0 .and. smax .le. 0) then
        call lcvpbo(zero, zero, l0, l1, etamin,&
                    etamax, vide, nsol, sol, sgn)
        goto 999
    endif
!
!
!  TERME QUADRATIQUE NON NUL PARTOUT : Q = (A*ETA)**2 + M1*ETA + M0
    if (smin .ge. 0 .and. smax .ge. 0) then
        call lcvpbo(a, b, l0, l1, etamin,&
                    etamax, vide, nsol, sol, sgn)
        goto 999
    endif
!
!
!  LE TERME A*ETA+B CHANGE DE SIGNE
    etas = -b/a
!
!  QUADRATIQUE PUIS NUL
    if (a .le. 0) then
        call lcvpbo(a, b, l0, l1, etamin,&
                    etas, vide1, nsol1, sol1, sgn1)
        call lcvpbo(zero, zero, l0, l1, etas,&
                    etamax, vide2, nsol2, sol2, sgn2)
!
!  NUL PUIS QUADRATIQUE
    else
        call lcvpbo(zero, zero, l0, l1, etamin,&
                    etas, vide1, nsol1, sol1, sgn1)
        call lcvpbo(a, b, l0, l1, etas,&
                    etamax, vide2, nsol2, sol2, sgn2)
    endif
!
    vide = vide1 .and. vide2
    nsol = nsol1+nsol2
    if (nsol .gt. 2) call utmess('F', 'PILOTAGE_83')
!
    ptr = 0
    do i = 1, nsol1
        ptr = ptr+1
        sol(ptr)=sol1(i)
        sgn(ptr)=sgn1(i)
    end do
    do i = 1, nsol2
        ptr = ptr+1
        sol(ptr)=sol2(i)
        sgn(ptr)=sgn2(i)
    end do
!
!
999 continue
end subroutine
