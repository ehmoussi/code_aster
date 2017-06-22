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

subroutine tuesch(nssch)
    implicit none
!
!
#include "jeveux.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
    character(len=19) :: nssch
!
!**********************************************************************
!
!  OPERATION REALISEE :
!  ------------------
!
!     DESTRUCTION DE LA SD D' UN SOUS_CHAMP_GD
!
!**********************************************************************
!
!   -------------------------
!
!
    integer :: iret
!
!====================== CORPS DE LA ROUTINE ========================
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call jedetr(nssch//'.VALE')
    call jedetr(nssch//'.PADR')
    call jedetr(nssch//'.NOMA')
    call jedetr(nssch//'.NUGD')
    call jedetr(nssch//'.ERRE')
    call jedetr(nssch//'.PCMP')
!
    call jeexin(nssch//'.PNBN', iret)
!
    if (iret .ne. 0) then
!
        call jedetr(nssch//'.PNBN')
        call jedetr(nssch//'.PNCO')
        call jedetr(nssch//'.PNSP')
!
!
    endif
!
end subroutine
