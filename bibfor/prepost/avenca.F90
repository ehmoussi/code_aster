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

subroutine avenca(jrvecp, nbvec, nbordr, lsig0, iflag,&
                  rmima)
! person_in_charge: van-xuan.tran at edf.fr
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterc/r8maem.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbvec, nbordr, iflag(nbvec), jrvecp
    real(kind=8) :: rmima(4*nbvec)
    aster_logical :: lsig0
! ----------------------------------------------------------------------
! BUT: ENCADRER LES POINTS REPRESANTANT LE CISAILLEMENT TAU
!      DANS LE PLAN DE CISAILLEMENT (PLAN u, v).
! ----------------------------------------------------------------------
! ARGUMENTS:
! JRVECPG    IN   I  : VECTEUR DE TRAVAIL CONTENANT LES
!                     COMPOSANTES u ET v DU VECTEUR TAU (CISAILLEMENT),
!                     POUR TOUS LES VECTEURS NORMAUX (n) ET TOUS LES
!                     NUMEROS D'ORDRE.
!                     VECTEUR NORMAL ASSOCIE A DELTA_TAU_MAX.
! NBVEC     IN   I  : NOMBRE DE VECTEURS NORMAUX.
! NBORDR    IN   I  : NOMBRE DE NUMERO D'ORDRE STOCKE DANS LA
!                     STRUCTURE DE DONNEES RESULTAT.
! LSIG0     OUT  L  : VARIABLE LOGIQUE QUI INDIQUE :
!                      - LSIG0 = FALSE --> CAS GENERAL, LES CONTRAINTES
!                                          SONT DIFFERENTES DE ZERO ;
!                      - LSIG0 =  TRUE --> LES CONTRAINTES SONT NULLES
!                                          A TOUS LES PAS DE TEMPS, QUEL
!                                          QUE SOIT LE VECTEUR NORMAL.
! IFLAG     OUT  I  : VECTEUR DE DRAPEAUX QUI INDIQUE :
!                      - IFLAG(i) = 0 --> CAS GENERAL ;
!                      - IFLAG(i) = 1 --> CAS OU LES POINTS DANS LE
!                                         PLAN DE CISAILLEMENT SONT
!                                         ALIGNES VERTICALEMENT ;
!                      - IFLAG(i) = 2 --> CAS OU LES POINTS DANS LE
!                                         PLAN DE CISAILLEMENT SONT
!                                         ALIGNES HORIZONTALEMENT ;
!                      - IFLAG(i) = 3 --> CAS OU LES POINTS DANS LE
!                                         PLAN DE CISAILLEMENT SONT
!                                         CONTENUS DANS UN CADRE DE
!                                         COTES INFERIEURS A EPSILO.
! RMIMA     OUT  R  : VECTEUR CONTENANT LES COORDONNEES DES POINTS
!                     EXTREMES DU CADRE (CUMIN, CUMAX, CVMIN, CVMAX)
!                     POUR TOUS LES VECTEURS NORMAUX.
!
!-----------------------------------------------------------------------
!     ------------------------------------------------------------------
    integer :: n1, ivect, iordr, nsig0
!
    real(kind=8) :: epsilo, cumin, cumax, cvmin, cvmax
    real(kind=8) :: cui, cvi
!
!-----------------------------------------------------------------------
!234567                                                              012
!
    call jemarq()
!
!-----------------------------------------------------------------------
!     ------------------------------
!    |  TRAITEMENT DU CAS GENERAL  |
!    ------------------------------
!-----------------------------------------------------------------------
!
    epsilo = 1.0d-5
!
! ININTIALISATION
!
    n1 = 0
    nsig0 = 0
!
    do 30 ivect = 1, nbvec
!
! INITIALISATION
!
        iflag(ivect) = 0
!
        cumin = r8maem()
        cumax = -r8maem()
        cvmin = r8maem()
        cvmax = -r8maem()
!
        do 40 iordr = 1, nbordr
            n1 = n1 + 1
            cui = zr(jrvecp+2*n1 -1)
            cvi = zr(jrvecp+2*n1)
!
            if (cui .lt. cumin) then
                cumin = cui
            endif
            if (cui .gt. cumax) then
                cumax = cui
            endif
            if (cvi .lt. cvmin) then
                cvmin = cvi
            endif
            if (cvi .gt. cvmax) then
                cvmax = cvi
            endif
 40     continue
!
!-----------------------------------------------------------------------
!   ------------------------------------
!  |  TRAITEMENT DES CAS PARTICULIERS  |
!  ------------------------------------
!-----------------------------------------------------------------------
!
! 1/ CAS OU TOUS LES POINTS SONT ALIGNES VERTICALEMENT, ON NE FERA PAS
!    DE PROJECTION.
!
        if (abs(cumax-cumin)/2.d0 .lt. epsilo) then
            iflag(ivect) = 1
!
! 2/ CAS OU TOUS LES POINTS SONT ALIGNES HORIZONTALEMENT, ON NE FERA
!    PAS DE PROJECTION.
!
        else if (abs(cvmax-cvmin)/2.d0 .lt. epsilo) then
            iflag(ivect) = 2
!
! 3/ CAS OU TOUS LES POINTS SONT DANS UNE BOITE DONT LES DEUX COTES
!    SONT INFERIEURS A EPSILO, ON NE FERA PAS DE PROJECTION.
!
            elseif ( (abs(cvmax-cvmin)/2.d0 .lt. epsilo) .and. (abs(cumax-&
        cumin)/2.d0 .lt. epsilo) ) then
            iflag(ivect) = 3
            nsig0 = nsig0 + 1
        endif
!
        rmima(4*ivect - 3) = cumin
        rmima(4*ivect - 2) = cumax
        rmima(4*ivect - 1) = cvmin
        rmima(4*ivect) = cvmax
!
        if (nsig0 .eq. nbvec) then
            lsig0 = .true.
        endif
!
 30 end do
!
    call jedema()
end subroutine
