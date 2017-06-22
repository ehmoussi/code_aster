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

subroutine ascima(infcha, nu, matass, cumul)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
#include "jeveux.h"
!
#include "asterfort/asschc.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
    character(len=19) :: infcha
    character(len=*) :: nu, matass
    integer :: nchci
! ----------------------------------------------------------------------
!  BUT : ON NOTE LES DDLS ELIMINES PAR LES CHARGES CINEMATIQUES
!
!  REMARQUE : LE RESTE DU TRAITEMENT DES CHARGES CINEMATIQUES EST FAIT
!             LORS DE LA RESOLUTION (ASMCHC+CSMBGG)
!
! IN  K*  INFCHA : / SD_INFCHA (K19)
!                  / NOM D'UN OBJET JEVEUX (K24) CONTENANT
!                    LES NOMS DES CHARGES CINEMATIQUES (K8)
!
! IN  NU      : NUME_DDL
! VAR MATASS  : MATR_ASSE : CREATION / MISE A JOUR DE .CCID
! IN  CUMUL   : 'ZERO' / 'CUMU'
!
!
!----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
    character(len=4) :: cumul
    character(len=19) :: infch2
    integer :: iret, iret1, iret2, iret3, ich, ncharg,   jlchci
    integer, pointer :: infc(:) => null()
    character(len=24), pointer :: lcha(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
!
    infch2=infcha
    if (infch2 .eq. ' ') goto 9999
!
    call jeexin(infch2//'.LCHA', iret1)
    call jeexin(infch2//'.INFC', iret2)
    call jeexin(infcha, iret3)
    if (iret1+iret2+iret3 .eq. 0) goto 9999
!
!
!     -- CAS SD_INFCHA :
    if (iret1+iret2 .gt. 0) then
        call jeexin(infch2//'.LCHA', iret)
        if (iret .eq. 0) goto 9999
!
        call jeveuo(infch2//'.LCHA', 'L', vk24=lcha)
        call jeveuo(infch2//'.INFC', 'L', vi=infc)
!
        ncharg = infc(1)
        if (ncharg .eq. 0) goto 9999
        call wkvect('&&ASCIMA.LCHCI', 'V V K24', ncharg, jlchci)
!
        nchci = 0
        do 1 ich = 1, ncharg
!
!         -- CAS DES SD_CHAR_CINE :
            if (infc(ich+1) .lt. 0) then
                nchci = nchci+1
                zk24(jlchci-1+nchci) = lcha(ich)
            endif
 1      continue
        if (nchci .eq. 0) goto 9999
        call asschc(matass, nchci, zk24(jlchci), nu, cumul)
!
!
!     -- CAS LISTE DE CHARGES CINEMATIQUES :
    else
        call jeveuo(infcha, 'L', jlchci)
        call jelira(infcha, 'LONMAX', nchci)
        call asschc(matass, nchci, zk24(jlchci), nu, cumul)
    endif
!
!
!
!
!
9999  continue
    call jedetr('&&ASCIMA.LCHCI')
    call jedema()
end subroutine
