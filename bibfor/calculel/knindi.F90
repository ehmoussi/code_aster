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

function knindi(long, kn, lkn, nbkn)
    implicit none
!
! person_in_charge: jacques.pellet at edf.fr
! A_UTIL
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/indk16.h"
#include "asterfort/indk24.h"
    integer :: nbkn, knindi, long
    character(len=*) :: kn, lkn(*)
! ----------------------------------------------------------------------
! BUT: TROUVER LE RANG D'UNE CHAINE DE CARACTERES DANS UNE LISTE DE
!      CHAINES. ON CHERCHE LE RANG DE SA 1ERE OCCURENCE.
!      SI LA CHAINE N'EST PAS TROUVEE : KNINDI=0
!
! LONG    IN   I  : 8/16/24 : LONGUEUR DES CHAINES DE LKN
! KN      IN   K* : CHAINE A CHERCHER
! LKN     IN   V(K*)  : LISTE DE CHAINES (K8/K16/24)
! NBKN    IN   I  : LONGUEUR DE LA LISTE LKN
! KNINDI  IN   I  : RANG DE LA 1ERE OCCURENCE DE KN DANS LKN
!                   SI KN EST ABSENT: INDK=0
!
! ----------------------------------------------------------------------
    character(len=8) :: k8
    character(len=16) :: k16
    character(len=24) :: k24
! DEB-------------------------------------------------------------------
!
!
    ASSERT((long.eq.8).or.(long.eq.16).or.(long.eq.24))
!
    if (long .eq. 8) then
        k8 = kn
        knindi = indik8(lkn,k8,1,nbkn)
    else if (long.eq.16) then
        k16 = kn
        knindi = indk16(lkn,k16,1,nbkn)
    else if (long.eq.24) then
        k24 = kn
        knindi = indk24(lkn,k24,1,nbkn)
    endif
!
end function
