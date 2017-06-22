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

subroutine pteddl(typesd   , resuz    , nb_cmp, list_cmp, nb_equa,&
                  tabl_equa, list_equa)
!
implicit none
!
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/select_dof_2.h"
!
!
    integer, intent(in) :: nb_cmp
    integer, intent(in) :: nb_equa
    character(len=*), intent(in) :: typesd
    character(len=*), intent(in) :: resuz
    character(len=8), target, intent(in) :: list_cmp(nb_cmp)
    integer, target, optional, intent(inout) :: tabl_equa(nb_equa, nb_cmp)
    integer, target, optional, intent(inout) :: list_equa(nb_equa)
!
! --------------------------------------------------------------------------------------------------
!
! In  typesd     : type of datastructure (chamno/nume_ddl)
! In  resu       : name of datastructure (chamno/nume_ddl)
! In  nb_cmp     : number of components
! In  list_cmp   : list of components
! In  nb_equa    : number of equations
! IO  tabl_equa  : table of equations
!      tabl_equa(IEQ,ICMP) =
!                   1 SI LE IEQ-EME CMP DE NUM A POUR NOM: list_cmp(ICMP)
!                   0 SINON
! IO  list_equa  : list of equations
!      list_equa(IEQ) =
!                   1 SI LE IEQ-EME CMP DE NUM A POUR NOM: list_cmp(ICMP)
!                   0 SINON
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: resu
    character(len=8), pointer :: list_cmp_p(:) => null()
    integer, pointer :: tabl_equa_p(:,:) => null()
    integer, pointer :: list_equa_p(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resu = resuz
!
! - Table of equations
!
    if (present(tabl_equa)) then
        tabl_equa(1:nb_equa,1:nb_cmp) = 0
        tabl_equa_p => tabl_equa
    endif
!
! - List of equations
!
    if (present(list_equa)) then
        list_equa(1:nb_equa) = 0
        list_equa_p => list_equa
        ASSERT(nb_cmp.eq.1)
    endif
!
! - Get list of components
!
    list_cmp_p => list_cmp
!
! - Set dof in table
!
    if (typesd .eq. 'NUME_DDL') then
        if (present(tabl_equa)) then
            call select_dof_2(tabl_equa = tabl_equa_p, &
                            nume_ddlz = resu, &
                            nb_cmpz   = nb_cmp, list_cmpz  = list_cmp_p)
        else
            call select_dof_2(list_equa = list_equa_p, &
                            nume_ddlz = resu, &
                            nb_cmpz   = nb_cmp, list_cmpz  = list_cmp_p)
        endif
    else if (typesd .eq. 'CHAM_NO') then
        if (present(tabl_equa)) then
            call select_dof_2(tabl_equa = tabl_equa_p, &
                            chamnoz   = resu,&
                            nb_cmpz   = nb_cmp, list_cmpz  = list_cmp_p)
        else
            call select_dof_2(list_equa = list_equa_p, &
                            chamnoz   = resu,&
                            nb_cmpz   = nb_cmp, list_cmpz  = list_cmp_p)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
