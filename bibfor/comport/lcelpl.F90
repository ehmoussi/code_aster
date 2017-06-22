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

subroutine lcelpl(mod, loi, nmat, materd, materf,&
                  timed, timef, deps, nvi, vind,&
                  vinf, nr, yd, yf, sigd,&
                  sigf, drdy)
! aslint: disable=W1306
    implicit none
!
! ----------------------------------------------------------------
!   MISE A JOUR DES VARIABLES INTERNES EN ELASTICITE
!
!   POST-TRAITEMENTS SPECIFIQUES AUX LOIS
!
!   CAS GENERAL :
!      VINF = VIND
!      VINF(NVI) = 0.0
! ----------------------------------------------------------------
!  IN
!     MOD    :  TYPE DE MODELISATION
!     LOI    :  NOM DE LA LOI
!     NMAT   :  DIMENSION MATER ET DE NBCOMM
!     MATERD :  COEF MATERIAU A T
!     MATERF :  COEF MATERIAU A T+DT
!     TIMED  :  INSTANT T
!     TIMEF  :  INSTANT T+DT
!     IDPLAS :  INDICATEUR PLASTIQUE
!     NVI    :  NOMBRE VARIABLES INTERNES
!     VIND   :  VARIABLES INTERNES A T
!     SIGD   :  CONTRAINTES A T
!     SIGF   :  CONTRAINTES A T+DT
!     NR     :  NB EQUATION SYSTEME INTEGRE A RESOUDRE
!     YD     :  VECTEUR SOLUTION A T
!     YF     :  VECTEUR SOLUTION A T+DT
!  OUT
!     VINF   :  VARIABLES INTERNES A T+DT
!     DRDY   :  MATRICE JACOBIENNE POUR BETON_BURGER
! ----------------------------------------------------------------
!     ------------------------------------------------------------
#include "asterfort/burjac.h"
#include "asterfort/burlnf.h"
#include "asterfort/irrlnf.h"
#include "asterfort/lceqvn.h"
#include "asterfort/srilnf.h"
    common /tdim/   ndt  , ndi
!     ------------------------------------------------------------
    character(len=16) :: loi
    integer :: nmat, nvi, nr, i, j, ndi, ndt
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: vinf(nvi), vind(nvi), dy(nr), drdy(nr, nr)
    real(kind=8) :: timed, timef, dt, yd(nr), yf(nr)
    real(kind=8) :: deps(6), sigf(6), sigd(6)
    character(len=8) :: mod
! ----------------------------------------------------------------
    if (loi(1:7) .eq. 'IRRAD3M') then
        call irrlnf(nmat, materf, vind, 0.0d0, vinf)
    else if (loi(1:12) .eq. 'BETON_BURGER') then
        dt = timef-timed
        call burlnf(nvi, vind, nmat, materd, materf,&
                    dt, nr, yd, yf, vinf,&
                    sigf)
        do 10 i = 1, nr
            dy(i) = yf(i)-yd(i)
            do 20 j = 1, nr
                drdy(i,j) = 0.d0
20          continue
10      continue
        call burjac(mod, nmat, materd, materf, nvi,&
                    vind, timed, timef, yd, yf,&
                    dy, nr, drdy)
    else if (loi(1:4).eq.'LETK') then
        call lceqvn(nvi-3, vind, vinf)
        vinf(5) = 0.d0
        vinf(6) = 0.d0
        vinf(7) = 0.d0
    else if (loi(1:3).eq.'LKR') then
        call lceqvn(4, vind, vinf)
        vinf(5)=0.d0
        vinf(6)=0.d0
        vinf(7)=0.d0
        vinf(9)=vind(9)-3.d0*materf(3,1)*(materf(7,1)-materf(6,1))
        vinf(8)=vind(8)-deps(1)-deps(2)-deps(3)-(vinf(9)-vind(9))
        vinf(10)=0.d0
        vinf(11)=0.d0
        vinf(12)=0
    else if (loi(1:6).eq.'HUJEUX') then
! --- PAS DE MODIFICATION PARTICULIERE
! --- CAS DIFFERENT DE LA GENERALITE
    else
!
! --- CAS GENERAL :
!        VINF  = VIND ,  ETAT A T+DT = VINF(NVI) = 0 = ELASTIQUE
        call lceqvn(nvi-1, vind, vinf)
        vinf(nvi) = 0.0d0
    endif
!
end subroutine
