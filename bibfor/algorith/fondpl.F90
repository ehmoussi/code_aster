! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine fondpl(modele, mate, mateco, numedd, neq, chondp,&
                  nchond, vecond, veonde, vaonde, temps,&
                  foonde)
    implicit none
#include "jeveux.h"
#include "asterfort/asasve.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/detrsd.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecact.h"
#include "asterfort/reajre.h"
#include "asterfort/vrcins.h"
!
    integer :: i, ibid, iret, j,  jvaond
    integer :: nchond, neq, npain
    character(len=8) :: lpain(6), lpaout(1), chondp(nchond)
    character(len=24) :: modele, mateco, numedd, vecond
    character(len=24) :: chinst
    character(len=24) :: veonde, vaonde, lchin(6), lchout(1)
    character(len=24) :: chgeom, ligrel
    real(kind=8) :: foonde(neq), temps
    character(len=8), pointer :: lgrf(:) => null()
    real(kind=8), pointer :: vale(:) => null()
    character(len=19) :: chvarc
    character(len=2) :: codret
    character(len=8) :: mate
!
!-----------------------------------------------------------------------
    call jemarq()
!
    do i = 1, neq
        foonde(i) = 0.d0
    end do
!
    chinst = '&&CHINST'
    call mecact('V', chinst, 'MODELE', modele(1:8)//'.MODELE', 'INST_R',&
                ncmp=1, nomcmp='INST', sr=temps)
    ligrel = modele(1:8)//'.MODELE'
    call jeveuo(ligrel(1:19)//'.LGRF', 'L', vk8=lgrf)
    chgeom = lgrf(1)//'.COORDO'
!
! --- CREATION CHAMP DE VARIABLES DE COMMANDE CORRESPONDANT
!
    chvarc = '&&CHME.ONDPL.CHVARC'
    call vrcins(modele, mate, ' ', temps, chvarc,&
                codret)
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom
    lpain(2) = 'PMATERC'
    lchin(2) = mateco
!
    lpain(3) = 'PVARCPR'
    lchin(3) = chvarc(1:19)
    lpain(4) = 'PTEMPSR'
    lchin(4) = chinst
!
    lpain(5) = 'PONDPLA'
    lpain(6) = 'PONDPLR'
!
    npain = 6
!
    lpaout(1) = 'PVECTUR'
    lchout(1) = vecond
!
    do i = 1, nchond
        call exisd('CARTE', chondp(i)//'.CHME.ONDPL', iret)
        call exisd('CARTE', chondp(i)//'.CHME.ONDPR', ibid)
        if (iret .ne. 0 .and. ibid .ne. 0) then
            lchin(5) = chondp(i)//'.CHME.ONDPL.DESC'
            lchin(6) = chondp(i)//'.CHME.ONDPR.DESC'
!
            call calcul('S', 'ONDE_PLAN', ligrel, npain, lchin,&
                        lpain, 1, lchout, lpaout, 'V',&
                        'OUI')
!
            call corich('E', lchout(1), -1, ibid)
            call jedetr(veonde(1:19)//'.RELR')
            call reajre(veonde, lchout(1), 'V')
            call asasve(veonde, numedd, 'R', vaonde)
!
            call jeveuo(vaonde, 'L', jvaond)
            call jeveuo(zk24(jvaond) (1:19)//'.VALE', 'L', vr=vale)
!
            do j = 1, neq
                foonde(j) = foonde(j) + vale(j)
            end do
            call detrsd('CHAMP_GD', zk24(jvaond) (1:19))
!
        endif
    end do
!
    call detrsd('CHAMP_GD', chvarc)
!
    call jedema()
end subroutine
