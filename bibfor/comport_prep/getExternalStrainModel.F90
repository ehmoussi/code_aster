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
subroutine getExternalStrainModel(l_mfront_offi, l_mfront_proto, comp_exte,&
                                  defo_comp    , istrainexte)
!
use Behaviour_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/Behaviour_type.h"
!
aster_logical, intent(in) :: l_mfront_offi
aster_logical, intent(in) :: l_mfront_proto
type(Behaviour_External), intent(in) :: comp_exte
character(len=16), intent(in) :: defo_comp
integer, intent(out) :: istrainexte
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get model of strains for external programs (MFRONT/UMAT)
!
! --------------------------------------------------------------------------------------------------
!
! In  l_mfront_proto   : .true. if MFront prototype
! In  l_mfront_offi    : .true. if MFront official
! In  comp_exte        : values defining external behaviour
! In  defo_comp        : DEFORMATION comportment
! Out istrainexte      : model of (large) strains
!                        0 - MFront is small strains
!                        1 - MFront use F (SIMO_MIEHE)
!                        1 - MFront use F (SIMO_MIEHE)

!
! --------------------------------------------------------------------------------------------------
!
    integer :: strain_model
!
! --------------------------------------------------------------------------------------------------
!
    strain_model = comp_exte%strain_model
    istrainexte  = 0
!
    if (l_mfront_offi .or. l_mfront_proto) then
! ----- Check compatibility
        if (strain_model .eq. MFRONT_STRAIN_SMALL) then
            if (defo_comp .ne. 'PETIT' .and.&
                defo_comp .ne. 'PETIT_REAC' .and.&
                defo_comp .ne. 'GDEF_LOG' .and.&
                defo_comp .ne. 'GROT_GDEP' ) then
                call utmess('F', 'COMPOR4_35', sk = defo_comp)
            endif
        endif
        if (strain_model .eq. MFRONT_STRAIN_SIMOMIEHE) then
            if (defo_comp .ne. 'SIMO_MIEHE' ) then
                call utmess('F', 'COMPOR4_35', sk = defo_comp)
            endif
        endif
        if (strain_model .eq. MFRONT_STRAIN_GROTGDEP) then
            if (defo_comp .ne. 'GROT_GDEP' .and.&
                defo_comp .ne. 'PETIT' ) then
                call utmess('F', 'COMPOR4_35', sk = defo_comp)
            endif
        endif
! ----- Indicator for large strains
        istrainexte = MFRONT_STRAIN_SMALL
        if (strain_model .eq. MFRONT_STRAIN_SIMOMIEHE ) then
            istrainexte = MFRONT_STRAIN_SIMOMIEHE
        endif
        if (strain_model .eq. MFRONT_STRAIN_GROTGDEP) then
            if (defo_comp .eq. 'PETIT' ) then
                istrainexte = MFRONT_STRAIN_GROTGDEP_S
            elseif (defo_comp .eq. 'GROT_GDEP') then
                istrainexte = MFRONT_STRAIN_GROTGDEP_L
            else
                ASSERT(ASTER_FALSE)
            endif
        endif  
    endif
!
end subroutine
