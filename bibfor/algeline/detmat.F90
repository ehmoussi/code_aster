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

subroutine detmat()
    implicit none
! ----------------------------------------------------------------------
!
! BUT : DETRUIRE TOUTES LES MATR_ASSE PRESENTES SUR LA BASE VOLATILE
!       DETRUIT AUSSI LES EVENTUELLES INSTANCES MUMPS OU PETSC
!
! ----------------------------------------------------------------------
! person_in_charge: jacques.pellet at edf.fr
!
#include "asterfort/assert.h"
#include "asterfort/detlsp.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelstc.h"
#include "asterfort/xfem_precond.h"
    integer :: nbmat, i, ier
    character(len=19) :: matass, solveu
    character(len=24) :: lirefa(100), kxfem
!-----------------------------------------------------------------------
!
    call jelstc('V', '.REFA', 20, 100, lirefa,&
                nbmat)
    ASSERT(nbmat.ge.0)
!
    do i = 1, nbmat
        call jeexin(lirefa(i), ier)
        if (ier .eq. 0) goto 10
        matass = lirefa(i)(1:19)
!
!       -- on detruit l'eventuelle instance mumps associee a ldlt_sp
        call dismoi('SOLVEUR', matass, 'MATR_ASSE', repk=solveu, arret='C',&
                    ier=ier)
        if (ier .eq. 0 .and. solveu(1:4) .ne. 'XXXX' .and. solveu(1:4) .ne. ' ') then
            call detlsp(matass, solveu)
        endif
!
!       -- on detruit les eventuels pré-conditinneurs xfem stockés sous forme de matr_asse
        call dismoi('XFEM', matass, 'MATR_ASSE', repk=kxfem)
        if ( kxfem .eq. 'XFEM_PRECOND') call xfem_precond('FIN', matass)
!
!       --  on detruit les matr_asse ainsi que les
!           eventuelles instances mumps et petsc
        call detrsd('MATR_ASSE', matass)
!
 10     continue
    end do
!
end subroutine
