! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine detmatrix(matass)
use elg_data_module
    implicit none
!
    character(len=19), intent(in) :: matass
! ----------------------------------------------------------------------
!
! BUT : DETRUIRE UNE MATR_ASSE
!       DETRUIT AUSSI LES EVENTUELLES INSTANCES MUMPS OU PETSC
!
! ----------------------------------------------------------------------
!
#include "asterfort/assert.h"
#include "asterfort/detlsp.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/xfem_precond.h"
    integer :: ier
    character(len=19) :: solveu
    character(len=24) :: kxfem
!-----------------------------------------------------------------------
!
!   -- on detruit l'eventuelle instance mumps associee a ldlt_sp
    call dismoi('SOLVEUR', matass, 'MATR_ASSE', repk=solveu, arret='C', ier=ier)
    if (ier .eq. 0 .and. solveu(1:4) .ne. 'XXXX' .and. solveu(1:4) .ne. ' ') then
        call detlsp(matass, solveu)
    endif
!
!  -- on detruit les eventuels pré-conditinneurs xfem stockés sous forme de matr_asse
    call dismoi('XFEM', matass, 'MATR_ASSE', repk=kxfem)
    if ( kxfem .eq. 'XFEM_PRECOND') call xfem_precond('FIN', matass)
!
!  --  on detruit les matr_asse ainsi que les
!           eventuelles instances mumps et petsc
    call detrsd('MATR_ASSE', matass)
!
!  -- on detruit les eventuelles structures creees pour eliminer les multiplicateurs
!          de Lagrange
    call elg_gest_data('EFFACE', ' ', matass, ' ')
!
end subroutine
