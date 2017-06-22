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

subroutine parti0(nbmat, tlimat, partit)
    implicit none
!
! person_in_charge: jacques.pellet at edf.fr
!
#include "asterfort/dismoi.h"
#include "asterfort/utmess.h"
    character(len=*) :: tlimat(*), partit
    integer :: nbmat
!----------------------------------------------------------------------
! but : determiner le nom de la partition attachee a la liste de
!       matr_elem (ou de vect_elem)  tlimat
!
! out k8 partit  : nom de la partition
!        - si partit=' ' : il n'y a pas de partition. Tous les resuelem de
!          tous les matr_elem ete completement calcules
!          sur tous les procs.
! Remarque : si les resuelem des matr_elem n'ont pas ete calcules avec la
!            meme partition : erreur <F>
!----------------------------------------------------------------------
    character(len=8) :: part1
    character(len=19) :: matel
    character(len=24) :: valk(5)
    integer :: i
!----------------------------------------------------------------------

    partit=' '
    do i = 1, nbmat
        matel = tlimat(i)
        call dismoi('PARTITION', matel, 'MATR_ELEM', repk=part1)
        if (partit .eq. ' ' .and. part1 .ne. ' ') partit=part1
        if (partit .ne. ' ' .and. part1 .eq. ' ') goto 10
        if (partit .ne. ' ' .and. partit .ne. part1) then
            valk(1)=partit
            valk(2)=part1
            call utmess('F', 'CALCULEL_10', nk=2, valk=valk)
        endif
 10     continue
    end do
end subroutine
