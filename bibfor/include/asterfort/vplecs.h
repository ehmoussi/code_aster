! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

!
!
#include "asterf_types.h"
!
interface
    subroutine vplecs(eigsol, itemax_, maxitr_, nbborn_, nitv_,&
                  nborto_, nbvec2_, nbvect_, nbrss_, nfreq_,&
                  nperm_, alpha_, omecor_, freq1_, freq2_,&
                  precdc_, precsh_, prorto_, prsudg_, seuil_,&
                  tol_, toldyn_, tolsor_, appr_, arret_,&
                  method_, typevp_, matra_, matrb_, matrc_,&
                  modrig_, optiof_, stoper_, sturm_, typcal_, typeqz_,&
                  typres_, amor_, masse_, raide_, tabmod_,&
                  lc_, lkr_, lns_, lpg_, lqz_)
!                    
    character(len=19) , intent(in)    :: eigsol
!!
    integer, optional           , intent(out)   :: itemax_
    integer, optional           , intent(out)   :: maxitr_
    integer, optional           , intent(out)   :: nbborn_
    integer, optional           , intent(out)   :: nitv_
    integer, optional           , intent(out)   :: nborto_
    integer, optional           , intent(out)   :: nbvec2_
    integer, optional           , intent(out)   :: nbvect_
    integer, optional           , intent(out)   :: nbrss_
    integer, optional           , intent(out)   :: nfreq_
    integer, optional           , intent(out)   :: nperm_
!
    real(kind=8), optional      , intent(out)   :: alpha_
    real(kind=8), optional      , intent(out)   :: omecor_
    real(kind=8), optional      , intent(out)   :: freq1_
    real(kind=8), optional      , intent(out)   :: freq2_
    real(kind=8), optional      , intent(out)   :: precdc_
    real(kind=8), optional      , intent(out)   :: precsh_
    real(kind=8), optional      , intent(out)   :: prorto_
    real(kind=8), optional      , intent(out)   :: prsudg_
    real(kind=8), optional      , intent(out)   :: seuil_
    real(kind=8), optional      , intent(out)   :: tol_
    real(kind=8), optional      , intent(out)   :: toldyn_
    real(kind=8), optional      , intent(out)   :: tolsor_
!
    character(len=1), optional  , intent(out)   :: appr_
!
    character(len=8), optional  , intent(out)   :: arret_
    character(len=8), optional  , intent(out)   :: method_
!
    character(len=9), optional  , intent(out)   :: typevp_
!
    character(len=14), optional , intent(out)   :: matra_
    character(len=14), optional , intent(out)   :: matrb_
    character(len=14), optional , intent(out)   :: matrc_
!    
    character(len=16), optional , intent(out)   :: modrig_
    character(len=16), optional , intent(out)   :: optiof_
    character(len=16), optional , intent(out)   :: stoper_
    character(len=16), optional , intent(out)   :: sturm_
    character(len=16), optional , intent(out)   :: typcal_
    character(len=16), optional , intent(out)   :: typeqz_
    character(len=16), optional , intent(out)   :: typres_
!
    character(len=19), optional , intent(out)   :: amor_
    character(len=19), optional , intent(out)   :: masse_
    character(len=19), optional , intent(out)   :: raide_
    character(len=19), optional , intent(out)   :: tabmod_ 
!
    aster_logical, optional, intent(out)  :: lc_
    aster_logical, optional, intent(out)  :: lkr_
    aster_logical, optional, intent(out)  :: lns_
    aster_logical, optional, intent(out)  :: lpg_
    aster_logical, optional, intent(out)  :: lqz_
!    
    end subroutine vplecs
end interface
