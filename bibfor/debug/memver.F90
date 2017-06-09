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

subroutine memver(action, prec, arret, titre)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/memres.h"
#include "asterfort/utgtme.h"
    character(len=*) :: action, arret, titre
    real(kind=8) :: prec, precs
! person_in_charge: jacques.pellet at edf.fr
!   BUT: VERIFIER QU'IL N'Y A PAS DE FUITE MEMOIRE DANS UN
!        PROGRAMME FORTRAN
!---------------------------------------------------------------------
! IN  ACTION : /'MESURE' : ON MESURE LA MEMOIRE TOTALE =
!              MEMOIRE LIBRE + MEMOIRE JEVEUX DYNAMIQUE ALLOUEE
!              /'VERIF' : ON VERIFIE QUE LA MEMOIRE TOTALE N'A PAS
!              BOUGE DEPUIS L'APPEL A "MESURE"
! IN  PREC : PRECISION SOUHAITEE POUR LA COMPARAISON.
!            PREC EST DONNE POUR 'MESURE'. IL EST STOCKE.
!            ET IL EST UTILISE POUR ACTION='VERIF'
! IN  ARRET  (K2)
!   ARRET(1:1) :
!     /'F' : ERREUR FATALE SI FUITE MEMOIRE > PREC
!     /' ' : NE S'ARRETE PAS EN CAS DE FUITE
!   ARRET(2:2) :
!     /'I' : IMPRIME LES 2 VALEURS COMPAREES AINSI QUE LEUR DIFFERENCE
!     /' ' : N'IMPRIME RIEN
! IN  TITRE : CHAINE DE CARACTERES IMPRIMEE AU DEBUT DES LIGNES
!            SI ARRET(2:2)='I'
!----------------------------------------------------------------------
!
    real(kind=8) :: tmax, mtots, mtot, rval(1)
    character(len=8) :: k8tab(1)
    integer :: iret
    save mtots,precs
!
    ASSERT(action.eq.'MESURE' .or. action.eq.'VERIF')
    if (action .eq. 'MESURE') precs=2.d0*prec
!
    ASSERT(arret(1:1).eq.'F' .or. arret(1:1).eq.' ')
    ASSERT(arret(2:2).eq.'I' .or. arret(2:2).eq.' ')
!
    call memres('NON', 'NON', ' ', precs, tmax)
    k8tab(1) = 'COUR_JV'
    call utgtme(1, k8tab, rval, iret)
    mtot=tmax+rval(1)
!
    if (action .eq. 'MESURE') then
        mtots=mtot
    else
        if (arret(2:2) .eq. 'I') then
            write (6,9000)'<MEMVER> MTOTS,MTOT,DIFF=',titre, mtots,&
            mtot,mtots-mtot
        endif
        if (arret(1:1) .eq. 'F') then
            ASSERT(mtots-mtot.lt.precs)
        endif
    endif
!
    9000 format (2(a,1x),3(f15.3,1x))
end subroutine
