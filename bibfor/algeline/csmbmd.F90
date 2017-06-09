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

subroutine csmbmd(nommat, neq, vsmb)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: nommat
    real(kind=8) :: vsmb(*)
    integer :: neq
! BUT :
!-----------------------------------------------------------------------
!     FONCTIONS JEVEUX
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!     VARIABLES LOCALES
!-----------------------------------------------------------------------
    integer ::  ieq,   iccid
    character(len=14) :: nu
    character(len=19) :: mat
    character(len=24), pointer :: refa(:) => null()
    integer, pointer :: ccid(:) => null()
    integer, pointer :: nugl(:) => null()
!-----------------------------------------------------------------------
!     DEBUT
    call jemarq()
!-----------------------------------------------------------------------
    mat = nommat
!
    call jeveuo(mat//'.REFA', 'L', vk24=refa)
    if (refa(11) .eq. 'MATR_DISTR') then
        nu = refa(2)(1:14)
        call jeveuo(nu//'.NUML.NUGL', 'L', vi=nugl)
!
        call jeexin(mat//'.CCID', iccid)
!
        if (iccid .ne. 0) then
            call jeveuo(mat//'.CCID', 'L', vi=ccid)
            do 10 ieq = 1, neq
!         SI LE DDL N'APPARTIENT PAS AU PROC COURANT ET QU'IL Y A
!         UNE CHARGE CINEMATIQUE DESSUS, ON MET LE SECOND MEMBRE A ZERO
!         SUR LE PROC COURANT POUR EVITER DES INTERFERENCES AVEC
!         LE PROC QUI POSSEDE EFFECTIVEMENT LE DDL BLOQUE
                if ((nugl(ieq).eq.0) .and. (ccid(ieq).eq.1)) then
                    vsmb(ieq) = 0.d0
                endif
10          continue
        endif
    endif
!
    call jedema()
end subroutine
