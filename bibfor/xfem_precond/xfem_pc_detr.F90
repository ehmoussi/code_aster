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

subroutine xfem_pc_detr(matass)
!
!-----------------------------------------------------------------------
! BUT : DESTRUCTION DU PRE-CONDITIONNEUR XFEM
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!
!-----------------------------------------------------------------------
    implicit none
!
#include "jeveux.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
!
    character(len=*) :: matass
!-----------------------------------------------------------------------
    character(len=14) :: nu_pc_0, nu_pc_1
    character(len=19) :: matas1, pc_0, pc_1
    character(len=24), pointer :: refa(:) => null()
    character(len=24), pointer :: refa_pc_0(:) => null()
    character(len=24), pointer :: refa_pc_1(:) => null()
    integer :: iret_0, iret_1
!-----------------------------------------------------------------------
!
    call jemarq()
!
    matas1 = matass
    pc_1=' '
    nu_pc_1=' '
    pc_0=' '
    nu_pc_0=' '
    call jeveuo(matas1//'.REFA', 'E', vk24=refa)
!
    if (refa(17) .ne. 'XFEM_PRECOND') goto 999
!
    if (refa(18) .ne. ' ') then 
       pc_1=refa(18)(1:19)
       refa(18)=' '
       call jeexin(pc_1//'.REFA', iret_1)
       if (iret_1 .gt. 0) then 
          call jeveuo(pc_1//'.REFA', 'E', vk24=refa_pc_1)
          nu_pc_1=refa_pc_1(2)(1:14)
          call detrsd('MATR_ASSE', pc_1)
          if (nu_pc_1 .ne. ' ') then 
             call detrsd('NUME_DDL', nu_pc_1)
          endif
       endif
    endif
!
    if (refa(16) .ne. ' ') then 
       pc_0=refa(16)(1:19)
       refa(16)=' '
       call jeexin(pc_0//'.REFA', iret_0)
       if (iret_0 .gt. 0) then 
          call jeveuo(pc_0//'.REFA', 'E', vk24=refa_pc_0)
          nu_pc_0=refa_pc_0(2)(1:14)
          call detrsd('MATR_ASSE', pc_0)
          if (nu_pc_0 .ne. ' ') then
             call detrsd('NUME_DDL', nu_pc_0)
          endif  
       endif
    endif
!
!   RETOUR DE LA MATRICE A SON ETAT INITIAL ... A FAIRE
!
!    if (pc_0 .ne. ' ') call detrsd('MATR_ASSE', pc_0)
!    if (pc_1 .ne. ' ') call detrsd('MATR_ASSE', pc_1)
!
999 continue
!
    call jedema()
!
end subroutine
