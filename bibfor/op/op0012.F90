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

subroutine op0012()
    implicit none
!
!                       OPERATEUR ASSE_MATRICE
!----------------------------------------------------------------------
!     VARIABLES LOCALES
!----------------------------------------------------------------------
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/asmatr.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/sdmpic.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/matr_asse_syme.h"
!
    character(len=8) :: mpicomp
    character(len=8) :: nu, matas, syme, kmpic
    character(len=16) :: typm, oper
    character(len=24) :: lchci, lmatel
    integer :: itysca, nbchc, nbmat, jlimat, jlchci, ibid, k
    integer :: ico
!----------------------------------------------------------------------
    call jemarq()


    call infmaj()

    call getres(matas, typm, oper)
    if (typm(16:16) .eq. 'R') itysca = 1
    if (typm(16:16) .eq. 'C') itysca = 2


!   -- recuperation des matrices elementaires:
!   -------------------------------------------------
    call getvid(' ', 'MATR_ELEM', nbval=0, nbret=nbmat)
    nbmat = -nbmat
    lmatel='&&OP0012.LMATEL'
    call wkvect(lmatel, 'V V K24', nbmat, jlimat)
    call getvid(' ', 'MATR_ELEM', nbval=nbmat, vect=zk24(jlimat), nbret=ibid)


!   -- recuperation des charges cinematiques:
!   ----------------------------------------------
    lchci='&&OP0012.LCHARCINE'
    call getvid(' ', 'CHAR_CINE', nbval=0, nbret=nbchc)
    nbchc = -nbchc

    if (nbchc .gt. 0) then
        call wkvect(lchci, 'V V K24', nbchc, jlchci)
        call getvid(' ', 'CHAR_CINE', nbval=nbchc, vect=zk24(jlchci), nbret=ico)
    endif


!   -- pour ASSE_MATRICE, assmam.F90 interdit la distribution des resu_elem:
!   ------------------------------------------------------------------------
    do k = 0, nbmat-1
        call dismoi('MPI_COMPLET', zk24(jlimat+k), 'MATR_ELEM', repk = mpicomp)
        if( mpicomp .eq. 'NON' ) then
            call utmess('F', 'ASSEMBLA_2', nk = 1, valk = zk24(jlimat+k))
        endif
    enddo


!   -- assemblage proprement dit
!   ------------------------------
    call getvid(' ', 'NUME_DDL', scal=nu, nbret=ibid)
    call asmatr(nbmat, zk24(jlimat), ' ', nu, &
                    lchci, 'ZERO', 'G', itysca, matas)


!   -- si matas n'est pas MPI_COMPLET, on la complete :
!   ------------------------------------------------------
    call dismoi('MPI_COMPLET', matas, 'MATR_ASSE', repk=kmpic)
    ASSERT((kmpic.eq.'OUI').or.(kmpic.eq.'NON'))
    if (kmpic .eq. 'NON') call sdmpic('MATR_ASSE', matas)


!   -- si l'utilisateur veut symetriser la matrice :
!   ------------------------------------------------------
    syme = ' '
    call getvtx(' ', 'SYME', scal=syme, nbret=ibid)
    if (syme .eq. 'OUI') call matr_asse_syme(matas)


!   -- menage :
!   ------------
    call jedetr(lchci)
    call jedetr(lmatel)

    call jedema()
end subroutine
