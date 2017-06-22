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

subroutine pjeftc(ma1, ma2, resuou, base)
! person_in_charge: nicolas.greffet at edf.fr
! ======================================================================
!     COMMANDE:  PROJ_CHAMP  METHODE:'COUPLAGE' (COUPLAGE IFS VIA YACS)
! ----------------------------------------------------------------------
!
    implicit none
!
! 0.1. ==> ARGUMENTS
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/pjecou.h"
#include "asterfort/pjfuc2.h"
#include "asterfort/utmess.h"
    character(len=8) :: ma1, ma2
    character(len=16) :: resuou
    character(len=1) :: base
!
! 0.2. ==> COMMUNS
!
!
!
! 0.3. ==> VARIABLES LOCALES
    integer :: nbval, nbocc, iocc, nbgno2, vali(2)
    character(len=16) :: nomgma, nomgno
    character(len=16) :: corre1, corre2, corre3
!
! DEB ------------------------------------------------------------------
    call jemarq()
    ASSERT(base.eq.'V')
    corre1 = '&&PJEFTC.CORRES1'
    corre2 = '&&PJEFTC.CORRES2'
    corre3 = '&&PJEFTC.CORRES3'
!
!
!     NOMBRE D'OCCURENCE (ou NOMBRE DE GROUP_MAILLE DEFINIS)
!     ------------------------------------------------------
    call getfac('VIS_A_VIS', nbocc)
!
!     COHERENCE ENTRE GROUP_MAILLE ET GOURP_NOEUDS
!     --------------------------------------------
    call jelira(ma2//'.GROUPENO', 'NMAXOC', nbgno2)
    if (nbgno2 .ne. nbocc) then
        vali(1) = nbgno2
        vali(2) = nbocc
        call utmess('F', 'COUPLAGEIFS_8', ni=2, vali=vali)
    endif
!
!     PROJECTION ENTRE GROUP_MAILLE ET GROUP_NOEUDS
!     ---------------------------------------------
    if (nbocc .gt. 0) then
!
        do 10 iocc = 1, nbocc
!
!         -- NOMS DES GROUPES DE MAILLES ET DE NOEUDS COUPLES :
!         -----------------------------------------------------------
            call getvtx('VIS_A_VIS', 'GROUP_MA_1', iocc=iocc, scal=nomgma, nbret=nbval)
            call getvtx('VIS_A_VIS', 'GROUP_NO_2', iocc=iocc, scal=nomgno, nbret=nbval)
!
!         -- CALCUL DU CORRESP_2_MAILLA POUR IOCC :
!         ----------------------------------------------
            call pjecou(ma1, ma2, nomgma, nomgno, corre1)
!
!        -- SURCHARGE DU CORRESP_2_MAILLA :
!        ----------------------------------------------
            if (iocc .eq. 1) then
                call copisd('CORRESP_2_MAILLA', 'V', corre1, corre2)
            else
                call pjfuc2(corre2, corre1, 'V', corre3)
                call detrsd('CORRESP_2_MAILLA', corre2)
                call copisd('CORRESP_2_MAILLA', 'V', corre3, corre2)
                call detrsd('CORRESP_2_MAILLA', corre3)
            endif
            call detrsd('CORRESP_2_MAILLA', corre1)
10      continue
        call copisd('CORRESP_2_MAILLA', 'G', corre2, resuou)
        call detrsd('CORRESP_2_MAILLA', corre2)
    else
        call utmess('F', 'COUPLAGEIFS_2')
    endif
!
    call jedema()
end subroutine
