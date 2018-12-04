subroutine rcmfmc_wrap(chmatz, chmacz, l_thm_, l_ther_, basename, base)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rcmfmc.h"
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2018  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.

! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.

! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
    character(len=*), intent(in) :: chmatz
    character(len=*), intent(out) :: chmacz
    integer, intent(in) :: l_thm_, l_ther_
    character(len=*), intent(inout) :: basename
    character(len=1), intent(in), optional :: base
    aster_logical :: l_thm, l_ther
!
! --------------------------------------------------------------------------------------------------
!
    l_thm = l_thm_ .eq. 1
    l_ther = l_ther_ .eq. 1
    call rcmfmc(chmatz, chmacz, l_thm, l_ther, basename, base)

end subroutine
