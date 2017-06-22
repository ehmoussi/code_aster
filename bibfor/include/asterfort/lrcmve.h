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
    subroutine lrcmve(ntvale, nmatyp, nbnoma, ntproa, lgproa,&
                      ncmprf, nomcmr, ntypel, npgmax, indpg,&
                      nbcmfi, nmcmfi, nbcmpv, ncmpvm, numcmp,&
                      jnumma, nochmd, nbma, npgma, npgmm,&
                      nspmm, typech, nutyma, adsl, adsv, adsd,&
                      lrenum, nuanom, codret)
        integer :: nbma
        integer :: npgmax
        integer :: ntypel
        character(len=*) :: ntvale
        integer :: nmatyp
        integer :: nbnoma
        character(len=*) :: ntproa
        integer :: lgproa
        integer :: ncmprf
        character(len=*) :: nomcmr(*)
        integer :: indpg(ntypel, npgmax)
        integer :: nbcmfi
        character(len=*) :: nmcmfi
        integer :: nbcmpv
        character(len=*) :: ncmpvm
        character(len=*) :: numcmp
        integer :: jnumma
        character(len=*) :: nochmd
        integer :: npgma(nbma)
        integer :: npgmm(nbma)
        integer :: nspmm(nbma)
        character(len=*) :: typech
        integer :: nutyma
        integer :: adsl
        integer :: adsv
        integer :: adsd
        integer :: nuanom(69, 27)
        aster_logical :: lrenum
        integer :: codret
    end subroutine lrcmve
end interface
