subroutine dbr_paraRBDSInit(ds_multipara, ds_solveDOM, ds_solveROM, ds_para_rb)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
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
    type(ROM_DS_Solve), intent(in)       :: ds_solveDOM
    type(ROM_DS_Solve), intent(in)       :: ds_solveROM
    type(ROM_DS_MultiPara), intent(in)   :: ds_multipara
    type(ROM_DS_ParaDBR_RB), intent(out) :: ds_para_rb
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Initialization of datastructures for parameters - POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_solveDOM      : datastructure for datastructure to solve systems (DOM)
! In  ds_solveROM      : datastructure for datastructure to solve systems (ROM)
! In  ds_multipara     : datastructure for multiparametric problems
! Out ds_para_rb       : datastructure for RB parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_26')
    endif
!
! - General initialisations of datastructure
!
    ds_para_rb%coef_redu       = '&&OP0053.COEF_REDU'
    ds_para_rb%solver          = '&&OP0053.SOLVER'
    ds_para_rb%resi_type       = ' '
    ds_para_rb%resi_vect       = '&&OP0053.RESI_VECT'
    ds_para_rb%vect_2mbr_init  = '&&OP0053.2MBR_INIT'
    ds_para_rb%resi_norm       => null()
    ds_para_rb%resi_refe       = 0.d0
    ds_para_rb%multipara       = ds_multipara
    ds_para_rb%solveROM        = ds_solveROM
    ds_para_rb%solveDOM        = ds_solveDOM
!
end subroutine
