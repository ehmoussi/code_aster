! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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
! person_in_charge: sylvie.granet at edf.fr
! aslint: disable=W1504
!
subroutine calcco(l_steady,&
                  option  , angl_naut,&
                  j_mater ,&
                  ndim    , nbvari   ,&
                  dimdef  , dimcon   ,&
                  adcome  , adcote   , adcp11, adcp12, adcp21, adcp22,&
                  addeme  , addete   , addep1, addep2,&
                  temp    , p1       , p2    ,&
                  dtemp   , dp1      , dp2   ,&
                  deps    , epsv     , depsv ,&
                  tbiot   ,&
                  phi     , rho11    , satur ,&
                  pad     , pvp      , h11   , h12   ,&
                  congem  , congep   ,&
                  vintm   , vintp    , dsde  ,& 
                  retcom)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/thmCpl010.h"
#include "asterfort/thmCpl009.h"
#include "asterfort/thmCpl001.h"
#include "asterfort/thmCpl002.h"
#include "asterfort/thmCpl003.h"
#include "asterfort/thmCpl004.h"
#include "asterfort/thmCpl005.h"
#include "asterfort/thmCpl006.h"
#include "asterfort/thmGetParaCoupling.h"
#include "asterfort/THM_type.h"
!
aster_logical, intent(in) :: l_steady
character(len=16), intent(in) :: option
real(kind=8), intent(in) :: angl_naut(3)
integer, intent(in) :: j_mater, ndim, nbvari
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: adcome, adcote, adcp11, adcp12, adcp21, adcp22
integer, intent(in) :: addeme, addete, addep1, addep2
real(kind=8), intent(in) :: temp, p1, p2
real(kind=8), intent(in) :: dtemp, dp1, dp2
real(kind=8), intent(in) :: epsv, depsv, deps(6), tbiot(6)
real(kind=8), intent(out) :: phi, rho11, satur
real(kind=8), intent(out) :: pad, pvp, h11, h12
real(kind=8), intent(in) :: congem(dimcon)
real(kind=8), intent(inout) :: congep(dimcon)
real(kind=8), intent(in) :: vintm(nbvari)
real(kind=8), intent(inout) :: vintp(nbvari)
real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
integer, intent(out)  :: retcom
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute generalized stresses and matrix for coupled quantities
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  l_steady         : .true. for no-transient problem
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  j_mater          : coded material address
! In  ndim             : dimension of space (2 or 3)
! In  nbvari           : total number of internal state variables
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  adcome           : adress of mechanic components in generalized stresses vector
! In  adcote           : adress of thermic components in generalized stresses vector
! In  adcp11           : adress of first component and first phase in generalized stresses vector
! In  adcp12           : adress of first component and second phase in generalized stresses vector
! In  adcp21           : adress of second component and first phase in generalized stresses vector
! In  adcp22           : adress of second component and second phase in generalized stresses vector
! In  addeme           : adress of mechanic components in generalized strains vector
! In  addete           : adress of thermic components in generalized strains vector
! In  addep1           : adress of capillary pressure in generalized strains vector
! In  addep2           : adress of gaz pressure in generalized strains vector
! In  temp             : temperature at end of current time step
! In  p1               : capillary pressure at end of current time step
! In  p2               : gaz pressure at end of current time step
! In  dtemp            : increment of temperature
! In  dp1              : increment of capillary pressure
! In  dp2              : increment of gaz pressure
! In  deps             : increment of mechanical strains vector
! In  epsv             : current volumic strain
! In  depsv            : increment of volumic strain
! In  tbiot            : Biot tensor
! Out phi              : porosity
! Out rho11            : volumic mass for liquid
! Out satur            : saturation
! Out pad              : dissolved air pressure
! Out pvp              : steam pressure
! Out h11              : enthalpy of liquid
! Out h12              : enthalpy of steam
! In  congem           : generalized stresses - At begin of current step
! IO  congep           : generalized stresses - At end of current step
! In  vintm            : internal state variables - At begin of current step
! IO  vintp            : internal state variables - At end of current step
! IO  dsde             : derivative matrix
! Out retcom           : return code for error
!
! --------------------------------------------------------------------------------------------------
!
    integer :: bdcp11
!
! --------------------------------------------------------------------------------------------------
!
    phi    = 0.d0
    rho11  = 0.d0
    satur  = 0.d0
    pvp    = 0.d0
    h11    = 0.d0
    h12    = 0.d0
    retcom = 0
!
    if (l_steady) then
        bdcp11 = adcp11 - 1
    else
        bdcp11 = adcp11
    endif
!
! - Get parameters for coupling
!
    call thmGetParaCoupling(j_mater, temp)
!
! - Compute
!
    select case (ds_thm%ds_behaviour%nume_thmc)
    case (LIQU_SATU)
        call thmCpl001(l_steady, option, angl_naut,&
                       ndim    , nbvari, &
                       dimdef  , dimcon,&
                       adcome  , adcote, bdcp11,& 
                       addeme  , addete, addep1,&
                       temp    ,&
                       dtemp   , dp1   ,&
                       deps    , epsv  , depsv,&
                       tbiot   ,&
                       phi     , rho11 , satur,&
                       congem  , congep,&
                       vintm   , vintp , dsde,&
                       retcom)
    case (GAZ)
        call thmCpl002(option, angl_naut,&
                       ndim  , nbvari, &
                       dimdef, dimcon,&
                       adcome, adcote, adcp11,& 
                       addeme, addete, addep1,&
                       temp  , p1    ,&
                       dtemp , dp1   ,&
                       deps  , epsv  , depsv,&
                       tbiot ,&
                       phi   , rho11 , satur,&
                       congem, congep,&
                       vintm , vintp , dsde,&
                       retcom)
    case (LIQU_VAPE)
        call thmCpl003(option, angl_naut,&
                       j_mater  ,&
                       ndim  , nbvari   ,&
                       dimdef, dimcon   ,&
                       adcote, adcp11   , adcp12, & 
                       addete, addep1   , &
                       temp  , p1       ,&
                       dtemp , dp1      ,&
                       deps  , epsv     , depsv ,&
                       tbiot ,&
                       phi   , rho11    , satur ,&
                       pvp   , h11      , h12   ,&
                       congem, congep   ,&       
                       vintm , vintp    , dsde  ,& 
                       retcom)
    case (LIQU_VAPE_GAZ)
        call thmCpl004(option, angl_naut,&
                       j_mater,&
                       ndim  , nbvari   ,&
                       dimdef, dimcon   ,&
                       adcome, adcote   , adcp11, adcp12, adcp21,&
                       addeme, addete   , addep1, addep2,&
                       temp  , p1       , p2    ,&
                       dtemp , dp1      , dp2   ,&
                       deps  , epsv     , depsv ,&
                       tbiot ,&
                       phi   , rho11    , satur ,&
                       pvp   , h11      , h12   ,&
                       congem, congep   ,&
                       vintm , vintp    , dsde  ,&
                       retcom)
    case (LIQU_GAZ)
        call thmCpl005(option, angl_naut,&
                       j_mater,&
                       ndim  , nbvari   ,&
                       dimdef, dimcon   ,&
                       adcome, adcote   , adcp11, adcp21,&
                       addeme, addete   , addep1, addep2,&
                       temp  , p1       , p2    ,&
                       dtemp , dp1      , dp2   ,&
                       deps  , epsv     , depsv ,&
                       tbiot ,&
                       phi   , rho11    , satur ,&
                       congem, congep   ,&
                       vintm , vintp    , dsde  ,&
                       retcom)
    case (LIQU_GAZ_ATM)
        call thmCpl006(option, angl_naut,&
                       j_mater,&
                       ndim  , nbvari   ,&
                       dimdef, dimcon   ,&
                       adcome, adcote   , adcp11,&
                       addeme, addete   , addep1,&
                       temp  , p1       ,&
                       dtemp , dp1      ,&
                       deps  , epsv     , depsv ,&
                       tbiot ,&
                       phi   , rho11    , satur ,&
                       congem, congep   ,&
                       vintm , vintp    , dsde  ,&
                       retcom)
    case (LIQU_AD_GAZ_VAPE)
        call thmCpl009(option   , angl_naut,&
                       j_mater  ,&
                       ndim     , nbvari   ,&
                       dimdef   , dimcon   ,&
                       adcome   , adcote   , adcp11, adcp12, adcp21, adcp22,&
                       addeme   , addete   , addep1, addep2,&
                       temp     , p1       , p2    ,&
                       dtemp    , dp1      , dp2   ,&
                       deps     , epsv     , depsv ,&
                       tbiot    ,&
                       phi      , rho11    , satur ,&
                       pad      , pvp      , h11   , h12   ,&
                       congem   , congep   ,&
                       vintm    , vintp    , dsde  ,&
                       retcom)
    case (LIQU_AD_GAZ)
        call thmCpl010(option   , angl_naut,&
                       j_mater  ,&
                       ndim     , nbvari   ,&
                       dimdef   , dimcon   ,&
                       adcome   , adcote   , adcp11, adcp12, adcp21, adcp22,&
                       addeme   , addete   , addep1, addep2,&
                       temp     , p1       , p2    ,&
                       dtemp    , dp1      , dp2   ,&
                       deps     , epsv     , depsv ,&
                       tbiot    ,&
                       phi      , rho11    , satur ,&
                       pad      , pvp      , h11   , h12   ,&
                       congem   , congep   ,&
                       vintm    , vintp    , dsde  ,&
                       retcom)
    case default
        ASSERT(ASTER_FALSE)
    end select
!
end subroutine
