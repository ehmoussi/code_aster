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

subroutine delat(modgen, nbsst, nbmo)
    implicit none
!
! AUTEUR : G. ROUSSEAU
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rsorac.h"
#include "asterfort/wkvect.h"
!
    integer :: ibid, nbid, isst
    character(len=8) :: k8bid
    character(len=8) :: modgen, macel
    complex(kind=8) :: cbid
! -----------------------------------------------------------------
!---------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: ibamo, icompt, idelat, ij, imacl, jpara, nbmo
    integer :: nbmodg(1), nbsst, nbtype
    real(kind=8) :: bid, ebid
!-----------------------------------------------------------------------
    call jemarq()
!
! NB DE MODES TOTAL
!
    nbmo=0
    do 1 isst = 1, nbsst
        call jeveuo(jexnum(modgen//'      .MODG.SSME', isst), 'L', imacl)
        macel=zk8(imacl)
        call jeveuo(macel//'.MAEL_REFE', 'L', ibamo)
        call rsorac(zk24(ibamo), 'LONUTI', ibid, bid, k8bid,&
                    cbid, ebid, 'ABSOLU', nbmodg, 1,&
                    nbid)
        nbmo=nbmo+nbmodg(1)
 1  continue
!
! TABLEAU INDIQUANT LES MODES PROPRES
!
    call wkvect('&&DELAT.INDIC', 'V V I', nbmo, idelat)
    icompt=0
    do 2 isst = 1, nbsst
        call jeveuo(jexnum(modgen//'      .MODG.SSME', isst), 'L', imacl)
        macel=zk8(imacl)
!
        call jeveuo(macel//'.MAEL_REFE', 'L', ibamo)
!
!       CALL JEVEUO(ZK24(IBAMO)(1:19)//'.TYPE','L',ITYPE)
        call jelira(zk24(ibamo)(1:19)//'.ORDR', 'LONUTI', nbtype)
        do 3, ij=1,nbtype
        icompt=icompt+1
        call rsadpa(zk24(ibamo)(1:19), 'L', 1, 'TYPE_DEFO', ij,&
                    0, sjv=jpara, styp=k8bid)
        if (zk16(jpara)(1:8) .ne. 'PROPRE  ') goto 3
        zi(idelat+icompt-1)=1
 3      continue
 2  continue
    call jedema()
end subroutine
