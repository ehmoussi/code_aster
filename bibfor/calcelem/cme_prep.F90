subroutine cme_prep(option, model, time_curr, time_incr, chtime)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/mecact.h"
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
    character(len=16), intent(in) :: option
    character(len=8), intent(in) :: model
    real(kind=8), intent(in) :: time_curr
    real(kind=8), intent(in) :: time_incr
    character(len=24), intent(out) :: chtime
!
! --------------------------------------------------------------------------------------------------
!
! CALC_MATR_ELEM
!
! Preparation
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  model            : name of the model
! In  time_curr        : current time
! In  time_incr        : time step
! Out chtime           : time parameters (field)
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_cmp = 6
    character(len=8), parameter :: list_cmp(nb_cmp) = (/'INST    ','DELTAT  ','THETA   ',&
                                                        'KHI     ','R       ','RHO     '/)
    real(kind=8) :: list_vale(nb_cmp)   = (/0.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
!
! --------------------------------------------------------------------------------------------------
!
    chtime       = '&&CHTIME'
    list_vale(1) = time_curr
    list_vale(2) = time_incr
!
    if ((option.eq.'RIGI_THER') .or. (option.eq.'MASS_THER')) then
        call mecact('V', chtime, 'MODELE', model//'.MODELE', 'INST_R',&
                    ncmp=nb_cmp, lnomcmp=list_cmp, vr=list_vale)
    endif
!
end subroutine
