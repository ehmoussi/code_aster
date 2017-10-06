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
subroutine thmFlh004(option, perman, ndim  , j_mater,&
                     dimdef, dimcon,&
                     addep1, addep2, adcp11, adcp12, adcp21 ,&
                     addeme, addete, &
                     t     , p2    , pvp    ,&
                     grat  , grap1 , grap2  ,& 
                     rho11 , h11   , h12    ,&
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
character(len=16), intent(in) :: option
aster_logical, intent(in) :: perman
integer, intent(in) :: j_mater
integer, intent(in) :: ndim, dimdef, dimcon
integer, intent(in) :: addeme, addep1, addep2, addete, adcp11, adcp12, adcp21
real(kind=8), intent(in) :: rho11, satur, dsatur
real(kind=8), intent(in) :: grat(3), grap1(3), grap2(3)
real(kind=8), intent(in) :: p2, pvp, t
real(kind=8), intent(in) :: gravity(3), tperm(ndim, ndim)
real(kind=8), intent(in) :: h11, h12
real(kind=8), intent(inout) :: congep(1:dimcon)
real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute flux and stress for hydraulic - 'LIQU_VAPE_GAZ'
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : option to compute
! In  perman           : .flag. for no-transient problem
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
! In  p2               : gaz pressure - At end of current step
! In  pvp              : steam pressure
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
    integer :: i, j, k, bdcp11
    real(kind=8) :: rgaz
    real(kind=8) :: permli, dperml
    real(kind=8) :: permgz, dperms, dpermp
    real(kind=8) :: dfickt, dfickg, krel2, fick
    real(kind=8) :: krel1, dkrel1, rho12, rho21, masrt
    real(kind=8) :: cliq, alpliq
    real(kind=8) :: viscl, dviscl, viscg, dviscg
    real(kind=8) :: mamolg, mamolv
    real(kind=8) :: lambd1(5), lambd2(5), fv(5)
    real(kind=8) :: cvp, gp(3), gc(3)
    real(kind=8) :: dp12p1, dp12p2, dp12t
    real(kind=8) :: dcvp1, dcvp2, dcvt
    real(kind=8) :: dr11p1, dr11p2, dr11t
    real(kind=8) :: dr12p1, dr12p2, dr12t
    real(kind=8) :: dr22t
    real(kind=8) :: dr21p1, dr21p2, dr21t
    real(kind=8) :: dauxp1, dauxp2, dauxt
    real(kind=8) :: dgpvp1(3), dgpvp2(3), dgpvt(3)
    real(kind=8) :: dgcvp1(3), dgcvp2(3), dgcvt(3)
    real(kind=8) :: dgpgt(2)
    real(kind=8) :: dgcgp1(2), dgcgp2(2), dgcgt(2)
    real(kind=8) :: dgpgp1(2), dgpgp2(2)
!
! --------------------------------------------------------------------------------------------------
!
    lambd1(:) = 0.d0
    lambd2(:) = 0.d0
    fv(:)     = 0.d0
    cvp       = 0.d0
    gp(:)     = 0.d0 
    gc(:)     = 0.d0
    dp12p1    = 0.d0
    dp12p2    = 0.d0
    dp12t     = 0.d0
    dcvp1     = 0.d0
    dcvp2     = 0.d0
    dcvt      = 0.d0
    dr11p1    = 0.d0
    dr11p2    = 0.d0
    dr11t     = 0.d0
    dr12p1    = 0.d0
    dr12p2    = 0.d0
    dr12t     = 0.d0
    dr22t     = 0.d0
    dr21p1    = 0.d0
    dr21p2    = 0.d0
    dr21t     = 0.d0
    dauxp1    = 0.d0
    dauxp2    = 0.d0
    dauxt     = 0.d0
    dgpvp1(:) = 0.d0
    dgpvp2(:) = 0.d0
    dgpvt(:)  = 0.d0
    dgcvp1(:) = 0.d0
    dgcvp2(:) = 0.d0
    dgcvt(:)  = 0.d0
    dgpgt(:)  = 0.d0
    dgcgp1(:) = 0.d0
    dgcgp2(:) = 0.d0
    dgcgt(:)  = 0.d0
    dgpgp1(:) = 0.d0
    dgpgp2(:) = 0.d0
!
! - Adress
!
    if (perman) then
        bdcp11 = adcp11-1
    else
        bdcp11 = adcp11
    endif
!
! - Evaluate permeability for liquid and gaz
!
    call thmEvalPermLiquGaz(j_mater, satur, p2, t,&
                            permli , dperml ,&
                            permgz , dperms , dpermp)
! 
! - Evaluate Fick coefficients for steam in gaz
!
    call thmEvalFickSteam(j_mater,&
                          satur, p2    , pvp   , t,&
                          fick , dfickt, dfickg)
!
! - Get parameters
!
    krel1  = permli
    dkrel1 = dperml*dsatur
    krel2  = permgz
    rgaz   = ds_thm%ds_material%solid%r_gaz
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    viscl  = ds_thm%ds_material%liquid%visc
    dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    mamolv = ds_thm%ds_material%steam%mass_mol
    viscg  = ds_thm%ds_material%steam%visc
    dviscg = ds_thm%ds_material%steam%dvisc_dtemp
    mamolg = ds_thm%ds_material%gaz%mass_mol
    rho12  = mamolv*pvp/rgaz/t
    rho21  = mamolg*(p2-pvp)/rgaz/t
    masrt  = mamolg/rgaz/t
    cvp    = pvp/p2
!
! - Fick
!
    fv(1) = fick
    fv(2) = 0.d0
    fv(3) = 0.d0
    fv(4) = dfickg
    fv(5) = dfickt
!
! - Thermic conductivity
!
    lambd2(1) = krel2/viscg
    lambd2(2) = 0.d0
    lambd2(3) = dperms*dsatur/viscg
    lambd2(4) = dpermp/viscg
    lambd2(5) = -krel2/viscg/viscg*dviscg
    lambd1(1) = krel1/viscl
    lambd1(2) = 0.d0
    lambd1(3) = dkrel1/viscl
    lambd1(4) = 0.d0
    lambd1(5) = -krel1/viscl/viscl*dviscl
!
! - Pressure gradient (Eq. 5.5.1-7)
!
    do i = 1, ndim
        gp(i) = rho12/rho11*(grap2(i)-grap1(i))
        if (ds_thm%ds_elem%l_dof_ther) then
            gp(i) = gp(i)+rho12*(h12-h11)/t*grat(i)
        endif
        gc(i) = gp(i)/p2-pvp/p2/p2*grap2(i)
    end do
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dp12p1 = -rho12/rho11
        dp12p2 = rho12/rho11
        if (ds_thm%ds_elem%l_dof_ther) then
            dp12t = rho12*(h12-h11)/t
        endif
        dcvp1 = dp12p1/p2
        dcvp2 = dp12p2/p2-pvp/p2/p2
        if (ds_thm%ds_elem%l_dof_ther) then
            dcvt = dp12t/p2
        endif
    endif
!
! - Volumic mass - Derivative
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dr11p1 = -rho11*cliq
        dr11p2 = rho11*cliq
        dr12p1 = rho12/pvp*dp12p1
        dr12p2 = rho12/pvp*dp12p2
        dr21p1 = masrt*(-dp12p1)
        dr21p2 = masrt*(1.d0-dp12p2)
        if (ds_thm%ds_elem%l_dof_ther) then
            dr11t = -3.d0*alpliq*rho11
            dr12t = rho12*(dp12t/pvp-1.d0/t)
            dr21t = -masrt*dp12t-rho21/t
            dauxp1 = (h12-h11)/t*dr12p1 +&
                     rho12/t*(dsde(adcp12+ndim+1,addep1)-&
                     dsde(adcp11+ndim+1,addep1))
            dauxp2 = (h12-h11)/t*dr12p2 +&
                     rho12/t*(dsde(adcp12+ndim+1,addep2)-&
                     dsde(adcp11+ndim+1,addep2))
            dauxt  = (h12-h11)/t*dr12t +&
                     rho12/t*(dsde(adcp12+ndim+1,addete)-&
                     dsde(adcp11+ndim+1,addete))-&
                     rho12*(h12-h11)/t/t
        endif
! ----- GRADPVP and GRADCVP - Derivative
        do i = 1, ndim
! --------- GRADPVP - Derivative
            dgpvp1(i) = (grap2(i)-grap1(i))/rho11*dr12p1
            dgpvp1(i) = dgpvp1(i)-(grap2(i)-grap1(i))*rho12/rho11/rho11*dr11p1
            dgpvp2(i) = (grap2(i)-grap1(i))/rho11*dr12p2
            dgpvp2(i) = dgpvp2(i)-(grap2(i)-grap1(i))*rho12/rho11/rho11*dr11p2
            if (ds_thm%ds_elem%l_dof_ther) then
                dgpvp1(i) = dgpvp1(i)+dauxp1*grat(i)
                dgpvp2(i) = dgpvp2(i)+dauxp2*grat(i)
                dgpvt(i)  = (grap2(i)-grap1(i))/rho11*dr12t+dauxt*grat(i)
                dgpvt(i)  = dgpvt(i)-(grap2(i)-grap1(i))*rho12/rho11/rho11*dr11t
            endif
            dgpgp1(1) = -rho12/rho11
            dgpgp2(1) = rho12/rho11
            if (ds_thm%ds_elem%l_dof_ther) then
                dgpgt(1)=rho12*(h12-h11)/t
            endif
! --------- GRADCVP - Derivative
            dgcvp1(i) = dgpvp1(i)/p2-grap2(i)/p2/p2*dp12p1
            dgcvp2(i) = dgpvp2(i)/p2-gp(i)/p2/p2-&
                        grap2(i)/p2/p2*dp12p2 +&
                        2.d0*pvp*grap2(i)/p2/p2/p2
            if (ds_thm%ds_elem%l_dof_ther) then
                dgcvt(i) = dgpvt(i)/p2-grap2(i)/p2/p2*dp12t
            endif
            dgcgp1(1) = dgpgp1(1)/p2
            dgcgp2(1) = dgpgp2(1)/p2-pvp/p2/p2
            if (ds_thm%ds_elem%l_dof_ther) then
                dgcgt(1) = dgpgt(1)/p2
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
            congep(adcp21+i) = 0.d0
            do j = 1, ndim
                congep(adcp11+i) = congep(adcp11+i)+&
                    rho11*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                congep(adcp12+i) = congep(adcp12+i)+&
                    rho12*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))-&
                    rho12*(1.d0-cvp)*fv(1)*gc(i)
                congep(adcp21+i) = congep(adcp21+i)+&
                    rho21*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))+&
                    rho21*cvp*fv(1)*gc(i)
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
                    dr11p1*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                dsde(adcp11+i,addep1)   = dsde(adcp11+i,addep1)+&
                    rho11*lambd1(3)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                dsde(adcp11+i,addep1)   = dsde(adcp11+i,addep1)+&
                    rho11*lambd1(1)*tperm(i,j)*(dr11p1*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    dr11p2*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    rho11*lambd1(4)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    rho11*lambd1(1)*tperm(i,j)*(dr11p2*gravity(j))
                dsde(adcp11+i,addep1+j) = dsde(adcp11+i,addep1+j)+&
                    rho11*lambd1(1)*tperm(i,j)
                dsde(adcp11+i,addep2+j) = dsde(adcp11+i,addep2+j)-&
                    rho11*lambd1(1)*tperm(i,j)
            end do
            do j = 1, ndim
                dsde(adcp12+i,addep1)   = dsde(adcp12+i,addep1)+&
                    dr12p1*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp12+i,addep1)   = dsde(adcp12+i,addep1)+&
                    rho12*lambd2(3)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp12+i,addep1)   = dsde(adcp12+i,addep1)+&
                    rho12*lambd2(1)*tperm(i,j)*((dr12p1+dr21p1)*gravity(j))
            end do
            dsde(adcp12+i,addep1) = dsde(adcp12+i,addep1)-&
                dr12p1*(1.d0-cvp)*fv(1)*gc(i)
            dsde(adcp12+i,addep1) = dsde(adcp12+i,addep1)+&
                rho12*dcvp1*fv(1)*gc(i)
            dsde(adcp12+i,addep1) = dsde(adcp12+i,addep1)-&
                rho12*(1.d0-cvp)*fv(3)*gc(i)
            dsde(adcp12+i,addep1)  =dsde(adcp12+i,addep1)-&
                rho12*(1.d0-cvp)*fv(1)*dgcvp1(i)
            do j = 1, ndim
                dsde(adcp12+i,addep2) = dsde(adcp12+i,addep2) +&
                    dr12p2*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp12+i,addep2) = dsde(adcp12+i,addep2) +&
                    rho12*lambd2(4)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp12+i,addep2) = dsde(adcp12+i,addep2) +&
                    rho12*lambd2(1)*tperm(i,j)*((dr12p2+dr21p2)*gravity(j))
            end do
            dsde(adcp12+i,addep2)   = dsde(adcp12+i,addep2)-&
                dr12p2*(1.d0-cvp)*fv(1)*gc(i)
            dsde(adcp12+i,addep2)   = dsde(adcp12+i,addep2)+&
                rho12*dcvp2*fv(1)*gc(i)
            dsde(adcp12+i,addep2)   = dsde(adcp12+i,addep2)-&
                rho12*(1.d0-cvp)*fv(4)*gc(i)
            dsde(adcp12+i,addep2)   = dsde(adcp12+i,addep2)-&
                rho12*(1.d0-cvp)*fv(1)*dgcvp2(i)
            dsde(adcp12+i,addep1+i) = dsde(adcp12+i,addep1+i)-&
                rho12*(1.d0-cvp)*fv(1)*dgcgp1(1)
            do j = 1, ndim
                dsde(adcp12+i,addep2+j) = dsde(adcp12+i,addep2+j)-&
                    rho12*lambd2(1)*tperm(i,j)
            end do
            dsde(adcp12+i,addep2+i) = dsde(adcp12+i,addep2+i)-&
                rho12*(1.d0-cvp)*fv(1)*dgcgp2(1)
            do j = 1, ndim
                dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                    dr21p1*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                    rho21*lambd2(3)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                    rho21*lambd2(1)*tperm(i,j)*((dr12p1+dr21p1)*gravity(j))
            end do
            dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                dr21p1*cvp*fv(1)*gc(i)
            dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                rho21*dcvp1*fv(1)*gc(i)
            dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                rho21*cvp*fv(3)*gc(i)
            dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                rho21*cvp*fv(1)*dgcvp1(i)
            do j = 1, ndim
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    dr21p2*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    rho21*lambd2(4)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    rho21*lambd2(1)*tperm(i,j)*((dr12p2+dr21p2)*gravity(j))
            end do
            dsde(adcp21+i,addep2)   = dsde(adcp21+i,addep2)+ &   
                dr21p2*cvp*fv(1)*gc(i)
            dsde(adcp21+i,addep2)   = dsde(adcp21+i,addep2)+&
                rho21*dcvp2*fv(1)*gc(i)
            dsde(adcp21+i,addep2)   = dsde(adcp21+i,addep2)+&
                rho21*cvp*fv(4)*gc(i)
            dsde(adcp21+i,addep2)   = dsde(adcp21+i,addep2)+&
                rho21*cvp*fv(1)*dgcvp2(i)
            dsde(adcp21+i,addep1+i) = dsde(adcp21+i,addep1+i)+&
                rho21*cvp*fv(1)*dgcgp1(1)
            do j = 1, ndim
                dsde(adcp21+i,addep2+j) = dsde(adcp21+i,addep2+j)-&
                    rho21*lambd2(1)*tperm(i,j)
            end do
            dsde(adcp21+i,addep2+i) = dsde(adcp21+i,addep2+i)+&
                rho21*cvp*fv(1)*dgcgp2(1)          
            if (ds_thm%ds_elem%l_dof_meca) then
                do j = 1, 3
                    do k = 1, ndim
                        dsde(adcp11+i,addeme+ndim-1+j)=&
                            dsde(adcp11+i,addeme+ndim-1+j)+&
                            rho11*lambd1(2)*tperm(i,k)*&
                            (-grap2(k)+grap1(k)+rho11*gravity(k))
                        dsde(adcp12+i,addeme+ndim-1+j)=&
                            dsde(adcp12+i,addeme+ndim-1+j)+&
                            rho12*lambd2(2)*tperm(i,k)*(-grap2(k)+(rho12+rho21)*gravity(k))
                    end do
                    dsde(adcp12+i,addeme+ndim-1+j) = dsde(adcp12+i,addeme+ndim-1+j)-&
                        rho12*(1.d0-cvp)*fv(2)*gc(i)
                    do k = 1, ndim
                        dsde(adcp21+i,addeme+ndim-1+j) =&
                            dsde(adcp21+i,addeme+ndim-1+j)+&
                            rho21*lambd2(2)*tperm(i,k)*(-grap2(k)+(rho12+rho21)*gravity(k))
                    end do
                    dsde(adcp21+i,addeme+ndim-1+j) = &
                        dsde(adcp21+i,addeme+ndim-1+j)+&
                        rho21*cvp*fv(2)*gc(i)   
                end do
            endif
            if (ds_thm%ds_elem%l_dof_ther) then
                do j = 1, ndim
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete) +&
                        dr11t*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete) +&
                        rho11*lambd1(5)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete) +&
                        rho11*lambd1(1)*tperm(i,j)*((dr22t+dr11t)*gravity(j))
                    dsde(adcp12+i,addete) = dsde(adcp12+i,addete) +&
                        dr12t*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                    dsde(adcp12+i,addete) = dsde(adcp12+i,addete) +&
                        rho12*lambd2(5)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                    dsde(adcp12+i,addete) = dsde(adcp12+i,addete) +&
                        rho12*lambd2(1)*tperm(i,j)*((dr12t+dr21t)*gravity(j))
                end do
                dsde(adcp12+i,addete)   = dsde(adcp12+i,addete)-&
                    dr12t*(1.d0-cvp)*fv(1)*gc(i)
                dsde(adcp12+i,addete)   = dsde(adcp12+i,addete)+&
                    rho12*dcvt*fv(1)*gc(i)
                dsde(adcp12+i,addete)   = dsde(adcp12+i,addete)-&
                    rho12*(1.d0-cvp)*fv(5)*gc(i)
                dsde(adcp12+i,addete)   = dsde(adcp12+i,addete)-&
                    rho12*(1.d0-cvp)*fv(1)*dgcvt(i)
                dsde(adcp12+i,addete+i) = dsde(adcp12+i,addete+i)-&
                    rho12*(1.d0-cvp)*fv(1)*dgcgt(1)
                do j = 1, ndim
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete) +&
                        dr21t*lambd2(1)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete) +&
                        rho21*lambd2(5)*tperm(i,j)*(-grap2(j)+(rho12+rho21)*gravity(j))
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete) +&
                        rho21*lambd2(1)*tperm(i,j)*((dr12t+dr21t)*gravity(j))
                end do
                dsde(adcp21+i,addete)   = dsde(adcp21+i,addete)+&
                    dr21t*cvp*fv(1)*gc(i)
                dsde(adcp21+i,addete)   = dsde(adcp21+i,addete)+&
                    rho21*dcvt*fv(1)*gc(i)
                dsde(adcp21+i,addete)   = dsde(adcp21+i,addete)+&
                    rho21*cvp*fv(5)*gc(i)
                dsde(adcp21+i,addete)   = dsde(adcp21+i,addete)+&
                    rho21*cvp*fv(1)*dgcvt(i)
                dsde(adcp21+i,addete+i) = dsde(adcp21+i,addete+i)+&
                    rho21*cvp*fv(1)*dgcgt(1)            
            endif
        end do   
    endif
!
end subroutine
