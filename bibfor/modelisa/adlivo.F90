! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine adlivo(mv, is, nvtot, nvoima, nscoma,&
                  touvoi, nomail)
    implicit none
#include "asterf_types.h"
#include "asterfort/utmess.h"
    integer :: mv, is, nvtot
    integer :: nvoima, nscoma
    integer :: touvoi(1:nvoima, 1:nscoma+2)
    integer :: iv, nsco, isco
    aster_logical :: trma, trso
    character(len=8) :: nomail
!
!  AJOUTE A LA LISTE DE TOUS LES VOISINS DE LA MAILLE COURANTE MO
!  LA MAILLE MV ET LE SOMMET IS SI CETTE MAILE N EXISTE PAS DEJA
!
!       : M ,MAILLE VOISINE
!       : IS ,SOMMET LOCAL DE LA MAILLE COURANTE
!         QUI EST AUSSI SOMMET DE MV
!    VAR NVTOT : NOMBRE TOTAL DE VOI
!         TOUVOI : CES VOISINS :
!    CONTENU DU TABLEAU TOUVOI :
!     TOUVOI(IV,1) : MAILLE VOISINE
!     TOUVOI(IV,2) : NOMBRE DE SOMMETS COMMUNS
!     TOUVOI(IV,2+IS) : CES SOMMETS COMMUNS DANS NUMEROTATION DE M0
!
    trma=.false.
    do 30 iv = 1, nvtot
        if (mv .eq. touvoi(iv,1)) then
            trma=.true.
            trso=.false.
            nsco=touvoi(iv,2)
            do 10 isco = 1, nsco
                if (touvoi(iv,2+isco) .eq. is) then
                    trso=.true.
                    goto 20
!
                endif
 10         continue
 20         continue
            if (.not.trso) then
                nsco=nsco+1
                if (nsco .gt. nscoma) then
                    call utmess('F', 'VOLUFINI_4', si=nsco)
                endif
                touvoi(iv,2)=nsco
                touvoi(iv,2+nsco)=is
            endif
            goto 40
!
        endif
 30 end do
 40 continue
    if (.not.trma) then
        nvtot=nvtot+1
        if (nvtot .gt. nvoima) then
            call utmess('F', 'VOLUFINI_3', sk=nomail)
        endif
        touvoi(nvtot,1)=mv
        touvoi(nvtot,2)=1
        touvoi(nvtot,3)=is
    endif
!
end subroutine
