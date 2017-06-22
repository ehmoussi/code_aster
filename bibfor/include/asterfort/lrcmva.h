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
    subroutine lrcmva(ntvale, nbvato, ntproa, lgproa, ncmprf,&
                      nomcmr, nbcmfi, nmcmfi, nbcmpv, ncmpvm,&
                      numcmp, nochmd, adsl, adsv, codret)
        character(len=*) :: ntvale
        integer :: nbvato
        character(len=*) :: ntproa
        integer :: lgproa
        integer :: ncmprf
        character(len=*) :: nomcmr(*)
        integer :: nbcmfi
        character(len=*) :: nmcmfi
        integer :: nbcmpv
        character(len=*) :: ncmpvm
        character(len=*) :: numcmp
        character(len=*) :: nochmd
        integer :: adsl
        integer :: adsv
        integer :: codret
    end subroutine lrcmva
end interface
