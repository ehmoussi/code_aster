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

subroutine rdtchp(corrn, corrm, ch1, ch2, base,&
                  noma, nomare, ligrel, cret)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/carces.h"
#include "asterfort/celces.h"
#include "asterfort/cescar.h"
#include "asterfort/cescel.h"
#include "asterfort/cnocns.h"
#include "asterfort/cnscno.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/rdtces.h"
#include "asterfort/rdtcns.h"
    integer :: cret
    character(len=1) :: base
    character(len=8) :: noma, nomare
    character(len=24) :: corrn, corrm
    character(len=19) :: ch1, ch2, ligrel
!
! person_in_charge: jacques.pellet at edf.fr
!-------------------------------------------------------------------
! BUT: REDUIRE UNE SD_CHAMP SUR UN MAILLAGE REDUIT
!
!  CH1    : IN  : CHAMP A REDUIRE
!  CH2    : OUT : CHAMP REDUIT
!  NOMA   : IN  : MAILLAGE AVANT REDUCTION
!  NOMARE : IN  : MAILLAGE REDUIT
!  LIGREL : IN  : LIGREL REDUIT
!  CORRN  : IN  : NOM DE L'OBJET CONTENANT LA CORRESPONDANCE
!                 INO_RE -> INO
!  CORRM  : IN  : NOM DE L'OBJET CONTENANT LA CORRESPONDANCE
!                 IMA_RE -> IMA
!-------------------------------------------------------------------
!
    integer :: iret, nncp
    character(len=16) :: option
    character(len=4) :: tych
    character(len=19) :: ch1s, ch2s
!     -----------------------------------------------------------------
!
    call jemarq()
!
    ASSERT(noma.ne.nomare)
    ASSERT(ch1.ne.ch2)
!
    call dismoi('TYPE_CHAMP', ch1, 'CHAMP', repk=tych)
!
    ch1s='&&RDTCHP'//'.CH1S'
    ch2s='&&RDTCHP'//'.CH2S'
!
    cret=0
    if (tych .eq. 'NOEU') then
        call cnocns(ch1, 'V', ch1s)
        call rdtcns(nomare, corrn, ch1s, 'V', ch2s)
        call cnscno(ch2s, ' ', 'NON', base, ch2,&
                    ' ', cret)
        call detrsd('CHAM_NO_S', ch1s)
        call detrsd('CHAM_NO_S', ch2s)
!
!
    else if (tych(1:2).eq.'EL') then
        call celces(ch1, 'V', ch1s)
        call rdtces(nomare, corrm, ch1s, 'V', ch2s,&
                    cret)
        if (cret .eq. 0) then
            call dismoi('NOM_OPTION', ch1, 'CHAMP', repk=option)
            call cescel(ch2s, ligrel, option, ' ', 'OUI',&
                        nncp, base, ch2, 'F', iret)
            ASSERT(iret.eq.0)
            ASSERT(nncp.eq.0)
        endif
        call detrsd('CHAM_ELEM_S', ch1s)
        call detrsd('CHAM_ELEM_S', ch2s)
!
!
    else if (tych.eq.'CART') then
        call carces(ch1, 'ELEM', ' ', 'V', ch1s,&
                    'A', iret)
        ASSERT(iret.eq.0)
        call rdtces(nomare, corrm, ch1s, 'V', ch2s,&
                    cret)
        call cescar(ch2s, ch2, base)
        ASSERT(iret.eq.0)
        call detrsd('CHAM_ELEM_S', ch1s)
        call detrsd('CHAM_ELEM_S', ch2s)
!
!
    else
        ASSERT(.false.)
    endif
!
!
!
!
    call jedema()
!
end subroutine
