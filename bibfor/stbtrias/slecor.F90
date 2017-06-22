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

subroutine slecor(iunv, datset)
!  ROUTINE DE TRAITEMENT DES SYSTEMES DE COORDONNEES SUPERTAB
!  LE DATASET 18 EST OBSOLETE DEPUIS 1987
!  DATSET : IN :DATASET DES SYSTEMES DE COORDONNEES
! ======================================================================
! aslint: disable=
    implicit none
!     =================
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    aster_logical :: first
    character(len=6) :: moins1
    character(len=80) :: cbuf, kbid
    real(kind=8) :: rbid
    integer :: datset, ibid, iunv, inus, inum, icoor, jsys, iret, icol, ibid2
!
!  ------------ FIN DECLARATION -------------
!
!  -->N  D'UNITE LOGIQUE ASSOCIE AUX FICHIERS
    call jemarq()
!
    first=.true.
    moins1 = '    -1'
    inus = 10
    call jeexin('&&IDEAS.SYST', iret)
    if (iret .ne. 0) then
        call jedetr('&&IDEAS.SYST')
        if (datset .eq. 2420) then
            call utmess('A', 'STBTRIAS_3')
        else if (datset.eq.18) then
            call utmess('A', 'STBTRIAS_4')
        endif
    endif
    call wkvect('&&IDEAS.SYST', 'V V I', inus, jsys)
!
  1 continue
!
    read(iunv,'(A)') cbuf
    if (cbuf(1:6) .ne. moins1) then
!
        if (first) then
            if (datset .eq. 2420) then
                read(iunv,'(A)') kbid
                read(iunv,'(3I10)') inum,icoor,icol
            else if (datset.eq.18) then
                read(cbuf,'(5I10)') inum,icoor,ibid,icol,ibid2
            endif
        else
            if (datset .eq. 2420) then
                read(cbuf,'(3I10)') inum,icoor,icol
            else if (datset.eq.18) then
                read(cbuf,'(5I10)') inum,icoor,ibid,icol,ibid2
            endif
        endif
        if (inum .gt. inus) then
            inus = inum
            call juveca('&&IDEAS.SYST', inus)
            call jeveuo('&&IDEAS.SYST', 'E', jsys)
        endif
!
        zi(jsys-1+inum) = icoor
!
        if (datset .eq. 2420) then
            read(iunv,'(A)') kbid
            read(iunv,'(3(1PD25.16))') rbid
            read(iunv,'(3(1PD25.16))') rbid
            read(iunv,'(3(1PD25.16))') rbid
            read(iunv,'(3(1PD25.16))') rbid
        else
            read(iunv,'(A)') kbid
            read(iunv,'(6(1PE13.5))') rbid
            read(iunv,'(3(1PE13.5))') rbid
        endif
!
        first = .false.
!
        goto 1
!
    endif
    call jedema()
end subroutine
