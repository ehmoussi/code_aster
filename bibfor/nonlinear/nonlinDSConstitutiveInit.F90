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

subroutine nonlinDSConstitutiveInit(model, cara_elem, ds_constitutive)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmdoco.h"
#include "asterfort/nmcpqu.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/Behaviour_type.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: model
    character(len=24), intent(in) :: cara_elem
    type(NL_DS_Constitutive), intent(inout) :: ds_constitutive
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Constitutive laws
!
! Initializations for constitutive laws management datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of the model
! In  cara_elem        : name of elementary characteristics (field)
! IO  ds_constitutive  : datastructure for constitutive laws management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=8) :: answer
    integer :: nb_affe, i_affe
    character(len=16), pointer :: v_compor_vale(:) => null()
    integer, pointer :: v_compor_desc(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Initializations for constitutive laws'
    endif
!
! - Construct CHEM_ELEM_S
!
    call nmdoco(model, cara_elem, ds_constitutive%compor)
!
! - Some functionnalities
!
    call nmcpqu(ds_constitutive%compor, 'C_PLAN', 'DEBORST', ds_constitutive%l_deborst)
    call nmcpqu(ds_constitutive%compor, 'RELCOM', 'DIS_CHOC', ds_constitutive%l_dis_choc)
    call dismoi('POST_INCR', ds_constitutive%carcri, 'CARTE_CARCRI', repk=answer)
    ds_constitutive%l_post_incr = answer .eq. 'OUI'
!
! - Look if geometric matrix is included in global tangent matrix
!
    call jeveuo(ds_constitutive%compor(1:19)//'.VALE', 'L', vk16 = v_compor_vale)
    call jeveuo(ds_constitutive%compor(1:19)//'.DESC', 'L', vi   = v_compor_desc)
    nb_affe = v_compor_desc(3)
    do i_affe = 1, nb_affe
        if ((v_compor_vale(DEFO+NB_COMP_MAXI*(i_affe-1)).eq.'GROT_GDEP') .or.&
            (v_compor_vale(DEFO+NB_COMP_MAXI*(i_affe-1)).eq.'SIMO_MIEHE') .or.&
            (v_compor_vale(DEFO+NB_COMP_MAXI*(i_affe-1)).eq.'GDEF_LOG')) then
            ds_constitutive%l_matr_geom = .true.
        endif
    enddo
!
end subroutine
