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

subroutine nmcpqu(compor, nomcmz, nompaz, exist)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/carces.h"
#include "asterfort/cesexi.h"
#include "asterfort/cesred.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: compor
    character(len=*) :: nomcmz
    character(len=*) :: nompaz
    aster_logical :: exist
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! INTERROGATION DE LA CARTE COMPOR
!
! ----------------------------------------------------------------------
!
! IN  COMPOR : CARTE COMPORTEMENT
! IN  NOMCMP : NOM DE LA CMP DE LA GRANDEUR COMPOR QUE L'ON VEUT TESTER
!               'RELCOM': EST-CE QUE CE COMPORTEMENT EXISTE ?
!               'DEFORM': EST-CE QUE DEFORM = NOMPAR
!               'C_PLAN': EST-CE QUE ALGO_C_PLAN OU ALGO_1D =DEBORST
!                ETC...
! IN  NOMPAZ : NO DU PARAMETRE INTERROGE (PAR EX. NOM DU COMPORTEMENT
!                RECHERCHE'
! OUT EXIST  : REPONSE A LA NOMCMPON
!
!
!
!
!
    character(len=24) :: nomcmp
    character(len=16) :: nompar, comp
    integer :: iret, ima, jdecal
    integer :: jcesd, jcesl
    integer :: nbma
    character(len=19) :: coto, copm
    character(len=16), pointer :: cesv(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    nomcmp = nomcmz
    nompar = nompaz
    exist = .false.
    coto = '&&NMCPQU.COTO'
    copm = '&&NMCPQU.COPM'
!
! --- TRANSFO CARTE EN CHAM_ELEM_S
!
    call carces(compor, 'ELEM', ' ', 'V', coto,&
                'A', iret)
!
! --- REDUCTION SUR COMPOSANTE
!
    call cesred(coto, 0, [0], 1, nomcmp,&
                'V', copm)
    call detrsd('CHAM_ELEM_S', coto)
!
! --- ACCES CHAM_ELEM_S
!
    call jeveuo(copm(1:19)//'.CESD', 'L', jcesd)
    call jeveuo(copm(1:19)//'.CESL', 'L', jcesl)
    call jeveuo(copm(1:19)//'.CESV', 'L', vk16=cesv)
    nbma = zi(jcesd-1+1)
!
    do 60 ima = 1, nbma
        call cesexi('C', jcesd, jcesl, ima, 1,&
                    1, 1, jdecal)
        comp = cesv(jdecal)
        if (comp .eq. nompar) then
            exist = .true.
            goto 99
        endif
 60 end do
!
 99 continue
!
    call detrsd('CHAM_ELEM_S', copm)
!
    call jedema()
!
end subroutine
