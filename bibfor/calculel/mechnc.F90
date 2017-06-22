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

subroutine mechnc(noma, motcle, iocc, chnumc)
    implicit none
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/mecact.h"
    integer :: iocc
    character(len=*) :: noma, motcle
    character(len=24) :: chnumc
!     CREE UNE CARTE POUR LES COQUES
!     ------------------------------------------------------------------
! IN  : NOMA   : NOM DU MAILLAGE
! IN  : MOTCLE : MOTCLE FACTEUR
! IN  : IOCC   : NUMERO D'OCCURENCE
! OUT : CHNUMC : NOM DE LA CARTE CREEE
!     ------------------------------------------------------------------
    integer :: ival(3), ncou, nangl
    character(len=3) :: ordo
    character(len=8) :: licmp(3)
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: n1, n2, n3, nx3
!-----------------------------------------------------------------------
    call getvis(motcle, 'NUME_COUCHE', iocc=iocc, scal=ncou, nbret=n1)
    call getvtx(motcle, 'NIVE_COUCHE', iocc=iocc, scal=ordo, nbret=n2)
    call getvis(motcle, 'ANGLE', iocc=iocc, scal=nangl, nbret=n3)
    chnumc = ' '
    if (n2 .ne. 0) then
        if (ordo .eq. 'SUP') then
            nx3 = 1
        else if (ordo.eq.'MOY') then
            nx3 = 0
        else if (ordo.eq.'INF') then
            nx3 = -1
        endif
        chnumc = '&&MECHNC.NUMC'
        licmp(1) = 'NUMC'
        licmp(2) = 'ORDO'
        licmp(3) = 'ANGL'
        ival(1) = ncou
        ival(2) = nx3
        ival(3) = nangl
        call mecact('V', chnumc, 'MAILLA', noma, 'NUMC_I',&
                    ncmp=3, lnomcmp=licmp, vi=ival)
    endif
!
end subroutine
