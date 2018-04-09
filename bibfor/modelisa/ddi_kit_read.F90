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
subroutine ddi_kit_read(keywordfact, iocc     , l_etat_init,&
                        rela_flua  , rela_plas, rela_cpla  , rela_coup)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/getvtx.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
    character(len=16), intent(in) :: keywordfact
    integer, intent(in) :: iocc
    aster_logical, intent(in) :: l_etat_init
    character(len=16), intent(out) :: rela_flua
    character(len=16), intent(out) :: rela_plas
    character(len=16), intent(out) :: rela_cpla
    character(len=16), intent(out) :: rela_coup
!
! --------------------------------------------------------------------------------------------------
!
! KIT_DDI
!
! Read informations for KIT
!
! --------------------------------------------------------------------------------------------------
!
! In  keywordfact      : factor keyword to read (COMPORTEMENT)
! In  iocc             : factor keyword index in COMPORTEMENT
! In  l_etat_init      : .true. if initial state is defined
! Out rela_flua        : comportment relation for fluage
! Out rela_plas        : comportment relation for plasticity
! Out rela_cpla        : comportment relation for plane stress (GLRC)
! Out rela_coup        : comportment relation for coupling (GLRC)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: dmflua, dmplas
    parameter  ( dmflua = 5, dmplas = 9)
    character(len=16) :: poflua(dmflua), poplas(dmplas)
    integer :: ikit, ii, nocc
    character(len=16) :: rela_kit(2)
!
! --------------------------------------------------------------------------------------------------
!
    data poflua / 'BETON_GRANGER'      ,'BETON_GRANGER_V'    ,        &
                  'BETON_UMLV'   ,'GLRC_DM'         ,'GLRC_DAMAGE'/
    data poplas / 'ELAS'            ,'VMIS_ISOT_TRAC'  ,'VMIS_ISOT_PUIS'  ,        &
                  'VMIS_ISOT_LINE'  ,'VMIS_CINE_LINE'  ,'ROUSS_PR'        ,        &
                  'BETON_DOUBLE_DP' ,'ENDO_ISOT_BETON' ,'MAZARS'/
!
! --------------------------------------------------------------------------------------------------
!
    rela_flua = 'VIDE'
    rela_plas = 'VIDE'
    rela_cpla = 'VIDE'
    rela_coup = 'VIDE'
!
! - Read command file
!
    call getvtx(keywordfact, 'RELATION_KIT', iocc = iocc, nbval = 0, nbret = nocc)
    nocc = -nocc
    ASSERT(nocc.le.2)
    call getvtx(keywordfact, 'RELATION_KIT', iocc = iocc, nbval = nocc, vect = rela_kit)
!
! - Get relations for kit
!
    do ikit = 1, nocc
!
! ----- Fluage
!
        do ii = 1, dmflua
            if (rela_kit(ikit) .eq. poflua(ii)) then
                rela_flua = rela_kit(ikit)
                cycle
            endif
        enddo
!
! ----- Elasto-plastic
!
        do ii = 1, dmplas
            if (rela_kit(ikit) .eq. poplas(ii)) then
                rela_plas = rela_kit(ikit)
                cycle
            endif
        enddo
    enddo
!
! - Compatibility
!
    if (rela_flua(1:13) .eq. 'BETON_GRANGER') then
        if (rela_plas .ne. 'ELAS' .and. rela_plas .ne. 'VMIS_ISOT_TRAC' .and. rela_plas&
            .ne. 'VMIS_ISOT_PUIS' .and. rela_plas .ne. 'VMIS_ISOT_LINE' .and. rela_plas&
            .ne. 'ROUSS_PR' .and. rela_plas .ne. 'BETON_DOUBLE_DP') then
            call utmess('F', 'COMPOR3_2', sk=rela_plas)
        endif
    else if (rela_flua.eq.'BETON_UMLV') then
        if (rela_plas .ne. 'ENDO_ISOT_BETON' .and. rela_plas .ne. 'MAZARS') then
            call utmess('F', 'COMPOR3_3', sk=rela_plas)
        endif
    else if (rela_flua(1:4).eq.'GLRC') then
        if (rela_plas .ne. 'VMIS_ISOT_TRAC' .and. rela_plas .ne. 'VMIS_ISOT_LINE' .and.&
            rela_plas .ne. 'VMIS_CINE_LINE') then
            call utmess('F', 'COMPOR3_4', sk=rela_plas)
        endif
    else
        call utmess('F', 'COMPOR3_6', sk=rela_flua)
    endif
!
! - For GLRC: internal Deborst Algorithm and special internal variables
!
    if (rela_flua(1:4) .eq. 'GLRC') then
        rela_coup = 'DDI_PLAS_ENDO'
        rela_cpla = 'DEBORST'
    endif
!
! - Alarm
!
    if (l_etat_init) then
        if (rela_flua .eq. 'BETON_UMLV') then
            if (rela_plas .eq. 'ENDO_ISOT_BETON' .or. rela_plas .eq. 'MAZARS') then
                call utmess('A', 'COMPOR3_83')
            endif
        endif
    endif
!
end subroutine
