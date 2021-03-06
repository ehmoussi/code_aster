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

subroutine cjsmis(mod, crit, mater, nvi, epsd,&
                  deps, sigd, sigf, vind, vinf,&
                  noconv, aredec, stopnc, niter, epscon)
!
    implicit none
!     INTEGRATION PLASTIQUE (MECANISME ISOTROPE SEUL) DE LA LOI CJS
!                 SUR DT DE Y = (SIG, VIN, LAMBI)
!
!     ON RESOUD                       R(DY) = 0
!     PAR UNE METHODE DE NEWTON       DRDY(DYI) DDYI = - R(DYI)
!                                     DYI+1 = DYI + DDYI  (DYO DEBUT)
!     ET ON REACTUALISE               YF = YD + DY
!     ------------------------------------------------------------------
!     IN   MOD      :  MODELISATION
!          CRIT     :  CRITERES DE CONVERGENCE
!          MATER    :  COEFFICIENTS MATERIAU A T+DT
!          DEPS     :  INCREMENT DE DEFORMATION
!          SIGD     :  CONTRAINTE  A T
!          VIND     :  VARIABLES INTERNES  A T
!          AREDEC   :  ARRET DES DECOUPAGES
!          STOPNC   :  ARRET EN CAS DE NON CONVERGENCE
!     VAR  SIGF     :  CONTRAINTE  A T+DT
!          VINF     :  VARIABLES INTERNES  A T+DT
!          NOCONV   :  PAS DE CONVERGENCE
!          NITER    :  NOMBRE D ITERATIONS A CONVERGENCE
!          EPSCON   :  VALEUR ERR FINALE
!     ------------------------------------------------------------------
!
#include "asterf_types.h"
#include "asterfort/cjsjis.h"
#include "asterfort/cjsncv.h"
#include "asterfort/iunifi.h"
#include "asterfort/lceqvn.h"
#include "asterfort/lcnrvn.h"
#include "asterfort/lcsovn.h"
#include "asterfort/mgauss.h"
    integer :: ndt, ndi, nr, nmod, niter, nvi, iret
    integer :: nitimp
    parameter     (nmod = 8 )
    parameter     (nitimp = 100)
    integer :: iter
    aster_logical :: noconv, aredec, stopnc
!
!
    real(kind=8) :: epsd(6), deps(6), det
    real(kind=8) :: sigd(6), sigf(6)
    real(kind=8) :: vind(*), vinf(*), epscon
    real(kind=8) :: mater(14, 2), crit(*)
    real(kind=8) :: r(nmod), drdy(nmod, nmod)
    real(kind=8) :: ddy(nmod), dy(nmod), yd(nmod), yf(nmod)
!
    real(kind=8) :: err, err1, err2
    integer :: umess
    real(kind=8) :: erimp(nitimp, 3)
    integer :: i, j
!
    character(len=8) :: mod
!
    common /tdim/   ndt, ndi
!
!
!     ------------------------------------------------------------------
!
!
!
!
!
    umess = iunifi('MESSAGE')
    noconv = .false.
!
! -> DIMENSION DU PROBLEME NR = NDT(SIG) + 1(QISO) + 1(DLAMBI)
!
    nr = ndt + 2
!
!
!
! -> MISE A ZERO DES DATAS
!
    do 10 i = 1, nr
        ddy(i) = 0.d0
        dy(i) = 0.d0
        yd(i) = 0.d0
        yf(i) = 0.d0
 10 continue
!
!
! -> INITIALISATION DE YD PAR LA PREDICTION ELASTIQUE (SIGF, VIND, ZERO)
!
    call lceqvn(ndt, sigf, yd)
    yd(ndt+1) = vind(1)
    yd(ndt+2) = 0.d0
!
! -> INITIALISATION : DY : CALCUL DE LA SOLUTION D ESSAI INITIALE EN DY
!    (SOLUTION EXPLICITE)
!
!        CALL CJSIIS( MOD, MATER, DEPS, YD, DY )
!
!
!---------------------------------------
! -> BOUCLE SUR LES ITERATIONS DE NEWTON
!---------------------------------------
!
    iter = 0
100 continue
!
    iter = iter + 1
!
! -> INCREMENTATION DE YF = YD + DY
!
    call lcsovn(nr, yd, dy, yf)
!
!
! -> CALCUL DU SECOND MEMBRE A T+DT :  -R(DY)
!    ET CALCUL DU JACOBIEN DU SYSTEME A T+DT :  DRDY(DY)
!
    do 50 i = 1, nr
        r(i) = 0.d0
        do 60 j = 1, nr
            drdy(i,j) = 0.d0
 60     continue
 50 continue
!
    call cjsjis(mod, mater, deps, yd, yf,&
                r, drdy)
!
!
! -> RESOLUTION DU SYSTEME LINEAIRE : DRDY(DY).DDY = -R(DY)
!
    call lceqvn(nr, r, ddy)
    call mgauss('NFVP', drdy, ddy, nmod, nr,&
                1, det, iret)
!
!
! -> REACTUALISATION DE DY = DY + DDY
!
    call lcsovn(nr, ddy, dy, dy)
!
!
! -> VERIFICATION DE LA CONVERGENCE : ERREUR = !!DDY!!/!!DY!! < TOLER
!
    call lcnrvn(nr, ddy, err1)
    call lcnrvn(nr, dy, err2)
    if (err2 .eq. 0.d0) then
        err = err1
    else
        err = err1 / err2
    endif
    if (iter .le. nitimp) then
        erimp(iter,1) = err1
        erimp(iter,2) = err2
        erimp(iter,3) = err
    endif
!
!
    if (iter .le. int(abs(crit(1)))) then
!
!          --   CONVERVENCE   --
        if (err .lt. crit(3)) then
            goto 200
!
!          --  NON CONVERVENCE : ITERATION SUIVANTE  --
        else
            goto 100
        endif
!
    else
!
!          --  NON CONVERVENCE : ITERATION MAXI ATTEINTE  --
        if (aredec .and. stopnc) then
            call cjsncv('CJSMIS', nitimp, iter, ndt, nvi,&
                        umess, erimp, epsd, deps, sigd,&
                        vind)
        else
            noconv = .true.
        endif
    endif
!
200 continue
    niter = iter
    epscon = err
!
!
! -> INCREMENTATION DE YF = YD + DY
!
    call lcsovn(nr, yd, dy, yf)
!
!
! -> MISE A JOUR DES CONTRAINTES ET VARIABLES INTERNES
!
    call lceqvn(ndt, yf(1), sigf)
    vinf(1) = yf(ndt+1)
!
end subroutine
