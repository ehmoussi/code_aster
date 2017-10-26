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

subroutine rc32ma()
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jemarq.h"
#include "asterfort/getvid.h"
#include "asterfort/rccome.h"
#include "asterfort/utmess.h"
#include "asterc/getfac.h"
#include "asterfort/wkvect.h"
#include "asterfort/getvr8.h"
#include "asterfort/rcvale.h"
#include "asterfort/jedema.h"
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE B3200 et ZE200
!     TRAITEMENT DU CHAM_MATER
!     PAS DE MATERIAU FONCTION DU TEMPS
!          DE  E, NU, ALPHA    SOUS ELAS
!          DE  E_REFE          SOUS FATIGUE
!          DE  M_KE, N_KE, SM  SOUS RCCM
!     ------------------------------------------------------------------
!
    character(len=8) :: mater, nocmp(7), nopa
    integer :: n1, icodre(7), jvala, nbpa, i
    real(kind=8) :: tempa, para(7)
!
! DEB ------------------------------------------------------------------
    call jemarq()
!
! --- le matériau contient-il tous les comportements nécessaires ?
    call getvid(' ', 'MATER', scal=mater, nbret=n1)
!
    call rccome(mater, 'ELAS', icodre(1))
    if (icodre(1) .eq. 1) then
        call utmess('F', 'POSTRCCM_7', sk='ELAS')
    endif
!
    call rccome(mater, 'FATIGUE', icodre(1))
    if (icodre(1) .eq. 1) then
        call utmess('F', 'POSTRCCM_7', sk='FATIGUE')
    endif
!
    call rccome(mater, 'RCCM', icodre(1))
    if (icodre(1) .eq. 1) then
        call utmess('F', 'POSTRCCM_7', sk='RCCM')
    endif
!
! --- ON STOCKE 7 VALEURS : E, NU, ALPHA, E_REFE, SM, M_KE, N_KE
!     POUR LES 2 ETATS STABILISES DE CHAQUE SITUATION
!
    nocmp(1) = 'E'
    nocmp(2) = 'NU'
    nocmp(3) = 'ALPHA'
    nocmp(4) = 'E_REFE'
    nocmp(5) = 'SM'
    nocmp(6) = 'M_KE'
    nocmp(7) = 'N_KE'
!
    call wkvect('&&RC3200.MATERIAU', 'V V R8', 7, jvala)
!
    nbpa = 0
    nopa = ' '
    tempa = 0.d0
!
    call rcvale(mater, 'ELAS', nbpa, nopa, [tempa],&
                3, nocmp(1), para(1), icodre, 2)
!
    call rcvale(mater, 'FATIGUE', nbpa, nopa, [tempa],&
                1, nocmp(4), para(4), icodre, 2)
!
    call rcvale(mater, 'RCCM', nbpa, nopa, [tempa],&
                3, nocmp(5), para(5), icodre, 2)
!
    do 12 i = 1, 7
        zr(jvala-1+i) = para(i)
12  continue
!
    call jedema()
end subroutine
