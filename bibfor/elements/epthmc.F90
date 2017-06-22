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

subroutine epthmc(fami      , nno      , ndim  , nbsig, npg    ,&
                  shape_func, xyz      , repere, time , j_mater,&
                  option    , epsi_varc)
!
implicit none
!
#include "asterfort/epstmc.h"
#include "asterfort/lteatt.h"
!
!
    character(len=*), intent(in) :: fami
    integer, intent(in) :: nno
    integer, intent(in) :: ndim
    integer, intent(in) :: nbsig
    integer, intent(in) :: npg
    real(kind=8), intent(in) :: shape_func(1)
    real(kind=8), intent(in) :: xyz(*)
    real(kind=8), intent(in) :: repere(7)
    real(kind=8), intent(in) :: time
    integer, intent(in) :: j_mater
    character(len=16), intent(in) :: option
    real(kind=8), intent(out) :: epsi_varc(1)
!
! --------------------------------------------------------------------------------------------------
!
! Compute variable commands strains (thermics, drying, etc.)
!
! --------------------------------------------------------------------------------------------------
!
! In  fami         : Gauss family for integration point rule
! In  nno          : number of nodes
! In  ndim         : dimension of space
! In  nbsig        : number of stress tensor components
! In  npg          : number of Gauss points
! In  shape_func   : shape function
! In  xyz          : coordinates of element
! In  j_mater      : coded material address
! In  repere       : definition of basis (for non-isotropic materials)
! In  time         : current time
! In  option       : name of option to compute
! Out epsi_varc    : command variables strains
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: epsi_ther(6), epsi_hydr(6), epsi_sech(6), xyzgau(3), epsi_anel(6), epsi_pres(6)
    character(len=16) :: optio2
    integer :: i, idim, kpg, ndim2
    real(kind=8) :: zero
!
! --------------------------------------------------------------------------------------------------
!    
    zero   = 0.d0
    epsi_varc(1:nbsig*npg) = zero
    ndim2  = ndim
    if (lteatt('FOURIER','OUI')) then
        ndim2 = 2
    endif
!
! - Loop on Gauss points
!
    do kpg = 1, npg
!
! ----- Coordinates of Gauss point
!
        xyzgau(1:3) = zero
        do i = 1, nno
            do idim = 1, ndim2
                xyzgau(idim) = xyzgau(idim) + shape_func(i+nno*(kpg-1))*xyz( idim+ndim2*(i-1))
            end do
        end do
!
! ----- Thermic strains
!
        optio2 = ' '
        call epstmc(fami, ndim, time, '+', kpg,&
                    1, xyzgau, repere, j_mater, optio2,&
                    epsi_ther)
!
! ----- Hydric strains
!
        optio2 = option(1:9) // '_HYDR'
        call epstmc(fami, ndim, time, '+', kpg,&
                    1, xyzgau, repere, j_mater, optio2,&
                    epsi_hydr)
!
! ----- Drying strains
!
        optio2 = option(1:9) // '_SECH'
        call epstmc(fami, ndim, time, '+', kpg,&
                    1, xyzgau, repere, j_mater, optio2,&
                    epsi_sech)
!
! ----- Anelastic strains (given by user)
!
        optio2 = option(1:9) // '_EPSA'
        call epstmc(fami, ndim, time, '+', kpg,&
                    1, xyzgau, repere, j_mater, optio2,&
                    epsi_anel)
!
! ----- Pressure strains
!
        optio2 = option(1:9) // '_PTOT'
        call epstmc(fami, ndim, time, '+', kpg,&
                    1, xyzgau, repere, j_mater, optio2,&
                    epsi_pres)
!
! ----- Total command variables strains
!
        do i = 1, nbsig
            epsi_varc(i+nbsig*(kpg-1)) = epsi_varc(i+nbsig*(kpg-1)) + &
                                         epsi_ther(i)+&
                                         epsi_hydr(i)+&
                                         epsi_sech(i)+&
                                         epsi_anel(i)+&
                                         epsi_pres(i)
        end do
    end do
!
end subroutine
