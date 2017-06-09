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

subroutine cgvein(resu, compor, iord0, l_temp)
!
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
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
!
!
    integer, intent(in) :: iord0
    character(len=8), intent(in) :: resu
    character(len=19), intent(in) :: compor
    aster_logical, intent(in) :: l_temp
!
! --------------------------------------------------------------------------------------------------
!
! CALC_G
!
! Verifications supplementaires pour les comportements incrementaux (ELAS + ETAT_INIT ou GTP)
!
! --------------------------------------------------------------------------------------------------
!
! In resu   : nom du resultat
! In compor : carte comportement cree dans cgleco()
! In iord0  : premier NUME_ORDRE dans resu
! In l_temp : .true.  en presence de thermique
!             .false. sinon
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, jcald, jcall, nbma, iadc, ima
    character(len=8) :: noma
    character(len=16) :: k16ldc
    character(len=19) :: chcalc, chtmp
    aster_logical :: lldcok
    character(len=16), pointer :: cesv(:) => null()
    character(len=8), pointer :: cesk(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - les relations de comportement dans la carte compor sont elles autorisees ?
!
    chtmp = '&&CGVEIN_CHTMP'
    chcalc = '&&CGVEIN_CHCALC'
!
    call carces(compor, 'ELEM', ' ', 'V', chtmp,&
                'A', iret)
    call cesred(chtmp, 0, [0], 1, 'RELCOM',&
                'V', chcalc)
    call detrsd('CHAM_ELEM_S', chtmp)
    call jeveuo(chcalc//'.CESD', 'L', jcald)
    call jeveuo(chcalc//'.CESV', 'L', vk16=cesv)
    call jeveuo(chcalc//'.CESL', 'L', jcall)
    call jeveuo(chcalc//'.CESK', 'L', vk8=cesk)
!
    noma = cesk(1)
    nbma = zi(jcald-1+1)
!
    do ima = 1, nbma
!
        call cesexi('C', jcald, jcall, ima, 1,&
                    1, 1, iadc)
        ASSERT(iadc .gt. 0)
        k16ldc = cesv(iadc)
!
!       seules relations de type COMP_INCR autorisees
        lldcok = k16ldc .eq. 'ELAS            ' .or. k16ldc .eq. 'VMIS_ISOT_LINE  ' .or. k16ldc&
                 .eq. 'VMIS_ISOT_TRAC  '
        if (.not.lldcok) call utmess('F', 'RUPTURE1_69', sk=k16ldc)
!
!       on interdit VMIS_ISOT_TRAC en presence de thermique
        if (k16ldc .eq. 'VMIS_ISOT_TRAC  ' .and. l_temp) call utmess('F', 'RUPTURE1_70')
    enddo
!
    call jedema()
!
end subroutine
