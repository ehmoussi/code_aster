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

subroutine jxferm(iclas)
! aslint: disable=W1303
! for the path name
    implicit none
#include "asterc/closdr.h"
#include "asterfort/codent.h"
#include "asterfort/get_jvbasename.h"
#include "asterfort/utmess.h"
    integer :: iclas
!     ------------------------------------------------------------------
    integer :: n
!-----------------------------------------------------------------------
    integer :: k
!-----------------------------------------------------------------------
    parameter      ( n = 5 )
    character(len=2) :: dn2
    character(len=5) :: classe
    character(len=8) :: nomfic, kstout, kstini
    common /kficje/  classe    , nomfic(n) , kstout(n) , kstini(n) ,&
     &                 dn2(n)
    character(len=8) :: nombas
    common /kbasje/  nombas(n)
    integer :: idn, iext, nbenrg
    common /iextje/  idn(n) , iext(n) , nbenrg(n)
    character(len=128) :: repglo, repvol
    common /banvje/  repglo,repvol
    integer :: lrepgl, lrepvo
    common /balvje/  lrepgl,lrepvo
!     ------------------------------------------------------------------
    character(len=512) :: nom512
    integer :: ier
! DEB ------------------------------------------------------------------
    ier = 0
    do 1 k = 1, iext(iclas)
        call get_jvbasename(nomfic(iclas)(1:4), k, nom512)
        call closdr(nom512, ier)
        if (ier .ne. 0) then
            call utmess('F', 'JEVEUX_11', sk=nombas(iclas))
        endif
 1  end do
!
end subroutine
