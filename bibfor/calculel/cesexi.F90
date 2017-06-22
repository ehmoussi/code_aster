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

subroutine cesexi(stop, jcesd, jcesl, ima, ipt,&
                  ispt, icmp, iad)
! person_in_charge: jacques.pellet at edf.fr
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/utmess.h"
    character(len=1) :: stop
    integer :: jcesd, jcesl, ima, ipt, ispt, icmp, iad
! ------------------------------------------------------------------
! BUT : OBTENIR L'ADRESSE D'UNE CMP D'UN CHAM_ELEM_S
! ------------------------------------------------------------------
!     ARGUMENTS:
! STOP    IN  K1: COMPORTEMENT EN CAS D'ERREUR (CMP NON STOCKABLE) :
!                 'S' : ON S'ARRETE EN ERREUR FATALE
!                 'C' : ON CONTINUE ET ON REND IAD =0
! JCESD   IN  I : ADRESSE DE L'OBJET CHAM_ELEM_S.CESD
! JCESL   IN  I : ADRESSE DE L'OBJET CHAM_ELEM_S.CESL
! IMA     IN  I : NUMERO DE LA MAILLE
! IPT     IN  I : NUMERO DU POINT
! ISPT    IN  I : NUMERO DU SOUS-POINT
! ICMP    IN  I : NUMERO DE LA CMP
! IAD     OUT I : POSITION DE LA CMP DANS LES OBJETS .CESV ET .CESL
!
!  IAD=0  => LES ARGUMENTS IMA,IPT,ISPT OU ICMP SONT HORS BORNES
!  IAD<0  => LA POSITION DE LA CMP EST -IAD (MAIS LA CMP N'EST PAS
!             AFFECTEE POUR L'INSTANT (I.E. ZL(JCESL-1-IAD)=.FALSE.)
!  IAD>0  => LA POSITION DE LA CMP EST +IAD (LA CMP EST DEJA
!             AFFECTEE (I.E. ZL(JCESL-1+IAD)=.TRUE.)
    character(len=24) :: valk(4)
!     ------------------------------------------------------------------
    integer :: nbma, npt, nspt, ncmp, decal, iad1
    character(len=8) :: k8mail, k8pt, k8spt, k8cmp
!     ------------------------------------------------------------------
!
!
    nbma = zi(jcesd-1+1)
    if ((ima.le.0) .or. (ima.gt.nbma)) goto 10
!
    npt = zi(jcesd-1+5+4* (ima-1)+1)
    nspt = zi(jcesd-1+5+4* (ima-1)+2)
    ncmp = zi(jcesd-1+5+4* (ima-1)+3)
    decal = zi(jcesd-1+5+4* (ima-1)+4)
!
    if ((ipt.le.0) .or. (ipt.gt.npt)) goto 10
    if ((ispt.le.0) .or. (ispt.gt.nspt)) goto 10
    if ((icmp.le.0) .or. (icmp.gt.ncmp)) goto 10
!
!
    iad1 = decal + (ipt-1)*nspt*ncmp + (ispt-1)*ncmp + icmp
!
    if (zl(jcesl-1+iad1)) then
        iad = iad1
    else
        iad = -iad1
    endif
    goto 60
!
10  continue
!
    if (stop .eq. 'C') then
        iad = 0
!
    else if (stop.eq.'S') then
!
        call codent(ima, 'D', k8mail)
        call codent(ipt, 'D', k8pt)
        call codent(ispt, 'D', k8spt)
        call codent(icmp, 'D', k8cmp)
!
        if ((ima.le.0) .or. (ima.gt.nbma)) goto 20
        if ((ipt.le.0) .or. (ipt.gt.npt)) goto 30
        if ((ispt.le.0) .or. (ispt.gt.nspt)) goto 40
        if ((icmp.le.0) .or. (icmp.gt.ncmp)) goto 50
!
!
20      continue
        call utmess('F', 'CALCULEL_68', sk=k8mail)
!
30      continue
        valk(1) = k8pt
        valk(2) = k8mail
        call utmess('F', 'CALCULEL_69', nk=2, valk=valk)
!
40      continue
        valk(1) = k8spt
        valk(2) = k8mail
        valk(3) = k8pt
        call utmess('F', 'CALCULEL_70', nk=3, valk=valk)
!
50      continue
        valk(1) = k8cmp
        valk(2) = k8mail
        valk(3) = k8pt
        valk(4) = k8spt
        call utmess('F', 'CALCULEL_71', nk=4, valk=valk)
!
!
    else
        ASSERT(.false.)
    endif
!
60  continue
end subroutine
