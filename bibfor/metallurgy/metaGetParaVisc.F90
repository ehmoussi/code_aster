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
subroutine metaGetParaVisc(poum     , fami     , kpg, ksp, j_mater,&
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
    integer, parameter :: nb_resu_max = 5
    real(kind=8) :: resu_vale(nb_resu_max)
    integer :: codret(nb_resu_max)
    character(len=8) :: resu_name(nb_resu_max)
    integer :: nb_resu, i_resu
!
! --------------------------------------------------------------------------------------------------
!
    nb_resu = nb_phasis
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(eta)) then
            resu_name(1)   = 'F1_ETA'
            resu_name(2)   = 'F2_ETA'
            resu_name(3)   = 'F3_ETA'
            resu_name(4)   = 'F4_ETA'
            resu_name(5)   = 'C_ETA'
            eta(1:nb_resu) = 0.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(eta)) then
            resu_name(1)   = 'F1_ETA'
            resu_name(2)   = 'F2_ETA'
            resu_name(3)   = 'C_ETA'
            eta(1:nb_resu) = 0.d0
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
                    nb_resu, resu_name, resu_vale, codret, 2)
        do i_resu = 1, nb_resu
            eta(i_resu)    = resu_vale(i_resu)
        end do
    endif
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(n)) then
            resu_name(1)      = 'F1_N'
            resu_name(2)      = 'F2_N'
            resu_name(3)      = 'F3_N'
            resu_name(4)      = 'F4_N'
            resu_name(5)      = 'C_N'
            n(1:nb_resu)      = 20.d0
            unsurn(1:nb_resu) = 1.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(n)) then
            resu_name(1)      = 'F1_N'
            resu_name(2)      = 'F2_N'
            resu_name(3)      = 'C_N'
            n(1:nb_resu)      = 20.d0
            unsurn(1:nb_resu) = 1.d0
        endif
    endif
!
! - Get parameters
!
    call rcvalb(fami, kpg, ksp, poum, j_mater,&
                ' ', 'META_VISC', 0, ' ', [0.d0],&
                nb_resu, resu_name, resu_vale, codret, 2)
    if (present(n)) then
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_VISC', 0, ' ', [0.d0],&
                    nb_resu, resu_name, resu_vale, codret, 2)
        do i_resu = 1, nb_resu
            n(i_resu)      = resu_vale(i_resu)
            unsurn(i_resu) = 1.d0/n(i_resu)
        end do
    endif
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(c)) then
            resu_name(1) = 'F1_C'
            resu_name(2) = 'F2_C'
            resu_name(3) = 'F3_C'
            resu_name(4) = 'F4_C'
            resu_name(5) = 'C_C'
            c(1:nb_resu) = 0.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(c)) then
            resu_name(1) = 'F1_C'
            resu_name(2) = 'F2_C'
            resu_name(3) = 'C_C'
            c(1:nb_resu) = 0.d0
        endif
    endif
!
! - Get parameters
!
    if (present(c)) then
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_VISC', 0, ' ', [0.d0],&
                    nb_resu, resu_name, resu_vale, codret, 2)
        do i_resu = 1, nb_resu
            c(i_resu) = resu_vale(i_resu)
        end do
    endif
!
! - Name of parameters
!
    if (meta_type .eq. META_STEEL) then
        if (present(m)) then
            resu_name(1) = 'F1_M'
            resu_name(2) = 'F2_M'
            resu_name(3) = 'F3_M'
            resu_name(4) = 'F4_M'
            resu_name(5) = 'C_M'
            m(1:nb_resu) = 20.d0
        endif
    elseif (meta_type .eq. META_ZIRC) then
        if (present(m)) then
            resu_name(1) = 'F1_M'
            resu_name(2) = 'F2_M'
            resu_name(3) = 'C_M'
            m(1:nb_resu) = 20.d0
        endif
    endif
!
! - Get parameters
!
    if (present(m)) then
        call rcvalb(fami, kpg, ksp, poum, j_mater,&
                    ' ', 'META_VISC', 0, ' ', [0.d0],&
                    nb_resu, resu_name, resu_vale, codret, 2)
        do i_resu = 1, nb_resu
            m(i_resu) = resu_vale(i_resu)
        end do
    endif
!
end subroutine
