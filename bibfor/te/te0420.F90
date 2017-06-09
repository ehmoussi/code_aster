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

subroutine te0420(option, nomte)
!.......................................................................
!
!     BUT: CALCUL DES NIVEAUX DE PRESSION EN DB
!          ELEMENTS ISOPARAMETRIQUES 3D ET 3D_MIXTE
!
!          OPTION : 'PRME_ELNO'
!
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!          ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/jevech.h"
#include "asterfort/tecael.h"
    character(len=16) :: nomte, option
!
!
!
    integer :: iadzi, iazk24
    integer :: nno, ino, ipdeb, ipres, idino, ipino
!
!
    call jevech('PPRME_R', 'E', ipdeb)
    call jevech('PDEPLAC', 'L', ipres)
!
    call tecael(iadzi, iazk24, noms=0)
    nno = zi(iadzi+1)
!
    do 10 ino = 1, nno
        idino = ipdeb + ino - 1
        ipino = ipres + 2* (ino-1)
        zr(idino) = 20.d0*log10(abs(zc(ipino))/2.d-5)
10  end do
!
end subroutine
