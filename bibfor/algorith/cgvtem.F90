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

function cgvtem(resu, iord0)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
!
!
    character(len=8), intent(in) :: resu
    integer, intent(in) :: iord0
    aster_logical :: cgvtem
!
! --------------------------------------------------------------------------------------------------
!
! CALC_G / verifications : 
!
! 1. savoir si la VARC TEMP est presente dans la sd cham_mater du RESULTAT
! 2. arreter le code en erreur <F> si une autre VARC que TEMP est presente
!
! --------------------------------------------------------------------------------------------------
!
! in  resu   : nom du RESULTAT
! in  iord0  : premier NUME_ORDRE dans resu
! out cgvtem : .true.  si la VARC TEMP est presente dans la sd cham_mater de resu
!              .false. sinon
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, jadmat, nvacr, ivarc
    character(len=8) :: chmat, other_varc
    aster_logical :: exivrc, exitem
    character(len=8), pointer :: cvrcvarc(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - y a t il des VARC dans la sd cham_mater du resultat ?
!
    call rsadpa(resu, 'L', 1, 'CHAMPMAT', iord0, 0, sjv=jadmat)
    chmat = zk8(jadmat)
    call jeexin(chmat//'.CVRCVARC', iret)
    exivrc = iret .ne. 0
    exitem = .false.
!
! - si oui, seule TEMP (exitem) est autorisee
!
    if (exivrc) then
!
        other_varc = ''
        call jelira(chmat//'.CVRCVARC', 'LONMAX', ival=nvacr)
        call jeveuo(chmat//'.CVRCVARC', 'L', vk8=cvrcvarc)
        do ivarc = 1, nvacr
            if (cvrcvarc(ivarc) .eq. 'TEMP') then
                exitem = .true.
            else
                other_varc = cvrcvarc(ivarc)
            endif
        enddo
!
        if (other_varc .ne. '') call utmess('A', 'RUPTURE1_72', nk=2, valk=[other_varc, chmat])
!
    endif
!
! - valeur retournee par la fonction
!
    cgvtem = exitem
!
    call jedema()
!
end function
