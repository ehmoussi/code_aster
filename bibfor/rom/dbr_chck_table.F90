! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine dbr_chck_table(tablNameZ, nb_mode_in, nb_snap_in)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/tbGetListPara.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/tbexve.h"
#include "asterfort/jeveuo.h"
!
character(len=*), intent(in) :: tablNameZ
integer, intent(in) :: nb_mode_in, nb_snap_in
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Some checks for POD methods
!
! Check conformity of user table for reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
! In  tablNameZ        : name of table
! In  nb_mode_in       : number of modes in empiric base
! In  nb_snap_in       : number of snap in empiric base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbPara, tablNbLine, nbMode, nbSnap
    integer :: iPara, iLine
    character(len=24), pointer :: paraName(:) => null()
    character(len=24), pointer :: paraType(:) => null()
    integer, parameter :: nbParaRequired = 5
    character(len=24), parameter :: paraNameRequired(nbParaRequired) = (/&
                                                     'COOR_REDUIT','INST       ',&
                                                     'NUME_MODE  ','NUME_ORDRE ',&
                                                     'NUME_SNAP  '/)
    character(len=8), parameter :: paraTypeRequired(nbParaRequired) = (/&
                                                     'R','R',&
                                                     'I','I',&
                                                     'I'/)
    integer, pointer :: snapNume(:) => null()
    integer :: nbVale
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','ROM5_80')
    endif
!
! - Get parameters in existing table
!
    call tbGetListPara(tablNameZ, nbPara, paraName, paraType, tablNbLine)
!
! - Check number of parameters
!
    if (nbPara .ne. nbParaRequired) then
        call utmess('F', 'ROM7_27')
    endif
!
! - Check name/type of parameters
!
    do iPara = 1, nbPara
        if (paraName(iPara) .ne. paraNameRequired(iPara)) then
            call utmess('F', 'ROM7_27')
        endif
        if (paraType(iPara) .ne. paraTypeRequired(iPara)) then
            call utmess('F', 'ROM7_27')
        endif
    end do
    AS_DEALLOCATE(vk24 = paraType)
    AS_DEALLOCATE(vk24 = paraName)
!
! - Number of lines
!
    if (tablNbLine .eq. 0) then
        call utmess('F', 'ROM7_28')
    endif
!
! - Get number of snapshots
!
    call tbexve(tablNameZ, 'NUME_SNAP', '&&NUMESNAP', 'V', nbVale)
    call jeveuo('&&NUMESNAP', 'E', vi = snapNume)
    nbSnap = 0
    do iLine = 1, tablNbLine
        if (snapNume(iLine) .gt. nbSnap) then
            nbSnap = snapNume(iLine)
        endif
    end do
!
! - Check number of snapshots
!
    if (nbSnap .ne. nb_snap_in) then
        call utmess('F', 'ROM7_29')
    endif
!
! - Check number of modes
!
    nbMode = tablNbLine / nbSnap
    if (nbMode .ne. nb_mode_in) then
        call utmess('F', 'ROM7_30')
    endif
!
end subroutine
