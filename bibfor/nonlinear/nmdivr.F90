subroutine nmdivr(sddisc, sderro, iter_newt)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/nmcrel.h"
#include "asterfort/nmlere.h"
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2016  EDF R&D                  WWW.CODE-ASTER.ORG
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
    character(len=19), intent(in) :: sddisc
    character(len=24), intent(in) :: sderro
    integer, intent(in) :: iter_newt
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Events
!
! Check if RESI_GLOB_MAXI increase
!
! --------------------------------------------------------------------------------------------------
!
! EVALUATION DE LA DIVERGENCE DU RESIDU :
!    ON DIT QU'IL Y A DIVERGENCE DU RESIDU SSI :
!       MIN[ R(I), R(I-1) ] > R(I-2), A PARTIR DE I=3 (COMME ABAQUS)
!
!    OU R(I)   EST LE RESIDU A L'ITERATION COURANTE
!       R(I-1) EST LE RESIDU A L'ITERATION MOINS 1
!       R(I-2) EST LE RESIDU A L'ITERATION MOINS 2
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for discretization
! In  sderro           : datastructure for error management (events)
! In  iter_newt        : index of current Newton iteration
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: r(1), rm1(1), rm2(1)
    aster_logical :: l_resi_dive
!
! --------------------------------------------------------------------------------------------------
!
    l_resi_dive = .false.
!
    if (iter_newt .ge. 3) then
!
! ----- Get RESI_GLOB_MAXI
!
        call nmlere(sddisc, 'L', 'VMAXI', iter_newt, r(1))
        call nmlere(sddisc, 'L', 'VMAXI', iter_newt-1, rm1(1))
        call nmlere(sddisc, 'L', 'VMAXI', iter_newt-2, rm2(1))
!
! ----- Check evolution of RESI_GLOB_MAXI
!
        if (min(r(1),rm1(1)) .gt. rm2(1)) then
            l_resi_dive = .true.
        endif
    endif
!
! - Save event
!
    call nmcrel(sderro, 'DIVE_RESI', l_resi_dive)
!
end subroutine
