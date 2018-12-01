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
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
subroutine caralv(sdcont, nb_cont_zone, cont_form)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mminfi.h"
#include "asterfort/mminfl.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: sdcont
integer, intent(in) :: cont_form
integer, intent(in) :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Set automatic parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  cont_form        : formulation of contact
! In  nb_cont_zone     : number of zones of contact
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_zone
    aster_logical :: l_all, l_exist
    aster_logical :: l_verif, l_newt_geom, l_geom_hpp, l_pena, l_node, l_glis_zone
    aster_logical :: l_cont_xczm
    integer :: i_cont_init
    character(len=24) :: sdcont_defi
    character(len=24) :: sdcont_paraci
    integer, pointer :: v_sdcont_paraci(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi = sdcont(1:8)//'.CONTACT'
!
! - Datastructure for contact definition
!
    sdcont_paraci = sdcont(1:8)//'.PARACI'
    call jeveuo(sdcont_paraci, 'E', vi=v_sdcont_paraci)
!
! - All zones are only contact verification ?
!
    if ((cont_form .eq. 1).or.(cont_form .eq. 2)) then
        i_zone = 1
        l_all  = mminfl(sdcont_defi,'VERIF',i_zone)
        do i_zone = 2, nb_cont_zone
            l_verif = mminfl(sdcont_defi,'VERIF',i_zone)
            l_all   = l_all.and.l_verif
        end do
        if (l_all) then
            v_sdcont_paraci(8) = 1
        endif
!
! ----- If contact verification : REAC_GEOM= 'SANS' / ALGO_RESO_GEOM='POINT_FIXE'
!
        if (l_all) then
            l_newt_geom = cfdisl(sdcont_defi,'GEOM_NEWTON')
            if (l_newt_geom) then
                v_sdcont_paraci(1) = 0
                v_sdcont_paraci(9) = 0
                call utmess('I', 'CONTACT2_3')
                call utmess('I', 'CONTACT2_4')
            else
                l_geom_hpp = cfdisl(sdcont_defi,'REAC_GEOM_SANS')
                if (.not. l_geom_hpp) then
                    v_sdcont_paraci(1) = 0
                    call utmess('I', 'CONTACT2_3')
                endif
            endif
        endif
    endif
!
! - At least one zone is contact verification ?
!
    if ((cont_form .eq. 1).or.(cont_form .eq. 2)) then
        l_exist = ASTER_FALSE
        do i_zone = 1, nb_cont_zone
            l_verif = mminfl(sdcont_defi,'VERIF',i_zone)
            l_exist = l_exist.or.l_verif
        end do
        if (l_exist) then
            v_sdcont_paraci(23) = 1
        endif
    endif
!
! - Penalization ? (non-symmetric matrix)
!
    if ((cont_form .eq. 2) .or. (cont_form .eq. 3)) then
        l_exist = ASTER_FALSE
        do i_zone = 1, nb_cont_zone
            l_pena = (&
                    mminfl(sdcont_defi,'ALGO_CONT_PENA',i_zone) .or.&
                    mminfl(sdcont_defi,'ALGO_FROT_PENA',i_zone))
            l_exist = l_exist.or.l_pena
                end do
        if (l_exist) then
            v_sdcont_paraci(22) = 1
        endif
    endif
!
! - Integration scheme for CONTINUE formulation: nodes ?
!
    if (cont_form .eq. 2) then
        i_zone = 1
        l_all  = (mminfi(sdcont_defi,'INTEGRATION' ,i_zone).eq.1)
        do i_zone = 2, nb_cont_zone
            l_node = (mminfi(sdcont_defi,'INTEGRATION' ,i_zone).eq.1)
            l_all = l_all.and.l_node
                end do
        if (l_all) then
            v_sdcont_paraci(24) = 1
        endif
    else if (cont_form.eq.1) then
        v_sdcont_paraci(24) = 1
    else if (cont_form.eq.3) then
        v_sdcont_paraci(24) = 1
    endif
!
! - Bilateral contact ?
!
    if (cont_form .eq. 2) then
        l_exist = ASTER_FALSE
        do i_zone = 1, nb_cont_zone
            l_glis_zone  = mminfl(sdcont_defi,'GLISSIERE_ZONE',i_zone)
            l_exist      = l_exist.or.l_glis_zone
                end do
        if (l_exist) then
            v_sdcont_paraci(26) = 1
        endif
    endif
!
! - At least one zone with XFEM+CZM ?
!
    if (cont_form .eq. 3) then
        l_exist = ASTER_FALSE
        do i_zone = 1, nb_cont_zone
            l_cont_xczm = mminfl(sdcont_defi,'CONT_XFEM_CZM',i_zone)
            l_exist     = l_exist.or.l_cont_xczm
                end do
        if (l_exist) then
            v_sdcont_paraci(21) = 1
        endif
    endif
!
! - All zones ares CONTACT_INIT INTERPENETRE ?
!
    if (cont_form .eq. 2) then
        l_all = ASTER_TRUE
        do i_zone = 1, nb_cont_zone
            i_cont_init = mminfi(sdcont_defi,'CONTACT_INIT',i_zone)
            l_all       = l_all .and.(i_cont_init.eq.2)
        end do
        if (l_all) then
            v_sdcont_paraci(11) = 1
        endif
    endif
!
end subroutine
