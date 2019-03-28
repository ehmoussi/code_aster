! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
subroutine romCalcIndiceUPPHI(ds_multipara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/indik8.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jexnom.h"
#include "asterfort/wkvect.h"
#include "jeveux.h"
!
type(ROM_DS_MultiPara), intent(in) :: ds_multipara
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE     : Create an objet voltile for saving indice of U, P, PHI in IFS problem
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_multipara      : datastructure for multiparametric problems
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8)  :: gran_name
    character(len=19) :: pfchno
    character(len=24) :: name_obj 
    integer :: i_equa, nb_equa, i_obj, nb_cmp_maxi
    integer, pointer :: v_deeq(:) => null()
    character(len=8), pointer :: v_list_cmp(:) => null()
    integer :: indx_cmp_p, indx_cmp_phi, nume_cmp
!
! --------------------------------------------------------------------------------------------------
!

!
! - Find index of composant PRES and PHI
!   
    call dismoi('NOM_GD',     ds_multipara%vect_name, 'CHAM_NO',   repk = gran_name)
    call dismoi('PROF_CHNO' , ds_multipara%vect_name, 'CHAM_NO',   repk = pfchno)
    
    call jeveuo(pfchno//'.DEEQ', 'L', vi = v_deeq)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', gran_name), 'L', vk8 = v_list_cmp)
    call jelira(jexnom('&CATA.GD.NOMCMP', gran_name), 'LONMAX', nb_cmp_maxi)
    
    indx_cmp_p   = indik8(v_list_cmp, 'PRES', 1, nb_cmp_maxi) 
    indx_cmp_phi = indik8(v_list_cmp, 'PHI', 1, nb_cmp_maxi) 
!    
! - Create an objet voltile for saving indice of U, P, PHI in IFS problem    
!
    call dismoi('NB_EQUA',    ds_multipara%matr_name(1), 'MATR_ASSE', repi = nb_equa)
    name_obj  = '&&OP0053.INDICE_U_P_PHI'
    call wkvect(name_obj, 'V V I', nb_equa, i_obj)
    do i_equa = 1, nb_equa
        nume_cmp = v_deeq(2*(i_equa-1)+2)
        if (nume_cmp .eq. indx_cmp_p) then 
            zi(i_obj+i_equa-1) = 0
        else if (nume_cmp .eq. indx_cmp_phi) then
            zi(i_obj+i_equa-1) = 1
        else 
            zi(i_obj+i_equa-1) = 2
        end if 
    end do
!
end subroutine
