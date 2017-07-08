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
!
subroutine dfllad(sdlist)
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/dinogd.h"
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utcmp2.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
character(len=8), intent(in) :: sdlist
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_LIST_INST - Read parameters
!
! Keyword ADAPTATION
!
! --------------------------------------------------------------------------------------------------
!
! In  sdlist           : name of DEFI_LIST_INST datastructure
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: keywf
    integer :: nb_adapt, nbret
    integer :: ibid, nb_iter_newton_ref, nb_incr_seuil
    integer :: i_adap
    character(len=16) :: event_typek, nom_para, crit_comp, mode_calcul_tplus, nom_cham
    character(len=8) :: nomgd, nom_cmp
    real(kind=8) :: pcent_augm, vale_ref, valer
    integer :: valei, nucmp(1)
    character(len=24) :: sdlist_aevenr
    real(kind=8), pointer :: v_sdlist_aevenr(:) => null()
    character(len=24) :: sdlist_atplur
    real(kind=8), pointer :: v_sdlist_atplur(:) => null()
    character(len=24) :: sdlist_atpluk
    character(len=16), pointer :: v_sdlist_atpluk(:) => null()
    character(len=24) :: sdlist_linfor
    real(kind=8), pointer :: v_sdlist_linfor(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    keywf    = 'ADAPTATION'
    nb_adapt = 0
!
! - Access to datastructures
!
    sdlist_linfor = sdlist(1:8)//'.LIST.INFOR'
    call jeveuo(sdlist_linfor, 'E', vr = v_sdlist_linfor)
!
! - Get number of adaptation keywords
!
    call getfac(keywf, nb_adapt)
!
! - For IMPLEX: only one MODE_CALCUL_TPLUS
!
    call getvtx('ADAPTATION', 'MODE_CALCUL_TPLUS', iocc=nb_adapt, scal=mode_calcul_tplus,&
                                                   nbret=nbret)
    if (nb_adapt .ne. 1 .and. mode_calcul_tplus .eq. 'IMPLEX') then
        call utmess('F', 'DISCRETISATION_15')
    endif
!
! - Create datastructure
!
    sdlist_aevenr = sdlist(1:8)//'.ADAP.EVENR'
    sdlist_atplur = sdlist(1:8)//'.ADAP.TPLUR'
    sdlist_atpluk = sdlist(1:8)//'.ADAP.TPLUK'
    call wkvect(sdlist_aevenr, 'G V R'  , nb_adapt*SIZE_LAEVR, vr   = v_sdlist_aevenr)
    call wkvect(sdlist_atplur, 'G V R'  , nb_adapt*SIZE_LATPR, vr   = v_sdlist_atplur)
    call wkvect(sdlist_atpluk, 'G V K16', nb_adapt*SIZE_LATPK, vk16 = v_sdlist_atpluk)
    v_sdlist_linfor(10) = nb_adapt
!
! - Read parameters
!
    do i_adap = 1, nb_adapt
!
! ----- Get event
!
        call getvtx(keywf, 'EVENEMENT', iocc=i_adap, scal=event_typek, nbret=nbret)
        if (event_typek .eq. adapEventKeyword(ADAP_EVT_NONE)) then
            v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+1) = ADAP_EVT_NONE
            call utmess('A', 'DISCRETISATION_5')
        else if (event_typek .eq. adapEventKeyword(ADAP_EVT_ALLSTEPS)) then
            v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+1) = ADAP_EVT_ALLSTEPS
        else if (event_typek .eq. adapEventKeyword(ADAP_EVT_TRIGGER)) then
            v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+1) = ADAP_EVT_TRIGGER
        else
            ASSERT(.false.)
        endif
!
! ----- Options for 'SEUIL'
!
        if (event_typek .eq. adapEventKeyword(ADAP_EVT_TRIGGER)) then
            call getvis(keywf, 'NB_INCR_SEUIL', iocc=i_adap, scal=nb_incr_seuil, nbret=nbret)
            v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+2) = nb_incr_seuil
            call getvtx(keywf, 'NOM_PARA', iocc=i_adap, scal=nom_para, nbret=nbret)
            if (nom_para .eq. 'NB_ITER_NEWTON') then
                v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+3) = 1.d0
                valei = 0
                call getvis(keywf, 'VALE_I', iocc=i_adap, scal=valei, nbret=nbret)
                valer = valei
            else
                ASSERT(.false.)
            endif
            v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+5) = valer
            call getvtx(keywf, 'CRIT_COMP', iocc=i_adap, scal=crit_comp, nbret=nbret)
            if (crit_comp .eq. 'LT') then
                v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+4) = 1.d0
            else if (crit_comp.eq.'GT') then
                v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+4) = 2.d0
            else if (crit_comp.eq.'LE') then
                v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+4) = 3.d0
            else if (crit_comp.eq.'GE') then
                v_sdlist_aevenr(SIZE_LAEVR*(i_adap-1)+4) = 4.d0
            else
                ASSERT(.false.)
            endif
        endif
!
! ----- Options for 'MODE_CALCUL_TPLUS'
!
        call getvtx(keywf, 'MODE_CALCUL_TPLUS', iocc=i_adap, scal=mode_calcul_tplus, nbret=nbret)
        if (mode_calcul_tplus .eq. 'FIXE') then
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+1) = 1.d0
        else if (mode_calcul_tplus.eq.'DELTA_GRANDEUR') then
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+1) = 2.d0
        else if (mode_calcul_tplus.eq.'ITER_NEWTON') then
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+1) = 3.d0
        else if (mode_calcul_tplus.eq.'IMPLEX') then
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+1) = 5.d0
            if (event_typek .ne. adapEventKeyword(ADAP_EVT_ALLSTEPS)) then
                call utmess('F', 'DISCRETISATION_14')
            endif
        else
            ASSERT(.false.)
        endif
!
! ----- Options for MODE_CALCUL_TPLUS/FIXE
!
        if (mode_calcul_tplus .eq. 'FIXE') then
            call getvr8(keywf, 'PCENT_AUGM', iocc=i_adap, scal=pcent_augm, nbret=nbret)
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+2) = pcent_augm
        endif
!
! ----- Options for MODE_CALCUL_TPLUS/DELTA_GRANDEUR
!
        if (mode_calcul_tplus .eq. 'DELTA_GRANDEUR') then
            call getvr8(keywf, 'VALE_REF', iocc=i_adap, scal=vale_ref, nbret=nbret)
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+3) = vale_ref
            call getvtx(keywf, 'NOM_PARA', iocc=i_adap, scal=nom_para, nbret=nbret)
            call getvtx(keywf, 'NOM_CHAM', iocc=i_adap, scal=nom_cham, nbret=nbret)
            call getvtx(keywf, 'NOM_CMP', iocc=i_adap, scal=nom_cmp, nbret=nbret)
            nomgd = dinogd(nom_cham)
            call utcmp2(nomgd, keywf, i_adap, 1, nom_cmp,&
                        nucmp, ibid)
            v_sdlist_atpluk(SIZE_LATPK*(i_adap-1)+1) = nom_para
            v_sdlist_atpluk(SIZE_LATPK*(i_adap-1)+2) = nom_cham
            v_sdlist_atpluk(SIZE_LATPK*(i_adap-1)+3) = nom_cmp
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+4) = nucmp(1)
        endif
!
! ----- Options for MODE_CALCUL_TPLUS/ITER_NEWTON
!
        if (mode_calcul_tplus .eq. 'ITER_NEWTON') then
            call getvis(keywf, 'NB_ITER_NEWTON_REF', iocc=i_adap, scal=nb_iter_newton_ref,&
                        nbret=nbret)
            v_sdlist_atplur(SIZE_LATPR*(i_adap-1)+5) = nb_iter_newton_ref
        endif
    end do
!
    call jedema()
end subroutine
