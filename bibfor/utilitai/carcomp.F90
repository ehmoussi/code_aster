! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
subroutine carcomp(carte_1, carte_2, iret)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/carces.h"
#include "asterfort/cesexi.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
!
character(len=*), intent(in) :: carte_1, carte_2
integer, intent(out) :: iret
!
! --------------------------------------------------------------------------------------------------
!
! Utility - Fields
!
! Comparison of two CARTE
!
! --------------------------------------------------------------------------------------------------
!
! In  carte_1   : first CARTE
! In  carte_2   : second CARTE
! Out iret      : 0 if same CARTE
!                 1 if not
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbCell, iCell, iCmp, iret1, iret2
    character(len=8) :: mesh_1, mesh_2, mesh
    character(len=19) :: carte_1s, carte_2s
    integer :: jcesd1, jcesv1, jcesl1
    integer :: jcesd2, jcesv2, jcesl2
    integer :: iad1, iad2
    character(len=8) :: nomgd1, nomgd2, nomgd, type_test
    character(len=3) :: tsca
    real(kind=8) :: zero, valr1, valr2, valr_error
    integer :: vali1, vali2
    integer :: ncmp1, ncmp2, nbCmp
    character(len=80) :: valk1, valk2
    aster_logical :: vall1, vall2, lok
    real(kind=8) :: epsi
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    iret = 0
    zero = 0.d0
    carte_1s = '&&CARCOMP.C1S'
    carte_2s = '&&CARCOMP.C2S'
    epsi = 1.d-15
!
! - <GRANDEUR>
!
    call dismoi('NOM_GD', carte_1, 'CARTE', repk = nomgd1)
    call dismoi('NOM_GD', carte_2, 'CARTE', repk = nomgd2)
    if (nomgd1 .eq. nomgd2) then
        nomgd = nomgd1
    else
        iret = 1
        goto 99
    endif
    call dismoi('TYPE_SCA', nomgd, 'GRANDEUR', repk = tsca)
!
! - Mesh
!
    call dismoi('NOM_MAILLA', carte_1, 'CHAMP', repk = mesh_1)
    call dismoi('NOM_MAILLA', carte_2, 'CHAMP', repk = mesh_2)
    if (mesh_1 .eq. mesh_2) then
        mesh = mesh_1
    else
        iret = 1
        goto 99
    endif
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi = nbCell)
!
! - Changing in simpler datastructure
!
    call carces(carte_1, 'ELEM', ' ', 'V', carte_1s, 'A', iret1)
    call carces(carte_2, 'ELEM', ' ', 'V', carte_2s, 'A', iret2)
    call jeveuo(carte_1s//'.CESD', 'L', jcesd1)
    call jeveuo(carte_1s//'.CESV', 'L', jcesv1)
    call jeveuo(carte_1s//'.CESL', 'L', jcesl1)
    call jeveuo(carte_2s//'.CESD', 'L', jcesd2)
    call jeveuo(carte_2s//'.CESV', 'L', jcesv2)
    call jeveuo(carte_2s//'.CESL', 'L', jcesl2)
!
! - Comparing
!
    do iCell = 1, nbCell
        ncmp1 = zi(jcesd1-1+5+4*(iCell-1)+3)
        ncmp2 = zi(jcesd2-1+5+4*(iCell-1)+3)
        if (ncmp1 .eq. ncmp2) then
            nbCmp = ncmp1
        else
            iret = 1
            goto 99
        endif
        do iCmp = 1, nbCmp
            call cesexi('C', jcesd1, jcesl1, iCell, 1, 1, iCmp, iad1)
            call cesexi('C', jcesd2, jcesl2, iCell, 1, 1, iCmp, iad2)
            if (iad1 .lt. 0 .or. iad2 .lt. 0) then
                cycle
            endif
            if (iad1 .eq. 0) then
                if (iad2 .ne. 0) then
                    iret = 1
                    goto 99
                endif
            else if (iad2 .eq. 0) then
                if (iad1 .ne. 0) then
                    iret = 1
                    goto 99
                endif
            else
                if (tsca .eq. 'R') then
                    valr1 = zr(jcesv1-1+iad1)
                    valr2 = zr(jcesv2-1+iad2)
                    if (valr2 .ne. zero) then
                        valr_error = (valr1-valr2)/valr2
                        type_test = 'RELATIF'
                    else
                        valr_error = valr1-valr2
                        type_test = 'ABSOLU'
                    endif
                    if (type_test .eq. 'RELATIF') then
                        lok = ( abs( valr_error ) .le. epsi*abs(valr2))
                    else
                        lok = ( abs( valr_error ) .le. epsi )
                    endif
                else if (tsca.eq.'I') then
                    vali1 = zi(jcesv1-1+iad1)
                    vali2 = zi(jcesv2-1+iad2)
                    lok = vali1 .eq. vali2
                else if (tsca.eq.'L') then
                    vall1 = zl(jcesv1-1+iad1)
                    vall2 = zl(jcesv2-1+iad2)
                    lok = vall1 .and. vall2
                else if (tsca.eq.'K8') then
                    valk1 = zk8(jcesv1-1+iad1)
                    valk2 = zk8(jcesv2-1+iad2)
                    lok = valk1 .eq. valk2
                else if (tsca.eq.'K16') then
                    valk1 = zk16(jcesv1-1+iad1)
                    valk2 = zk16(jcesv2-1+iad2)
                    lok = valk1 .eq. valk2
                else if (tsca.eq.'K24') then
                    valk1 = zk24(jcesv1-1+iad1)
                    valk2 = zk24(jcesv2-1+iad2)
                    lok = valk1 .eq. valk2
                else if (tsca.eq.'K32') then
                    valk1 = zk32(jcesv1-1+iad1)
                    valk2 = zk32(jcesv2-1+iad2)
                    lok = valk1 .eq. valk2
                else if (tsca.eq.'K80') then
                    valk1 = zk80(jcesv1-1+iad1)
                    valk2 = zk80(jcesv2-1+iad2)
                    lok = valk1 .eq. valk2
                else
                    ASSERT(.false.)
                endif
            endif
            if (.not.lok) then
                iret = 1
                goto 99
            endif
        end do
    end do
!
 99 continue
!
    call detrsd('CHAM_ELEM_S', carte_1s)
    call detrsd('CHAM_ELEM_S', carte_2s)
!
    call jedema()
!
end subroutine
