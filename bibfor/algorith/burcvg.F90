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

subroutine burcvg(nr, itmax, toler, iter, dy,&
                  r, rini, irtet)
! person_in_charge: alexandre.foucault at edf.fr
!       ----------------------------------------------------------------
!       CONTROLE DE LA CONVERGENCE DE LA METHODE DE NEWTON :
!
!                       - CONTROLE DU NOMBRE D ITERATIONS
!                       - CONTROLE DE LA PRECISION DE CONVERGENCE
!                       - CONTROLE DE LA VALIDITE SOLUTION A CONVERGENCE
!                       - CONTROLE DES RE-INTEGRATIONS EVENTUELLES
!                       - CONTROLE DU REDECOUPAGE DU PAS DE TEMPS
!
!       ----------------------------------------------------------------
!       IN  ITMAX  :  NB MAXI D ITERATIONS LOCALES
!           TOLER  :  TOLERANCE A CONVERGENCE
!           ITER   :  NUMERO ITERATION COURANTE
!           INTG   :  NUMERO INTEGRATION COURANTE
!           NR     :  DIMENSION DY DDY
!           DY     :  INCREMENT DU VECTEUR SOLUTION (YF-YD)
!           R      :  RESIDU DU SYSTEME NL A L'ITERATION COURANTE
!           RINI   :  RESIDU DU SYSTEME NL APRES TIR D'EULER
!       OUT IRTET = 0:  CONVERGENCE
!           IRTET = 1:  ITERATION SUIVANTE
!           IRTET = 2:  RE-INTEGRATION
!           IRTET = 3:  REDECOUPAGE DU PAS DE TEMPS
!       ----------------------------------------------------------------
    implicit none
!     ----------------------------------------------------------------
    common /tdim/   ndt ,ndi
!     ----------------------------------------------------------------
    integer :: i, nr, itmax, iter, irtet, imax, ndt, ndi
    real(kind=8) :: toler, r(nr), rini(nr), dy(nr)
    real(kind=8) :: er, erini, ndy, maxi
!       ----------------------------------------------------------------
! === =================================================================
! --- CALCUL DE LA NORME DE RINI ET DE R(Y)
! === =================================================================
    er = 0.0d0
    erini = 0.0d0
    do 1 i = 1, nr
        er = er + r(i)*r(i)
        erini = erini + rini(i)*rini(i)
 1  end do
    er = sqrt(er)
    erini = sqrt(erini)
!      IF(ERINI.GT.TOLER)ER=ER/ERINI
! === =================================================================
! --- TEST DE CONVERGENCE PAR RAPPORT A TOLER
! === =================================================================
    if (er .lt. toler) then
        irtet = 0
        goto 9999
    endif
! === =================================================================
! --- TEST DE CONVERGENCE PAR RAPPORT A DY
! === =================================================================
    if (er .lt. erini) then
        ndy = 0.d0
        do 2 i = ndt+1, 2*ndt
            ndy = ndy + dy(i)*dy(i)
 2      continue
        ndy = sqrt(ndy)
        if (ndy .lt. toler) then
            maxi = 0.d0
            imax = 0
            do 3 i = 1, nr
                if (abs(r(i)) .gt. maxi) then
                    maxi = abs(r(i))
                    imax = i
                endif
 3          continue
            if (imax .gt. ndt) then
                irtet = 0
                goto 9999
            endif
        endif
    endif
! === =================================================================
! --- SI NON CONVERGENCE: TEST DU N°ITERATION
! === =================================================================
    if (iter .lt. itmax) then
        irtet = 1
    else
        irtet = 3
    endif
!
9999  continue
!
end subroutine
