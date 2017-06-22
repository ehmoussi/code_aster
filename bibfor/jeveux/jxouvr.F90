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

subroutine jxouvr(iclas, idn, mode)
! aslint: disable=W1303
! for the path name
    implicit none
#include "asterc/opendr.h"
#include "asterfort/codent.h"
#include "asterfort/get_jvbasename.h"
#include "asterfort/utmess.h"
    integer :: iclas, idn
    integer, optional :: mode
!     ==================================================================
    character(len=2) :: dn2
    character(len=5) :: classe
    integer :: n
!-----------------------------------------------------------------------
    integer :: ierr
!-----------------------------------------------------------------------
    parameter      ( n = 5 )
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
    character(len=8) :: nombas
    common /kbasje/  nombas(n)
    character(len=128) :: repglo, repvol
    common /banvje/  repglo,repvol
    integer :: lrepgl, lrepvo
    common /balvje/  lrepgl,lrepvo
!     ------------------------------------------------------------------
    character(len=512) :: nom512
    integer :: mode_
! DEB ------------------------------------------------------------------
    mode_ = 1
    if ( present(mode) ) then
        mode_ = mode
    else 
      if ( kstout(iclas) == 'LIBERE' .and. kstini(iclas) == 'POURSUIT' ) then
        mode_ = 0
      endif
      if ( kstini(iclas) == 'DEBUT' ) then
        mode_ = 2
      endif
    endif
    ierr = 0
    call get_jvbasename(nomfic(iclas)(1:4), idn, nom512)
    call opendr(nom512, mode_, ierr)
    if (ierr .ne. 0) then
       call utmess('F', 'JEVEUX_43', sk=nom512(1:24), si=ierr)
    endif
end subroutine
