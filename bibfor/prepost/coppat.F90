! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine coppat(main, maout, nbma, nbpain, lenpat, same_zone)
!

    implicit none
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/jenonu.h"
#include "asterfort/jelira.h"

    character(len=8), intent(in) :: main
    character(len=8), intent(in) :: maout
    integer, intent(in) :: nbma
    integer, intent(in) :: lenpat
    integer, intent(out) :: nbpain
    aster_logical, intent(in) :: same_zone
! -------------------------------------------------------------------------------------------------
!   RECUPERATION ET MISE A JOUR DE LA COLLECTION .PATH
! -------------------------------------------------------------------------------------------------
    integer :: nbpatch, nbzone, nbinfo, patch
    integer :: nwpath, odpath, lonpat
    integer :: inc1, inc2

! -------------------------------------------------------------------------------------------------
    call jemarq()
!
    call jedetr(maout//'.PATCH')
    call jelira(main//'.PATCH','NUTIOC',nbpatch)
    nbpain = nbpatch-1
    call jelira(jexnum(main//'.PATCH', 1),'LONUTI' ,nbzone)
    call jelira(main//'.PATCH','LONT' ,lonpat)
    call jecrec(maout//'.PATCH','G V I', 'NU', 'CONTIG', 'VARIABLE', nbpatch+nbma)
    if (same_zone) then
        call jeecra(maout//'.PATCH', 'LONT', ival=lonpat+lenpat)
    else
        call jeecra(maout//'.PATCH', 'LONT', ival=lonpat+lenpat+2)
    endif
    call jeecra(maout//'.PATCH', 'LONT', ival=lonpat+lenpat+2)
    call jecroc(jexnum(maout//'.PATCH',1))
    if (same_zone) then
        call jeecra(jexnum(maout//'.PATCH',1), 'LONMAX', ival=nbzone)
        call jeecra(jexnum(maout//'.PATCH',1), 'LONUTI', ival=nbzone)
    else
        call jeecra(jexnum(maout//'.PATCH',1), 'LONMAX', ival=nbzone+2)
        call jeecra(jexnum(maout//'.PATCH',1), 'LONUTI', ival=nbzone+2)
    endif
    call jeveuo(jexnum(maout//'.PATCH',1), 'E', patch)
    call jeveuo(jexnum(main//'.PATCH', 1), 'L', odpath)
    call jelira(jexnum(main//'.PATCH', 1), 'LONUTI', nbinfo)
    if (same_zone) then
        do inc2=1,nbinfo
            zi(patch+inc2-1)=zi(odpath+inc2-1)
        end do
        zi(patch+nbzone+0-1)= zi(patch+nbzone+0-1) + nbma
    else
        do inc2=1,nbinfo
            zi(patch+inc2-1)=zi(odpath+inc2-1)
        end do
        zi(patch+nbzone+1-1)=nbpatch+1
        zi(patch+nbzone+2-1)=nbma
    endif
    do inc1=1, nbpatch-1
        call jeveuo(jexnum(main//'.PATCH', inc1+1), 'L', odpath)
        call jelira(jexnum(main//'.PATCH', inc1+1), 'LONUTI', nbinfo)
        call jecroc(jexnum(maout//'.PATCH', inc1+1))
        call jeecra(jexnum(maout//'.PATCH', inc1+1), 'LONMAX', nbinfo)
        call jeecra(jexnum(maout//'.PATCH', inc1+1), 'LONUTI', nbinfo)
        call jeveuo(jexnum(maout//'.PATCH', inc1+1), 'E', nwpath)
        do inc2=1, nbinfo
            zi(nwpath+inc2-1) = zi(odpath+inc2-1)
        end do
    end do
!
    call jedema()
end subroutine
