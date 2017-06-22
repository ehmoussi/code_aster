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

subroutine rc36ca(carael, noma, nbma, listma, chcara)
    implicit   none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/carces.h"
#include "asterfort/cesexi.h"
#include "asterfort/cesred.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rc36zz.h"
    integer :: nbma, listma(*)
    character(len=8) :: carael, noma
    character(len=24) :: chcara
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3600
!
!     TRAITEMENT DU CARA_ELEM
!     ON A BESOIN DES INERTIES (CARGENPO): IY1, IZ1, IY2, IZ2
!                 DU DIAMETRE EXTERIEUR (CARGEOPO) : R1, R2
!                 DE L'EPAISSEUR (CARGEOPO) : EP1, EP2
!
! IN  : CARAEL : CARA_ELEM UTILISATEUR
! IN  : NOMA   : MAILLAGE
! IN  : NBMA   : NOMBRE DE MAILLES D'ANALYSE
! IN  : LISTMA : LISTE DES MAILLES D'ANALYSE
! OUT : CHCARA : CHAM_ELEM DE TYPE ELNO DE CARACTERISTIQUES ELEMENTAIRES
!     ------------------------------------------------------------------
!
    integer :: nbcmp, iret, im, ima, nbpt, decal, ipt, icmp, iad, iadc, ncmp
    integer :: jcesd,  jcesl, jcesdc, jcesvc, jceslc
    integer :: jcesd1, jcesv1, jcesl1, jcesd2, jcesv2, jcesl2
    real(kind=8) :: vc
    character(len=8) :: nomgd
    character(len=16) :: nocmp(4)
    character(len=19) :: k19b, ces1, ces2
    real(kind=8), pointer :: cesv(:) => null()
! DEB ------------------------------------------------------------------
    call jemarq()
!
    nomgd = 'RCCM_R'
    nbcmp = 4
    nocmp(1) = 'IY'
    nocmp(2) = 'IZ'
    nocmp(3) = 'D'
    nocmp(4) = 'EP'
!
    call rc36zz(noma, nomgd, nbcmp, nocmp, nbma,&
                listma, chcara)
!
    call jeveuo(chcara(1:19)//'.CESD', 'E', jcesd)
    call jeveuo(chcara(1:19)//'.CESV', 'E', vr=cesv)
    call jeveuo(chcara(1:19)//'.CESL', 'E', jcesl)
!
    k19b = carael//'.CARGENPO'
    ces1 = '&&RC36CA.CARGENPO'
    call carces(k19b, 'ELNO', ' ', 'V', ces1,&
                'A', iret)
!
    nbcmp = 4
    nocmp(1) = 'IY1'
    nocmp(2) = 'IZ1'
    nocmp(3) = 'IY2'
    nocmp(4) = 'IZ2'
    call cesred(ces1,nbma,listma,nbcmp,nocmp,&
                'V', ces1)
!
    call jeveuo(ces1//'.CESD', 'L', jcesd1)
    call jeveuo(ces1//'.CESV', 'L', jcesv1)
    call jeveuo(ces1//'.CESL', 'L', jcesl1)
!
    k19b = carael//'.CARGEOPO'
    ces2 = '&&RC36CA.CARGEOPO'
    call carces(k19b, 'ELNO', ' ', 'V', ces2,&
                'A', iret)
!
    nbcmp = 4
    nocmp(1) = 'R1'
    nocmp(2) = 'EP1'
    nocmp(3) = 'R2'
    nocmp(4) = 'EP2'
    call cesred(ces2,nbma,listma,nbcmp,nocmp,&
                'V', ces2)
!
    call jeveuo(ces2//'.CESD', 'L', jcesd2)
    call jeveuo(ces2//'.CESV', 'L', jcesv2)
    call jeveuo(ces2//'.CESL', 'L', jcesl2)
!
    do 100 im = 1, nbma
        ima = listma(im)
        nbpt = zi(jcesd-1+5+4*(ima-1)+1)
        ncmp = zi(jcesd-1+5+4*(ima-1)+3)
        ASSERT(ncmp.eq.4 .and. nbpt.eq.2)
        do 110 ipt = 1, nbpt
            do 120 icmp = 1, ncmp
!            POINT 1 : CMPS 1 ET 2 - POINT 2 : CMPS 3 ET 4
                if (icmp .le. 2) then
                    if (ipt .eq. 1) then
                        decal = 0
                    else
                        decal = 2
                    endif
                else
                    if (ipt .eq. 1) then
                        decal = -2
                    else
                        decal = 0
                    endif
                endif
!            CMPS IY/IZ DANS CHAMP 1 - CMPS D/EP DANS CHAMP 2
                if (icmp .le. 2) then
                    jcesdc = jcesd1
                    jcesvc = jcesv1
                    jceslc = jcesl1
                else
                    jcesdc = jcesd2
                    jcesvc = jcesv2
                    jceslc = jcesl2
                endif
                call cesexi('S', jcesdc, jceslc, ima, ipt,&
                            1, icmp+decal, iadc)
                ASSERT(iadc.gt.0)
                vc = zr(jcesvc-1+iadc)
!            PASSAGE R A D : X2 (CMP 3)
                if (icmp .eq. 3) then
                    vc = 2.d0 * vc
                endif
                call cesexi('S', jcesd, jcesl, ima, ipt,&
                            1, icmp, iad)
                if (iad .lt. 0) then
                    iad = -iad
                endif
                cesv(iad) = vc
                zl(jcesl-1+iad) = .true.
120          continue
110      continue
100  end do
!
    call detrsd('CHAM_ELEM_S', ces1)
    call detrsd('CHAM_ELEM_S', ces2)
!
    call jedema()
end subroutine
