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

subroutine encadr(func, x1, x2, f1, f2,&
                  niter, xmult, iret)
    implicit none
!
! aslint: disable=W0307
    interface
        function func(x)
            real(kind=8) :: x
            real(kind=8) :: func
        end function
    end interface
    real(kind=8) :: x1, x2, f1, f2, xmult
    integer :: niter, iret
!
!
!     DETERMINATION D'UN ENCADREMENT DU ZERO D'UNE FONCTION.
!
! IN      func       : FONCTION func
! IN      PREC    : PRECISION ABSOLUE :
!                   LA SOLUTION EST TELLE QUE func(X)<PREC
! IN      NITER   : NOMBRE D'ITERATIONS MAXIMUM
! IN/OUT  X1      : BORNE A GAUCHE TROUVEE
! IN/OUT  X2      : BORNE A DROITE TROUVEE
! OUT     F1      : VALEUR DE func EN X1
! OUT     F2      : VALEUR DE func EN X2
! OUT     IRET    : CODE RETOUR : IRET = 0 : OK
!                                 IRET = 1 : PB
!
! ----------------------------------------------------------------------
!
    integer :: i
!
    iret = 1
!
    if (x1 .eq. x2) goto 9999
!
    f1 = func(x1)
    f2 = func(x2)
    do 10 i = 1, niter
        if (f1*f2 .lt. 0.d0) then
            iret = 0
            goto 9999
        endif
        if (abs(f1) .lt. abs(f2)) then
            x1 = x1 + xmult*(x1-x2)
            f1 = func(x1)
        else
            x2 = x2 + xmult*(x2-x1)
            f2 = func(x2)
        endif
10  end do
!
! ----------------------------------------------------------------------
!
9999  continue
end subroutine
