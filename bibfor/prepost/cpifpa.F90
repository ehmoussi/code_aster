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

subroutine cpifpa(main, maout)
!

    implicit none
#include "jeveux.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/jelira.h"

    character(len=8), intent(in) :: main
    character(len=8), intent(in) :: maout
! -------------------------------------------------------------------------------------------------
!   RECOPIE DES INFORMATIONS CONCERNANT LES PATCHS
! -------------------------------------------------------------------------------------------------
    integer :: nbpatch, nbinfo, odcnpa, odcmpa
    integer :: nwpath, odpath, jcnnpa, jcnmpa
    integer :: inc1, inc2, nbma ,nbno,info, lonpat
! -------------------------------------------------------------------------------------------------
    call jemarq()
!
! ------ INITIALISATION
    call jeveuo(main//'.DIME', 'L', info)
    nbno = zi(info-1+1)
    nbma = zi(info-1+3)
! ------ RECOPIE .PATCH
    call jelira(main//'.PATCH','NUTIOC',nbpatch)
    call jelira(main//'.PATCH','LONT',lonpat)
    call jedetr(maout//'.PATCH')
    call jecrec(maout//'.PATCH','G V I', 'NU', 'CONTIG', 'VARIABLE', nbpatch)
    call jeecra(maout//'.PATCH', 'LONT',lonpat)
    do inc1=1, nbpatch
        call jeveuo(jexnum(main//'.PATCH', inc1), 'L', odpath)
        call jelira(jexnum(main//'.PATCH', inc1), 'LONUTI', nbinfo)
        call jecroc(jexnum(maout//'.PATCH',inc1))
        call jeecra(jexnum(maout//'.PATCH',inc1), 'LONMAX',nbinfo)
        call jeecra(jexnum(maout//'.PATCH',inc1), 'LONUTI',nbinfo)
        call jeveuo(jexnum(maout//'.PATCH',inc1), 'E', nwpath)
        do inc2=1, nbinfo
            zi(nwpath+inc2-1) = zi(odpath+inc2-1)
        end do
    end do
! ------ RECOPIE .CONOPA
    call jedetr(maout//'.CONOPA')
    call wkvect(maout//'.CONOPA', 'G V I',nbno, jcnnpa)
    call jeveuo(main//'.CONOPA', 'L', odcnpa)
    do inc1=1,nbno 
        zi(jcnnpa+inc1-1) = zi(odcnpa+inc1-1)
    end do
! ------ RECOPIE .COMAPA
    call jedetr(maout//'.COMAPA')
    call wkvect(maout//'.COMAPA', 'G V I', nbma, jcnmpa)
    call jeveuo(main//'.COMAPA', 'L', odcmpa)
    do inc1=1,nbma 
        zi(jcnmpa+inc1-1) = zi(odcmpa+inc1-1)  
    end do
!
    call jedema()
end subroutine
