subroutine dbr_para_info(ds_para)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/dbr_para_info_pod.h"
#include "asterfort/dbr_para_info_rb.h"
#include "asterfort/romBaseInfo.h"
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
! person_in_charge: mickael.abbas at edf.fr
!
    type(ROM_DS_ParaDBR), intent(in) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Informations about DEFI_BASE_REDUITE parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    character(len=16) :: operation = ' '
    character(len=8)  :: result_out = ' '
    integer :: nb_mode_maxi
    aster_logical :: l_reuse
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
!
! - Get parameters in datastructure - General for DBR
!
    operation    = ds_para%operation
    result_out   = ds_para%result_out
    nb_mode_maxi = ds_para%nb_mode_maxi
    l_reuse      = ds_para%l_reuse
!
! - Print - General for DBR
!
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_24')
        call utmess('I', 'ROM5_16', sk = operation)
        if (nb_mode_maxi .ne. 0) then
            call utmess('I', 'ROM5_17', si = nb_mode_maxi)
        endif
        if (l_reuse) then
            call utmess('I', 'ROM7_15', sk = result_out)
        else
            call utmess('I', 'ROM7_16')
        endif
    endif
!
! - Print about empiric base
!
    if (niv .ge. 2) then
        call romBaseInfo(ds_para%ds_empi)
    endif
!
! - Print / method
!
    if (operation(1:3) .eq. 'POD') then
        call dbr_para_info_pod(ds_para%para_pod)
        
    elseif (operation .eq. 'GLOUTON') then
        call dbr_para_info_rb(ds_para%para_rb)

    else
        ASSERT(.false.)
    endif
!
end subroutine
