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

subroutine chloet(iparg, etendu, jceld)
use calcul_module, only : ca_iachii_, ca_iachik_, ca_iachoi_, ca_iachok_, &
    ca_iawloc_, ca_nparin_
implicit none
! person_in_charge: jacques.pellet at edf.fr
!------------------------------------------------------------------
!     But : determiner si le champ local associe a iparg
!           est "etendu"
!     Un champ local etendu n'a pas la meme longueur pour tous ses
!     elements
!------------------------------------------------------------------
#include "asterf_types.h"
#include "jeveux.h"
    aster_logical :: etendu
    integer :: iparg, jceld
!------------------------------------------------------------------
!     Entrees:
!        iparg  : numero du parametre (dans le catalogue de l'option)

!     Sorties:
!        etendu : .true. : le champ local est etendu
!                 .false.: le champ local n'est pas etendu
!        jceld : si le champ local est etendu, jceld est l'adresse
!                dans zi de l'objet champ_global.CELD
!------------------------------------------------------------------
    integer ::  iachlo
    integer ::      ich
    character(len=8) :: tych
!------------------------------------------------------------------


!   -- le champ local est-il un cham_elem etendu ?
!      oui si champ global associe est 1 cham_elem etendu
!   --------------------------------------------------
    iachlo=zi(ca_iawloc_-1+3*(iparg-1)+1)
    if ((iachlo.eq.-1) .or. (iachlo.eq.-2)) goto 20
    ich=zi(ca_iawloc_-1+3*(iparg-1)+3)
    if (ich .eq. 0) goto 20
    if (iparg .le. ca_nparin_) then
        tych = zk8(ca_iachik_-1+2* (ich-1)+1)
        if (tych .ne. 'CHML') goto 20
        jceld = zi(ca_iachii_-1+11* (ich-1)+4)
    else
        tych = zk8(ca_iachok_-1+2* (ich-1)+1)
        if (tych .ne. 'CHML') goto 20
        jceld = zi(ca_iachoi_-1+2* (ich-1)+1)
    endif
    if ((zi(jceld-1+4).eq.0) .and. (zi(jceld-1+3).le.1)) then
        goto 20
    else
        goto 10
    endif


!   le champ local est etendu:
!   --------------------------
 10 continue
    etendu = .true.
    goto 30


!   le champ local n'est pas etendu:
!   --------------------------------
 20 continue
    etendu = .false.
    goto 30


 30 continue

end subroutine
