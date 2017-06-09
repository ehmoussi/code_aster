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

subroutine xfem_precond(action, matass, base)
!
!-----------------------------------------------------------------------
! BUT : CALCUL DU PRE CONDITIONNEUR XFEM
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!
!-----------------------------------------------------------------------
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/xfem_pc.h"
#include "asterfort/xfem_pc_detr.h"
!
    character(len=*) :: matass
    character(len=1),optional :: base
    character(len=*) :: action
!
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
    ASSERT((action .eq. 'PRE_COND').or.(action .eq. 'FIN'))
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    if (action .eq. 'PRE_COND') then 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
       ASSERT(present(base))
!    PRE_CONDITIONNEMENT DE LA MATRICE
       call xfem_pc(matass, base)
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    elseif (action .eq. 'FIN') then 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!    DESTRUCTION DU PRECONDITIONNEUR ET RETOUR A L ETAT INITIAL
       call xfem_pc_detr(matass)
!
    endif
!
    call jedema()
!
!
end subroutine
