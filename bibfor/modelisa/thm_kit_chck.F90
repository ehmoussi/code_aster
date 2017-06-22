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

subroutine thm_kit_chck(model, l_affe_all, list_elem_affe, nb_elem_affe, rela_thmc)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
! person_in_charge: sylvie.granet at edf.fr
!
    character(len=8), intent(in) :: model
    aster_logical, intent(in) :: l_affe_all
    character(len=24), intent(in) :: list_elem_affe
    integer, intent(in) :: nb_elem_affe
    character(len=16), intent(in) :: rela_thmc
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Check relation/model for KIT_THM
!
! --------------------------------------------------------------------------------------------------
!
! In  model          : name of model
! In  l_affe_all     : .true. if affect on all elements of model
! In  nb_elem_affe   : number of elements where comportment affected
! In  list_elem_affe : list of elements where comportment affected
! In  rela_thmc      : relation for coupling
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: notype
    integer :: j_elem_affe
    integer :: nb_elem_mesh, nb_elem
    integer :: nume_elem
    integer :: ielem
    integer :: nutyel
    character(len=16) :: modeli
    character(len=8) :: mesh, name_elem
    character(len=24) :: valk(2)
    integer, pointer :: maille(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Access to model and mesh
!
    call jeveuo(model//'.MAILLE', 'L', vi=maille)
    call dismoi('NOM_MAILLA', model, 'MODELE', repk=mesh)
    call dismoi('NB_MA_MAILLA', mesh, 'MAILLAGE', repi=nb_elem_mesh)
!
! - Mesh affectation
!
    if (l_affe_all) then
        nb_elem = nb_elem_mesh
    else
        call jeveuo(list_elem_affe, 'L', j_elem_affe)
        nb_elem = nb_elem_affe
    endif
!
! - Loop on elements
!
    do ielem = 1, nb_elem
!
! ----- Current element
!
        if (l_affe_all) then
            nume_elem = ielem
        else
            nume_elem = zi(j_elem_affe-1+ielem)
        endif
        call jenuno(jexnum(mesh(1:8)//'.NOMMAI', nume_elem), name_elem)
!
! ----- Access to element type
!
        nutyel = maille(nume_elem)
        if (nutyel .ne. 0) then
            call jenuno(jexnum('&CATA.TE.NOMTE', nutyel), notype)
            call dismoi('MODELISATION', notype, 'TYPE_ELEM', repk=modeli)
            if ((rela_thmc(1:3) .eq. 'GAZ') .or. (rela_thmc(1:9) .eq. 'LIQU_SATU') .or.&
                (rela_thmc(1:12) .eq. 'LIQU_GAZ_ATM')) then
                if ((modeli(1:6).ne.'3D_THM') .and. (modeli(1:5) .ne.'3D_HM') .and.&
                    (modeli(1:5).ne.'3D_HS') .and. (modeli(1:8).ne.'AXIS_THM') .and.&
                    (modeli(1:7) .ne.'AXIS_HM') .and. (modeli(1:10).ne.'D_PLAN_THM') .and.&
                    (modeli(1:9).ne.'D_PLAN_HS') .and. (modeli(1: 9).ne.'D_PLAN_HM') .and.&
                    (modeli(1:8) .ne.'PLAN_JHM') .and. (modeli(1:8).ne.'AXIS_JHM') .and.&
                    (modeli.ne.'#PLUSIEURS')) then
                    valk(1) = rela_thmc
                    valk(2) = modeli
                    call utmess('F', 'THM1_35', nk=2, valk=valk)
                endif
                elseif ((rela_thmc(1:13).eq.'LIQU_VAPE_GAZ').or.&
                    (rela_thmc(1:8).eq.'LIQU_GAZ')) then
                if ((modeli(1:6).ne.'3D_THH') .and. (modeli(1:6) .ne.'3D_HHM') .and.&
                    (modeli(1:5).ne.'3D_HH') .and. (modeli(1:8).ne.'AXIS_THH') .and.&
                    (modeli(1:8) .ne.'AXIS_HHM') .and. (modeli(1:7).ne.'AXIS_HH') .and.&
                    (modeli(1:10).ne.'D_PLAN_THH') .and. (modeli( 1:10).ne.'D_PLAN_HHM')&
                    .and. (modeli(1:9) .ne.'D_PLAN_HH') .and. (modeli.ne.'#PLUSIEURS')) then
                    valk(1) = rela_thmc
                    valk(2) = modeli
                    call utmess('F', 'THM1_35', nk=2, valk=valk)
                endif
            else if (rela_thmc(1:9).eq.'LIQU_VAPE') then
                if ((modeli(1:6).ne.'3D_THV') .and. (modeli(1:8) .ne.'AXIS_THV') .and.&
                    (modeli(1:10) .ne.'D_PLAN_THV') .and. (modeli.ne.'#PLUSIEURS')) then
                    valk(1) = rela_thmc
                    valk(2) = modeli
                    call utmess('F', 'THM1_35', nk=2, valk=valk)
                endif
                else if ((rela_thmc(1:16).eq.'LIQU_AD_GAZ_VAPE').or.&
                     (rela_thmc(1:16).eq.'LIQU_AD_GAZ')) then
                if ((modeli(1:9).ne.'AXIS_HH2M') .and. (modeli(1:9) .ne.'AXIS_THH2') .and.&
                    (modeli(1:8).ne.'AXIS_HH2') .and. (modeli(1:11).ne.'D_PLAN_HH2M') .and.&
                    (modeli(1:11).ne.'D_PLAN_THH2') .and. (modeli(1:11) .ne.'D_PLAN_THH2')&
                    .and. (modeli(1:10) .ne.'D_PLAN_HH2') .and. (modeli(1:7).ne.'3D_HH2M')&
                    .and. (modeli(1:7).ne.'3D_THH2') .and. (modeli(1:6) .ne.'3D_HH2') .and.&
                    (modeli.ne.'#PLUSIEURS')) then
                    valk(1) = rela_thmc
                    valk(2) = modeli
                    call utmess('F', 'THM1_35', nk=2, valk=valk)
                endif
            endif
        endif
    enddo
!
    call jedema()
end subroutine
