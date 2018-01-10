! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
subroutine get_meta_visc(poum     , fami     , kpg, ksp, j_mater,&
                         meta_type, nb_phasis, eta, n  , unsurn ,&
                         c        , m)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/rcvalb.h"
#include "asterfort/Metallurgy_type.h"
!
character(len=1), intent(in) :: poum
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg
integer, intent(in) :: ksp
integer, intent(in) :: j_mater
integer, intent(in) :: meta_type
integer, intent(in) :: nb_phasis
real(kind=8), optional, intent(out) :: eta(*)
real(kind=8), optional, intent(out) :: n(*)
real(kind=8), optional, intent(out) :: unsurn(*)
real(kind=8), optional, intent(out) :: c(*)
real(kind=8), optional, intent(out) :: m(*)
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility - Metallurgy
!
! Get parameters for viscosity
!
! --------------------------------------------------------------------------------------------------
!
! In  poum         : '-' or '+' for parameters evaluation (previous or current)
! In  fami         : Gauss family for integration point rule
! In  kpg          : current point gauss
! In  ksp          : current "sous-point" gauss
! In  j_mater      : coded material address
! In  meta_type    : type of metallurgy
! In  nb_phasis    : total number of phasis (cold and hot)
! Out eta          : viscosity parameter - eta
! Out n            : viscosity parameter - n
! Out unsurn       : viscosity parameter - 1/n
! Out c            : viscosity parameter - C
! Out m            : viscosity parameter - m
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_res_mx
    parameter (nb_res_mx = 20)
    real(kind=8) :: valres(nb_res_mx)
    integer :: codret(nb_res_mx)
    character(len=8) :: nomres(nb_res_mx)
    integer :: nb_res, i_res
!
! --------------------------------------------------------------------------------------------------
!
    nb_res = nb_phasis
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(eta)) then
            nomres(1)     = 'F1_ETA'
            nomres(2)     = 'F2_ETA'
            nomres(3)     = 'F3_ETA'
            nomres(4)     = 'F4_ETA'
            nomres(5)     = 'C_ETA'
            eta(1:nb_res) = 0.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(eta)) then
            nomres(1)     = 'F1_ETA'
            nomres(2)     = 'F2_ETA'
            nomres(3)     = 'C_ETA'
            eta(1:nb_res) = 0.d0
        endif
    else
        ASSERT(ASTER_FALSE)
    endif
!
! - Get parameters
!
    if (present(eta)) then
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_VISC', 0, ' ', [0.d0],&
                    nb_res, nomres, valres, codret, 2)
        do i_res = 1, nb_res
            eta(i_res)    = valres(i_res)
        end do
    endif
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(n)) then
            nomres(1)        = 'F1_N'
            nomres(2)        = 'F2_N'
            nomres(3)        = 'F3_N'
            nomres(4)        = 'F4_N'
            nomres(5)        = 'C_N'
            n(1:nb_res)      = 20.d0
            unsurn(1:nb_res) = 1.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(n)) then
            nomres(1)        = 'F1_N'
            nomres(2)        = 'F2_N'
            nomres(3)        = 'C_N'
            n(1:nb_res)      = 20.d0
            unsurn(1:nb_res) = 1.d0
        endif
    endif
!
! - Get parameters
!
    call rcvalb(fami, kpg, ksp, poum, j_mater,&
                ' ', 'META_VISC', 0, ' ', [0.d0],&
                nb_res, nomres, valres, codret, 2)
    if (present(n)) then
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_VISC', 0, ' ', [0.d0],&
                    nb_res, nomres, valres, codret, 2)
        do i_res = 1, nb_res
            n(i_res)      = valres(i_res)
            unsurn(i_res) = 1.d0/n(i_res)
        end do
    endif
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(c)) then
            nomres(1)   = 'F1_C'
            nomres(2)   = 'F2_C'
            nomres(3)   = 'F3_C'
            nomres(4)   = 'F4_C'
            nomres(5)   = 'C_C'
            c(1:nb_res) = 0.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(c)) then
            nomres(1)   = 'F1_C'
            nomres(2)   = 'F2_C'
            nomres(3)   = 'C_C'
            c(1:nb_res) = 0.d0
        endif
    endif
!
! - Get parameters
!
    if (present(c)) then
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_VISC', 0, ' ', [0.d0],&
                    nb_res, nomres, valres, codret, 2)
        do i_res = 1, nb_res
            c(i_res) = valres(i_res)
        end do
    endif
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(m)) then
            nomres(1)   = 'F1_M'
            nomres(2)   = 'F2_M'
            nomres(3)   = 'F3_M'
            nomres(4)   = 'F4_M'
            nomres(5)   = 'C_M'
            m(1:nb_res) = 20.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(m)) then
            nomres(1)   = 'F1_M'
            nomres(2)   = 'F2_M'
            nomres(3)   = 'C_M'
            m(1:nb_res) = 20.d0
        endif
    endif
!
! - Get parameters
!
    if (present(m)) then
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_VISC', 0, ' ', [0.d0],&
                    nb_res, nomres, valres, codret, 2)
        do i_res = 1, nb_res
            m(i_res) = valres(i_res)
        end do
    endif
!
end subroutine
