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
subroutine xcalfh(option, thmc, ndim, dimcon,&
                  addep1, adcp11, addeme, congep, dsde,&
                  grap1, rho11, pesa, tperm, &
                  dimenr,&
                  adenhy, nfh)
!
use THM_type
use THM_module
!
implicit none
!

! ======================================================================
! ROUTINE CALC_FLUX_HYDRO
! CALCULE LES CONTRAINTES GENERALISEES ET LA MATRICE TANGENTE DES FLUX
! HYDRAULIQUES AU POINT DE GAUSS CONSIDERE
! ======================================================================
!
    integer :: ndim, dimcon, nfh
    integer :: addeme, addep1, adcp11, adenhy
    integer :: bdcp11, dimenr
    real(kind=8) :: congep(1:dimcon)
    real(kind=8) :: dsde(1:dimcon, 1:dimenr), grap1(3)
    real(kind=8) :: rho11, pesa(3), tperm(ndim,ndim)
    real(kind=8) :: cliq, viscl, dviscl
    character(len=16) :: option, thmc
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j, k, ifh
    real(kind=8) :: lambd1(3), visco, dvisco
    real(kind=8) :: krel1, dkrel1
    real(kind=8) :: dr11p1
!
! ======================================================================
! --- QUELQUES INITIALISATIONS -----------------------------------------
! ======================================================================
!
    cliq = ds_thm%ds_material%liquid%unsurk
    viscl  = ds_thm%ds_material%liquid%visc
    dviscl = ds_thm%ds_material%liquid%dvisc_dtemp
    dr11p1 = 0.d0
    bdcp11 = adcp11
!
! ======================================================================
! RECUPERATION DES COEFFICIENTS
! ======================================================================
    if (thmc .eq. 'LIQU_SATU') then
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
        if (thmc .eq. 'LIQU_SATU') then
            dr11p1=rho11*cliq
        endif
    endif
!
! ======================================================================
! CALCUL DES FLUX HYDRAULIQUES
!
    if ((option(1:9).eq.'RAPH_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (thmc .eq. 'LIQU_SATU') then
            do i = 1, ndim
                congep(bdcp11+i)=0.d0
                do j = 1, ndim
                    congep(bdcp11+i) = congep(bdcp11+i)+&
                                       rho11*lambd1(1) *tperm(i,j)*(-grap1(j)+rho11*pesa(j))
                end do
            end do
        endif
    endif
!
    if ((option(1:9).eq.'RIGI_MECA') .or. (option(1:9).eq.'FULL_MECA')) then
        if (thmc .eq. 'LIQU_SATU') then
            do i=1,ndim
                do j = 1, ndim
                    dsde(bdcp11+i,addep1) = dsde(bdcp11+i,addep1) +&
                                            dr11p1*lambd1(1)*tperm(i,j)*(-grap1(j)+rho11*pesa(j))
                    dsde(bdcp11+i,addep1) = dsde(bdcp11+i, addep1) +&
                                            rho11*lambd1(3)*tperm(i,j)*(-grap1(j)+rho11*pesa(j))
                    dsde(bdcp11+i,addep1) = dsde(bdcp11+i,addep1) +&
                                            rho11*lambd1(1)*tperm(i,j)*(dr11p1*pesa(j))
                    dsde(bdcp11+i,addep1+j) = dsde(bdcp11+i,addep1+j)-&
                                              rho11*lambd1(1)*tperm(i,j)
                end do
                if (ds_thm%ds_elem%l_dof_meca) then
                    do j=1, 3
                        do k = 1, ndim 
                            dsde(bdcp11+i,addeme+ndim-1+i) = dsde(bdcp11+i,addeme+ndim-1+i)+&
                                         rho11*lambd1(2)*tperm(i,k)*(-grap1(k)+rho11*pesa(k))
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
        if (thmc .eq. 'LIQU_SATU') then
            do i = 1, ndim
                do ifh = 1, nfh
                    do j = 1, ndim
                        dsde(bdcp11+i,adenhy+(ifh-1)*(ndim+1)) = &
                            dsde(bdcp11+i,adenhy+(ifh-1)*(ndim+1))+&
                            dr11p1*lambd1(1)*(-grap1(j)+rho11*pesa(j))*tperm(i,j)
                        dsde(bdcp11+i,adenhy+(ifh-1)*(ndim+1)) =&
                            dsde(bdcp11+i,adenhy+(ifh-1)*(ndim+1))+&
                            rho11*lambd1(3)*(-grap1(j)+rho11*pesa(j))*tperm(i,j)
                        dsde(bdcp11+i,adenhy+(ifh-1)*(ndim+1)) =&
                            dsde(bdcp11+i,adenhy+(ifh-1)*(ndim+1))+&
                            rho11*lambd1(1)*(dr11p1*pesa(j))*tperm(i,j)
                    end do
                end do
            end do
        endif
    endif
end subroutine
