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

subroutine lecojb(ob, unite, base, iret)
! aslint: disable=
    implicit none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/lecvec.h"
#include "asterfort/wkvect.h"
    character(len=*) :: ob
    character(len=1) :: base
    integer :: unite, iret
!    BUT : LIRE UN OBJET JEVEUX SUR L'UNITE LOGIQUE : UNITE.
!          S'IL N'Y A PLUS RIEN A LIRE SUR LE FICHIER : IRET=1
! OUT   OB (K24)   : NOM DE L'OBJET LU
! IN    UNITE (I)  : UNITE LOGIQUE
! IN    BASE (K1)  : G/V/L
! OUT   IRET  (I)  : CODE RETOUR : 0 -> OK ; 1 : IL N'Y RIEN A LIRE
    character(len=24) :: ob1
    character(len=3) :: type
    character(len=40) :: acces
    character(len=8) :: stock, modlon, nomk8, genr
    character(len=16) :: mocle1, mocle2, mocle3, mocle4
    integer :: lonmax
    integer :: iad, long, nmaxoc, nutioc, iobj, lont
    integer :: jtmp, k
!
    call jemarq()
    read(unite,1001,end=9998) mocle1,genr
    ASSERT(mocle1.eq.'|TYPE_JEVEUX=')
!
!
    if (genr .eq. 'SIMPLE') then
!     ----------------------------
        read (unite,1002) mocle1,ob1,mocle2,type,mocle3,long
        ASSERT(mocle1.eq.'|NOM=')
        ASSERT(mocle2.eq.'|TYPE=')
        ASSERT(mocle3.eq.'|LONMAX=')
        call wkvect(ob1, base//' V '//type, long, iad)
        call lecvec(iad, long, type, unite)
!
!
    else if (genr.eq.'PT_NOM') then
!     ----------------------------
        read (unite,1002) mocle1,ob1,mocle2,type,mocle3,long
        ASSERT(mocle1.eq.'|NOM=')
        ASSERT(mocle2.eq.'|TYPE=')
        ASSERT(mocle3.eq.'|NOMMAX=')
        call jecreo(ob1, base//' N '//type)
        call wkvect('&&LECOJB.PTNOM', base//' V '//type, long, jtmp)
        call lecvec(jtmp, long, type, unite)
        call jeecra(ob1, 'NOMMAX', long)
        if (type .eq. 'K8') then
            do 10, k=1,long
            call jecroc(jexnom(ob1, zk8(jtmp-1+k)))
10          continue
        else if (type.eq.'K16') then
            do 11, k=1,long
            call jecroc(jexnom(ob1, zk16(jtmp-1+k)))
11          continue
        else if (type.eq.'K24') then
            do 12, k=1,long
            call jecroc(jexnom(ob1, zk24(jtmp-1+k)))
12          continue
        else if (type.eq.'K32') then
            do 13, k=1,long
            call jecroc(jexnom(ob1, zk32(jtmp-1+k)))
13          continue
        else
            ASSERT(.false.)
        endif
        call jedetr('&&LECOJB.PTNOM')
!
!
!
    else if (genr.eq.'COLLEC') then
!     ----------------------------
        read (unite,1004) mocle1,ob1,mocle2,type,mocle3,nmaxoc,&
        mocle4,nutioc,mocle4,acces(1:2),mocle4,stock, mocle4,modlon,&
        mocle4,lonmax,mocle4,lont
!
        ASSERT(mocle1.eq.'|NOM=')
        ASSERT(mocle2.eq.'|TYPE=')
        ASSERT(mocle3.eq.'|NMAXOC=')
        call jecrec(ob1, base//' V '//type, acces(1:2), stock, modlon,&
                    nmaxoc)
!
        if (stock .eq. 'CONTIG') call jeecra(ob1, 'LONT', lont)
        if ((modlon.eq.'CONSTANT') .and. (stock.ne.'CONTIG')) call jeecra(ob1, 'LONMAX', lonmax)
        do 2,iobj=1,nutioc
!
        if (acces(1:2) .eq. 'NO') then
            read (unite,1005) mocle1,nomk8,mocle2,long
            ASSERT(mocle1.eq.'|NOM=')
            ASSERT(mocle2.eq.'|LONMAX=')
            call jecroc(jexnom(ob1, nomk8))
            if (modlon .ne. 'CONSTANT') call jeecra(jexnom(ob1, nomk8), 'LONMAX', long)
            if (long .gt. 0) call jeveuo(jexnom(ob1, nomk8), 'E', iad)
        else
            read (unite,1006) mocle1,long
            ASSERT(mocle1.eq.'|LONMAX=')
            call jecroc(jexnum(ob1, iobj))
            if (modlon .ne. 'CONSTANT') call jeecra(jexnum(ob1, iobj), 'LONMAX', long)
            if (long .gt. 0) call jeveuo(jexnum(ob1, iobj), 'E', iad)
        endif
        call lecvec(iad, long, type, unite)
 2      continue
!
    else
        ASSERT(.false.)
    endif
!
!
    ob = ob1
    iret=0
    goto 9999
!
9998  continue
    ob=' '
    iret=1
!
9999  continue
!
    call jedema()
!
    1001 format (a13,a6)
    1002 format (a5,a24,a6,a3,a8,i12)
    1004 format (a5,a24,a6,a3,a8,i12,a8,i12,&
     &        a7,a2,a10,a8,a10,a8,&
     &        a8,i12,a6,i12)
    1005 format (a5,a8,a8,i12)
    1006 format (a8,i12)
end subroutine
