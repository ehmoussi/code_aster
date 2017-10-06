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
subroutine calcfh_liga(option, ndim  , j_mater,&
                       dimdef, dimcon,&
                       addep1, addep2, adcp11, adcp21 ,&
                       addeme, addete,&
                       t     , p2    ,&
                       grap1 , grap2 ,& 
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
character(len=16), intent(in) :: option
integer, intent(in) :: j_mater
integer, intent(in) :: ndim, dimdef, dimcon
integer, intent(in) :: addeme, addep1, addep2, addete, adcp11, adcp21
real(kind=8), intent(in) :: rho11, satur, dsatur
real(kind=8), intent(in) :: grap1(3), grap2(3)
real(kind=8), intent(in) :: p2, t
real(kind=8), intent(in) :: gravity(3), tperm(ndim, ndim)
real(kind=8), intent(inout) :: congep(1:dimcon)
real(kind=8), intent(inout) :: dsde(1:dimcon, 1:dimdef)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute flux and stress for hydraulic - 'LIQU_GAZ'
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
! In  addep2           : adress of second hydraulic dof in vector of generalized strains
! In  adcp11           : adress of first hydraulic/first component dof in vector of gene. stresses
! In  adcp21           : adress of second hydraulic/first component dof in vector of gene. stresses
! In  t                : temperature - At end of current step
! In  p2               : gaz pressure - At end of current step
! In  grap1            : gradient of capillary pressure
! In  grap2            : gradient of gaz pressure
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
    integer :: i, j, k
    real(kind=8) :: rgaz
    real(kind=8) :: permli, dperml
    real(kind=8) :: permgz, dperms, dpermp
    real(kind=8) :: krel2, krel1, dkrel1, rho21
    real(kind=8) :: cliq, alpliq
    real(kind=8) :: viscl, dviscl, viscg, dviscg
    real(kind=8) :: mamolg
    real(kind=8) :: lambd1(5), lambd2(5)
    real(kind=8) :: dr11p1, dr11p2, dr11t
    real(kind=8) :: dr21p2, dr21t
!
! --------------------------------------------------------------------------------------------------
!
    dr11p1    = 0.d0 
    dr11p2    = 0.d0 
    dr11t     = 0.d0
    dr21p2    = 0.d0
    dr21t     = 0.d0
    lambd1(:) = 0.d0
    lambd2(:) = 0.d0
!
! - Evaluate permeability for liquid and gaz
!
    call thmEvalPermLiquGaz(j_mater, satur  , p2, t,&
                            permli , dperml ,&
                            permgz , dperms , dpermp)
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
    viscg  = ds_thm%ds_material%gaz%visc
    dviscg = ds_thm%ds_material%gaz%dvisc_dtemp
    mamolg = ds_thm%ds_material%gaz%mass_mol
    rho21  = mamolg*p2/rgaz/t
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
! - Volumic mass - Derivative
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        dr11p1 =-rho11*cliq
        dr11p2 = rho11*cliq
        dr11t  = -3.d0*alpliq*rho11
        dr21p2 = rho21/p2
        dr21t  = -rho21/t
    endif
!
! - Hydraulic flux
!
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
        do i = 1, ndim
            congep(adcp11+i)= 0.d0
            congep(adcp21+i)= 0.d0
            do j = 1, ndim
                congep(adcp11+i) = congep(adcp11+i)+&
                    rho11*lambd1(1)*tperm(i,j) *(-grap2(j)+grap1(j)+rho11*gravity(j))
                congep(adcp21+i) = congep(adcp21+i)+&
                    rho21*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
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
                    rho11*lambd1(1)*tperm(i,j)*dr11p1*gravity(j)
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    dr11p2*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    rho11*lambd1(4)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                dsde(adcp11+i,addep2)   = dsde(adcp11+i,addep2)+&
                    rho11*lambd1(1)*tperm(i,j)*dr11p2*gravity(j)
                dsde(adcp11+i,addep1+j) = dsde(adcp11+i,addep1+j)+&
                    rho11*lambd1(1)*tperm(i,j)
                dsde(adcp11+i,addep2+j) = dsde(adcp11+i,addep2+j)-&
                    rho11*lambd1(1)*tperm(i,j)
            end do
            do j = 1, ndim
                dsde(adcp21+i,addep1) = dsde(adcp21+i,addep1)+&
                    rho21*lambd2(3)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
            end do
            do j = 1, ndim
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    dr21p2*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    rho21*lambd2(4)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                dsde(adcp21+i,addep2) = dsde(adcp21+i,addep2)+&
                    rho21*lambd2(1)*tperm(i,j)*dr21p2*gravity(j)
            end do
            do j = 1, ndim
                dsde(adcp21+i,addep2+j) = dsde(adcp21+i,addep2+j)-&
                    rho21*lambd2(1)*tperm(i,j)
            end do
            if (ds_thm%ds_elem%l_dof_meca) then
                do j = 1, 3
                    do k = 1, ndim
                        dsde(adcp11+i,addeme+ndim-1+j) = dsde(adcp11+i,addeme+ndim-1+j)+&
                            (rho11*lambd1(2)*tperm(i,k)*(-grap2(k)+grap1(k)+rho11*gravity(k)))
                    end do
                    do k = 1, ndim
                        dsde(adcp21+i,addeme+ndim-1+j) = dsde(adcp21+i,addeme+ndim-1+j)+&
                            rho21*lambd2(2)*tperm(i,k)*(-grap2(k)+rho21*gravity(k))
                    end do                     
                end do
            endif
            if (ds_thm%ds_elem%l_dof_ther) then
                do j = 1, ndim
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete)+&
                        dr11t*lambd1(1)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete)+&
                        rho11*lambd1(5)*tperm(i,j)*(-grap2(j)+grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addete) = dsde(adcp11+i,addete)+&
                        rho11*lambd1(1)*tperm(i,j)*(dr11t*gravity(j))
                end do
                do j = 1, ndim
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete) +&
                        dr21t*lambd2(1)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete) +&
                        rho21*lambd2(5)*tperm(i,j)*(-grap2(j)+rho21*gravity(j))
                    dsde(adcp21+i,addete) = dsde(adcp21+i,addete) +&
                        rho21*lambd2(1)*tperm(i,j)*(dr21t*gravity(j))
                end do
            endif
        end do
    endif
!
end subroutine
