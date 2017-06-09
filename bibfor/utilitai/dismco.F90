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

subroutine dismco(questi, nomob, repi, repk, ierd)
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/carces.h"
#include "asterfort/cesexi.h"
#include "asterfort/cesred.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
    integer :: repi, ierd
    character(len=*) :: nomob, repk
    character(len=*) :: questi
!
!
!
!     --     DISMOI(COMPOR)
!
!     IN:
!       QUESTI : TEXTE PRECISANT LA QUESTION POSEE
!       NOMOB  : NOM D'UN OBJET DE TYPE CARTE_COMPOR
!     OUT:
!       REPI   : REPONSE ( SI ENTIERE )
!       REPK   : REPONSE ( SI CHAINE DE CARACTERES )
!       IERD   : CODE RETOUR (0--> OK, 1 --> PB)
! ======================================================================
!
    character(len=19) :: chtmp, chcalc
    integer :: iret, jcald, jcall, nbma, ima, iadc
    character(len=6) :: lcham(3)
    character(len=8) :: noma, nomail
    aster_logical :: incr, elas
    character(len=8), pointer :: cesk(:) => null()
    character(len=16), pointer :: cesv(:) => null()
    data  lcham/ 'RELCOM', 'DEFORM', 'INCELA'/
!
!
    call jemarq()
!
    ASSERT(questi(1:9).eq.'ELAS_INCR')
!
    repk = ' '
    repi = 0
    ierd = 0
!
    incr = .false.
    elas = .false.
!
    chtmp ='&&DISMCO_CHTMP'
    chcalc='&&GVERLC_CHCALC'
!
!     PASSAGE CARTE COMPOR --> CHAMP SIMPLE,
!     PUIS REDUCTION DU CHAMP SUR LA COMPOSANTE 'RELCOM'
!     QUI CORRESPOND AU NOM DE LA LOI DE COMPORTEMENT
!
    call carces(nomob, 'ELEM', ' ', 'V', chtmp,&
                'A', iret)
    call cesred(chtmp, 0, [0], 3, lcham,&
                'V', chcalc)
    call detrsd('CHAM_ELEM_S', chtmp)
!
    call jeveuo(chcalc//'.CESD', 'L', jcald)
    call jeveuo(chcalc//'.CESV', 'L', vk16=cesv)
    call jeveuo(chcalc//'.CESL', 'L', jcall)
    call jeveuo(chcalc//'.CESK', 'L', vk8=cesk)
!
    noma = cesk(1)
    nbma = zi(jcald-1+1)
!
    do 10 ima = 1, nbma
!
        if (incr .and. elas) goto 999
!
        call cesexi('C', jcald, jcall, ima, 1,&
                    1, 1, iadc)
!
        if (iadc .gt. 0) then
            call jenuno(jexnum(noma//'.NOMMAI', ima), nomail)
            if (cesv(1+iadc-1+2)(1:9) .eq. 'COMP_INCR') then
                incr = .true.
            endif
            if (cesv(1+iadc-1+2)(1:9) .eq. 'COMP_ELAS') then
                elas = .true.
            endif
        endif
!
 10 end do
!
999 continue
!
    if (incr .and. .not.elas) repk='INCR'
    if (elas .and. .not.incr) repk='ELAS'
    if (elas .and. incr) repk='MIXTE'
!
    if (.not.elas .and. .not.incr) ierd = 1
!
    call jedema()
!
end subroutine
