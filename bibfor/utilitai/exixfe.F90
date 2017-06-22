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

subroutine exixfe(modele, iret)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
    character(len=*) :: modele
    integer :: iret
!
!     BUT:
!         DETECTER SI LE MODELE EST UNE MODELISATION XFEM.
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   MODELE : NOM DU MODELE
!
!      SORTIE :
!-------------
! OUT  IRET : 0 -> LA MODELISATION N'EST PAS XFEM
!             1 -> LA MODELISATION EST XFEM
! ......................................................................
!
!
!      CHARACTER*32 JEEXIN
!
!
    integer :: ifiss
!
! ......................................................................
!
    call jemarq()
!
    iret=0
!
    call jeexin(modele(1:8)//'.FISS', ifiss)
    if (ifiss .ne. 0) iret=1
!
    call jedema()
!
end subroutine
