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
subroutine nonlinDSContactCreate(ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
!
type(NL_DS_Contact), intent(out) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Contact management
!
! Create contact management datastructure
!
! --------------------------------------------------------------------------------------------------
!
! Out ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: i_loop
    integer, parameter :: nb_loop_defi = 3
    character(len=4), parameter :: loop_type(nb_loop_defi) = (/'Geom','Fric','Cont'/)
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> . Create contact management datastructure'
    endif
!
! - Main parameters
!
    ds_contact%l_contact   = ASTER_FALSE
    ds_contact%l_meca_cont = ASTER_FALSE
    ds_contact%l_meca_unil = ASTER_FALSE
    ds_contact%l_thm       = ASTER_FALSE
    ds_contact%sdcont      = ' '
    ds_contact%l_form_cont = ASTER_FALSE
    ds_contact%l_form_disc = ASTER_FALSE
    ds_contact%l_form_xfem = ASTER_FALSE
    ds_contact%l_form_lac  = ASTER_FALSE
!
! - Name of datastructures
!
    ds_contact%sdcont_defi = '&&OP0070.DEFIC'
    ds_contact%sdunil_defi = '&&OP0070.DEFIU'
    ds_contact%sdcont_solv = '&&OP0070.RESOC'
    ds_contact%sdunil_solv = '&&OP0070.RESUC'
!
! - Name of <LIGREL> - Slave and contact elements
!
    ds_contact%ligrel_elem_slav = ' '
    ds_contact%l_elem_slav      = ASTER_FALSE
    ds_contact%ligrel_elem_cont = ' '
    ds_contact%l_elem_cont      = ASTER_FALSE
!
! - Name of <CHELEM> - Input field
!
    ds_contact%field_input      = ' '
!
! - Name of NUME_DOF for discrete friction methods
!
    ds_contact%nume_dof_frot    = ' '
!
! - Identity relations between dof
!
    ds_contact%l_iden_rela = ASTER_FALSE
    ds_contact%iden_rela   = ' '
!
! - Relations between dof (QUAD8 in discrete methods or XFEM)
!
    ds_contact%l_dof_rela       = ASTER_FALSE
    ds_contact%ligrel_dof_rela  = ' '
!
! - Management of loops
!
    ds_contact%nb_loop = nb_loop_defi
    ASSERT(ds_contact%nb_loop.le.ds_contact%nb_loop_maxi)
    do i_loop = 1, nb_loop_defi
        ds_contact%loop(i_loop)%type    = loop_type(i_loop)
        ds_contact%loop(i_loop)%conv    = ASTER_FALSE
        ds_contact%loop(i_loop)%error   = ASTER_FALSE
        ds_contact%loop(i_loop)%counter = 0
    end do
!
! - Field for CONT_NODE
!
    ds_contact%field_cont_node  = ' '
    ds_contact%fields_cont_node = ' '
    ds_contact%field_cont_perc  = ' '
!
! - Field for CONT_ELEM
!
    ds_contact%field_cont_elem  = ' '
!
! - Flag for (re) numbering
!
    ds_contact%l_renumber   = ASTER_FALSE
!
! - Geometric loop control
!
    ds_contact%geom_maxi    = -1.d0
!
! - Penalization loop control
!
    ds_contact%estimated_coefficient    = 100.d0
    ds_contact%calculated_penetration   = 1.d0
    ds_contact%update_init_coefficient  = 0.d0
    ds_contact%continue_pene            = 0.d0
!
! - Get-off indicator
!
    ds_contact%l_getoff     = ASTER_FALSE
!
! - First geometric loop
!
    ds_contact%l_first_geom = ASTER_FALSE
!
! - Flag for pairing
!
    ds_contact%l_pair       = ASTER_FALSE
!
! - Total number of patches (for LAC method)
!
    ds_contact%nt_patch     = 0
!
! - Total number of contact pairs
!
    ds_contact%nb_cont_pair = 0
!
! - Force for DISCRETE contact
!
    ds_contact%l_cnctdf     = ASTER_FALSE
    ds_contact%cnctdf       = '&&OP0070.CNCTDF'
    ds_contact%l_cnctdc     = ASTER_FALSE
    ds_contact%cnctdc       = '&&OP0070.CNCTDC'
    ds_contact%l_cnunil     = ASTER_FALSE
    ds_contact%cnunil       = '&&OP0070.CNUNIL'
    ds_contact%l_cneltc     = ASTER_FALSE
    ds_contact%cneltc       = '&&OP0070.CNELTC'
    ds_contact%veeltc       = '&&OP0070.VEELTC'
    ds_contact%l_cneltf     = ASTER_FALSE
    ds_contact%cneltf       = '&&OP0070.CNELTF'
    ds_contact%veeltf       = '&&OP0070.VEELTF'
!
end subroutine
