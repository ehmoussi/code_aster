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

subroutine trprec(mcf, iocc, epsi, crit, prec,&
                  crit2)
    implicit none
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/tresu_tole.h"
    character(len=*) :: mcf
!     Commande:  TEST_RESU
!
!     Remarques:  MCF=_F( ...
!                         TOLE_MACHINE=(epsi, prec)
!                         CRITERE=(crit, crit2)
!     epsi et crit  sont la tolérance et le critère du test
!     prec et crit2 sont la précision et le critère de l'extraction
! ----------------------------------------------------------------------
    integer :: iocc, nc
    real(kind=8) :: epsi, prec
    character(len=8) :: crit, crit2, critr(2)
!     ------------------------------------------------------------------
!
    call tresu_tole(epsi, prec, mcf, iocc)
!
    call getvtx(mcf, 'CRITERE', iocc=iocc, nbval=0, nbret=nc)
    nc = -nc
    if (nc .eq. 0) then
        crit = 'RELATIF'
        crit2 = 'RELATIF'
    else if (nc.eq.1) then
        call getvtx(mcf, 'CRITERE', iocc=iocc, scal=crit, nbret=nc)
        crit2 = crit
    else
        call getvtx(mcf, 'CRITERE', iocc=iocc, nbval=2, vect=critr,&
                    nbret=nc)
        crit = critr(1)
        crit2 = critr(2)
    endif
!
end subroutine
