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

!
!
interface 
    subroutine xmoini(nh8, nh20, np6, np15, np5,&
                      np13, nt4, nt10, ncpq4, ncpq8,&
                      ncpt3, ncpt6, ndpq4, ndpq8, ndpt3,&
                      ndpt6, nf4, nf8, nf3, nf6,&
                      npf2, npf3, naxt3, naxq4, naxq8,&
                      naxt6, nax2, nax3, nth8, ntp6,&
                      ntp5, ntt4, ntpq4, ntpt3, ntaq4,&
                      ntat3, ntf4, ntf3, ntpf2, ntax2,&
                      nhyq8, nhyt6, nhymq8, nhymt6, nhysq8,&
                      nhyst6, nhydq8, nhydt6, nphm, nhe20,&
                      npe15, npy13, nte10, nhem20, npem15,&
                      npym13, ntem10, nhes20, npes15, npys13,&
                      ntes10, nhed20, nped15, npyd13,&
                      nted10, nbhm, nchm)
        integer :: nh8(15)
        integer :: nh20(7)
        integer :: np6(15)
        integer :: np15(7)
        integer :: np5(15)
        integer :: np13(7)
        integer :: nt4(15)
        integer :: nt10(7)
        integer :: ncpq4(15)
        integer :: ncpq8(7)
        integer :: ncpt3(15)
        integer :: ncpt6(7)
        integer :: ndpq4(15)
        integer :: ndpq8(7)
        integer :: ndpt3(15)
        integer :: ndpt6(7)
        integer :: nf4(11)
        integer :: nf8(7)
        integer :: nf3(11)
        integer :: nf6(7)
        integer :: npf2(11)
        integer :: npf3(7)
        integer :: naxt3(7)
        integer :: naxq4(7)
        integer :: naxq8(7)
        integer :: naxt6(7)
        integer :: nax2(7)
        integer :: nax3(7)
        integer :: nth8(7)
        integer :: ntp6(7)
        integer :: ntp5(7)
        integer :: ntt4(7)
        integer :: ntpq4(7)
        integer :: ntpt3(7)
        integer :: ntaq4(7)
        integer :: ntat3(7)
        integer :: ntf4(7)
        integer :: ntf3(7)
        integer :: ntpf2(7)
        integer :: ntax2(7)
        integer :: nhyq8(17)
        integer :: nhyt6(17)
        integer :: nhymq8(7)
        integer :: nhymt6(7)
        integer :: nhysq8(7)
        integer :: nhyst6(7)
        integer :: nhydq8(7)
        integer :: nhydt6(7)
        integer :: nphm(17)
        integer :: nhe20(17)
        integer :: nhem20(7)
        integer :: nhed20(7)
        integer :: nhes20(7)
        integer :: npe15(17)
        integer :: npem15(7)
        integer :: npes15(7)
        integer :: nped15(7)
        integer :: npy13(17)
        integer :: npym13(7)
        integer :: npys13(7)
        integer :: npyd13(7)
        integer :: nte10(17)
        integer :: ntem10(7)
        integer :: ntes10(7)
        integer :: nted10(7)
        integer :: nbhm(17)
        integer :: nchm(17)
    end subroutine xmoini
end interface 
