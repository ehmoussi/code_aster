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
subroutine thmFlh003(option, ndim  , j_mater,&
                     dimdef, dimcon,&
                     addep1, adcp11, adcp12, addeme, addete,&
                     t     , p2    , pvp,&
                     grap1 , grat  ,&
                     rho11 , h11   , h12    ,&
                     satur , dsatur, gravity, tperm,&
                     congep, dsde  )
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
!
character(len=16), intent(in) :: option
integer, intent(in) :: ndim, j_mater
integer, intent(in) :: dimdef, dimcon
integer, intent(in) :: addep1, adcp11, adcp12, addeme, addete
real(kind=8), intent(in) :: rho11, h11, h12
real(kind=8), intent(in) :: t, p2, pvp
real(kind=8), intent(in) :: grap1(3), grat(3)
real(kind=8), intent(in) :: satur, dsatur, gravity(3), tperm(ndim, ndim)
real(kind=8), intent(inout) :: congep(1:dimcon)
real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute flux and stress for hydraulic - 'LIQU_VAPE'
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  ndim             : dimension of space (2 or 3)
! In  j_mater          : coded material address
! In  dimdef           : dimension of generalized strains vector
! In  dimcon           : dimension of generalized stresses vector
! In  addeme           : adress of mechanic dof in vector of generalized strains
! In  addete           : adress of thermic dof in vector of generalized strains
! In  addep1           : adress of first hydraulic dof in vector of generalized strains
! In  adcp11           : adress of first hydraulic/first component dof in vector of gene. stresses
! In  adcp12           : adress of first hydraulic/second component dof in vector of gene. stresses
! In  t                : temperature - At end of current step
! In  p1               : capillary pressure - At end of current step
! In  pvp              : steam pressure
! In  grap1            : gradient of capillary pressure
! In  grat             : gradient of temperature
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
    integer :: i, j, k 
    real(kind=8) :: rgaz
    real(kind=8) :: krel2, dkr2s, dkr2p
    real(kind=8) :: permli, dperml, permgz, dperms, dpermp
    real(kind=8) :: cliq, alpliq
    real(kind=8) :: viscl, dviscl, viscg, dviscg
    real(kind=8) :: mamolv
    real(kind=8) :: lambd1(5), lambd2(5)
    real(kind=8) :: krel1, dkrel1, rho12
    real(kind=8) :: gp(3)
    real(kind=8) :: dp12p1, dp12t
    real(kind=8) :: dr11p1, dr11t
    real(kind=8) :: dr12p1, dr12t
    real(kind=8) :: dauxp1, dauxt
    real(kind=8) :: dgpvp1(3), dgpgp1(2), dgpgt(2), dgpvt(3)
!
! --------------------------------------------------------------------------------------------------
!
    dp12p1    = 0.d0
    dp12t     = 0.d0
    dr11p1    = 0.d0
    dr11t     = 0.d0
    dr12p1    = 0.d0
    dr12t     = 0.d0
    dauxp1    = 0.d0
    dauxt     = 0.d0
    dgpvp1(:) = 0.d0
    dgpgp1(:) = 0.d0
    dgpgt(:)  = 0.d0
    dgpvt(:)  = 0.d0
    lambd1(:) = 0.d0
    lambd2(:) = 0.d0
    gp(:)     = 0.d0
!
! - Evaluate permeability for liquid and gaz
!
    call thmEvalPermLiquGaz(j_mater, satur, p2, t,&
                            permli , dperml ,&
                            permgz , dperms , dpermp)
!
! - Get parameters
!
    krel1  = permli
    dkrel1 = dperml*dsatur
    krel2  = permgz
    dkr2s  = dperms
    dkr2p  = dpermp
    rgaz   = ds_thm%ds_material%solid%r_gaz
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    viscl  = ds_thm%ds_material%liquid%visc
    dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    mamolv = ds_thm%ds_material%steam%mass_mol
    viscg  = ds_thm%ds_material%steam%visc
    dviscg = ds_thm%ds_material%steam%dvisc_dtemp
    rho12  = mamolv*pvp/rgaz/t
!
! - Thermic conductivity
!
    lambd2(1) = krel2/viscg
    lambd2(2) = 0.0d0
    lambd2(3) = dkr2s*dsatur*(rho12/rho11-1.d0)/viscg
    lambd2(4) = dkr2p/viscg
    lambd2(5) = -krel2/viscg/viscg*dviscg+ dkr2s*dsatur*rho12*(h12-h11)/t/viscg
    lambd1(1) = krel1/viscl
    lambd1(2) = 0.0d0
    lambd1(3) = dkrel1*(rho12/rho11-1.d0)/viscl
    lambd1(4) = 0.0d0
    lambd1(5) = -krel1/viscl/viscl*dviscl+ dkrel1*rho12*(h12-h11)/t/viscl
!
! - Pressure gradient (Eq. 5.5.1-7)
!
    do i = 1, ndim
        gp(i) = rho12/rho11*grap1(i)
        if (ds_thm%ds_elem%l_dof_ther) then
            gp(i) = gp(i)+rho12*(h12-h11)/t*grat(i)
        endif
    end do
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dp12p1 = rho12/rho11
        if (ds_thm%ds_elem%l_dof_ther) then
            dp12t = rho12*(h12-h11)/t
        endif
    endif
!
! - Volumic mass - Derivative
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dr11p1 = rho11*cliq
        dr12p1 = rho12/pvp*dp12p1
        if (ds_thm%ds_elem%l_dof_ther) then
            dr11t  = -3.d0*alpliq*rho11
            dr12t  = rho12*(dp12t/pvp-1.d0/t)
            dauxp1 = (h12-h11)/t*dr12p1 +&
                     rho12/t*(dsde(adcp12+ndim+1,addep1)-dsde(adcp11+ndim+1,addep1))
            dauxt  = (h12-h11)/t*dr12t +&
                     rho12/t*(dsde(adcp12+ndim+1,addete)-dsde(adcp11+ndim+1,addete))-&
                     rho12*(h12-h11)/t/t
        endif
        do i = 1, ndim
            dgpvp1(i) = grap1(i)/rho11*dr12p1
            dgpvp1(i) = dgpvp1(i)-&
                        grap1(i)*rho12/rho11/rho11*dr11p1
            if (ds_thm%ds_elem%l_dof_ther) then
                dgpvp1(i) = dgpvp1(i)+&
                            dauxp1*grat(i)
                dgpvt(i)  = grap1(i)/rho11*dr12t+&
                            dauxt*grat(i)
                dgpvt(i)  = dgpvt(i)-&
                            grap1(i)*rho12/rho11/rho11*dr11t
            endif
            dgpgp1(1) = rho12/rho11
            if (ds_thm%ds_elem%l_dof_ther) then
                dgpgt(1) = rho12*(h12-h11)/t
            endif
        end do
    endif
!
! - Hydraulic flux
!
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
        do i = 1, ndim
            congep(adcp11+i) = 0.d0
            congep(adcp12+i) = 0.d0
            do j = 1, ndim
                congep(adcp11+i) = congep(adcp11+i)+&
                                   rho11*lambd1(1)*tperm(i,j)*(-grap1(j)+rho11*gravity(j))
                congep(adcp12+i) = congep(adcp12+i)+&
                                   rho12*lambd2(1)*tperm(i,j)*(-gp(j)+rho12*gravity(j))
            end do
        end do
    endif
!
! - Update matrix
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
        do i = 1, ndim
            do j = 1, ndim
                dsde(adcp11+i,addep1)   = dsde(adcp11+i,addep1)+&
                                          dr11p1*lambd1(1)*tperm(i,j)*(-grap1(j)+rho11*gravity(j))+&
                                          rho11*lambd1(1)*tperm(i,j)*(dr11p1*gravity(j))+&
                                          rho11*lambd1(3)*tperm(i,j)*(-grap1(j)+rho11*gravity(j))
                dsde(adcp11+i,addep1+j) = dsde(adcp11+i,addep1+j)-&
                                          rho11*lambd1(1)*tperm(i,j)
            end do
            do j = 1, ndim
                dsde(adcp12+i,addep1)   = dsde(adcp12+i,addep1)+&
                                          dr12p1*lambd2(1)*tperm(i,j)*(-gp(j)+rho12*gravity(j))
                dsde(adcp12+i,addep1)   = dsde(adcp12+i,addep1)+&
                                          rho12*lambd2(3)*tperm(i,j)*(-gp(j)+rho12*gravity(j))
                dsde(adcp12+i,addep1)   = dsde(adcp12+i,addep1)+&
                                          rho12*lambd2(1)*tperm(i,j)*(dr12p1*gravity(j))
                dsde(adcp12+i,addep1)   = dsde(adcp12+i,addep1)-&
                                          rho12*lambd2(1)*tperm(i,j)*dgpvp1(j)
                dsde(adcp12+i,addep1+j) = dsde(adcp12+i,addep1+j)-&
                                          rho12*lambd2(1)*tperm(i,j)*dgpgp1(1)
            end do
            if (ds_thm%ds_elem%l_dof_meca) then
                do j = 1, 3
                    do k = 1, ndim
                        dsde(adcp11+i,addeme+ndim-1+j) = &
                            dsde(adcp11+i,addeme+ndim-1+j)+&
                            rho11*lambd1(2)*tperm(i,k)*(-grap1(k)+rho11*gravity(k))
                        dsde(adcp12+i,addeme+ndim-1+j) = &
                            dsde(adcp12+i,addeme+ndim-1+j)+&
                            rho12*lambd2(2)*tperm(i,k)*(-gp(k)+rho12*gravity(k))
                    end do
                end do
            endif
            if (ds_thm%ds_elem%l_dof_ther) then
                do j = 1, ndim
                    dsde(adcp11+i,addete)   = &
                        dsde(adcp11+i,addete) +&
                        dr11t*lambd1(1)*tperm(i,j)*(-grap1(j)+rho11*gravity(j))+&
                        rho11*lambd1(5)*tperm(i,j)*(-grap1(j)+rho11*gravity(j))+&
                        rho11*lambd1(1)*tperm(i,j)*dr11t*gravity(j)
                    dsde(adcp12+i,addete)   = &
                        dsde(adcp12+i,addete) +&
                        dr12t*lambd2(1)*tperm(i,j)*(-gp(j)+rho12*gravity(j))
                    dsde(adcp12+i,addete)   = &
                        dsde(adcp12+i,addete) +&
                        rho12*lambd2(5)*tperm(i,j)*(-gp(j)+rho12*gravity(j))
                    dsde(adcp12+i,addete)   = &
                        dsde(adcp12+i,addete) +&
                        rho12*lambd2(1)*tperm(i,j)*(dr12t*gravity(j))
                    dsde(adcp12+i,addete)   = &
                        dsde(adcp12+i,addete) -&
                        rho12*lambd2(1)*tperm(i,j)*dgpvt(j)
                    dsde(adcp12+i,addete+j) = &
                        dsde(adcp12+i,addete+j) -&
                        rho12*lambd2(1)*tperm(i,j)*dgpgt(1)
                end do
            endif
        end do
    endif
!
end subroutine
