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
subroutine calcfh(option, l_steady, ndim  , j_mater,&
                  dimdef, dimcon  ,&
                  addep1, addep2  ,&
                  adcp11, adcp12  , adcp21 , adcp22,&
                  addeme, addete  , &
                  t     , p1      , p2     , pvp   , pad,&
                  grat  , grap1   , grap2  ,& 
                  rho11 , h11     , h12    ,&
                  satur , dsatur  , gravity, tperm,&
                  congep, dsde)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/THM_type.h"
#include "asterfort/calcfh_gazp.h"
#include "asterfort/calcfh_lisa.h"
#include "asterfort/calcfh_liva.h"
#include "asterfort/calcfh_lvag.h"
#include "asterfort/calcfh_liga.h"
#include "asterfort/calcfh_lgat.h"
#include "asterfort/calcfh_lvga.h"
#include "asterfort/calcfh_ladg.h"
!
character(len=16), intent(in) :: option
aster_logical, intent(in) :: l_steady
integer, intent(in) :: j_mater
integer, intent(in) :: ndim, dimdef, dimcon
integer, intent(in) :: addeme, addep1, addep2, addete, adcp11, adcp12, adcp21, adcp22
real(kind=8), intent(in) :: rho11, satur, dsatur
real(kind=8), intent(in) :: grat(3), grap1(3), grap2(3)
real(kind=8), intent(in) :: t, p1, p2, pvp, pad
real(kind=8), intent(in) :: gravity(3), tperm(ndim, ndim)
real(kind=8), intent(in) :: h11, h12
real(kind=8), intent(inout) :: congep(1:dimcon)
real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute flux and stress for hydraulic
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  l_steady         : .flag. for no-transient problem
! In  ndim             : dimension of space (2 or 3)
! In  j_mater          : coded material address
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  addeme           : adress of mechanic dof in vector of generalized strains
! In  addete           : adress of thermic dof in vector of generalized strains
! In  addep1           : adress of first hydraulic dof in vector of generalized strains
! In  addep2           : adress of second hydraulic dof in vector of generalized strains
! In  adcp11           : adress of first hydraulic/first component dof in vector of gene. stresses
! In  adcp12           : adress of first hydraulic/second component dof in vector of gene. stresses
! In  adcp21           : adress of second hydraulic/first component dof in vector of gene. stresses
! In  adcp22           : adress of second hydraulic/second component dof in vector of gene. stresses
! In  t                : temperature - At end of current step
! In  p1               : capillary pressure - At end of current step
! In  p2               : gaz pressure - At end of current step
! In  pvp              : steam pressure
! In  pad              : dissolved air pressure
! In  grat             : gradient of temperature
! In  grap1            : gradient of capillary pressure
! In  grap2            : gradient of gaz pressure
! In  rho11            : volumic mass for liquid
! In  h11              : enthalpy of liquid
! In  h12              : enthalpy of steam
! In  satur            : saturation
! In  dsatur           : derivative of saturation (/pc)
! In  gravity          : gravity
! In  tperm            : permeability tensor
! IO  congep           : generalized stresses - At end of current step
! IO  dsde             : derivative matrix
!
! --------------------------------------------------------------------------------------------------
!
    select case (ds_thm%ds_behaviour%nume_thmc)
    case (1)
        call calcfh_lisa(option, l_steady, ndim,&
                         dimdef, dimcon,&
                         addep1, adcp11, addeme , addete,&
                         grap1 , rho11 , gravity, tperm ,&
                         congep, dsde  )
    case (2)
        call calcfh_gazp(option, l_steady , ndim,&
                         dimdef, dimcon ,&
                         addep1, adcp11 , addeme, addete,&
                         t     , p1     , grap1 ,&
                         rho11 , gravity, tperm ,&
                         congep, dsde)
    case (3)
        call calcfh_liva(option, ndim, j_mater,&
                         dimdef, dimcon,&
                         addep1, adcp11, adcp12, addeme, addete,&
                         t     , p2    , pvp,&
                         grap1 , grat  ,&
                         rho11 , h11   , h12    ,&
                         satur , dsatur, gravity, tperm,&
                         congep, dsde  )
    case (4)
        call calcfh_lvag(option, l_steady, ndim  , j_mater,&
                         dimdef, dimcon,&
                         addep1, addep2, adcp11 , adcp12, adcp21 ,&
                         addeme, addete, &
                         t     , p2    , pvp    ,&
                         grat  , grap1 , grap2  ,& 
                         rho11 , h11   , h12    ,&
                         satur , dsatur, gravity, tperm,&
                         congep, dsde)
    case (5)
        call calcfh_liga(option, ndim  , j_mater,&
                         dimdef, dimcon,&
                         addep1, addep2, adcp11 , adcp21 ,&
                         addeme, addete, &
                         t     , p2    , &
                         grap1 , grap2  ,& 
                         rho11 , &
                         satur , dsatur, gravity, tperm,&
                         congep, dsde)
    case (6)
        call calcfh_lgat(option, l_steady , ndim  , j_mater,&
                         dimdef, dimcon ,&
                         addep1, adcp11 ,&
                         addeme, addete ,&
                         t     , p2     ,&
                         grap1 , & 
                         rho11 , &
                         satur , dsatur , gravity , tperm,&
                         congep, dsde)
    case (9)
        call calcfh_lvga(option, l_steady, ndim  , j_mater,&
                         dimdef, dimcon,&
                         addep1, addep2, adcp11 , adcp12, adcp21 , adcp22,&
                         addeme, addete, &
                         t     , p1    , p2     , pvp   , pad,&
                         grat  , grap1 , grap2  ,& 
                         rho11 , h11   , h12    ,&
                         satur , dsatur, gravity, tperm,&
                         congep, dsde)
    case (10)
        call calcfh_ladg(option, l_steady, ndim  , j_mater,&
                         dimdef, dimcon,&
                         addep1, addep2, adcp11 , adcp12, adcp21 , adcp22,&
                         addeme, addete, &
                         t     , p1    , p2     , pvp   , pad,&
                         grat  , grap1 , grap2  ,& 
                         rho11 , h11   , h12    ,&
                         satur , dsatur, gravity, tperm,&
                         congep, dsde)
    case default
        ASSERT(ASTER_FALSE)
    end select
!
end subroutine
