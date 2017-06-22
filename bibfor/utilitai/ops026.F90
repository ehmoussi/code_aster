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

subroutine ops026()
    implicit none
!
!    OPERATEUR DEFI_FICHIER
!
!     ------------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/putvir.h"
#include "asterc/rmfile.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/infniv.h"
#include "asterfort/uldefi.h"
#include "asterfort/ulimpr.h"
#include "asterfort/ulnomf.h"
#include "asterfort/ulnume.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
    integer :: unite, ifm, niv, n1, nf, nu
    aster_logical :: sortie
    character(len=1) :: kacc, ktyp
    character(len=8) :: action, acces, type
    character(len=16) :: knom
    character(len=255) :: fichie
!     ------------------------------------------------------------------
!
    call infmaj()
    call infniv(ifm, niv)
!
    sortie = .false.
    unite = 999
    knom = ' '
    kacc = ' '
    ktyp = 'A'
    fichie = ' '
!
    call getvtx(' ', 'ACTION', scal=action, nbret=n1)
    call getvtx(' ', 'FICHIER', scal=fichie, nbret=nf)
    call getvis(' ', 'UNITE', scal=unite, nbret=nu)
    call getvtx(' ', 'ACCES', scal=acces, nbret=n1)
    if (n1 .ne. 0) kacc = acces(1:1)
    call getvtx(' ', 'TYPE', scal=type, nbret=n1)
    if (n1 .ne. 0) ktyp = type(1:1)
!
    if (action .eq. 'LIBERER ') then
!          ---------------------
        if (nu .eq. 0) then
! --------- L'ACCES AU FICHIER EST REALISE PAR NOM, IL FAUT VERIFIER
!           SA PRESENCE DANS LA STRUCTURE DE DONNEES
            unite = ulnomf ( fichie, kacc, ktyp )
            if (unite .lt. 0) then
                call utmess('A', 'UTILITAI3_33', sk=fichie)
                goto 999
            endif
        endif
        unite = -unite
!
        elseif ( (action .eq. 'ASSOCIER') .or. (action .eq. 'RESERVER') )&
    then
!               ---------------------
        if (nu .eq. 0 .and. nf .gt. 0) then
            sortie = .true.
            unite = ulnume()
            if (unite .lt. 0) then
                call utmess('F', 'UTILITAI3_34')
            endif
        endif
!
    else
!
        call utmess('F', 'UTILITAI3_35', sk=action)
!
    endif
!
    if (ktyp .eq. 'A') then
        if (action .eq. 'RESERVER') then
            call ulopen(unite, fichie, knom, kacc, 'R')
        else
            call ulopen(unite, fichie, knom, kacc, 'O')
        endif
    else
        call uldefi(unite, fichie, knom, ktyp, kacc,&
                    'O')
    endif
!
!---- POUR DETRUIRE LE FICHIER SI CE DERNIER EST OUVERT EN NEW
!
    if (ktyp .ne. 'A') then
        if (kacc .eq. 'N') then
            call rmfile(fichie, 1)
        endif
    endif
!
    if (sortie) call putvir(unite)
!
999 continue
    if (niv .gt. 1) call ulimpr(ifm)
!
end subroutine
