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

subroutine cfmmap(mesh, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/apcrsd.h"
#include "asterfort/apcrsd_lac.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue/Discrete/LAC method - Prepare pairing datastructures
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: sdappa
    integer :: ifm, niv
    integer :: nb_cont_zone, nt_poin, model_ndim, nt_elem_node, nb_cont_elem, nb_cont_node
    integer :: nb_node_mesh, nb_cont_poin
    aster_logical :: l_cont_disc, l_cont_cont, l_cont_lac
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<CONTACT> . Prepare pairing datastructures'
    endif
!
! - Contact method
!
    l_cont_cont  = cfdisl(ds_contact%sdcont_defi,'FORMUL_CONTINUE')
    l_cont_disc  = cfdisl(ds_contact%sdcont_defi,'FORMUL_DISCRETE')
    l_cont_lac   = cfdisl(ds_contact%sdcont_defi,'FORMUL_LAC')
!
! - Get parameters
!
    nb_cont_zone = cfdisi(ds_contact%sdcont_defi,'NZOCO' )
    nb_cont_node = cfdisi(ds_contact%sdcont_defi,'NNOCO' )
    nt_poin      = cfdisi(ds_contact%sdcont_defi,'NTPT'  )
    nb_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC'  )
    model_ndim   = cfdisi(ds_contact%sdcont_defi,'NDIM'  )
    nb_cont_elem = cfdisi(ds_contact%sdcont_defi,'NMACO' )
    nt_elem_node = cfdisi(ds_contact%sdcont_defi,'NTMANO')
    call dismoi('NB_NO_MAILLA', mesh, 'MAILLAGE', repi=nb_node_mesh)
!
! - Pairing datastructure
!
    sdappa = ds_contact%sdcont_solv(1:14)//'.APPA'
!
! - Create pairing datastructure
!
    if (l_cont_cont .or. l_cont_disc) then
        call apcrsd(ds_contact  ,sdappa       ,&
                    nt_poin     , nb_cont_elem, nb_cont_node,&
                    nt_elem_node, nb_node_mesh)
    elseif (l_cont_lac) then
        call apcrsd_lac(ds_contact  , sdappa      , mesh,&
                        nt_poin     , nb_cont_elem, nb_cont_node,&
                        nt_elem_node, nb_node_mesh)
    else
        ASSERT(.false.)
    endif
!
! - Number of contact pairs
!
    if (l_cont_cont .or. l_cont_disc) then
        ds_contact%nb_cont_pair = nb_cont_poin
    elseif (l_cont_lac) then
        ds_contact%nb_cont_pair = 0
    else
        ASSERT(.false.)
    endif
!
end subroutine
