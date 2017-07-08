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
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1501
!
subroutine utdidt(getset, sddisc, ques_type, question, index_, &
                  valr_ , vali_ , valk_    )
!
implicit none
!
#include "asterf_types.h"
#include "event_def.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
!
character(len=1), intent(in) :: getset
character(len=19), intent(in) :: sddisc
character(len=4), intent(in) :: ques_type
character(len=*), intent(in) :: question
integer, intent(in), optional :: index_
integer, intent(inout), optional :: vali_
real(kind=8), intent(inout), optional :: valr_
character(len=*), intent(inout), optional :: valk_
!
! --------------------------------------------------------------------------------------------------
!
! Utility for discretization datastructure
!
! --------------------------------------------------------------------------------------------------
!
! IN  GETSET : 'L' -> LECTURE
!              'E' -> ECRITURE
! IN  SDDISC : SDDISC LOCALE A OP00700
! IN  TYPQUE : TYPE DE DEMANDE (LIST, ECHE OU ADAP)
! IN  IOCC   : NUMERO OCCURRENCE (POUR ECHEC/ADAPT)
! IN  QUEST  : QUESTION
! I/O VALI   : VALEUR ENTIERE
! I/O VALR   : VALEUR REELLE
! I/O VALK   : VALEUR CHAINE
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iechec, iadapt
    character(len=16) :: valk
    real(kind=8) :: valr
    integer :: vali
    character(len=24) :: sddisc_linf
    real(kind=8), pointer :: v_sddisc_linf(:) => null()
    character(len=24) :: sddisc_eevr
    real(kind=8), pointer :: v_sddisc_eevr(:) => null()
    character(len=24) :: sddisc_eevk        
    character(len=16), pointer :: v_sddisc_eevk(:) => null()
    character(len=24) :: sddisc_esur    
    real(kind=8), pointer :: v_sddisc_esur(:) => null()
    character(len=24) :: sddisc_epil
    integer, pointer :: v_sddisc_epil(:) => null()
    character(len=24) :: sddisc_aevr
    real(kind=8), pointer :: v_sddisc_aevr(:) => null()
    character(len=24) :: sddisc_atpr
    real(kind=8), pointer :: v_sddisc_atpr(:) => null()
    character(len=24) :: sddisc_atpk
    character(len=16), pointer :: v_sddisc_atpk(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(ques_type.eq.'LIST'.or. ques_type.eq.'ECHE'.or. ques_type.eq.'ADAP')
    ASSERT(getset.eq.'L'.or.getset.eq.'E')
!
! - Initializations
!
    if (getset .eq. 'L') then
        valk = ' '
        vali = 0
        valr = 0.d0
    else
        if (present(valk_)) then
            valk = valk_
        endif
        if (present(vali_)) then
            vali = vali_
        endif
        if (present(valr_)) then
            valr = valr_
        endif
    endif
!
! - Questions about LIST
!
    if (ques_type .eq. 'LIST') then
        sddisc_linf = sddisc(1:19)//'.LINF'
        call jeveuo(sddisc_linf, getset, vr = v_sddisc_linf)
        if (question .eq. 'METHODE') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_linf(1))
                if (vali .eq. 1) valk = 'MANUEL'
                if (vali .eq. 2) valk = 'AUTO'
            else if (getset.eq.'E') then
                if (valk .eq. 'MANUEL') then
                    v_sddisc_linf(1) = 1
                else if (valk.eq.'AUTO') then
                    v_sddisc_linf(1) = 2
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'PAS_MINI') then
            if (getset .eq. 'L') then
                valr =v_sddisc_linf(2)
            else if (getset.eq.'E') then
                v_sddisc_linf(2) = valr
            endif
        else if (question.eq.'PAS_MAXI') then
            if (getset .eq. 'L') then
                valr = v_sddisc_linf(3)
            else if (getset.eq.'E') then
                v_sddisc_linf(3) = valr
            endif
        else if (question.eq.'NB_PAS_MAXI') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_linf(4))
            else if (getset.eq.'E') then
                v_sddisc_linf(4) = vali
            endif
        else if (question.eq.'DTMIN') then
            if (getset .eq. 'L') then
                valr = v_sddisc_linf(5)
            else if (getset.eq.'E') then
                v_sddisc_linf(5) = valr
            endif
        else if (question.eq.'DT-') then
            if (getset .eq. 'L') then
                valr = v_sddisc_linf(6)
            else if (getset.eq.'E') then
                v_sddisc_linf(6) = valr
            endif
        else if (question.eq.'EXIS_DECOUPE') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_linf(7))
                if (vali .eq. 0) valk = 'NON'
                if (vali .eq. 1) valk = 'OUI'
            else if (getset.eq.'E') then
                if (valk .eq. 'NON') then
                    v_sddisc_linf(7) = 0
                else if (valk.eq.'OUI') then
                    v_sddisc_linf(7) = 1
                else
                    write(6,*) 'VALK: ',valk
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'NBINST') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_linf(8))
            else if (getset.eq.'E') then
                v_sddisc_linf(8) = vali
            endif
        else if (question.eq.'NECHEC') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_linf(9))
            else if (getset.eq.'E') then
                v_sddisc_linf(9) = vali
            endif
        else if (question.eq.'NADAPT') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_linf(10))
            else if (getset.eq.'E') then
                v_sddisc_linf(10) = vali
            endif
        else
            ASSERT(.false.)
        endif
!
! - Questions about ECHEC
!
    else if (ques_type.eq.'ECHE') then
        sddisc_eevr = sddisc(1:19)//'.EEVR'
        sddisc_eevk = sddisc(1:19)//'.EEVK'
        sddisc_esur = sddisc(1:19)//'.ESUR'
        sddisc_epil = sddisc(1:19)//'.EPIL'
        call jeveuo(sddisc_eevr, getset, vr   = v_sddisc_eevr)
        call jeveuo(sddisc_eevk, getset, vk16 = v_sddisc_eevk)
        call jeveuo(sddisc_esur, getset, vr   = v_sddisc_esur)
        call jeveuo(sddisc_epil, getset, vi   = v_sddisc_epil)
        if (present(index_)) then
            iechec = index_
        endif
        if (question.eq.'VERIF_EVEN') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+3))
                if (vali .eq. 0) valk = 'OUI'
                if (vali .eq. 1) valk = 'NON'
            else if (getset.eq.'E') then
                if (valk .eq. 'OUI') then
                    v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+3) = 0
                else if (valk.eq.'NON') then
                    v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+3) = 1
                else
                    ASSERT(.false.)
                endif
            endif
!
! ----- Parameters for DELTA_GRANDEUR
!
        else if (question.eq.'NOM_CHAM') then
            if (getset .eq. 'L') then
                valk = v_sddisc_eevk(SIZE_LEEVK*(iechec-1)+1)
            else if (getset.eq.'E') then
                v_sddisc_eevk(SIZE_LEEVK*(iechec-1)+1) = valk
            endif
        else if (question.eq.'NOM_CMP') then
            if (getset .eq. 'L') then
                valk = v_sddisc_eevk(SIZE_LEEVK*(iechec-1)+2)
            else if (getset.eq.'E') then
                v_sddisc_eevk(SIZE_LEEVK*(iechec-1)+2) = valk
            endif
        else if (question.eq.'CRIT_COMP') then
            if (getset .eq. 'L') then
                valk = v_sddisc_eevk(SIZE_LEEVK*(iechec-1)+3)
            else if (getset.eq.'E') then
                v_sddisc_eevk(SIZE_LEEVK*(iechec-1)+3) = valk
            endif
        else if (question.eq.'VALE_REF') then
            if (getset .eq. 'L') then
                valr = v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+5)
            else if (getset.eq.'E') then
                v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+5) = valr
            endif
!
! ----- Parameters for INTERPENETRATION
!
        else if (question.eq.'PENE_MAXI') then
            if (getset .eq. 'L') then
                valr = v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+6)
            else if (getset.eq.'E') then
                v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+6) = valr
            endif
!
! ----- Parameters for RESI_MAXI
!
        else if (question.eq.'RESI_GLOB_MAXI') then
            if (getset .eq. 'L') then
                valr = v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+7)
            else if (getset.eq.'E') then
                v_sddisc_eevr(SIZE_LEEVR*(iechec-1)+7) = valr
            endif
!
! ----- Parameters for DECOUPE
!
        else if (question.eq.'SUBD_METHODE') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_esur(SIZE_LESUR*(iechec-1)+1))
                if (vali .eq. 0) valk = 'AUCUNE'
                if (vali .eq. 1) valk = 'MANUEL'
                if (vali .eq. 2) valk = 'AUTO'
            else if (getset.eq.'E') then
                if (valk .eq. 'AUCUNE') then
                    v_sddisc_esur(SIZE_LESUR*(iechec-1)+1) = 0
                else if (valk .eq. 'MANUEL') then
                    v_sddisc_esur(SIZE_LESUR*(iechec-1)+1) = 1
                else if (valk .eq. 'AUTO') then
                    v_sddisc_esur(SIZE_LESUR*(iechec-1)+1) = 2
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'SUBD_METHODE_AUTO') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_esur(SIZE_LESUR*(iechec-1)+10))
                if (vali .eq. 1) valk = 'COLLISION'
                if (vali .eq. 2) valk = 'EXTRAPOLE'
            else if (getset.eq.'E') then
                if (valk .eq. 'COLLISION') then
                    v_sddisc_esur(SIZE_LESUR*(iechec-1)+10) = 1
                else if (valk .eq. 'EXTRAPOLE') then
                    v_sddisc_esur(SIZE_LESUR*(iechec-1)+10) =21
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'SUBD_PAS') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_esur(SIZE_LESUR*(iechec-1)+2))
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+2) = vali
            endif
        else if (question.eq.'SUBD_PAS_MINI') then
            if (getset .eq. 'L') then
                valr = v_sddisc_esur(SIZE_LESUR*(iechec-1)+3)
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+3) = valr
            endif
        else if (question.eq.'SUBD_NIVEAU') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_esur(SIZE_LESUR*(iechec-1)+4))
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+4) = vali
            endif
        else if (question.eq.'SUBD_INST') then
            if (getset .eq. 'L') then
                valr = v_sddisc_esur(SIZE_LESUR*(iechec-1)+5)
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+5) = valr
            endif
        else if (question.eq.'SUBD_DUREE') then
            if (getset .eq. 'L') then
                valr = v_sddisc_esur(SIZE_LESUR*(iechec-1)+6)
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+6) = valr
            endif
        else if (question.eq.'SUBD_RATIO') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_esur(SIZE_LESUR*(iechec-1)+9))
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+9) = vali
            endif
!
! ----- Parameters for ITER_SUPPL
!
        else if (question.eq.'PCENT_ITER_PLUS') then
            if (getset .eq. 'L') then
                valr = v_sddisc_esur(SIZE_LESUR*(iechec-1)+7)
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+7) = valr
            endif
!
! ----- Parameters for ADAPT_COEF_PENA
!
        else if (question.eq.'COEF_MAXI') then
            if (getset .eq. 'L') then
                valr = v_sddisc_esur(SIZE_LESUR*(iechec-1)+8)
            else if (getset.eq.'E') then
                v_sddisc_esur(SIZE_LESUR*(iechec-1)+8) = valr
            endif
!
! ----- Parameters for AUTRE_PILOTAGE
!
        else if (question.eq.'CHOIX_SOLU_PILO') then
            if (getset .eq. 'L') then
                vali = v_sddisc_epil(1)
                if (vali .eq. 1) valk = 'NATUREL'
                if (vali .eq. 2) valk = 'AUTRE'
            else if (getset.eq.'E') then
                if (valk .eq. 'NATUREL') then
                    v_sddisc_epil(1)=1
                else if (valk.eq.'AUTRE') then
                    v_sddisc_epil(1)=2
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'ESSAI_ITER_PILO') then
            if (getset .eq. 'L') then
                vali = v_sddisc_epil(2)
            else if (getset.eq.'E') then
                v_sddisc_epil(2) = vali
            endif
        else
            ASSERT(.false.)
        endif
!
! - Questions about ADAPTATION
!
    else if (ques_type.eq.'ADAP') then
        sddisc_aevr = sddisc(1:19)//'.AEVR'
        sddisc_atpr = sddisc(1:19)//'.ATPR'
        sddisc_atpk = sddisc(1:19)//'.ATPK'
        call jeveuo(sddisc_aevr, getset, vr   = v_sddisc_aevr)
        call jeveuo(sddisc_atpr, getset, vr   = v_sddisc_atpr)
        call jeveuo(sddisc_atpk, getset, vk16 = v_sddisc_atpk)
        iadapt = index_
        if (question .eq. 'NOM_EVEN') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+1))
                if (vali .eq. 0) valk = 'AUCUN'
                if (vali .eq. 1) valk = 'TOUT_INST'
                if (vali .eq. 2) valk = 'SEUIL_SANS_FORMU'
                if (vali .eq. 3) valk = 'SEUIL_AVEC_FORMU'
            else if (getset.eq.'E') then
                if (valk .eq. 'AUCUN') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+1) = 0
                else if (valk.eq.'TOUT_INST') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+1) = 1
                else if (valk.eq.'SEUIL_SANS_FORMU') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+1) = 2
                else if (valk.eq.'SEUIL_AVEC_FORMU') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+1) = 3
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'NB_INCR_SEUIL') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+2))
            else if (getset.eq.'E') then
                v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+2) = 1
            endif
        else if (question.eq.'NOM_PARA') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+3))
                if (vali .eq. 1) valk = 'NB_ITER_NEWT'
                if (vali .eq. 2) valk = 'DP'
            else if (getset.eq.'E') then
                if (valk .eq. 'NB_ITER_NEWT') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+3) = 1
                else if (valk.eq.'SEUIL_AVEC_FORMU') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+3) = 2
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'CRIT_COMP') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+4))
                if (vali .eq. 1) valk = 'LT'
                if (vali .eq. 2) valk = 'GT'
                if (vali .eq. 3) valk = 'LE'
                if (vali .eq. 4) valk = 'GE'
            else if (getset.eq.'E') then
                if (valk .eq. 'LT') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+4) = 1
                else if (valk.eq.'GT') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+4) = 2
                else if (valk.eq.'LE') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+4) = 3
                else if (valk.eq.'GE') then
                    v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+4) = 4
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'VALE') then
            if (getset .eq. 'L') then
                valr = v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+5)
                vali = nint(v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+5))
            else if (getset.eq.'E') then
                v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+5) = valr
            endif
        else if (question.eq.'NB_EVEN_OK') then
            if (getset .eq. 'L') then
                valr = v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+6)
                vali = nint(valr)
            else if (getset.eq.'E') then
                v_sddisc_aevr(SIZE_LAEVR*(iadapt-1)+6) = vali
            endif
        else if (question.eq.'METHODE') then
            if (getset .eq. 'L') then
                vali = nint(v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+1))
                if (vali .eq. 1) valk = 'FIXE'
                if (vali .eq. 2) valk = 'DELTA_GRANDEUR'
                if (vali .eq. 3) valk = 'ITER_NEWTON'
                if (vali .eq. 4) valk = 'FORMULE'
                if (vali .eq. 5) valk = 'IMPLEX'
            else if (getset.eq.'E') then
                if (valk .eq. 'FIXE') then
                    v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+1) = 1
                else if (valk.eq.'DELTA_GRANDEUR') then
                    v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+1) = 2
                else if (valk.eq.'ITER_NEWTON') then
                    v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+1) = 3
                else if (valk.eq.'FORMULE') then
                    v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+1) = 4
                else if (valk.eq.'IMPLEX') then
                    v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+1) = 5
                else
                    ASSERT(.false.)
                endif
            endif
        else if (question.eq.'PCENT_AUGM') then
            if (getset .eq. 'L') then
                valr = v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+2)
            else if (getset.eq.'E') then
                v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+2) = valr
            endif
        else if (question.eq.'VALE_REF') then
            if (getset .eq. 'L') then
                valr = v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+3)
            else if (getset.eq.'E') then
                v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+3) = valr
            endif
        else if (question.eq.'NU_CMP') then
            if (getset .eq. 'L') then
                valr = v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+4)
                vali = nint(valr)
            else if (getset.eq.'E') then
                v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+4) = vali
            endif
        else if (question.eq.'NB_ITER_NEWTON_REF') then
            if (getset .eq. 'L') then
                valr = v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+5)
                vali = nint(valr)
            else if (getset.eq.'E') then
                v_sddisc_atpr(SIZE_LATPR*(iadapt-1)+5) = vali
            endif
        else if (question.eq.'NOM_CHAM') then
            if (getset .eq. 'L') then
                valk = v_sddisc_atpk(SIZE_LATPK*(iadapt-1)+2)
            else if (getset.eq.'E') then
                v_sddisc_atpk(SIZE_LATPK*(iadapt-1)+2) = valk
            endif
        else if (question.eq.'NOM_CMP') then
            if (getset .eq. 'L') then
                valk = v_sddisc_atpk(SIZE_LATPK*(iadapt-1)+3)
            else if (getset.eq.'E') then
                v_sddisc_atpk(SIZE_LATPK*(iadapt-1)+3) = valk
            endif
        else
            ASSERT(.false.)
        endif
    endif
!
    if (present(vali_)) then
        vali_ = vali
    endif
    if (present(valr_)) then
        valr_ = valr
    endif
    if (present(valk_)) then
        valk_ = valk
    endif
!        
end subroutine
