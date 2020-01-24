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

subroutine nueffe(nb_ligr, list_ligr, base , nume_ddlz , renumz,&
                  modelocz , sd_iden_relaz)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nueffe_lag1.h"
#include "asterfort/nueffe_lag2.h"
#include "asterfort/utmess.h"
#include "jeveux.h"
!
    integer, intent(in) :: nb_ligr
    character(len=24), pointer :: list_ligr(:)
    character(len=2), intent(in) :: base
    character(len=*), intent(in) :: nume_ddlz
    character(len=*), intent(in) :: renumz
    character(len=*), optional, intent(in) :: modelocz
    character(len=*), optional, intent(in) :: sd_iden_relaz
!
! --------------------------------------------------------------------------------------------------
!
! Factor
!
! Numbering - Create NUME_EQUA objects
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_ligr        : number of LIGREL in list
! In  list_ligr      : pointer to list of LIGREL
! In  nume_ddl       : name of numbering object (NUME_DDL)
! In  base           : JEVEUX base to create objects
!                      base(1:1) => PROF_CHNO objects
!                      base(2:2) => NUME_DDL objects
! In  renum          : method for renumbering equations
!                       SANS/RCMK
! In  modelocz       : local mode for GRANDEUR numbering
! In  sd_iden_rela   : name of object for identity relations between dof
!
!-----------------------------------------------------------------------
! Attention : ne fait pas jemarq/jedema car nulili
!             recopie des adresses jeveux dans .ADNE et .ADLI
!             Ces objets seront utilises pendant la creation de la sd "stockage" (promor.F90)
! --------------------------------------------------------------------------------------------------
! Cette routine cree les objets suivants :
!  nume(1:14)//     .ADLI
!                   .ADNE
!              .NUME.DEEQ
!              .NUME.DELG
!              .NUME.LILI
!              .NUME.NEQU
!              .NUME.NUEQ
!              .NUME.PRNO
!              .NUME.REFN
! --------------------------------------------------------------------------------------------------
!
    integer :: iligr, jlgrf
    character(len=8) :: lag12
    aster_logical :: first
!
! Verification of number of Lagrange multipliers in load ligrel (single or double)
!
    first = ASTER_TRUE
    lag12 = 'LAG2'
!
    do iligr = 2, nb_ligr
        call jeveuo(list_ligr(iligr)(1:19)//'.LGRF', 'L', jlgrf)
        if( first ) then
            lag12 = zk8(jlgrf+2)
            first = ASTER_FALSE
        else
            if( lag12.ne.zk8(jlgrf+2) ) then
                call utmess('F', 'ASSEMBLA_6')
            endif
        endif
    enddo
!
    if( lag12.eq.'LAG1' ) then
        ASSERT(nb_ligr > 1)
! Case with simple Lagrange
        call nueffe_lag1(nb_ligr, list_ligr, base, nume_ddlz, renumz,&
                         modelocz, sd_iden_relaz)
    else
! Case without Lagrange or with double Lagrange
        call nueffe_lag2(nb_ligr, list_ligr, base, nume_ddlz, renumz,&
                         modelocz, sd_iden_relaz)
    endif
!
end subroutine
