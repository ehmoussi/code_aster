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

subroutine rc32pmb(lieu, iocc, ns, pm, pb, pmpb)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeexin.h"
#include "asterfort/utmess.h"
#include "asterfort/codent.h"
#include "asterfort/jexnom.h"
#include "asterfort/rctres.h"
#include "asterfort/rc32s0.h"

    integer :: iocc, ns
    real(kind=8) :: pm, pb, pmpb
    character(len=4) :: lieu

!     ------------------------------------------------------------------
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE B3200 et ZE200
!              CALCUL DU PM, PB, ET DU PMPB
!
!     ------------------------------------------------------------------
    integer :: jinfoi, npres, nmeca, n1, jsigu, j, jinfor, k, jchara
    integer :: jcharb, numcha, iret
    real(kind=8) :: sigmoya(6), sigmoyb(6), ma(12), mb(12), pma, pmb
    real(kind=8) :: sigflea(6), sigfleb(6), pba, pbb, siglina(6)
    real(kind=8) :: siglinb(6), pmba, pmbb
    character(len=8) ::  knumec
!
! DEB ------------------------------------------------------------------
!
    call jeveuo('&&RC3200.SITU_INFOI', 'L', jinfoi)
    call jeveuo('&&RC3200.SITU_INFOR', 'L', jinfor)
!
!
!-- on regarde si la pression est sous forme unitaire ou transitoire
!-- on regarde si la méca est sous forme unitaire ou transitoire
    nmeca = zi(jinfoi+27*(iocc-1)+23)
    npres = zi(jinfoi+27*(iocc-1)+22)
!
    if (npres .eq. 2 .or. nmeca .eq. 2 .or. nmeca .eq. 3) then
        call utmess('F', 'POSTRCCM_50')
    endif
!
    if (npres .eq. 1 .or. nmeca .eq. 1) then
        call getfac('RESU_MECA_UNIT', n1)
        if (n1 .eq. 0) call utmess('F', 'POSTRCCM_49')
        call jeveuo('&&RC3200.MECA_UNIT .'//lieu, 'L', jsigu)
    endif
!
    do 20 j = 1, 6
        sigmoya(j) = 0.d0
        sigmoyb(j) = 0.d0
        sigflea(j) = 0.d0
        sigfleb(j) = 0.d0
        siglina(j) = 0.d0
        siglinb(j) = 0.d0
20  continue
!
    if (npres .eq. 1) then
        do 30 j = 1, 6
            sigmoya(j) = zr(jinfor+4*(iocc-1))*zr(jsigu-1+156+72+j)
            sigmoyb(j) = zr(jinfor+4*(iocc-1)+1)*zr(jsigu-1+156+72+j)
            sigflea(j) = zr(jinfor+4*(iocc-1))*zr(jsigu-1+234+72+j)
            sigfleb(j) = zr(jinfor+4*(iocc-1)+1)*zr(jsigu-1+234+72+j)
            siglina(j) = zr(jinfor+4*(iocc-1))*zr(jsigu-1+78+72+j)
            siglinb(j) = zr(jinfor+4*(iocc-1)+1)*zr(jsigu-1+78+72+j)
30      continue
    endif
    if (nmeca .eq. 1) then
!------ Chargement état A
        numcha = zi(jinfoi+27*(iocc-1)+24)
        knumec = 'C       '
        call codent(numcha, 'D0', knumec(2:8))
        call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec),iret)
        if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
        call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jchara)
!------ Chargement état B
        numcha = zi(jinfoi+27*(iocc-1)+25)
        knumec = 'C       '
        call codent(numcha, 'D0', knumec(2:8))
        call jeexin(jexnom('&&RC3200.VALE_CHAR', knumec),iret)
        if (iret .eq. 0) call utmess('F', 'POSTRCCM_51')
        call jeveuo(jexnom('&&RC3200.VALE_CHAR', knumec), 'L', jcharb)
!
        do 31 k = 1, 12
            ma(k) = zr(jchara-1+k)
            mb(k) = zr(jcharb-1+k)
31      continue
!
        do 40 j = 1, 6
            do 50 k = 1, 12
              sigmoya(j) = sigmoya(j) + ma(k)*zr(jsigu-1+156+6*(k-1)+j)
              sigmoyb(j) = sigmoyb(j) + mb(k)*zr(jsigu-1+156+6*(k-1)+j)
              sigflea(j) = sigflea(j) + ma(k)*zr(jsigu-1+234+6*(k-1)+j)
              sigfleb(j) = sigfleb(j) + mb(k)*zr(jsigu-1+234+6*(k-1)+j)
              siglina(j) = siglina(j) + ma(k)*zr(jsigu-1+78+6*(k-1)+j)
              siglinb(j) = siglinb(j) + mb(k)*zr(jsigu-1+78+6*(k-1)+j)
50          continue
40      continue
    endif
!
    if (ns .eq. 0) then
        call rctres(sigmoya, pma)
        call rctres(sigmoyb, pmb)
        call rctres(sigflea, pba)
        call rctres(sigfleb, pbb)
        call rctres(siglina, pmba)
        call rctres(siglinb, pmbb) 
    else
        call rc32s0('PMPM',sigmoya, lieu, pma)
        call rc32s0('PMPM',sigmoyb, lieu, pmb)
        call rc32s0('PBPB',sigflea, lieu, pba)
        call rc32s0('PBPB',sigfleb, lieu, pbb)
        call rc32s0('SNSN',siglina, lieu, pmba)
        call rc32s0('SNSN',siglinb, lieu, pmbb)
    endif
!
    pm = max(pma, pmb)
    pb = max(pba, pbb)
    pmpb = max(pmba, pmbb)
!
end subroutine
