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

subroutine acemmt(noma, nmmt)
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/reliem.h"
    character(len=8) :: noma
    integer :: nmmt(*)
!     AFFE_CARA_ELEM
!     LECTURE DE MODI_METRIQUE POUR LES TUYAUX
!     REMPLISSAGE DU TABLEAU NMMT CONTENANT POUR CHAQUE MAILLE
!        0 : SI MODI_METRIQUE : NON
!        1 : SI MODI_METRIQUE : OUI
! ----------------------------------------------------------------------
    integer :: nbocpo, iocc, ibid, immt, nbma, jma, i, ima
    character(len=8) :: mmt, typmcl(2)
    character(len=16) :: motfac, motcls(2)
    character(len=24) :: mesmai
!     ------------------------------------------------------------------
    call jemarq()
!
    motfac = 'POUTRE'
    call getfac(motfac, nbocpo)
    if (nbocpo .eq. 0) goto 9999
!
    mesmai = '&&ACEMMT.MES_MAILLES'
    motcls(1) = 'GROUP_MA'
    motcls(2) = 'MAILLE'
    typmcl(1) = 'GROUP_MA'
    typmcl(2) = 'MAILLE'
!
    do 10 iocc = 1, nbocpo
!
        call getvtx(motfac, 'MODI_METRIQUE', iocc=iocc, scal=mmt, nbret=ibid)
        if (mmt .eq. 'NON') then
            immt = 0
        else if (mmt.eq.'OUI') then
            immt = 1
        endif
!
        call reliem(' ', noma, 'NU_MAILLE', motfac, iocc,&
                    2, motcls, typmcl, mesmai, nbma)
        if (nbma .ne. 0) then
            call jeveuo(mesmai, 'L', jma)
            do 12 i = 1, nbma
                ima = zi(jma+i-1)
                nmmt(ima) = immt
12          continue
            call jedetr(mesmai)
        endif
!
10  end do
!
9999  continue
    call jedema()
end subroutine
