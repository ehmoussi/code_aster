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

subroutine irrcvg(dy, ddy, nr, nmat, mater,&
                  itmax, toler, iter, r, rini,&
                  irteti)
    implicit none
#include "asterfort/utmess.h"
! person_in_charge: jean-luc.flejou at edf.fr
!       IRRAD3M        : CONTROLE DE LA CONVERGENCE
!                        DE LA CONFORMITE DE LA SOLUTION DP
!                        ET DE LA RE-INTEGRATION
!                        ET DU REDECOUPAGE DU PAS DE TEMPS
!                        SUR LA NORME DU RESIDU
!       ----------------------------------------------------------------
!       IN
!            DY     :  VECTEUR SOLUTION DY = ( DSIG DVINT)
!            DDY    :  VECTEUR CORRECTION SUR LA SOLUTION
!            NR     :  DIMENSION DY DDY
!            NMAT   :  DIMENSION  DE MATER
!            MATER  :  COEFFICIENTS MATERIAU
!            ITMAX  :  NB MAXI D ITERATIONS LOCALES
!            TOLER  :  TOLERANCE A CONVERGENCE
!            ITER   :  NUMERO ITERATION COURANTE
!            R      :  R(Y) RESIDU A L'ITERATION COURANTE
!            RINI   :  R(Y0) RESIDU A L'ITERATION 1
!       OUT  IRTETI  :  =0 CONVERGENCE
!                       =1 ITERATIONS SUPPLEMENTAIRE (ITER<ITMAX)
!                       =3 ITMAX ATTEINT REDECOUPAGE
!       ----------------------------------------------------------------
    integer :: itmax, iter, nr, irteti, ii, nmat
    real(kind=8) :: toler, ddy(nr), dy(nr), r(nr), rini(nr), mater(nmat, 2)
!
    real(kind=8) :: er, valrm(2)
!       ----------------------------------------------------------------
!
!     CALCUL DE LA NORME DE RINI ET DE R(Y)
    er = 0.0d0
    do 10 ii = 1, nr
        er = er + r(ii)*r(ii)
10  end do
    er = sqrt(er)
!     ER < TOLER , ON A CONVERGE
    if (er .lt. toler) then
!        VERIFICATION SUR LE FRANCHISSEMENT DU SEUIL
        if (abs(mater(21,2)) .gt. mater(20,2)) then
            valrm(1) = mater(20,2)
            valrm(2) = mater(21,2)
            call utmess('I', 'COMPOR1_58', nr=2, valr=valrm)
!           REDECOUPAGE
            irteti = 3
            goto 9999
        endif
        irteti = 0
        goto 9999
    endif
!
    if (iter .lt. itmax) then
!         CALL LCNRVN(NR,RINI,ERINI)
!          WRITE(*,*) 'ER ERINI', ER,ERINI,ER/ERINI,TOLER
!        SI ER/ERINI < TOLER ON A CONVERGE
!         IF ( (ER/ERINI) .LE. TOLER ) THEN
!            IRTETI = 0
!            GOTO 9999
!         ENDIF
! -      EVALUATION DE :  ERRR(1)  = MAX( ABS(R(I)/RINI(I)) )
!         CALL LCVERR(RINI,R,NR,0,ERREUR)
! -      CONVERGENCE    MAX(R,RINI)
!         IF ( ERREUR(1) .LE. TOLER ) THEN
!            IRTETI = 0
!            GOTO 9999
!         ENDIF
! -      NON CONVERGENCE ITERATION SUIVANTE
        irteti = 1
        goto 9999
!      ELSE
! -      EVALUATION DE :  ERRR(1)  = MAX( ABS(R(I)/RINI(I)) )
!         CALL LCVERR(RINI,R,NR,0,ERREUR)
!        RESIDU NON NUL MAIS STABLE. ON ACCEPTE
!         IF ( ERREUR(1) .LE. TOLER ) THEN
!            IRTETI = 0
!            GOTO 9999
!         ENDIF
! -      EVALUATION DE :  ERRDY(1)  = MAX( ABS(DDY(I)/DY(I)) )
!         CALL LCVERR(DY,DDY,NR,0,ERREUR)
!        RESIDU NON NUL MAIS SOLUTION STABLE. ON ACCEPTE : MAX(DDY,DY)
!         IF ( ERREUR(1) .LE. TOLER ) THEN
!            IRTETI = 0
!            GOTO 9999
!         ENDIF
    endif
! -   NON CONVERGENCE ET ITMAX ATTEINT
    irteti = 3
!
9999  continue
end subroutine
