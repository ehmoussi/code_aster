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

subroutine dgffibres(nboccfib, iinbgf, tousgroupesnom, tousgroupesnbf, maxmailgrp, &
                     ulnbnoeuds, ulnbmailles, nbfibres1, maxfibre1, ncarfi1)
!
!
! --------------------------------------------------------------------------------------------------
!
!                O P E R A T E U R    DEFI_GEOM_FIBRE
!
!   Pré-traitement du mot clef FIBRE
!
! --------------------------------------------------------------------------------------------------
!
! person_in_charge: jean-luc.flejou at edf.fr
!
    implicit none
!
    integer :: nboccfib, iinbgf, maxmailgrp, ulnbnoeuds, ulnbmailles, nbfibres1, maxfibre1, ncarfi1
    integer           :: tousgroupesnbf(*)
    character(len=24) :: tousgroupesnom(*)
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/codent.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvr8.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer           :: ioc, nbvfibre
    character(len=7)  :: k7bid
!
    integer           :: vali(3)
    character(len=24) :: valk(3)
!
    character(len=16) :: limcls(3), ltymcl(3)
    data limcls/'MAILLE_SECT','GROUP_MA_SECT','TOUT_SECT'/
    data ltymcl/'MAILLE','GROUP_MA','TOUT'/
!
! --------------------------------------------------------------------------------------------------
!
    maxfibre1 = 10
    do ioc = 1, nboccfib
        iinbgf = iinbgf + 1
        call getvtx('FIBRE', 'GROUP_FIBRE', iocc=ioc, scal=tousgroupesnom(iinbgf))
!
        call getvr8('FIBRE', 'VALE', iocc=ioc, nbval=0, nbret=nbvfibre)
        nbvfibre = -nbvfibre
        maxfibre1 = max(maxfibre1,nbvfibre)
!       Vérification multiple de 'ncarfi1' pour 'vale' dans 'fibre'
        if ( modulo(nbvfibre,ncarfi1).ne.0 ) then
            call codent(nbvfibre, 'G', k7bid)
            valk(1)=tousgroupesnom(iinbgf)
            valk(1)='VALE'
            vali(1)=nbvfibre
            vali(2)=ncarfi1
            call utmess('F', 'MODELISA6_26', nk=2, valk=valk, ni=2, vali=vali)
        endif
        ulnbmailles = ulnbmailles + nbvfibre/ncarfi1
        nbfibres1   = nbfibres1   + nbvfibre/ncarfi1
        ulnbnoeuds  = ulnbnoeuds  + nbvfibre/ncarfi1
        maxmailgrp  = max(maxmailgrp,nbvfibre/ncarfi1)
        tousgroupesnbf(iinbgf) = tousgroupesnbf(iinbgf) + nbvfibre/ncarfi1
    enddo

end
