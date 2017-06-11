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

subroutine fonoda(jv_mater, ndim  , l_steady, fnoevo,&
                  mecani  , press1, press2  , tempe ,&
                  dimdef  , dimcon, dt      , congem,&
                  r)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/rcvalb.h"
!
!
    integer, intent(in) :: jv_mater
    integer, intent(in) :: ndim
    aster_logical, intent(in) :: fnoevo
    aster_logical, intent(in) :: l_steady
    integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
    integer, intent(in) :: dimdef, dimcon
    real(kind=8), intent(in) :: dt
    real(kind=8), intent(inout) :: congem(dimcon)
    real(kind=8), intent(out) :: r(dimdef+1)
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Compute stress vector {R} 
!
! --------------------------------------------------------------------------------------------------
!
! In  jv_mater     : coded material address
! In  ndim         : dimension of element (2 ou 3)
! In  fnoevo       : .true. if compute in non-linear operator (transient terms)
! In  l_steady     : .true. for steady state
! In  mecani       : parameters for mechanic
! In  press1       : parameters for hydraulic (first pressure)
! In  press1       : parameters for hydraulic (second pressure)
! In  tempe        : parameters for thermic
! In  dimdef       : number of generalized strains
! In  dimcon       : number of generalized stresses
! In  dt           : time increment
! IO  congem       : generalized stresses at the beginning of time step
!                    => output sqrt(2) on SIG_XY, SIG_XZ, SIG_YZ
! Out r            : stress vector
!
! --------------------------------------------------------------------------------------------------
!
    integer :: yamec, yap1, yap2, yate
    integer :: nbpha1, nbpha2
    integer :: addeme, addete, addep1, addep2
    integer :: adcome, adcote, adcp11, adcp12, adcp21, adcp22
    integer :: i_dim
    real(kind=8) :: rac2
    integer, parameter :: nb_para = 3
    real(kind=8) :: para_vale(nb_para), pesa(3)
    integer :: icodre(nb_para)
    character(len=8), parameter :: para_name(nb_para) = (/ 'PESA_X','PESA_Y','PESA_Z' /)
!
! --------------------------------------------------------------------------------------------------
!
    rac2 = sqrt(2.d0)
!
! - Get gravity
!
    call rcvalb('FPG1', 1, 1, '+', jv_mater,&
                ' ', 'THM_DIFFU', 0, ' ', [0.d0],&
                nb_para, para_name, para_vale, icodre, 1)
    pesa(1) = para_vale(1)
    pesa(2) = para_vale(2)
    pesa(3) = para_vale(3)
!
! - Get active physics
!
    yamec  = mecani(1)
    yap1   = press1(1)
    nbpha1 = press1(2)
    yap2   = press2(1)
    nbpha2 = press2(2)
    yate   = tempe(1)
!
! - Get adresses in generalized vectors
!
    addeme = mecani(2)
    addep1 = press1(3)
    adcome = mecani(3)
    addete = tempe(2)
    adcote = tempe(3)
    addep2 = press2(3)
    if (l_steady) then
        adcp11 = press1(4) - 1
        adcp12 = press1(5) - 1
        adcp21 = press2(4) - 1
        adcp22 = press2(5) - 1
    else
        adcp11 = press1(4)
        adcp12 = press1(5)
        addep2 = press2(3)
        adcp21 = press2(4)
        adcp22 = press2(5)
    endif
!
! - Transforms stress with sqrt(2)
!
    if (yamec .eq. 1) then
        do i_dim = 4, 6
            congem(adcome+6+i_dim-1) = congem(adcome+6+i_dim-1)*rac2
            congem(adcome+i_dim-1)   = congem(adcome+i_dim-1)*rac2
        end do
    endif
!
! - Compute residual {R}
!
    if (yamec .eq. 1) then
! ----- {R} from mechanic
        do i_dim = 1, 6
            r(addeme+ndim+i_dim-1) = r(addeme+ndim+i_dim-1)+congem(adcome-1+i_dim)
        end do
        do i_dim = 1, 6
            r(addeme+ndim-1+i_dim) = r(addeme+ndim-1+i_dim)+congem(adcome+6+i_dim-1)
        end do
! ----- {R} from hydraulic (first)
        if (yap1 .eq. 1) then
            do i_dim = 1, ndim
                r(addeme+i_dim-1) = r(addeme+i_dim-1) - pesa(i_dim)*congem(adcp11)
            end do
            if (nbpha1 .gt. 1) then
                do i_dim = 1, ndim
                    r(addeme+i_dim-1) = r(addeme+i_dim-1)- pesa(i_dim)*congem(adcp12)
                end do
            endif
        endif
! ----- {R} from hydraulic (second)
        if (yap2 .eq. 1) then
            do i_dim = 1, ndim
                r(addeme+i_dim-1) = r(addeme+i_dim-1)- pesa(i_dim)*congem(adcp21)
            end do
            if (nbpha2 .gt. 1) then
                do i_dim = 1, ndim
                    r(addeme+i_dim-1) = r(addeme+i_dim-1)- pesa(i_dim)*congem(adcp22)
                end do
            endif
        endif
    endif
! - For transient terms
    if (fnoevo) then
! ----- {R(t)} from hydraulic (first)
        if (yap1 .eq. 1) then
            do i_dim = 1, ndim
                r(addep1+i_dim) = r(addep1+i_dim)+dt*congem(adcp11+i_dim)
            end do
            if (nbpha1 .gt. 1) then
                do i_dim = 1, ndim
                    r(addep1+i_dim) = r(addep1+i_dim)+dt*congem(adcp12+i_dim)
                end do
            endif
            if (yate .eq. 1) then
                do i_dim = 1, ndim
                    r(addete) = r(addete)+dt*congem(adcp11+i_dim)*pesa(i_dim)
                end do
                if (nbpha1 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete)=r(addete) +dt*congem(adcp12+i_dim)*pesa(i_dim)
                    end do
                endif
                do i_dim = 1, ndim
                    r(addete+i_dim) = r(addete+i_dim) + &
                        dt*congem(adcp11+ndim+1)*congem(adcp11+i_dim)
                end do
                if (nbpha1 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete+i_dim) = r(addete+i_dim) + &
                            dt*congem(adcp12+ndim+1)*congem(adcp12+i_dim)
                    end do
                endif
!
            endif
        endif
! ----- {R(t)} from hydraulic (second)
        if (yap2 .eq. 1) then
            do i_dim = 1, ndim
                r(addep2+i_dim) = r(addep2+i_dim)+dt*congem(adcp21+i_dim)
            end do
            if (nbpha2 .gt. 1) then
                do i_dim = 1, ndim
                    r(addep2+i_dim) = r(addep2+i_dim)+dt*congem(adcp22+i_dim)
                end do
            endif
            if (yate .eq. 1) then
                do i_dim = 1, ndim
                    r(addete) = r(addete)+dt*congem(adcp21+i_dim)*pesa(i_dim)
                end do
                if (nbpha2 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete) = r(addete)+dt*congem(adcp22+i_dim)*pesa(i_dim)
                    end do
                endif
                do i_dim = 1, ndim
                    r(addete+i_dim) = r(addete+i_dim) + &
                        dt*congem(adcp21+ndim+1)*congem(adcp21+i_dim)
                end do
                if (nbpha2 .gt. 1) then
                    do i_dim = 1, ndim
                        r(addete+i_dim) = r(addete+i_dim) + &
                            dt*congem(adcp22+ndim+1)*congem(adcp22+i_dim)
                    end do
                endif
            endif
        endif
! ----- {R(t)} from thermic
        if (yate .eq. 1) then
            do i_dim = 1, ndim
                r(addete+i_dim) = r(addete+i_dim)+dt*congem(adcote+i_dim)
            end do
        endif
    endif
!
end subroutine
