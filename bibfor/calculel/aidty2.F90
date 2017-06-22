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

subroutine aidty2(impr)

    implicit none
!    BUT:
!       ECRIRE SUR LE FICHIER "IMPR"
!       1  LES COUPLES (OPTION, TYPE_ELEMENT) REALISES AUJOURD'HUI
!          (POUR VERIFIER LA COMPLETUDE)
! ----------------------------------------------------------------------
#include "jeveux.h"
!
#include "asterfort/aidtyp.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
    character(len=16) :: nomte, noop
    integer ::  nbte, nbop, ianop2, iop, ite, ioptte, iaopmo, nucalc
    integer :: impr
    integer, pointer :: optte(:) => null()
!
    call jemarq()
!
!     1) IMPRESSION DES LIGNES DU TYPE :
!        &&CALCUL/MECA_XT_FACE3   /CHAR_MECA_PRES_R
!     ------------------------------------------------------------------
    call jeveuo('&CATA.TE.OPTTE', 'L', vi=optte)
    call jelira('&CATA.TE.NOMTE', 'NOMUTI', nbte)
    call jelira('&CATA.OP.NOMOPT', 'NOMUTI', nbop)
!
    call wkvect('&&AIDTY2.NOP2', 'V V K16', nbop, ianop2)
    do iop=1,nbop
        call jenuno(jexnum('&CATA.OP.NOMOPT', iop), noop)
        zk16(ianop2-1+iop)=noop
    end do
!
!
!     -- ECRITURE DES COUPLES (TE,OPT)
!     --------------------------------
    do ite=1,nbte
        call jenuno(jexnum('&CATA.TE.NOMTE', ite), nomte)
        do 101,iop=1,nbop
            ioptte= optte(nbop*(ite-1)+iop)
            if (ioptte .eq. 0) goto 101
            call jeveuo(jexnum('&CATA.TE.OPTMOD', ioptte), 'L', iaopmo)
            nucalc= zi(iaopmo)
            if (nucalc .le. 0) goto 101
            write(impr,*)'&&CALCUL/'//nomte//'/'//zk16(ianop2-1+iop)
101     continue
    end do
!
!
!     2) IMPRESSION DE LIGNES PERMETTANT LE SCRIPT "USAGE_ROUTINES" :
!        A QUELLES MODELISATIONS SERVENT LES ROUTINES TE00IJ ?
!     ----------------------------------------------------------------
!  PHENOMENE  MODELISATION TYPE_ELEMENT OPTION       TE00IJ
!  MECANIQUE  D_PLAN_HMS   HM_DPQ8S     SIEQ_ELNO    330
!
    call aidtyp(impr)
!
!
    call jedema()
end subroutine
