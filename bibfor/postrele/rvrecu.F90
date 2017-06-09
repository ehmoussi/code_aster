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

subroutine rvrecu(mcf, iocc, champ, nomvec)
    implicit none
#include "jeveux.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: iocc
    character(len=*) :: mcf, champ, nomvec
! IN  IOCC   : INDICE DE L' OCCURENCE
! IN  CHAMP  : NOM DU CHAMP A TRAITER
!     ------------------------------------------------------------------
!
    character(len=1) :: type
    character(len=8) :: form
    character(len=19) :: nch19
    character(len=24) :: vecteu
!
    real(kind=8) :: a, b
    integer :: i,  kval, n1, neq
    complex(kind=8), pointer :: vale(:) => null()
!
!==================== CORPS DE LA ROUTINE =============================
!
    call jemarq()
    nch19 = champ
    vecteu = nomvec
    call jelira(nch19//'.VALE', 'TYPE', cval=type)
    if (type .ne. 'C') then
        call utmess('F', 'POSTRELE_11')
    endif
    call jelira(nch19//'.VALE', 'LONMAX', neq)
    call jeveuo(nch19//'.VALE', 'L', vc=vale)
    call wkvect(vecteu, 'V V R', neq, kval)
!
    call getvtx(mcf, 'FORMAT_C', iocc=iocc, scal=form, nbret=n1)
!
    if (form .eq. 'MODULE') then
        do 11 i = 0, neq-1
            a = dble( vale(1+i) )
            b = dimag( vale(1+i) )
            zr(kval+i) = sqrt( a*a + b*b )
11      continue
!
    else if (form .eq. 'REEL') then
        do 20 i = 0, neq-1
            zr(kval+i) = dble( vale(1+i) )
20      continue
!
    else if (form .eq. 'IMAG') then
        do 30 i = 0, neq-1
            zr(kval+i) = dimag( vale(1+i) )
30      continue
!
    else
        call utmess('F', 'POSTRELE_52', sk=form)
    endif
!
    call jedema()
end subroutine
