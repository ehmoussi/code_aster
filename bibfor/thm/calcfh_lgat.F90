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
subroutine calcfh_lgat(option, perman, hydr  , ndim  , j_mater,&
                       dimdef, dimcon,&
                       yamec , yate  ,&
                       addep1, adcp11,&
                       addeme, addete,&
                       t     , p2    ,&
                       grap1 , & 
                       rho11 , &
                       satur , dsatur, gravity, tperm,&
                       congep, dsde)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/thmEvalPermLiquGaz.h"
#include "asterfort/thmEvalFickSteam.h"
!
character(len=16), intent(in) :: option, hydr
aster_logical, intent(in) :: perman
integer, intent(in) :: j_mater
integer, intent(in) :: ndim, dimdef, dimcon, yamec, yate
integer, intent(in) :: addeme, addep1, addete, adcp11
real(kind=8), intent(in) :: rho11, satur, dsatur
real(kind=8), intent(in) :: grap1(3)
real(kind=8), intent(in) :: p2, t
real(kind=8), intent(in) :: gravity(3), tperm(ndim, ndim)
real(kind=8), intent(inout) :: congep(1:dimcon)
real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute flux and stress for hydraulic - 'LIQU_GAZ_ATM'
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  perman           : .flag. for no-transient problem
! In  hydr             : type of hydraulic law
! In  ndim             : dimension of space (2 or 3)
! In  j_mater          : coded material address
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  yamec            : flag for mechanic (1 of dof exist)
! In  yate             : flag for thermic (1 of dof exist)
! In  addep1           : adress of first hydraulic dof in vector and matrix (gene. quantities)
! In  adcp11           : adress of first component in vector of gen. stress for first phase
! In  addeme           : adress of mechanic dof in vector and matrix (generalized quantities)
! In  addete           : adress of thermic dof in vector and matrix (generalized quantities)
! In  t                : temperature - At end of current step
! In  p2               : second pressure - At end of current step
! In  grap1            : gradient of first pressure
! In  rho11            : current volumic mass of liquid
! In  satur            : saturation
! In  dsatur           : derivative of saturation (/pc)
! In  gravity          : gravity
! In  tperm            : permeability tensor
! IO  congep           : generalized stresses - At end of current step
! IO  dsde             : derivative matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i, j, k, bdcp11
    real(kind=8) :: permli, dperml
    real(kind=8) :: krel1, dkrel1
    real(kind=8) :: cliq, alpliq
    real(kind=8) :: viscl, dviscl
    real(kind=8) :: lambd1(5)
    real(kind=8) :: dr11p1, dr11t
!
! --------------------------------------------------------------------------------------------------
!
    dr11p1    = 0.d0 
    dr11t     = 0.d0
    lambd1(:) = 0.d0
!
! - Evaluate permeability for liquid and gaz
!
    call thmEvalPermLiquGaz(hydr  , j_mater, satur, p2, t,&
                            permli, dperml )
!
! - Get parameters
!
    krel1  = permli
    dkrel1 = dperml*dsatur
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    viscl  = ds_thm%ds_material%liquid%visc
    dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
!
! - Adress
!
    if (perman) then
        bdcp11 = adcp11-1
    else
        bdcp11 = adcp11
    endif
!
! - Thermic conductivity
!
    lambd1(1) = krel1/viscl
    lambd1(2) = 0.d0
    lambd1(3) = dkrel1/viscl
    lambd1(4) = 0.d0
    lambd1(5) = -krel1/viscl/viscl*dviscl
!
! - Volumic mass - Derivative
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dr11p1 = -rho11*cliq
        if (yate .eq. 1) then
            dr11t = -3.d0*alpliq*rho11
        endif
    endif
!
! - Hydraulic flux
!
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
        do i = 1, ndim
            congep(bdcp11+i) = 0.d0
            do j = 1, ndim
                congep(bdcp11+i) = congep(bdcp11+i)+&
                    rho11*lambd1(1)*tperm(i,j)*(grap1(j)+rho11*gravity(j))
            end do
        end do
    endif
!
! - Update matrix
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
        do i = 1, ndim
            do j = 1, ndim
                dsde(bdcp11+i,addep1)   = dsde(bdcp11+i,addep1) +&
                    dr11p1*lambd1(1)*tperm(i,j)*(grap1(j)+rho11*gravity(j))
                dsde(bdcp11+i,addep1)   = dsde(bdcp11+i,addep1) +&
                    rho11*lambd1(3)*tperm(i,j)*(grap1(j)+rho11*gravity(j))
                dsde(bdcp11+i,addep1)   = dsde(bdcp11+i,addep1) +&
                    rho11*lambd1(1)*tperm(i,j)*(dr11p1*gravity(j))
                dsde(bdcp11+i,addep1+j) = dsde(bdcp11+i,addep1+j) +&
                    rho11*lambd1(1)*tperm(i,j)
            end do
            if (yamec .eq. 1) then
                do j = 1, 3
                    do k = 1, ndim
                        dsde(bdcp11+i,addeme+ndim-1+i) = dsde(bdcp11+i,addeme+ndim-1+i)+&
                            rho11*lambd1(2)*tperm(i,k)*(grap1(k)+rho11*gravity(k))
                    end do
                end do
            endif
            if (yate .eq. 1) then
                do j = 1, ndim
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete) +&
                        dr11t*lambd1(1)*tperm(i,j)*(grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete) +&
                        rho11*lambd1(5)*tperm(i,j)*(grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete) +&
                        rho11*lambd1(1)*tperm(i,j)*(dr11t*gravity(j))
                end do
                
            endif
        end do
    endif
!
end subroutine
