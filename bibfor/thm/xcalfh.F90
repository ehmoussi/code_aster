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
! person_in_charge: daniele.colombo at ifpen.fr
!
subroutine xcalfh(option, ndim, dimcon,&
                  addep1, adcp11, addeme, congep, dsde,&
                  grap1, rho11, gravity, tperm, &
                  dimenr,&
                  adenhy, nfh)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterfort/THM_type.h"
!
integer :: ndim,  nfh
integer :: addeme, addep1, adcp11, adenhy
integer :: dimcon, dimenr
real(kind=8) :: congep(1:dimcon)
real(kind=8) :: dsde(1:dimcon, 1:dimenr), grap1(3)
real(kind=8) :: rho11, gravity(3), tperm(ndim,ndim)
character(len=16) :: option
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (XFEM)
!
! Compute flux
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: cliq, viscl, dviscl
    integer :: i, j, k, ifh, nume_thmc
    real(kind=8) :: lambd1(3), visco, dvisco
    real(kind=8) :: krel1, dkrel1
    real(kind=8) :: dr11p1
!
! --------------------------------------------------------------------------------------------------
!
    cliq = ds_thm%ds_material%liquid%unsurk
    viscl  = ds_thm%ds_material%liquid%visc
    dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    dr11p1 = 0.d0
!
! - Get storage parameters for behaviours
!
    nume_thmc = ds_thm%ds_behaviour%nume_thmc
!
! ======================================================================
! RECUPERATION DES COEFFICIENTS
! ======================================================================
    if (nume_thmc .eq. LIQU_SATU) then
        krel1 = 1.d0
        dkrel1 = 0.d0
        visco = viscl
        dvisco = dviscl
    endif
! ======================================================================
! --- CALCUL DE LAMBDA1 ------------------------------------------------
! ======================================================================
! --- LAMBD1(1) = CONDUC_HYDRO_LIQ -------------------------------------
! --- LAMBD1(2) = D(CONDUC_HYDRO_LIQ)/DEPSV ----------------------------
! --- LAMBD1(3) = D(CONDUC_HYDRO_LIQ)/DP1 ------------------------------
! ======================================================================
    lambd1(1) = krel1/visco
    lambd1(2) = 0.0d0
    lambd1(3) = dkrel1/visco
!
! ======================================================================
! CALCUL DES DERIVEES DES MASSES VOLUMIQUES
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (nume_thmc .eq. LIQU_SATU) then
            dr11p1=rho11*cliq
        endif
    endif
!
! ======================================================================
! CALCUL DES FLUX HYDRAULIQUES
!
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (nume_thmc .eq. LIQU_SATU) then
            do i = 1, ndim
                congep(adcp11+i)=0.d0
                do j = 1, ndim
                    congep(adcp11+i) = congep(adcp11+i)+&
                                       rho11*lambd1(1) *tperm(i,j)*(-grap1(j)+rho11*gravity(j))
                end do
            end do
        endif
    endif
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (nume_thmc .eq. LIQU_SATU) then
            do i=1,ndim
                do j = 1, ndim
                    dsde(adcp11+i,addep1) = dsde(adcp11+i,addep1) +&
                                            dr11p1*lambd1(1)*tperm(i,j)*(-grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addep1) = dsde(adcp11+i, addep1) +&
                                            rho11*lambd1(3)*tperm(i,j)*(-grap1(j)+rho11*gravity(j))
                    dsde(adcp11+i,addep1) = dsde(adcp11+i,addep1) +&
                                            rho11*lambd1(1)*tperm(i,j)*(dr11p1*gravity(j))
                    dsde(adcp11+i,addep1+j) = dsde(adcp11+i,addep1+j)-&
                                              rho11*lambd1(1)*tperm(i,j)
                end do
                if (ds_thm%ds_elem%l_dof_meca) then
                    do j=1, 3
                        do k = 1, ndim 
                            dsde(adcp11+i,addeme+ndim-1+i) = dsde(adcp11+i,addeme+ndim-1+i)+&
                                         rho11*lambd1(2)*tperm(i,k)*(-grap1(k)+rho11*gravity(k))
                        end do
                    end do
               endif
            end do
        endif
    endif
! ======================================================================
! CALCUL DES FLUX HYDRAULIQUES POUR XFEM
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9) .eq.'FULL_MECA')) then
        if (nume_thmc .eq. LIQU_SATU) then
            do i = 1, ndim
                do ifh = 1, nfh
                    do j = 1, ndim
                        dsde(adcp11+i,adenhy+(ifh-1)*(ndim+1)) = &
                            dsde(adcp11+i,adenhy+(ifh-1)*(ndim+1))+&
                            dr11p1*lambd1(1)*(-grap1(j)+rho11*gravity(j))*tperm(i,j)
                        dsde(adcp11+i,adenhy+(ifh-1)*(ndim+1)) =&
                            dsde(adcp11+i,adenhy+(ifh-1)*(ndim+1))+&
                            rho11*lambd1(3)*(-grap1(j)+rho11*gravity(j))*tperm(i,j)
                        dsde(adcp11+i,adenhy+(ifh-1)*(ndim+1)) =&
                            dsde(adcp11+i,adenhy+(ifh-1)*(ndim+1))+&
                            rho11*lambd1(1)*(dr11p1*gravity(j))*tperm(i,j)
                    end do
                end do
            end do
        endif
    endif
end subroutine
