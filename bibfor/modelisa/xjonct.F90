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

subroutine xjonct(noma, modelx)
! person_in_charge: daniele.colombo at ifpen.fr
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/cescel.h"
#include "asterfort/celces.h"
#include "asterfort/cesexi.h"
#include "asterfort/cncinv.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
!
    character(len=8) :: noma, modelx
!
!----------------------------------------------------------------------
!  BUT: CONCATENATION DU CHAM_ELNO PJONCNO POUR LES JONCTIONS AVEC CONTACT
!
!----------------------------------------------------------------------
!
!     ARGUMENTS/
!  NOMA       IN       K8 : MAILLAGE
!  MODELX     IN/OUT   K8 : MODELE XFEM
!
    character(len=19) :: joncns, ligrel, cnxinv, joncno
    character(len=24) :: grp
    character(len=8) :: nomfis
    character(len=2) :: ch2
    integer ::  ibid, ier, nncp, jcesv, jcesl, jcesd, nmaenr, jgrp, ifis, nfis, i, k
    integer :: ima, nbnoma, jconx2, nmasup, nuno, j, ind , iad, l, nuno2, iad2, ind2
    integer :: ima2 , nbnoma2, jmasup
    integer, pointer :: xfem_cont(:) => null()
    integer, pointer :: vnfis(:) => null()
    character(len=8), pointer :: fiss(:) => null()
    integer, pointer :: connex(:) => null()
!
!     ------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
       call jeveuo(modelx//'.XFEM_CONT', 'L', vi=xfem_cont)
       if (xfem_cont(1).ne.2 .and. xfem_cont(1).ne.3) goto 999
!
       joncno = modelx//'.TOPOSE.PJO'
       cnxinv = '&&XJONCT.CNCINV'
       call cncinv(noma,[ibid], 0, 'V', cnxinv)
       ligrel = modelx//'.MODELE'
       call jeveuo(noma//'.CONNEX', 'L', vi=connex)
       call jeveuo(jexatr(noma//'.CONNEX', 'LONCUM'), 'L', jconx2)
       call codent(1, 'G', ch2)
       joncns = '&&XJONCT.CES'//ch2
!
       call jeexin(joncno//'.CELD', ier)
       if (ier .eq. 0) goto 999
!
       call celces(joncno, 'V', joncns)
       call jeveuo(joncns//'.CESD', 'L', jcesd)
       call jeveuo(joncns//'.CESL', 'L', jcesl)
       call jeveuo(joncns//'.CESV', 'E', jcesv)
       call jeveuo(modelx//'.NFIS', 'L', vi=vnfis)
       nfis = vnfis(1)
       call jeveuo(modelx//'.FISS', 'L', vk8=fiss)
!
! --- BOUCLE SUR LES FISSURES
       do ifis = 1, nfis
          nomfis = fiss(ifis)
          grp = nomfis(1:8)//'.MAILFISS.CONT'
          call jeexin(grp, ier)
          nmaenr = 0
          if (ier .ne. 0) then
             call jeveuo(grp, 'L', jgrp)
             call jelira(grp, 'LONMAX', nmaenr)
          endif
!
! --- BOUCLE SUR LES MAILES CONTACTANTES
          do i = 1, nmaenr
             ima = zi(jgrp-1+i)
             nbnoma = zi(jconx2+ima) - zi(jconx2+ima-1)
!
! --- BOUCLE SUR LES NOEUDS DE LA MAILLE
             do j = 1, nbnoma
                call cesexi('C', jcesd, jcesl, ima, 1,&
                            1, j, iad)
                if (iad.le.0) go to 220
                ind = zi(jcesv-1+iad)
                if (ind.ne.1) then
                   nuno = connex(zi(jconx2+ima-1)+ j-1)
                   call jelira(jexnum(cnxinv, nuno), 'LONMAX', nmasup)
                   call jeveuo(jexnum(cnxinv, nuno), 'L', jmasup)
!
! --- BOUCLE SUR LES MAILLES SUPPORT DU NOEUD
                   do k = 1, nmasup
                      ima2 = zi(jmasup-1+k)
                      nbnoma2 = zi(jconx2+ima2) - zi(jconx2+ima2-1)
!
! --- BOUCLE SUR LES NOEUDS DE LA MAILLE
                      do l = 1, nbnoma2
                         nuno2 = connex(zi(jconx2+ima2-1)+ l-1)
                         if (nuno2.eq.nuno) then
                            call cesexi('C', jcesd, jcesl, ima2, 1,&
                                        1, l, iad2)
                            if (iad2.le.0) go to 250
                            ind2 = zi(jcesv-1+iad2)
                            if (ind2.ge.1) then
                               zi(jcesv-1+iad) = ind2
                               goto 230
                            endif
                         endif
                      end do
 250                  continue
                   end do
                endif
 230            continue
             end do
 220         continue
          end do
       end do
!
       call cescel(joncns, ligrel, 'TOPOSE', 'PJONCNO', 'OUI',&
                   nncp, 'G', joncno, 'F', ibid)
!
       call jedetr(cnxinv)
       call detrsd('CHAM_ELEM_S', joncns)
!
 999   continue
!
    call jedema()
!
end subroutine
