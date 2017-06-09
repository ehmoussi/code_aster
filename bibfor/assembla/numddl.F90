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

subroutine numddl(nume_ddlz, base, nb_matr, list_matr)
!
implicit none
!
#include "asterfort/as_deallocate.h"
#include "asterfort/infniv.h"
#include "asterfort/jedetr.h"
#include "asterfort/nueffe.h"
#include "asterfort/numoch.h"
#include "asterc/getres.h"
!
! aslint: disable=W1306
!
    character(len=2), intent(in) :: base
    character(len=*), intent(in) :: nume_ddlz
    character(len=*), intent(in) :: list_matr(*)
    integer, intent(in) :: nb_matr
!
! --------------------------------------------------------------------------------------------------
!
! Factor
!
! Numbering - Create NUME_EQUA objects
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_ddl       : name of nume_ddl object
! In  base           : JEVEUX base to create objects
!                      base(1:1) => PROF_CHNO objects
!                      base(2:2) => NUME_DDL objects
! In  list_matr      : list of elementary matrixes
! In  nb_matr        : number of elementary matrixes
!                       SANS/RCMKs
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: list_matr_elem(nb_matr)
    integer :: nb_ligr
    character(len=24), pointer :: list_ligr(:) => null()
    integer :: i_matr
    character(len=4) :: renum
    character(len=8) :: nomres
    character(len=16) :: typres,nomcom
!
! --------------------------------------------------------------------------------------------------
!
    do i_matr = 1, nb_matr
        list_matr_elem(i_matr) = list_matr(i_matr)
    end do
!
! - Create list of LIGREL for numbering
!
    call numoch(list_matr_elem, nb_matr, list_ligr, nb_ligr)
!
! - Numbering - Create NUME_EQUA objects
!

    call getres(nomres, typres, nomcom)
    if (nomcom.eq.'MACR_ELEM_STAT') then
        renum='RCMK'
    else
        renum='SANS'
    endif

    call nueffe(nb_ligr, list_ligr, base, nume_ddlz, renum)
!
    AS_DEALLOCATE(vk24 = list_ligr)
!
end subroutine
