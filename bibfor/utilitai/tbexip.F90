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

subroutine tbexip(nomta, para, exist, typpar)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=*) :: nomta, para, typpar
    aster_logical :: exist
!      EXISTENCE D'UN PARAMETRE DANS UNE TABLE.
! ----------------------------------------------------------------------
! IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE".
! IN  : PARA   : PARAMETRE A CHERCHER
! OUT : EXIST  : LE PARAMETRE EXISTE OU N'EXISTE PAS
! OUT : TYPPAR : TYPE DU PARAMETRE (S'IL EXISTE) : I/R/C/K8/K16,...
! ----------------------------------------------------------------------
! ----------------------------------------------------------------------
    integer :: iret, nbpara, ipar
    character(len=19) :: nomtab
    character(len=24) :: inpar, jnpar
    character(len=24), pointer :: tblp(:) => null()
    integer, pointer :: tbnp(:) => null()
! DEB------------------------------------------------------------------
!
    call jemarq()
!
    nomtab = nomta
    inpar = para
    exist = .false.
    typpar = '????'
!
!     --- VERIFICATION DE LA TABLE ---
!
    call jeexin(nomtab//'.TBBA', iret)
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_79', sk=nomtab)
    endif
!
    call jeveuo(nomtab//'.TBNP', 'L', vi=tbnp)
    nbpara = tbnp(1)
    if (nbpara .eq. 0) then
        call utmess('F', 'UTILITAI4_80', sk=nomtab)
    endif
!
!     --- VERIFICATION QUE LE PARAMETRE EXISTE DANS LA TABLE ---
!
    call jeveuo(nomtab//'.TBLP', 'L', vk24=tblp)
    do 10 ipar = 1, nbpara
        jnpar = tblp(1+4*(ipar-1))
        if (inpar .eq. jnpar) then
            exist = .true.
            typpar = tblp(4*(ipar-1)+2)
            goto 12
        endif
 10 end do
 12 continue
!
    call jedema()
end subroutine
