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

subroutine ntcra0(sddisc)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmcrpx.h"
#include "asterfort/wkvect.h"
    character(len=19) :: sddisc
!
! ----------------------------------------------------------------------
!
! ROUTINE THER_* (STRUCTURES DE DONNES)
!
! CREATION SD ARCHIVAGE SPECIAL SI CALCUL NON TRANSITOIRE
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
!
! ----------------------------------------------------------------------
!
    character(len=24) :: arcinf, arcexc
    integer :: jarinf, jarexc
    character(len=19) :: sdarch
    integer :: iocc
    character(len=16) :: motfac, motpas
    character(len=1) :: base
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    motfac = ' '
    motpas = ' '
    iocc = 0
    base = 'V'
!
! --- NOM SD ARCHIVAGE
!
    sdarch = sddisc(1:14)//'.ARCH'
    arcinf = sdarch(1:19)//'.AINF'
    arcexc = sdarch(1:19)//'.AEXC'
!
! --- CREATION DES SDS
!
    call wkvect(arcexc, 'V V K16', 1, jarexc)
    call wkvect(arcinf, 'V V I', 3, jarinf)
!
! --- LECTURE LISTE INSTANTS D'ARCHIVAGE
!
    call nmcrpx(motfac, motpas, iocc, sdarch, base)
!
    call jedema()
!
end subroutine
