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

subroutine cusign(jcmpg, icmp, sign)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: jcmpg
    integer :: icmp
    real(kind=8) :: sign
!
! ----------------------------------------------------------------------
! ROUTINE APPELEE PAR : CUPREP
! ----------------------------------------------------------------------
!
! CETTE ROUTINE DONNE LE SIGNE A PLACER DEVANT LA COMPOSANTE DDL
! POUR LA THM, LE SIGNE EST POSITIF A CAUSE DE L'ECRITURE DE L'EQUATION
! HYDRAULIQUE.
! POUR LES AUTRES DDLS, IL EST NEGATIF
!
! IN  JCOEF  : ADRESSE JEVEUX DES COMPOSANTES
! IN  ICMP   : INDICE DE LA COMPOSANTE DU COEFFICIENT
! OUT COEF   : VALEUR DU SIGNE
!
!
!
!
!
    character(len=8) :: cmp
!
! ----------------------------------------------------------------------
!
    call jemarq()
! ----------------------------------------------------------------------
    cmp = zk8(jcmpg-1+icmp)
!
    if (cmp(1:4) .eq. 'PRE1') then
        sign = +1.d0
    else if (cmp(1:4).eq.'PRE2') then
        sign = +1.d0
    else
        sign = +1.d0
    endif
!
! ----------------------------------------------------------------------
    call jedema()
end subroutine
