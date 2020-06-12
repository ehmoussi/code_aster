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

subroutine numero_wrap(nume_ddlz    , base,&
                       old_nume_ddlz, modelocz    ,&
                       modelz       , list_loadz)
!
implicit none
!
#include "asterfort/numero.h"
!
! person_in_charge: nicolas.sellenet at edf.fr
!
    character(len=*) :: nume_ddlz
    character(len=2) :: base
    character(len=*) :: modelz
    character(len=*) :: list_loadz
    character(len=*) :: old_nume_ddlz
    character(len=*) :: modelocz
!
! --------------------------------------------------------------------------------------------------
!
! Factor
!
! Numbering
!
! --------------------------------------------------------------------------------------------------
!
! IO  nume_ddl       : name of numbering object (NUME_DDL)
! In  base           : JEVEUX base to create objects
!                      base(1:1) => PROF_CHNO objects
!                      base(2:2) => NUME_DDL objects
! In  old_nume_ddl   : name of previous nume_ddl object
! In  modelocz       : local mode for GRANDEUR numbering
! In  model          : name of model
! In  list_load      : list of loads
! In  list_matr_elem : list of elementary matrixes
! In  nb_matr_elem   : number of elementary matrixes
! In  sd_iden_rela   : name of object for identity relations between dof
!
! If old_nume_ddl is present
!   -> try to know if PROF_CHNO in old_nume_ddl can be reuse
!      In this case nume_ddl = old_nume_ddl
!
! --------------------------------------------------------------------------------------------------
!
    call numero(nume_ddlz, base, old_nume_ddlz, modelocz,&
                modelz, list_loadz)
!
end subroutine
