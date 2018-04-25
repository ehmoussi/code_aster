! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine pmfd02(noma, cesdec)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/alcart.h"
#include "asterfort/carces.h"
#include "asterfort/cescre.h"
#include "asterfort/detrsd.h"
#include "asterfort/getvis.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
! --------------------------------------------------------------------------------------------------
!
!                       AFFE_CARA_ELEM
!
!       CONSTRUCTION DU CHAM_ELEM_S DE NBSP_I (CESDEC)
!          IMA ->  COQ_NCOU   TUY_NCOU   TUY_NSEC
!
!     TRAITEMENT DES MOTS CLES :
!           COQUE  / COQUE_NCOU
!           GRILLE / COQUE_NCOU
!           POUTRE / TUYAU_NCOU
!           POUTRE / TUYAU_NSEC
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: noma
    character(len=19) :: cesdec
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbocc, iocc, iret, nbma, nbcou, nbv, nbsec
    integer :: nbap, k, i,   jma
!
    character(len=16) :: mocles(2), typmcl(2), moclef(3)
    character(len=19) :: carte
    character(len=24) :: mesmai
!
    integer, pointer          :: valv(:) => null()
    character(len=8), pointer :: ncmp(:) => null()
!
    data mocles/'MAILLE','GROUP_MA'/
    data typmcl/'MAILLE','GROUP_MA'/
    data moclef/'COQUE','POUTRE','GRILLE'/
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
    mesmai = '&&PMFD02.MES_MAILLES'
    nbap = 0
    do i = 1, 3
        call getfac(moclef(i), nbocc)
        nbap = nbap + nbocc
        do k = 1, nbocc
            call reliem(' ', noma, 'NU_MAILLE', moclef(i), k,&
                        2, mocles, typmcl, mesmai, nbma)
            if (nbma .ne. 0) call jedetr(mesmai)
        enddo
    enddo
!
    if (nbap .eq. 0) then
        call cescre('V', cesdec, 'ELEM', noma, 'NBSP_I',&
                    1, 'COQ_NCOU', [-1], [-1], [-1])
        goto 999
    endif
!
    carte='&&PMFD02.NBSP_I'
    call alcart('V', carte, noma, 'NBSP_I')
    call jeveuo(carte//'.NCMP', 'E', vk8=ncmp)
    call jeveuo(carte//'.VALV', 'E', vi=valv)
!
!   MOT CLE "COQUE" :
    call getfac('COQUE', nbocc)
    do iocc = 1, nbocc
        call reliem(' ', noma, 'NU_MAILLE', 'COQUE', iocc,&
                    2, mocles, typmcl, mesmai, nbma)
        call getvis('COQUE', 'COQUE_NCOU', iocc=iocc, scal=nbcou, nbret=nbv)
        ncmp(1) = 'COQ_NCOU'
        valv(1) = nbcou
        call jeveuo(mesmai, 'L', jma)
        call nocart(carte, 3, 1, mode='NUM', nma=nbma, limanu=zi(jma))
        call jedetr(mesmai)
    enddo
!
!   MOT CLE "POUTRE" :
    call getfac('POUTRE', nbocc)
    do iocc = 1, nbocc
        call reliem(' ', noma, 'NU_MAILLE', 'POUTRE', iocc,&
                    2, mocles, typmcl, mesmai, nbma)
        call getvis('POUTRE', 'TUYAU_NCOU', iocc=iocc, scal=nbcou, nbret=nbv)
        call getvis('POUTRE', 'TUYAU_NSEC', iocc=iocc, scal=nbsec, nbret=nbv)
        ncmp(1) = 'TUY_NCOU'
        ncmp(2) = 'TUY_NSEC'
        valv(1) = nbcou
        valv(2) = nbsec
        call jeveuo(mesmai, 'L', jma)
        call nocart(carte, 3, 2, mode='NUM', nma=nbma, limanu=zi(jma))
        call jedetr(mesmai)
    enddo
!
!   MOT CLE "GRILLE" :
    call getfac('GRILLE', nbocc)
    do iocc = 1, nbocc
        call reliem(' ', noma, 'NU_MAILLE', 'GRILLE', iocc,&
                    2, mocles, typmcl, mesmai, nbma)
        ncmp(1) = 'COQ_NCOU'
        valv(1) = 1
        call jeveuo(mesmai, 'L', jma)
        call nocart(carte, 3, 1, mode='NUM', nma=nbma, limanu=zi(jma))
        call jedetr(mesmai)
    enddo
!
!   TRANSFORME LA CARTE EN CHAM_ELEM_S
    call carces(carte, 'ELEM', ' ', 'V', cesdec, 'A', iret)
    call detrsd('CARTE', carte)
!
999 continue
    call jedema()
end subroutine
