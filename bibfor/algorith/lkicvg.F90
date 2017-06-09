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

subroutine lkicvg(nr, itmax, toler, iter, r,&
                  nvi, vinf, dy, irtet)
! person_in_charge: alexandre.foucault at edf.fr
!     ------------------------------------------------------------------
!       CONTROLE DE LA CONVERGENCE DU NEWTON LOCAL DE LETK
!                     - CONTROLE DU NOMBRE D ITERATIONS
!                     - CONTROLE DE LA PRECISION DE CONVERGENCEC
!     ------------------------------------------------------------------
!       IN  ITMAX  :  NB MAXI D ITERATIONS LOCALES
!           TOLER  :  TOLERANCE A CONVERGENCE
!           ITER   :  NUMERO ITERATION COURANTE
!           NR     :  DIMENSION R
!           R      :  RESIDU DU SYSTEME NL A L'ITERATION COURANTE
!           NVI    :  NOMBRE DE VARIABLES INTERNES
!           VINF   :  VARIABLES INTERNES A L'INSTANT T+DT
!           DY     :  SOLUTION DU SYSTEME NL A L'INSTANT T+DT
!
!       OUT IRET = 0  :  CONVERGENCE
!           IRET = 1  :  ITERATION SUIVANTE
!           IRET = 2  :  RE-INTEGRATION
!           IRET = 3  :  REDECOUPAGE DU PAS DE TEMPS
!           VINF(7)   :  SI ETAT PLASTIQUE NON VERIFIE - VINF(7)=0
!           DY(NDT+1) :  SI ETAT PLASTIQUE NON VERIFIE - DY(NDT+1)=0
!     ------------------------------------------------------------------
    implicit none
!     ------------------------------------------------------------------
    common /tdim/   ndt ,ndi
!     ------------------------------------------------------------------
    integer :: nr, itmax, iter, irtet, ndt, ndi, nvi
    real(kind=8) :: toler, r(nr), vinf(nvi), dy(nr)
!
    integer :: i
    real(kind=8) :: er, zero
    parameter       (zero  =  0.d0 )
!     ------------------------------------------------------------------
! === ==================================================================
! --- CALCUL DE LA NORME DE RINI ET DE R(Y)
! === ==================================================================
    er = zero
    do 10 i = 1, nr
        er = er + r(i)*r(i)
10  continue
    er = sqrt(er)
!
! === =================================================================
! --- TEST DE CONVERGENCE PAR RAPPORT A TOLER
! === =================================================================
    if (er .lt. toler) then
        if ((dy(ndt+1).ge.zero) .and. (vinf(7).gt.zero)) then
            irtet = 0
        else if (vinf(7).eq.zero) then
            irtet = 0
        else
            irtet = 2
            vinf(7) = zero
            do 20 i = 1, nr
                dy(i) = zero
20          continue
        endif
        goto 9999
    endif
!
! === ==================================================================
! --- SI NON CONVERGENCE: TEST DU N°ITERATION
! === ==================================================================
    if (iter .lt. itmax) then
        irtet = 1
    else
        irtet = 3
    endif
!
9999  continue
!
end subroutine
