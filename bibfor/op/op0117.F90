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

subroutine op0117()
    implicit none
! person_in_charge: nicolas.greffet at edf.fr
!     BUT: RECUPERER LE NUMERO DE COMPONENT VENANT DE YACS
!     ON LE MET DANS UN OBJET JEVEUX &ADR_YACS
#include "jeveux.h"
#include "asterfort/getvis.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: icompo
    integer :: ibid
!
    integer :: zyacs
    character(len=24) :: ayacs
!
!
!
!
!
!
!
!
    call jemarq()
!
!
    call getvis(' ', 'COMPO', scal=icompo, nbret=ibid)
!
!
!     ICOMPO MIS EN COMMON ASTER
!     --------------------------
    ayacs='&ADR_YACS'
    call wkvect(ayacs, 'G V I', 1, zyacs)
    zi(zyacs)=icompo
!
    call jedema()
!
end subroutine
