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

subroutine ssafmo(model)
!
    implicit none
!
#include "asterc/getfac.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jexnom.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
!
    character(len=8), intent(in) :: model
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_MODELE
!
! Macro-elements (AFFE_SOUS_STRUCT)
!
! --------------------------------------------------------------------------------------------------
!
! In  model        : name of the model
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: mesh, name_super_elem
    character(len=24) :: valk(2)
    character(len=16) :: keywordfact
    integer :: ielem, nume_super_elem, ioc, isuperelem
    integer :: n_affe_all, n1, nb_super_elem, nb_ss_acti, nb_node_lagr
    integer, pointer          :: p_model_sssa(:) => null()
    character(len=8), pointer :: p_list_elem(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    ioc         = 1
    keywordfact = 'AFFE_SOUS_STRUC'
!
! - Access to mesh
!
    call dismoi('NOM_MAILLA', model, 'MODELE', repk = mesh)
    call dismoi('NB_SM_MAILLA', mesh, 'MAILLAGE', repi = nb_super_elem)
    call dismoi('NB_NL_MAILLA', mesh, 'MAILLAGE', repi = nb_node_lagr)
    if (nb_super_elem .eq. 0) then
        call utmess('F', 'SOUSTRUC_30')
    endif
!
! - Create main object
!
    call wkvect(model//'.MODELE    .SSSA', 'G V I', nb_super_elem+3, vi = p_model_sssa)
!
! - TOUT = 'OUI'
!
    call getvtx(keywordfact, 'TOUT', iocc=ioc, nbret = n_affe_all)
    if (n_affe_all .eq. 1) then
        do ielem = 1, nb_super_elem
            p_model_sssa(ielem) = 1
        end do
        nb_ss_acti = nb_super_elem
        goto 999
    endif
!
! - SUPER_MAILLE
!
    call getvtx(keywordfact, 'SUPER_MAILLE', iocc=ioc, nbval=0, nbret=n1)
    nb_ss_acti = -n1
    AS_ALLOCATE(vk8 = p_list_elem, size = nb_ss_acti)
    call getvtx(keywordfact, 'SUPER_MAILLE', iocc=ioc, nbval=nb_ss_acti, vect=p_list_elem) 
    do isuperelem = 1, nb_ss_acti
        name_super_elem = p_list_elem(isuperelem)
        call jenonu(jexnom(mesh//'.SUPMAIL', name_super_elem), nume_super_elem)
        if (nume_super_elem .eq. 0) then
            valk(1) = name_super_elem
            valk(2) = mesh
            call utmess('F', 'SOUSTRUC_26', nk=2, valk=valk)
        else
            p_model_sssa(nume_super_elem) = 1
        endif
    end do
!
999 continue
    p_model_sssa(nb_super_elem+1) = nb_super_elem
    p_model_sssa(nb_super_elem+2) = nb_ss_acti
    p_model_sssa(nb_super_elem+3) = nb_node_lagr
!
    AS_DEALLOCATE(vk8 = p_list_elem)
    call jedema()
end subroutine
