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

subroutine rc32r8(nomres, mater, lfat)
    implicit none
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rcmcrt.h"
#include "asterfort/rcvale.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajpa.h"
#include "asterfort/utmess.h"
#include "asterfort/getvr8.h"
    character(len=8) :: nomres, mater
    aster_logical :: lfat
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3200
!     STOCKAGE DES RESULTATS DANS LA TABLE DE SORTIE
!     CALCUL DU ROCHET THERMIQUE
!
!     ------------------------------------------------------------------
!
    integer :: ibid, npar1, im, jresu, n1
    parameter    ( npar1 = 8 )
    real(kind=8) :: rbid, valer(npar1), valres(1), symax
    complex(kind=8) :: c16b
    integer :: icodre(1)
    character(len=4) :: lieu(2)
    character(len=8) :: k8b, typar1(npar1), valek(2)
    character(len=16) :: nopar1(npar1)
!     ------------------------------------------------------------------
    data lieu   / 'ORIG' , 'EXTR' /
!
    data nopar1 / 'TYPE', 'LIEU', 'SY', 'SIGM_M_PRES','SN_THER_MAX',&
     &              'VALE_MAXI_LINE', 'SP_THER_MAX', 'VALE_MAXI_PARAB' /
    data typar1 / 'K8', 'K8', 'R', 'R', 'R', 'R', 'R', 'R' /
! DEB ------------------------------------------------------------------
!
    symax = r8vide()
    call getvr8(' ', 'SY_MAX', scal=symax, nbret=n1)
!
    rbid = 0.d0
    ibid=0
    c16b=(0.d0,0.d0)
    call tbajpa(nomres, npar1-2, nopar1(3), typar1(3))
!
    if (symax .eq. r8vide()) then
        call rcvale(mater, 'RCCM', 0, k8b, [rbid],&
                    1, 'SY_02   ', valres(1), icodre(1), 0)
        if (icodre(1) .eq. 0) then
            symax = valres(1)
        else
            call utmess('A', 'POSTRCCM_4')
            goto 999
        endif
    endif
!
    valer(1) = symax
    valek(1) = 'ROCHET'
!
    do 10 im = 1, 2
!
        valek(2) = lieu(im)
!
        call jeveuo('&&RC3200.RESU.'//lieu(im), 'L', jresu)
!
        valer(2) = zr(jresu+9)
        if (lfat) then
            valer(5) = zr(jresu+10)
        else
            valer(5) = r8vide()
        endif
        valer(3) = zr(jresu+11)
!
        call rcmcrt(symax, valer(2), valer(4), valer(6))
!
        if (.not. lfat) valer(6) = r8vide()
!
        call tbajli(nomres, npar1, nopar1, [ibid], valer,&
                    [c16b], valek, 0)
!
10  continue
!
999  continue
!
end subroutine
