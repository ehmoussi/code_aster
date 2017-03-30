subroutine op0054()
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/infmaj.h"
#include "asterfort/titre.h"
#include "asterfort/rrc_ini0.h"
#include "asterfort/rrc_read.h"
#include "asterfort/rrc_init.h"
#include "asterfort/rrc_chck.h"
#include "asterfort/rrc_comp.h"
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
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
!
!
! --------------------------------------------------------------------------------------------------
!
!   REST_REDUIT_COMPLET
!
! --------------------------------------------------------------------------------------------------
!
    type(ROM_DS_ParaRRC) :: ds_para
!
! --------------------------------------------------------------------------------------------------
!
    call titre()
    call infmaj()
!
! - Initialization of datastructures
!
    call rrc_ini0(ds_para)
!
! - Read parameters
!
    call rrc_read(ds_para)
!
! - Initializations
!
    call rrc_init(ds_para)
!
! - Check parameters
!
    call rrc_chck(ds_para)
!
! - Compute 
!
    call rrc_comp(ds_para)
!
end subroutine
