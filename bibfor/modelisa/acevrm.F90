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

subroutine acevrm(nbocc, noma, noemax, noemaf)
    implicit none
#include "jeveux.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
!
    integer :: nbocc, noemax
    character(len=8) :: noma
! ----------------------------------------------------------------------
!     AFFE_CARA_ELEM
!     VERIFICATION DES DIMENSIONS POUR LES RAIDEURS REPARTIES
! ----------------------------------------------------------------------
! IN  : NBOCC  : NOMBRE D'OCCURENCE
! IN  : NOMA   : NOM DU MAILLAGE
! OUT : NOEMAX : NOMBRE TOTAL DE NOEUDS MAX
! ----------------------------------------------------------------------
    character(len=24) :: magrma
    character(len=24) :: nogp, nogl
!-----------------------------------------------------------------------
    integer :: in, ioc, ldgm, ngl, ngp, nma, noemaf
!
!-----------------------------------------------------------------------
    call jemarq()
    magrma = noma//'.GROUPEMA'
    noemax = 0
    noemaf = 0
! --- BOUCLE SUR LES OCCURENCES DE DISCRET
    do 10 ioc = 1, nbocc
        call getvtx('RIGI_MISS_3D', 'GROUP_MA_POI1', iocc=ioc, scal=nogp, nbret=ngp)
        call getvtx('RIGI_MISS_3D', 'GROUP_MA_SEG2', iocc=ioc, scal=nogl, nbret=ngl)
!
        if (ngp .ne. 0) then
            call jelira(jexnom(magrma, nogp), 'LONUTI', nma)
            call jeveuo(jexnom(magrma, nogp), 'L', ldgm)
            do 11 in = 0, nma-1
                noemaf = max(noemaf,zi(ldgm+in))
11          continue
            noemax = noemax + nma
        endif
        if (ngl .ne. 0) then
            call jelira(jexnom(magrma, nogl), 'LONUTI', nma)
            call jeveuo(jexnom(magrma, nogl), 'L', ldgm)
            do 12 in = 0, nma-1
                noemaf = max(noemaf,zi(ldgm+in))
12          continue
            noemax = noemax + nma
        endif
10  end do
!
    call jedema()
end subroutine
