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

subroutine comp_meca_elas(comp_elas, nb_cmp, l_etat_init)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/Behaviour_type.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=19), intent(in) :: comp_elas
    integer, intent(in) :: nb_cmp
    aster_logical, intent(in) :: l_etat_init
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Set elastic comportment
!
! --------------------------------------------------------------------------------------------------
!
! In  comp_elas   : name of ELAS <CARTE> COMPOR
! In  nb_cmp      : number of components in ELAS <CARTE> COMPOR
! In  l_etat_init : .true. if initial state is defined
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16), pointer :: p_compelas_valv(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(nb_cmp .ge. 6)
!
! - Access <CARTE>
!
    call jeveuo(comp_elas(1:19)//'.VALV', 'E', vk16 = p_compelas_valv)
!
! - Init <CARTE>
!
    p_compelas_valv(1:NB_COMP_MAXI) = 'VIDE'
!
! - Set for ELASTIQUE
!
    p_compelas_valv(NAME) = 'ELAS'
    p_compelas_valv(NVAR) = '1'
    p_compelas_valv(DEFO) = 'PETIT'
    if (l_etat_init) then
        p_compelas_valv(INCRELAS) = 'COMP_INCR'
    else
        p_compelas_valv(INCRELAS) = 'COMP_ELAS'
    endif
    p_compelas_valv(PLANESTRESS) = 'ANALYTIQUE'
    write (p_compelas_valv(NUME) ,'(I16)') 1
    write (p_compelas_valv(KIT1_NVAR) ,'(I16)') 1
    write (p_compelas_valv(KIT2_NVAR) ,'(I16)') 1
    write (p_compelas_valv(KIT3_NVAR) ,'(I16)') 1
    write (p_compelas_valv(KIT4_NVAR) ,'(I16)') 1
!
! - Create <CARTE>
!
    call nocart(comp_elas, 1, nb_cmp)
!
end subroutine
