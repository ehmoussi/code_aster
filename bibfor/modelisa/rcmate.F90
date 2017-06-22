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

subroutine rcmate(chmat, nomail, nomode)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/nocart.h"
#include "asterfort/reliem.h"
    character(len=8) :: chmat, nomail, nomode
!
!  IN : CHMAT  : CHAMP MATERIAU PRODUIT
!  IN : NOMAIL : NOM DU MAILLAGE
! ----------------------------------------------------------------------
!
    integer :: nocc, i, nm, nt,  jvalv, nbma, jmail, nbcmp
    integer :: jad
    character(len=4) :: oui
    character(len=8) :: nommat, typmcl(2)
    character(len=16) :: motcle(2)
    character(len=24) :: chamat, mesmai
    character(len=8), pointer :: ncmp(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
    chamat = chmat//'.CHAMP_MAT'
!
    call alcart('G', chamat, nomail, 'NOMMATER')
    call jeveuo(chamat(1:19)//'.NCMP', 'E', vk8=ncmp)
    call jeveuo(chamat(1:19)//'.VALV', 'E', jvalv)
!
    call dismoi('NB_CMP_MAX', 'NOMMATER', 'GRANDEUR', repi=nbcmp)
    ASSERT(nbcmp.eq.30)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', 'NOMMATER'), 'L', jad)
    do i = 1, nbcmp
        ncmp(i) = zk8(jad-1+i)
    end do
!
    call getfac('AFFE', nocc)
!
    motcle(1) = 'GROUP_MA'
    motcle(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
    mesmai = '&&RCMATE.MES_MAILLES'
!
    do i = 1, nocc
        call getvid('AFFE', 'MATER', iocc=i, scal=nommat, nbret=nm)
        if (nm .lt. -1) nm = -nm
        ASSERT(nm.le.nbcmp)
        call getvid('AFFE', 'MATER', iocc=i, nbval=nm, vect=zk8(jvalv))
        call getvtx('AFFE', 'TOUT', iocc=i, scal=oui, nbret=nt)
        if (nt .ne. 0) then
            call nocart(chamat, 1, nm)
        else
            call reliem(nomode, nomail, 'NU_MAILLE', 'AFFE', i,&
                        2, motcle(1), typmcl(1), mesmai, nbma)
            if (nbma .ne. 0) then
                call jeveuo(mesmai, 'L', jmail)
                call nocart(chamat, 3, nm, mode='NUM', nma=nbma,&
                            limanu=zi(jmail))
                call jedetr(mesmai)
            endif
        endif
    end do
!
    call jedetr(chamat(1:19)//'.VALV')
    call jedetr(chamat(1:19)//'.NCMP')
!
    call jedema()
end subroutine
