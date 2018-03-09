! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmaint(nume_dof, list_func_acti, sdnume,&
                  vefint  , cnfint)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assvec.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/isfonc.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmchex.h"
#include "asterfort/nmdebg.h"
#include "asterfort/vtzero.h"
!
character(len=24), intent(in) :: nume_dof
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sdnume
character(len=19), intent(in) :: vefint, cnfint
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! ASSEMBLAGE DU VECTEUR DES FORCES INTERNES
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=1) :: base
    integer :: nb_equa, i_equa
    integer :: endop1, endop2
    aster_logical :: lendo
    real(kind=8), pointer :: v_cnfint(:) => null()
    integer, pointer :: v_endo(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> ... ASSEMBLAGE DES FORCES INTERNES'
    endif
!
! - Initializations
!
    base  = 'V'
    call vtzero(cnfint)
    lendo = isfonc(list_func_acti,'ENDO_NO')
!
! - Assemble
!
    call assvec(base, cnfint, 1, vefint, [1.d0],&
                nume_dof, ' ', 'ZERO', 1)
!
! - Change values fro GDVARINO
!
    if (lendo) then
        call jeveuo(sdnume(1:19)//'.ENDO', 'L', vi=v_endo)
        call jeveuo(cnfint(1:19)//'.VALE', 'E', vr=v_cnfint)
        call dismoi('NB_EQUA', nume_dof, 'NUME_DDL', repi=nb_equa)
        endop1 = 0
        endop2 = 0
        do i_equa = 1, nb_equa
            if (v_endo(i_equa) .eq. 2) then
                if (v_cnfint(i_equa) .ge. 0.d0) then
                    endop2 = endop2+1
                    v_cnfint(i_equa) = 0.d0
                else
                    endop1 = endop1+1
                endif
            endif
        end do
    endif
!
! - Debug
!
    if (niv .ge. 2) then
        call nmdebg('VECT', cnfint, 6)
    endif
!
end subroutine
