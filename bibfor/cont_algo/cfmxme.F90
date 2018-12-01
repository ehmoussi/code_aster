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
subroutine cfmxme(nume_dof, sddyna, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/dismoi.h"
#include "asterfort/infdbg.h"
#include "asterfort/mm_cycl_crsd.h"
#include "asterfort/mm_pene_crsd.h"
#include "asterfort/mm_cycl_init.h"
#include "asterfort/ndynlo.h"
#include "asterfort/utmess.h"
#include "asterfort/vtcreb.h"
#include "asterfort/wkvect.h"
!
character(len=24), intent(in) :: nume_dof
character(len=19), intent(in) :: sddyna
type(NL_DS_Contact), intent(inout) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue method - Create datastructures for CONTINUE method
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_dof         : name of numbering object (NUME_DDL)
! In  sddyna           : name of dynamic solving datastructure
! IO  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nt_cont_poin
    aster_logical :: l_dyna, l_cont_node
    character(len=24) :: sdcont_etatct
    real(kind=8), pointer :: v_sdcont_etatct(:) => null()
    character(len=24) :: sdcont_tabfin
    real(kind=8), pointer :: v_sdcont_tabfin(:) => null()
    character(len=24) :: sdcont_apjeu
    real(kind=8), pointer :: v_sdcont_apjeu(:) => null()
    character(len=24) :: sdcont_vitini, sdcont_accini
    integer :: ztabf, zetat
    aster_logical :: l_pena_cont, l_fric
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('CONTACT', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','CONTACT5_5')
    endif
!
! - Get parameters
!
    nt_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC')
    l_pena_cont  = cfdisl(ds_contact%sdcont_defi,'EXIS_PENA')
    l_fric       = cfdisl(ds_contact%sdcont_defi,'FROTTEMENT')
    l_cont_node  = ds_contact%l_cont_node
    l_dyna       = ndynlo(sddyna,'DYNAMIQUE')
!
! - Create datastructure for general informations about contact
!
    sdcont_tabfin = ds_contact%sdcont_solv(1:14)//'.TABFIN'
    ztabf = cfmmvd('ZTABF')
    call wkvect(sdcont_tabfin, 'V V R', ztabf*nt_cont_poin+1, vr = v_sdcont_tabfin)
    v_sdcont_tabfin(1) = nt_cont_poin
!
! - Create fields for dynamic management
!
    if (l_dyna) then
        sdcont_vitini = ds_contact%sdcont_solv(1:14)//'.VITI'
        sdcont_accini = ds_contact%sdcont_solv(1:14)//'.ACCI'
        call vtcreb(sdcont_vitini, 'V', 'R', nume_ddlz = nume_dof)
        call vtcreb(sdcont_accini, 'V', 'R', nume_ddlz = nume_dof)
    endif
!
! - Create datastructure to save contact states (step cutting management)
!
    zetat         = cfmmvd('ZETAT')
    sdcont_etatct = ds_contact%sdcont_solv(1:14)//'.ETATCT'
    call wkvect(sdcont_etatct, 'V V R', zetat*nt_cont_poin, vr = v_sdcont_etatct)
!
! - Create datastructure for cycling detection and treatment
!
    call mm_cycl_crsd(ds_contact)
    call mm_cycl_init(ds_contact)
!
! - Create datastructure for penetration management detection and treatment
!
    if (l_pena_cont) then 
        call mm_pene_crsd(ds_contact)
    endif
!
! - Create datastructure to save gaps
!
    sdcont_apjeu = ds_contact%sdcont_solv(1:14)//'.APJEU'
    call wkvect(sdcont_apjeu, 'V V R', nt_cont_poin, vr = v_sdcont_apjeu)
!
! - Warning if not node integration (=> no CONT_NOEU)
!
    if (.not.l_cont_node) then
        call utmess('A', 'CONTACT3_16')
    endif
!
! - Forces to solve
!
    call vtcreb(ds_contact%cneltc, 'V', 'R', nume_ddlz = nume_dof)
    ds_contact%l_cneltc = ASTER_TRUE
    if (l_fric) then
        call vtcreb(ds_contact%cneltf, 'V', 'R', nume_ddlz = nume_dof)
        ds_contact%l_cneltf = ASTER_TRUE
    endif
!
end subroutine
