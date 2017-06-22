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

function nmrcyc(sddisc, iterat, prec)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmlere.h"
#include "asterfort/wkvect.h"
    aster_logical :: nmrcyc
    integer :: iterat
    real(kind=8) :: prec
    character(len=19) :: sddisc
!
! ----------------------------------------------------------------------
!       REPERAGE DE CYCLES DANS UNE SEQUENCE DE RESIDUS
! ----------------------------------------------------------------------
! IN  SDDISC SD DISCRETISATION
! IN  ITERAT ITERATION COURANTE (DONT LE RESIDU N'EST PAS CALCULE)
! IN  PREC   TOLERANCE POUR LA RECHERCHE DES CYCLES (QQ POURCENTS)
!
!
!
!
    integer :: itemax, maxseq, lenseq, finseq, offset, jres
    real(kind=8) :: res1, res2
    character(len=24) :: residu
! ----------------------------------------------------------------------
    data residu /'&&NMRCYC.RESIDU'/
! ----------------------------------------------------------------------
!
!    INITIALISATION
    call jemarq()
    nmrcyc = .false.
    itemax = iterat-1
    maxseq = (itemax+1)/2
    if (maxseq .le. 1) goto 9999
!
!    LECTURE DES RESIDUS DE L'ITERATION 0 A ITERAT
    call wkvect(residu, 'V V R', itemax, jres)
    call nmlere(sddisc, 'L', 'VMAXI_TOUS', itemax, zr(jres))
!
!    RECHERCHE DE CYCLES DE LONGUEUR LENSEQ
    do 10 lenseq = 2, maxseq
        do 20 finseq = lenseq, itemax-lenseq
            do 30 offset = 0, lenseq-1
                res1 = zr(jres+itemax-offset)
                res2 = zr(jres+finseq-offset)
                if (abs(res1-res2)/max(res1,res2) .gt. prec) goto 1000
 30         continue
            nmrcyc = .true.
            goto 2000
1000         continue
 20     continue
 10 end do
2000 continue
!
    call jedetr(residu)
9999 continue
    call jedema()
end function
