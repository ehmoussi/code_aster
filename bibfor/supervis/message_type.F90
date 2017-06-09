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

module message_type
!
!
!   Define a message type that can be emitted by utmess routines
!
! --------------------------------------------------------------------------------------------------
!
!   Message:
!       id          message identifier
!       typ         error type F, E, A+, I...
!       valk, nk    strings and number of strings
!       vali, ni    integers and number of integers
!       valr, nr    floats and number of floats
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: mathieu.courtois@edf.fr
!
    implicit none
!
    type Message
        character(len=2) :: typ
        character(len=24) :: id = "?"
        integer :: except
        integer :: nk
        character(len=256), allocatable :: valk(:)
        integer :: ni
        integer, allocatable :: vali(:)
        integer :: nr
        real(kind=8), allocatable :: valr(:)
    end type Message
!
end module
