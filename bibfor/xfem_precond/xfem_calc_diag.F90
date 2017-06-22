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

subroutine xfem_calc_diag(matass, nonu, neq, deeq, nbnomax, &
                           ino_xfem, is_xfem, nbnoxfem, ieq_loc,&
                           scal, deca, k8cmp, tab_mloc)
!
!-----------------------------------------------------------------------
! BUT :
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!   STOCKAGE DES MATRICES LOCALES DE PRE CONDITIONNMENT
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!
!-----------------------------------------------------------------------
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jexnum.h"
#include "asterfort/jeveuo.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!-----------------------------------------------------------------------
!
    character(len=19) :: matass
    character(len=14) :: nonu
    integer :: neq, nbnomax, nbnoxfem, deca
    integer :: deeq(*), ino_xfem(nbnomax)
    integer :: ieq_loc(neq)
    aster_logical :: is_xfem(nbnomax)
    real(kind=8) :: tab_mloc(deca*nbnoxfem), scal
    character(len=8) :: k8cmp(*)
!
!-----------------------------------------------------------------------
!
    integer :: jcoll, iligl, nunoj, nunoi, kterm, nnz, jvale, jval2, jsmhc, ipos, jpos, nvale
    integer, pointer :: smdi(:) => null()
    aster_logical :: lsym
    real(kind=8) :: valei, valej, rcoef
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
    call jeveuo(nonu//'.SMOS.SMDI', 'L', vi=smdi)
    call jeveuo(nonu//'.SMOS.SMHC', 'L', jsmhc)
    call jeveuo(jexnum(matass//'.VALM', 1), 'E', jvale)
    call jelira(jexnum(matass//'.VALM', 1), 'LONMAX', nnz)
    call jelira(matass//'.VALM', 'NMAXOC', nvale)
    if (nvale .eq. 1) then
       lsym=.true.
    else if (nvale.eq.2) then
       lsym=.false.
       call jeveuo(jexnum(matass//'.VALM', 2), 'E', jval2)
    else
        ASSERT(.false.)
    endif
!
    tab_mloc(1:deca*nbnoxfem)=0.d0
!
    jcoll=1
    nunoj=deeq(2*(jcoll-1)+1)
    jpos=ieq_loc(jcoll)
    do 30 kterm=1,nnz
       if (smdi(jcoll) .lt. kterm) then
           jcoll=jcoll+1 
           nunoj=deeq(2*(jcoll-1)+1)
           jpos=ieq_loc(jcoll)
       endif
       iligl=zi4(jsmhc-1+kterm)
       ipos=ieq_loc(iligl)
       if (ipos.le.0) goto 30
       nunoi=deeq(2*(iligl-1)+1)
       if (is_xfem(nunoi).and.ipos.gt.0) then
         tab_mloc(deca*(ino_xfem(nunoi)-1)+ipos)=max(&
                        tab_mloc(deca*(ino_xfem(nunoi)-1)+ipos),&
                        abs(zr(jvale-1+kterm)))
       endif
       if (iligl .eq. jcoll) goto 30
       if (jpos.le.0) goto 30
       if (is_xfem(nunoj).and.jpos.gt.0) then
         tab_mloc(deca*(ino_xfem(nunoj)-1)+jpos)=max(&
                        tab_mloc(deca*(ino_xfem(nunoj)-1)+jpos),&
                        abs(zr(jvale-1+kterm)))
       endif
       if (.not.lsym) then
         if (is_xfem(nunoi).and.ipos.gt.0) then
           tab_mloc(deca*(ino_xfem(nunoi)-1)+ipos)=max(&
                          tab_mloc(deca*(ino_xfem(nunoi)-1)+ipos),&
                          abs(zr(jval2-1+kterm)))
         endif
         if (is_xfem(nunoj).and.jpos.gt.0) then
           tab_mloc(deca*(ino_xfem(nunoj)-1)+jpos)=max(&
                          tab_mloc(deca*(ino_xfem(nunoj)-1)+jpos),&
                          abs(zr(jval2-1+kterm)))
         endif
       endif
!
30  continue
!
    do 60 iligl=1,neq
      if (ieq_loc(iligl) .le. 0 ) goto 60
      nunoi=deeq(2*(iligl-1)+1)
      if ( .not. is_xfem(nunoi) ) goto 60
      rcoef=sqrt(tab_mloc(deca*(ino_xfem(nunoi)-1)+ieq_loc(iligl)))
      if (rcoef.le.0.d0) then
         call utmess('F', 'XFEMPRECOND_7', nk=1, valk=k8cmp(deeq(2*(iligl-1)+2)),&
                                           ni=2, vali=[iligl,nunoi])
      endif
      tab_mloc(deca*(ino_xfem(nunoi)-1)+ieq_loc(iligl))=scal/rcoef
60  continue
!
    jcoll=1
    nunoj=deeq(2*(jcoll-1)+1)
    do kterm=1,nnz
       if (smdi(jcoll) .lt. kterm) then
           jcoll=jcoll+1
           nunoj=deeq(2*(jcoll-1)+1)
       endif
       if (ieq_loc(jcoll).ne.0) then
           valej=tab_mloc(deca*(ino_xfem(nunoj)-1)+ieq_loc(jcoll))
       else
           valej=1.d0
       endif
       iligl=zi4(jsmhc-1+kterm)
       nunoi=deeq(2*(iligl-1)+1)
       if (ieq_loc(iligl).ne.0) then
           valei=tab_mloc(deca*(ino_xfem(nunoi)-1)+ieq_loc(iligl))
       else
           valei=1.d0
       endif
       zr(jvale-1+kterm)=zr(jvale-1+kterm)*valei*valej
       if (.not. lsym) zr(jval2-1+kterm)=zr(jval2-1+kterm)*valei*valej
    enddo
!
    call jedema()
!
end subroutine
