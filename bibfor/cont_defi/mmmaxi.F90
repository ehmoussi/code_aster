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

function mmmaxi(sdcont_defi, model, mesh)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisi.h"
#include "asterfort/infbav.h"
#include "asterfort/infmue.h"
#include "asterfort/jedetr.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/lteatt.h"
#include "asterfort/utmasu.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    aster_logical :: mmmaxi
    character(len=24), intent(in) :: sdcont_defi
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Continue method - Check if all elements in contact surface are axisymmetric
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  model            : name of model
! In  mesh             : name of mesh
!
! function mmmaxi      : .true. if all elements in list are axisymmetric
!                        .false. if all elements in list are NOT axisymmetric
!                        error if some elements are axisymmetric
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: elem_type_name, list_elem_supp
    integer :: elem_nume, elem_type_nume
    integer :: i_elem, nb_cont_elem
    integer :: elem_supp_nume, nb_elem_axis, ivdummy(1)
    real(kind=8), pointer :: v_geom_vale(:) => null()
    character(len=24) :: model_maille
    integer, pointer :: v_model_maille(:) => null()
    integer, pointer :: v_list_elem_supp(:) => null()
    character(len=24) :: sdcont_mailco
    integer, pointer :: v_sdcont_mailco(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_elem_axis   = 0
    mmmaxi         = .false.
    list_elem_supp = '&&MMMAXI.MAISUP'
!
! - Datastructure for contact definition
!
    sdcont_mailco  = sdcont_defi(1:16)//'.MAILCO'
    call jeveuo(sdcont_mailco , 'L', vi = v_sdcont_mailco)
!
! - Parameters
!
    nb_cont_elem  = cfdisi(sdcont_defi,'NMACO' )
!
! - Access to model
!
    model_maille = model(1:8)//'.MAILLE'
    call jeveuo(model_maille, 'L', vi = v_model_maille)
!
! - Get support elements of skin elements
!
    call jeveuo(mesh//'.COORDO    .VALE', 'L', vr=v_geom_vale)
    call infmue()
    call utmasu(mesh, '2D', nb_cont_elem, v_sdcont_mailco, list_elem_supp,&
                v_geom_vale, 0, ivdummy, .false._1)
    call infbav()
    call jeveuo(list_elem_supp, 'L', vi = v_list_elem_supp)
!
! - Loop on elements
!
    do i_elem = 1, nb_cont_elem
        elem_supp_nume = v_list_elem_supp(i_elem)
        if (elem_supp_nume .ne. 0) then
            elem_type_nume = v_model_maille(elem_supp_nume)
            if (elem_type_nume .ne. 0) then
                goto 50
            endif
        endif
        elem_nume      = v_sdcont_mailco(i_elem)
        elem_type_nume = v_model_maille(elem_nume)
        if (elem_type_nume .eq. 0) then
            goto 100
        endif
 50     continue
        call jenuno(jexnum('&CATA.TE.NOMTE', elem_type_nume), elem_type_name)
        if (lteatt('AXIS','OUI', typel=elem_type_name)) then
            nb_elem_axis = nb_elem_axis +1
        endif
100     continue
    end do
!
    if (nb_elem_axis .eq. nb_cont_elem) then
        mmmaxi = .true.
    else if (nb_elem_axis.eq.0) then
        mmmaxi = .false.
    else
        call utmess('F', 'CONTACT2_12')
    endif
!
    call jedetr(list_elem_supp)
!
end function
