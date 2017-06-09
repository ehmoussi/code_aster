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

subroutine dyarc1(instc, nbpas, insta, nbinst, arch,&
                  epsi, crit)
    implicit none
#include "asterf_types.h"
#include "asterc/getres.h"
#include "asterfort/utmess.h"
    integer :: nbpas, nbinst, arch(*)
    real(kind=8) :: epsi, instc(*), insta(*)
    character(len=8) :: crit
!     SAISIE DU MOT CLE FACTEUR "ARCHIVAGE"
!
! IN  : INSTC  : INSTANTS DE CALCUL
! IN  : NBPAS  : NOMBRE DE PAS DE CALCUL
! IN  : INSTA  : INSTANTS D'ARCHIVAGE
! IN  : NBINST : NOMBRE DE PAS D'ARCHIVAGE
! IN  : LISARC : LISTE D'ARCHIVAGE DES PAS DE CALCUL
! OUT : ARCH   : NUMERO D'ORDRE DES INSTANTS A ARCHIVER
! IN  : EPSI   : PRECISION DE RECHERCHE
! IN  : CRIT   : CRITERE DE RECHERCHE
! ----------------------------------------------------------------------
    integer :: nbtrou, i, j
    integer :: inda, indc
    real(kind=8) :: rval
    real(kind=8) :: valr
    aster_logical :: trouve
    character(len=8) :: k8b
    character(len=16) :: typcon, nomcmd
!     ------------------------------------------------------------------
!
    call getres(k8b, typcon, nomcmd)
!
! --->SECURITE SI L'INSTANT INITIAL EST DANS LA LISTE INSTA
!     RAPPEL: ARCH A LA TAILLE DE LA LISTE-1
!     (L'INSTANT INITIAL EST ARCHIVÉ AUTOMATIQUEMENT DANS UNE
!     AUTRE ROUTINE)
!
    inda=1
    if (abs(instc(1)-insta(1)) .le. abs(epsi)) then
        inda=2
    endif
!
! --->TESTS DE PRÉSENCE DES INSTANTS DE LA LISTE D'ARCHIVAGE
!     DANS LA LISTE DES INSTANTS DE CALCUL
!
    indc=2
    do 10 i = inda, nbinst
        nbtrou = 0
        rval = insta(i)
        do 20 j = indc, nbpas+1
            if (crit(1:4) .eq. 'RELA') then
                if (abs(instc(j)-rval) .le. abs(epsi*rval)) then
                    trouve = .true.
                else
                    trouve = .false.
                endif
            else if (crit(1:4) .eq. 'ABSO') then
                if (abs(instc(j)-rval) .le. abs(epsi)) then
                    trouve = .true.
                else
                    trouve = .false.
                endif
            else
                call utmess('F', 'ALGORITH3_42', sk=crit)
            endif
            if (trouve) then
                nbtrou = nbtrou + 1
                arch(j-1) = 1
                indc=j+1
            endif
 20     continue
        if (nbtrou .eq. 0) then
            valr = rval
            call utmess('F', 'ALGORITH12_97', sr=valr)
        else if (nbtrou .ne. 1) then
            valr = rval
            call utmess('F', 'ALGORITH12_98', sr=valr)
        endif
 10 end do
!
end subroutine
