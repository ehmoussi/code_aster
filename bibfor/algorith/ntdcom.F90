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

subroutine ntdcom(evolsc)
!
    implicit none
#include "asterf_types.h"
#include "asterc/getfac.h"
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
    character(len=8) :: evolsc
!
! ----------------------------------------------------------------------
!
! COMMANDE THER_NON_LINE : VERIFICATION SYNTAXIQUE SPECIFIQUES AU
!                          SECHAGE
!                          RECUPERATION DE L'EVOL_THER
!
! ----------------------------------------------------------------------
!
    integer :: iocc, k, n1, nbcham
    character(len=8) :: k8b
    character(len=16) :: comp, motcle, k16bid, nomcmd, tysd
    aster_logical :: lrela, lsech
!
    data         motcle / 'COMPORTEMENT' /
! ----------------------------------------------------------------------
!
!
    call getres(k8b, k16bid, nomcmd)
!
    if (nomcmd .eq. 'THER_NON_LINE') then
        call getfac(motcle, iocc)
        lrela = .false.
        lsech = .false.
        do k = 1, iocc
            call getvtx(motcle, 'RELATION', iocc=k, scal=comp, nbret=n1)
            if (comp(1:10) .eq. 'SECH_NAPPE') lsech = .true.
            if (comp(1:12) .eq. 'SECH_GRANGER') lsech = .true.
            if (comp(1:5) .ne. 'SECH_') lrela = .true.
        end do
!
        if (lsech .and. lrela) then
            call utmess('F', 'ALGORITH8_96')
        endif
!
        evolsc = ' '
        if (lsech) then
            call getvid(' ', 'EVOL_THER_SECH', nbval=0, nbret=n1)
            if (n1 .eq. 0) then
                call utmess('F', 'ALGORITH8_97')
            else
                call getvid(' ', 'EVOL_THER_SECH', scal=evolsc, nbret=n1)
!
! ----------VERIFICATION DU CHAMP DE TEMPERATURE
!
                call gettco(evolsc, tysd)
                if (tysd(1:9) .ne. 'EVOL_THER') then
                    call utmess('F', 'ALGORITH8_98', sk=evolsc)
                else
                    call dismoi('NB_CHAMP_UTI', evolsc, 'RESULTAT', repi=nbcham)
                    if (nbcham .le. 0) then
                        call utmess('F', 'ALGORITH8_99', sk=evolsc)
                    endif
                endif
            endif
        endif
!
    endif
!
!-----------------------------------------------------------------------
end subroutine
