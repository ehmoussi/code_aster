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

module message_module
    use message_type
!
!
!   Manage the user messages
!
! --------------------------------------------------------------------------------------------------
! person_in_charge: mathieu.courtois@edf.fr
! aslint: disable=W1003
!
    implicit none
    private :: assert
#include "asterfort/assert.h"

contains
!
!   Initialize a Message object
    subroutine init_message(msg, typ, idmess, nk, valk, &
                            sk, ni, vali, si, nr, &
                            valr, sr, num_except)
        type(Message), intent(out) :: msg
        character(len=*), intent(in) :: typ
        character(len=*), intent(in) :: idmess
        integer, intent(in), optional :: num_except
        integer, intent(in), optional :: nk
        character(len=*), intent(in), optional, target :: valk(*)
        character(len=*), intent(in), optional :: sk
        integer, intent(in), optional :: ni
        integer, intent(in), optional, target :: vali(*)
        integer, intent(in), optional :: si
        integer, intent(in), optional :: nr
        real(kind=8), intent(in), optional, target :: valr(*)
        real(kind=8), intent(in), optional :: sr
!
        ASSERT(ENSEMBLE2(nk,valk))
        ASSERT(ENSEMBLE2(ni,vali))
        ASSERT(ENSEMBLE2(nr,valr))
        ASSERT(EXCLUS2(valk,sk))
        ASSERT(EXCLUS2(vali,si))
        ASSERT(EXCLUS2(valr,sr))
        ! ASSERT(absent(num_except) .or. typ == 'Z')
!
        msg%typ = typ
        msg%id = idmess
        msg%except = 0
        if (present(num_except)) then
            msg%except = num_except
        endif
!
        msg%nk = 0
        if (AU_MOINS_UN2(sk,valk)) then
            if (present(sk)) then
                msg%nk = 1
                allocate(msg%valk(1))
                msg%valk(1) = sk
            else
                if ( nk .eq. 0 ) then
                    allocate(msg%valk(1))
                    msg%valk(1) = " "
                else
                    ASSERT(nk.ge.1)
                    msg%nk = nk
                    allocate(msg%valk(msg%nk))
                    msg%valk(1:nk) = valk(1:nk)
                endif
            endif
        endif
!
        msg%ni = 0
        if (AU_MOINS_UN2(si,vali)) then
            if (present(si)) then
                msg%ni = 1
                allocate(msg%vali(1))
                msg%vali(1) = si
            else
                if ( ni .eq. 0 ) then
                    allocate(msg%vali(1))
                    msg%vali(1) = 0
                else
                    ASSERT(ni.ge.1)
                    msg%ni = ni
                    allocate(msg%vali(msg%ni))
                    msg%vali(1:ni) = vali(1:ni)
                endif
            endif
        endif
!
        msg%nr = 0
        if (AU_MOINS_UN2(sr,valr)) then
            if (present(sr)) then
                msg%nr = 1
                allocate(msg%valr(1))
                msg%valr(1) = sr
            else
                if ( nr .eq. 0 ) then
                    allocate(msg%valr(1))
                    msg%valr(1) = 0.d0
                else
                    ASSERT(nr.ge.1)
                    msg%nr = nr
                    allocate(msg%valr(msg%nr))
                    msg%valr(1:nr) = valr(1:nr)
                endif
            endif
        endif
    end subroutine

!   Free the content of a Message object
!   This routine must be called before freeing a Message.
!   It can also be called before reusing an existing Message with other values.
    subroutine free_message(msg)
        type(Message), intent(out) :: msg
!
        msg%typ = "?"
        msg%id = "?"
        msg%except = 0
        msg%nk = 0
        msg%ni = 0
        msg%nr = 0
        if( allocated(msg%valk) ) then
            deallocate(msg%valk)
        endif
        if( allocated(msg%vali) ) then
            deallocate(msg%vali)
        endif
        if( allocated(msg%valr) ) then
            deallocate(msg%valr)
        endif
!
    end subroutine

end module
