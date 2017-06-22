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

subroutine lspini(solveu)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: solveu
!  BUT : REINITIALISATION DU PRECONDITIONNEUR LDLT_SP POUR
!        PETSC OU GCPC
!
! IN K19 SOLVEU  : NOM DU SOLVEUR DONNE EN ENTREE
! ----------------------------------------------------------
!
!
!
!
    character(len=8) :: precon
    character(len=24), pointer :: slvk(:) => null()
    integer, pointer :: slvi(:) => null()
!
!------------------------------------------------------------------
    call jemarq()
!
! --- LECTURES PARAMETRES DU SOLVEUR
    call jeveuo(solveu//'.SLVK', 'L', vk24=slvk)
    precon = slvk(2)
!
! --- REMISE A ZERO
    if (precon .eq. 'LDLT_SP') then
        call jeveuo(solveu//'.SLVI', 'E', vi=slvi)
        slvi(5)=0
    endif
!
    call jedema()
end subroutine
