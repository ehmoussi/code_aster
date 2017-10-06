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
subroutine thmFlh010(option, perman, ndim  , j_mater,&
                     dimdef, dimcon,&
                     addep1, addep2, adcp11 , adcp12, adcp21 , adcp22,&
                     addeme, addete, &
                     t     , p1    , p2     , pvp   , pad,&
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
#include "asterfort/hmderp.h"
#include "asterfort/thmEvalPermLiquGaz.h"
#include "asterfort/thmEvalFickSteam.h"
#include "asterfort/thmEvalFickAir.h"
!
character(len=16), intent(in) :: option
aster_logical, intent(in) :: perman
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
! Compute flux and stress for hydraulic - 'LIQU_AD_GAZ'
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
    integer :: i, j, k, bdcp11
    real(kind=8) :: rgaz, cvp
    real(kind=8) :: permli, dperml
    real(kind=8) :: permgz, dperms, dpermp
    real(kind=8) :: dfickt, dfickg, fick, fickad, dfadt
    real(kind=8) :: rho12, rho21, rho22, masrt, kh
    real(kind=8) :: cliq, alpliq
    real(kind=8) :: viscl, dviscl, viscg, dviscg, mamolg
    real(kind=8) :: lambd1(5), lambd2(5), fv(5), fa(5)
    aster_logical :: yavp
    real(kind=8) :: gp(3), gc(3)
    real(kind=8) :: gpa(3), gca(3)
    real(kind=8) :: dp11p1, dp11p2, dp11t
    real(kind=8) :: dp21p1, dp21p2, dp21t
    real(kind=8) :: dp22p1, dp22p2, dp22t
    real(kind=8) :: dp12p1, dp12p2, dp12t
    real(kind=8) :: dcvp1, dcvp2, dcvt
    real(kind=8) :: dr11p1, dr11p2, dr11t
    real(kind=8) :: dr12p1, dr12p2, dr12t
    real(kind=8) :: dr22p1, dr22p2, dr22t
    real(kind=8) :: dr21p1, dr21p2, dr21t
    real(kind=8) :: dgpvp1(3), dgpvp2(3), dgpvt(3)
    real(kind=8) :: dgpap1(3), dgpap2(3), dgpat(3)
    real(kind=8) :: dgcvp1(3), dgcvp2(3), dgcvt(3)
    real(kind=8) :: dgcap1(3), dgcap2(3), dgcat(3)
    real(kind=8) :: dgpgp1(2), dgpgp2(2), dgpgt(2)
    real(kind=8) :: dgcgp1(2), dgcgp2(2), dgcgt(2)
    real(kind=8) :: dp1pp1(2), dp2pp1(2), dtpp1(2), dp1pp2(2), dp2pp2(2)
    real(kind=8) :: dtpp2(2), dp1pt(2), dp2pt(2), dtpt(2)
!
! --------------------------------------------------------------------------------------------------
!
    lambd1(:) = 0.d0
    lambd2(:) = 0.d0
    fa(:)     = 0.d0
    fv(:)     = 0.d0
    gc(:)     = 0.d0
    gp(:)     = 0.d0
    gca(:)    = 0.d0
    gpa(:)    = 0.d0
    dp11p1    = 0.d0
    dp11p2    = 0.d0
    dp11t     = 0.d0
    dp21p1    = 0.d0 
    dp21p2    = 0.d0 
    dp21t     = 0.d0
    dp22p1    = 0.d0 
    dp22p2    = 0.d0 
    dp22t     = 0.d0
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
    dr22p1    = 0.d0 
    dr22p2    = 0.d0 
    dr22t     = 0.d0
    dr21p1    = 0.d0 
    dr21p2    = 0.d0 
    dr21t     = 0.d0
    dgpvp1(:) = 0.d0
    dgpvp2(:) = 0.d0
    dgpvt(:)  = 0.d0
    dgpap1(:) = 0.d0
    dgpap2(:) = 0.d0
    dgpat(:)  = 0.d0
    dgcvp1(:) = 0.d0
    dgcvp2(:) = 0.d0
    dgcvt(:)  = 0.d0
    dgcap1(:) = 0.d0
    dgcap2(:) = 0.d0
    dgcat(:)  = 0.d0
    dgpgp1(:) = 0.d0
    dgpgp2(:) = 0.d0
    dgpgt(:)  = 0.d0
    dgcgp1(:) = 0.d0
    dgcgp2(:) = 0.d0
    dgcgt(:)  = 0.d0
    dp1pp1(:) = 0.d0
    dp2pp1(:) = 0.d0
    dtpp1(:)  = 0.d0
    dp1pp2(:) = 0.d0
    dp2pp2(:) = 0.d0
    dtpp2(:)  = 0.d0
    dp1pt(:)  = 0.d0
    dp2pt(:)  = 0.d0
    dtpt(:)   = 0.d0
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
! - Evaluate Fick coefficients for air in liquid
!
    call thmEvalFickAir(j_mater,&
                        satur  , pad  , p2-p1, t,&
                        fickad , dfadt)
!
! - Get parameters
!
    rgaz   = ds_thm%ds_material%solid%r_gaz
    cliq   = ds_thm%ds_material%liquid%unsurk
    alpliq = ds_thm%ds_material%liquid%alpha
    viscl  = ds_thm%ds_material%liquid%visc
    dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    viscg  = ds_thm%ds_material%gaz%visc
    dviscg = ds_thm%ds_material%gaz%dvisc_dtemp
    mamolg = ds_thm%ds_material%gaz%mass_mol
    kh     = ds_thm%ds_material%ad%coef_henry
    rho12  = 0.d0
    rho21  = mamolg*p2/rgaz/t
    rho22  = mamolg*pad/rgaz/t
    masrt  = mamolg/rgaz/t
    cvp    = 0.d0
    yavp   = .false.
!
! - Fick
!
    fv(1) = fick
    fv(2) = 0.d0
    fv(3) = 0.d0
    fv(4) = dfickg
    fv(5) = dfickt
    fa(1) = fickad
    fa(2) = 0.d0
    fa(3) = 0.d0
    fa(4) = 0.d0
    fa(5) = dfadt
!
! - Thermic conductivity
!
    lambd2(1) = permgz/viscg
    lambd2(2) = 0.d0
    lambd2(3) = dperms*dsatur/viscg
    lambd2(4) = dpermp/viscg
    lambd2(5) = -permgz/viscg/viscg*dviscg
    lambd1(1) = permli/viscl
    lambd1(2) = 0.d0
    lambd1(3) = dperml*dsatur/viscl
    lambd1(4) = 0.d0
    lambd1(5) = -permli/viscl/viscl*dviscl
!
! - Compute some derivatives for LIQU_AD_GAZ_VAPE and LIQU_AD_GAZ
!
    call hmderp(yavp  , t     ,&
                pvp   , pad   ,&
                rho11 , rho12 , h11  , h12,&
                dp11p1, dp11p2, dp11t,&
                dp12p1, dp12p2, dp12t,&
                dp21p1, dp21p2, dp21t,&
                dp22p1, dp22p2, dp22t,&
                dp1pp1, dp2pp1, dtpp1,&
                dp1pp2, dp2pp2, dtpp2,&
                dp1pt , dp2pt , dtpt)
!
! - Pressure gradient (Eq. 5.5.1-7)
!
    do i = 1, ndim
        gp(i)  = 0.d0
        gpa(i) = dp22p2*grap2(i) + dp22p1*grap1(i)
        if (ds_thm%ds_elem%l_dof_ther) then
            gp(i)  = 0.d0
            gpa(i) = gpa(i)+dp22t*grat(i)
        endif
        gc(i)  = 0.d0
        gca(i) = mamolg*gpa(i)/rgaz/t
        if (ds_thm%ds_elem%l_dof_ther) then
            gca(i) = gca(i)-mamolg*pad/rgaz/t/t*grat(i)
        endif
    end do
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dcvp1 = 0.d0
        dcvp2 = 0.d0
        if (ds_thm%ds_elem%l_dof_ther) then
            dcvt = 0.d0
        endif
    endif
!
! - Volumic mass - Derivative
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dr11p1 = rho11*dp11p1*cliq
        dr11p2 = rho11*dp11p2*cliq
        dr12p1 = 0.d0
        dr12p2 = 0.d0
        dr21p1 = masrt*dp21p1
        dr21p2 = masrt*dp21p2
        dr22p1 = mamolg/kh*dp21p1
        dr22p2 = mamolg/kh*dp21p2
        if (ds_thm%ds_elem%l_dof_ther) then
            dr11t = rho11*cliq*dp11t-3.d0*alpliq*rho11
            dr12t = 0.d0
            dr21t = masrt*dp12t-rho21/t
            dr22t = mamolg/kh*dp22t
        endif
! ----- GRADPVP and GRADCVP - Derivative
        do i = 1, ndim
! --------- GRADPVP - Derivative
            dgpvp1(i) = 0.d0
            dgpvp2(i) = 0.d0
            dgpap1(i) = dp1pp2(2)*grap2(i)+dp1pp1(2)*grap1(i)
            dgpap2(i) = dp2pp2(2)*grap2(i)+dp2pp1(2)*grap1(i)
            if (ds_thm%ds_elem%l_dof_ther) then
                dgpvp1(i) = 0.d0
                dgpvp2(i) = 0.d0
                dgpvt(i)  = 0.d0
                dgpap1(i) = dgpap1(i)+dp1pt(2)*grat(i)
                dgpap2(i) = dgpap2(i)+dp2pt(2)*grat(i)
                dgpat(i)  = dtpp2(2)*grap2(i)+dtpp1(2)*grap1(i)+dtpt(2)*grat(i)
            endif
            dgpgp1(1) = dp12p1
            dgpgp2(1) = dp12p2
            dgpgp1(2) = dp22p1
            dgpgp2(2) = dp22p2
            if (ds_thm%ds_elem%l_dof_ther) then
                dgpgt(1) = dp12t
                dgpgt(2)=  dp22t
            endif
! --------- GRADCVP - Derivative
            dgcvp1(i) = 0.d0
            dgcvp2(i) = 0.d0
            dgcap1(i) = mamolg*dgpap1(i)/rgaz/t
            dgcap2(i) = mamolg*dgpap2(i)/rgaz/t
            if (ds_thm%ds_elem%l_dof_ther) then
                dgcvt(i)  = 0.d0
                dgcap1(i) = dgcap1(i)-mamolg*1/rgaz/t/t*dp22p1*grat(i)
                dgcap2(i) = dgcap2(i)-mamolg*1/rgaz/t/t*dp22p2*grat(i)
                dgcat(i)  = masrt*dgpat(i)-mamolg*1/rgaz/t/t*dp22t*grat(i)+&
                            mamolg*(2*1/rgaz/t*pad/t/t*grat(i)-1/rgaz/t/t*gpa(i))
            endif
            dgcgp1(1) = dgpgp1(1)/p2
            dgcgp2(1) = dgpgp2(1)/p2-pvp/p2/p2
            dgcgp1(2) = mamolg*1/rgaz/t*dgpgp1(2)
            dgcgp2(2) = mamolg*1/rgaz/t*dgpgp2(2)
            if (ds_thm%ds_elem%l_dof_ther) then
                dgcgt(1) = dgpgt(1)/p2
                dgcgt(2) = mamolg*(1/rgaz/t*dgpgt(2)-1/rgaz/t*pad/t)
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
            congep(adcp22+i) = -fa(1)*gca(i)
            do j = 1, ndim
                congep(adcp11+i) = congep(adcp11+i)+&
                    rho11*lambd1(1)*tperm(i,j) *(-grap2(j)+grap1(j)+(rho11+rho22)*gravity(j))
                congep(adcp21+i) = congep(adcp21+i)+&
                    rho21*lambd2(1)*tperm(i,j) *(-grap2(j)+rho21*gravity(j))
                congep(adcp22+i) = congep(adcp22+i)+&
                    rho22*lambd1(1)*tperm(i,j) *(grap1(j)-grap2(j)+(rho22+rho11)*gravity(j))
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
                    dr11p1*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp11+i,addep1)   = dsde(adcp11+i,addep1)+&
                    rho11*lambd1(3)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp11+i,addep1)   = dsde(adcp11+i,addep1)+&
                    rho11*lambd1(1)*tperm(i,j)*((dr22p1+dr11p1)*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    dr11p2*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    rho11*lambd1(4)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    rho11*lambd1(1)*tperm(i,j)* ((dr22p2+dr11p2)*gravity(j))
                dsde(adcp11+i,addep1+j) = dsde(adcp11+i,addep1+j)+&
                    rho11*lambd1(1)*tperm(i,j)
                dsde(adcp11+i,addep2+j) = dsde(adcp11+i,addep2+j)-&
                    rho11*lambd1(1)*tperm(i,j)
            end do
            do j = 1, ndim
                dsde(adcp12+i,addep1) = dsde(adcp12+i,addep1)+&
                    dr12p1*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
            end do
            dsde(adcp12+i,addep1) = dsde(adcp12+i,addep1)-dr12p1*fv(1)*gc(i)
            do j = 1, ndim
                dsde(adcp12+i,addep2) = dsde(adcp12+i,addep2)+&
                    dr12p2*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
            end do
            dsde(adcp12+i,addep2)   = dsde(adcp12+i,addep2)-dr12p2*fv(1)*gc(i)
            do j = 1, ndim
                dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                    dr21p1*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                    rho21*lambd2(3)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                    rho21*lambd2(1)*tperm(i,j)*((dr12p1+dr21p1)*gravity(j))
            end do
            dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+rho21*dcvp1*fv(1)*gc(i)
            do j = 1, ndim
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    dr21p2*lambd2(1)*tperm(i,j)* (-grap2(j)+rho21*gravity(j))
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    rho21*lambd2(4)*tperm(i,j)* (-grap2(j)+rho21*gravity(j))
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    rho21*lambd2(1)*tperm(i,j)* ((dr12p2+dr21p2)*gravity(j))
            end do
            dsde(adcp21+i,addep2)   = dsde(adcp21+i,addep2)+rho21*dcvp2*fv(1)*gc(i)
            do j = 1, ndim
                dsde(adcp21+i,addep2+j) = dsde(adcp21+i,addep2+j)-rho21*lambd2(1)*tperm(i,j)
            end do
!
            do j = 1, ndim
                dsde(adcp22+i,addep1) = dsde(adcp22+i,addep1)+&
                    dr22p1*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp22+i,addep1) = dsde(adcp22+i,addep1)+&
                    rho22*lambd1(3)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp22+i,addep1) = dsde(adcp22+i,addep1)+&
                    rho22*lambd1(1)*tperm(i,j)*((dr22p1+dr11p1)*gravity(j))
            end do
            dsde(adcp22+i,addep1) = dsde(adcp22+i,addep1)-fa(3)*gca(i)
            dsde(adcp22+i,addep1) = dsde(adcp22+i,addep1)-fa(1)*dgcap1(i)
            do j = 1, ndim
                dsde(adcp22+i,addep2) = dsde(adcp22+i,addep2) +&
                    dr22p2*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp22+i,addep2) = dsde(adcp22+i,addep2) +&
                    rho22*lambd1(4)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                dsde(adcp22+i,addep2)=dsde(adcp22+i,addep2) +&
                    rho22*lambd1(1)*tperm(i,j)*((dr22p2+dr11p2)*gravity(j))
            end do
            dsde(adcp22+i,addep2) = dsde(adcp22+i,addep2)-fa(4)*gca(i)
            dsde(adcp22+i,addep2) = dsde(adcp22+i,addep2)-fa(1)*dgcap2(i)
            do j = 1, ndim
                dsde(adcp22+i,addep1+j) = dsde(adcp22+i,addep1+j)+rho22*lambd1(1)*tperm(i,j)
            end do
            dsde(adcp22+i,addep1+i) = dsde(adcp22+i,addep1+i)-fa(1)*dgcgp1(2)
            do j = 1, ndim
                dsde(adcp22+i,addep2+j) = dsde(adcp22+i,addep2+j)-rho22*lambd1(1)*tperm(i,j)
            end do
            dsde(adcp22+i,addep2+i) = dsde(adcp22+i,addep2+i)-fa(1)*dgcgp2(2)
!
            if (ds_thm%ds_elem%l_dof_meca) then
                do j = 1, 3
                    do k = 1, ndim
                        dsde(adcp11+i,addeme+ndim-1+j) = dsde(adcp11+i,addeme+ndim-1+j)+&
                            (rho11+rho22)*lambd1(2)*tperm(i,k)*&
                            (-grap2(k)+grap1(k)+(rho11+rho22)*gravity(k))
                    end do
                    do k = 1, ndim
                        dsde(adcp21+i,addeme+ndim-1+j) =  dsde(adcp21+i,addeme+ndim-1+j)+&
                            rho21*lambd2(2)*tperm(i,k)*(-grap2(k)+rho21*gravity(k))
                    end do
                    do k = 1, ndim
                        dsde(adcp22+i,addeme+ndim-1+j) = dsde(adcp22+i,addeme+ndim-1+j)+&
                            rho22*lambd1(2)*tperm(i,k)*(-grap2(i)+grap1(k)+(rho22+rho11)*gravity(k))
                    end do
                    dsde(adcp22+i,addeme+ndim-1+j) = dsde(adcp22+i,addeme+ndim-1+j)-fa(2)*gca(i)
                end do
            endif
            if (ds_thm%ds_elem%l_dof_ther) then
                do j = 1, ndim
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete)+&
                        dr11t*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete)+&
                        rho11*lambd1(5)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete)+&
                        rho11*lambd1(1)*tperm(i,j)*((dr22t+dr11t)*gravity(j))
                    dsde(adcp12+i,addete) = dsde(adcp12+i,addete)+&
                        dr12t*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                end do
                dsde(adcp12+i,addete)   = dsde(adcp12+i,addete)-dr12t*fv(1)*gc(i)
                do j = 1, ndim
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete)+&
                        dr21t*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete)+&
                        rho21*lambd2(5)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete)+&
                        rho21*lambd2(1)*tperm(i,j)*((dr12t+dr21t)*gravity(j))
                end do
                dsde(adcp21+i,addete)   = dsde(adcp21+i,addete)+rho21*dcvt*fv(1)*gc(i)
                do j = 1, ndim
                    dsde(adcp22+i,addete) = dsde(adcp22+i,addete)+&
                        dr22t*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+(rho22+rho11)*gravity(j))
                    dsde(adcp22+i,addete) = dsde(adcp22+i,addete)+&
                        rho22*lambd1(5)*tperm(i,j)*(-grap2(j)+grap1(j) +(rho22+rho11)*gravity(j))
                    dsde(adcp22+i,addete) = dsde(adcp22+i,addete)+&
                        rho22*lambd1(1)*tperm(i,j)*((dr22t+dr11t)*gravity(j))
                end do
                dsde(adcp22+i,addete)   = dsde(adcp22+i,addete)-fa(5)*gca(i)
                dsde(adcp22+i,addete)   = dsde(adcp22+i,addete)-fa(1)*dgcat(i)
                dsde(adcp22+i,addete+i) = dsde(adcp22+i,addete+i)-fa(1)*dgcgt(2)
            endif
        end do
    endif
!
end subroutine
