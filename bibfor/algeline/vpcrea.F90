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

subroutine vpcrea(icond, modes, masse, amor, raide,&
                  nume, ier)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/refdaj.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: icond, ier
    character(len=*) :: modes, masse, amor, raide, nume
!     CREATION OU VERIFICATION DE COHERENCE DES MODES
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
!
    integer :: iret, imat(3), i4, i
    character(len=14) :: nume2, numat(3)
    character(len=19) :: numddl, numtmp, nomat(3)
    character(len=24) :: valk(4), matric(3), raide2, masse2, amor2
!   integer :: nbmodes
!   character(len=24) :: k24bid
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jemarq()
    ier = 0
!
!     VERIFICATION DE L'EXISTENCE DES MATRICES ET DE LA NUMEROTATION
    call exisd('MATR_ASSE', raide, imat(1))
    nomat(1)=raide
    call exisd('MATR_ASSE', masse, imat(2))
    nomat(2)=masse
    call exisd('MATR_ASSE', amor, imat(3))
    nomat(3)=amor
    call exisd('NUME_DDL', nume, i4)
    nume2=nume(1:14)
!
!     VERIFICATION DE LA COHERENCE DES MATRICES ET DE LA NUMEROTATION
    do i = 1, 3
        if (imat(i) .ne. 0) then
            call dismoi('NOM_NUME_DDL', nomat(i), 'MATR_ASSE', repk=numtmp)
            numat(i)=numtmp(1:14)
        else
            numat(i)=' '
        endif
    end do
    if (i4 .ne. 0) then
        do i = 1, 3
            if ((numat(i).ne.nume2) .and. (numat(i).ne.' ')) then
                call utmess('F', 'ALGELINE3_60', sk=nomat(i))
            endif
        end do
        numddl=nume
    else
        do i = 1, 3
            if (imat(i) .ne. 0) then
                numddl=numat(i)
                goto 101
            else
                numddl=' '
            endif
        end do
    endif
!
101 continue
!
!     --------------------------- REFD --------------------------------
!     --- AFFECTATION DES INFORMATIONS DE REFERENCE A CHAMP ---
!    call dismoi('C', 'NB_MODES_TOT', modes, 'RESULTAT', nbmodes, k24bid, iret)
    if (icond .eq. 0) then
! On remplie les champs relatifs aux matrices assemblees
        matric(1) = raide
        matric(2) = masse
        matric(3) = amor
!       call refdaj('F',modes,nbmodes,numddl,'DYNAMIQUE',matric,iret)
        call refdaj('F', modes, -1, numddl, 'DYNAMIQUE',&
                    matric, iret)
    else
        call dismoi('REF_RIGI_PREM', modes, 'RESU_DYNA', repk=raide2)
        call dismoi('REF_MASS_PREM', modes, 'RESU_DYNA', repk=masse2)
        call dismoi('REF_AMOR_PREM', modes, 'RESU_DYNA', repk=amor2, arret='C')
        if ((raide.ne.raide2) .or. (masse.ne.masse2) .or. (amor.ne.amor2)) ier = 1
        if (ier .ne. 0) then
            valk(1) = modes
            valk(2) = raide2
            valk(3) = masse2
            valk(4) = amor2
            if (amor2(1:8) .ne. ' ') then
                call utmess('F', 'ALGELINE3_61', nk=4, valk=valk)
            else
                call utmess('F', 'ALGELINE3_62', nk=3, valk=valk)
            endif
        endif
    endif
    call jedema()
end subroutine
