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

subroutine gchfus(fonct1, fonct2, fonct3)
    implicit none
#include "jeveux.h"
#include "asterfort/copisd.h"
#include "asterfort/fointe.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: fonct1, fonct2, fonct3
!
!     BUT : DETERMINE UNE FONCTION A PARTIR DE 2 FONCTIONS.
!           LES VALEURS DE LA FONCTION OUT CORRESPONDENT
!           A LA SOMMES DES VALEURS DES FONCTIONS IN
!
!     IN :  FONCT1
!
! ======================================================================
! ----------------------------------------------------------------------
    integer :: nptf1, nptf2, jprol,  iret, jval, nptf, i
    real(kind=8) :: y
    character(len=19) :: fo1, fo2, fo3, fotmp1, fotmp2
    real(kind=8), pointer :: vale(:) => null()
!
    call jemarq()
!
    fo1=fonct1
    fo2=fonct2
    fo3=fonct3
!
    call jelira(fo1//'.VALE', 'LONMAX', nptf1)
    call jelira(fo2//'.VALE', 'LONMAX', nptf2)
!
    nptf1=nptf1/2
    nptf2=nptf2/2
!
    if (nptf1 .ge. nptf2) then
        call copisd('FONCTION', 'V', fo1, fo3)
        fotmp1=fo2
        fotmp2=fo1
        nptf=nptf1
    else
        call copisd('FONCTION', 'V', fo2, fo3)
        fotmp1=fo1
        fotmp2=fo2
        nptf=nptf2
    endif
!
    call jeveuo(fotmp1//'.PROL', 'L', jprol)
    call jeveuo(fotmp2//'.VALE', 'L', jval)
    call jeveuo(fo3//'.VALE', 'E', vr=vale)
!
    do 10 i = 1, nptf
        call fointe('A', fotmp1, 1, zk24(jprol+3-1), zr(jval+i-1),&
                    y, iret)
        vale(1+nptf+i-1)=zr(jval+nptf+i-1)+y
10  end do
!
    call jedema()
!
end subroutine
