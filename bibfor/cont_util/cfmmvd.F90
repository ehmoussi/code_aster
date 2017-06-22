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

function cfmmvd(vect)
!
implicit none
!
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: cfmmvd
    character(len=5), intent(in) :: vect
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Utility
!
! Get size of some contact objects
!
! --------------------------------------------------------------------------------------------------
!
! In  vect             : type of contact object
! Out cfmmvd           : size of contact object
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: zmeth = 23, ztole = 3 , ztabf = 34, zcmcf = 13
    integer, parameter :: ztgde = 6 , zdirn = 6 , zdime = 18, zpoud = 3
    integer, parameter :: ztypm = 2 , zperc = 4 , ztypn = 2 , zmesx = 5
    integer, parameter :: zapme = 3 , zmaes = 4 , zresu = 30, zcmdf = 6
    integer, parameter :: zcmxf = 16, zexcl = 3 , zparr = 5 , zpari = 29
    integer, parameter :: ztaco = 2 , zeven = 5 , zcoco = 8 , ztacf = 4 
    integer, parameter :: zetat = 3
!
! --------------------------------------------------------------------------------------------------
!
    if (vect .eq. 'ZMETH') then
        cfmmvd = zmeth
    else if (vect.eq.'ZTOLE') then
        cfmmvd = ztole
    else if (vect.eq.'ZTABF') then
        cfmmvd = ztabf
    else if (vect.eq.'ZTACF') then
        cfmmvd = ztacf
    else if (vect.eq.'ZCMCF') then
        cfmmvd = zcmcf
    else if (vect.eq.'ZCMXF') then
        cfmmvd = zcmxf
    else if (vect.eq.'ZTGDE') then
        cfmmvd = ztgde
    else if (vect.eq.'ZDIRN') then
        cfmmvd = zdirn
    else if (vect.eq.'ZPOUD') then
        cfmmvd = zpoud
    else if (vect.eq.'ZTYPM') then
        cfmmvd = ztypm
    else if (vect.eq.'ZTYPN') then
        cfmmvd = ztypn
    else if (vect.eq.'ZMESX') then
        cfmmvd = zmesx
    else if (vect.eq.'ZAPME') then
        cfmmvd = zapme
    else if (vect.eq.'ZRESU') then
        cfmmvd = zresu
    else if (vect.eq.'ZCMDF') then
        cfmmvd = zcmdf
    else if (vect.eq.'ZPERC') then
        cfmmvd = zperc
    else if (vect.eq.'ZEXCL') then
        cfmmvd = zexcl
    else if (vect.eq.'ZPARR') then
        cfmmvd = zparr
    else if (vect.eq.'ZPARI') then
        cfmmvd = zpari
    else if (vect.eq.'ZCOCO') then
        cfmmvd = zcoco
    else if (vect.eq.'ZDIME') then
        cfmmvd = zdime
    else if (vect.eq.'ZMAES') then
        cfmmvd = zmaes
    else if (vect.eq.'ZETAT') then
        cfmmvd = zetat
    else if (vect.eq.'ZTACO') then
        cfmmvd = ztaco
    else if (vect.eq.'ZEVEN') then
        cfmmvd = zeven
    else
        ASSERT(.false.)
    endif
!
end function
