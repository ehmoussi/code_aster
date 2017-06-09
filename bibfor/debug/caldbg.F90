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

subroutine caldbg(inout, ncham, lcham, lparam)
    implicit none
!
! person_in_charge: jacques.pellet at edf.fr
!     ARGUMENTS:
!     ----------
#include "jeveux.h"
!
#include "asterfort/dbgobj.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: ncham, i, iret
    character(len=*) :: inout
    character(len=19) :: lcham(*)
    character(len=8) :: lparam(*)
! ----------------------------------------------------------------------
!     BUT : IMPRIMER SUR UNE LIGNE LA VALEUR
!           D'UNE LISTE DE CHAMPS POUR COMPARER 2 VERSIONS
! ----------------------------------------------------------------------
    character(len=19) :: champ
    character(len=24) :: ojb
    character(len=4) :: inou2
! DEB-------------------------------------------------------------------
!
    call jemarq()
    inou2=inout
!
!     1- POUR FAIRE DU DEBUG PAR COMPARAISON DE 2 VERSIONS:
!     -----------------------------------------------------
    do 10,i = 1,ncham
    champ = lcham(i)
    call exisd('CARTE', champ, iret)
    if (iret .gt. 0) ojb = champ//'.VALE'
    call exisd('CHAM_NO', champ, iret)
    if (iret .gt. 0) ojb = champ//'.VALE'
    call exisd('CHAM_ELEM', champ, iret)
    if (iret .gt. 0) ojb = champ//'.CELV'
    call exisd('RESUELEM', champ, iret)
    if (iret .gt. 0) ojb = champ//'.RESL'
!
    call dbgobj(ojb, 'OUI', 6, '&&CALCUL|'//inou2//'|'//lparam(i))
    10 end do
!
    call jedema()
!
end subroutine
