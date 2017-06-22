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

subroutine nmrldb(solveu, lmat, resu, nbsm, cncine)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/resoud.h"
!
    integer :: lmat, nbsm
    real(kind=8) :: resu(*)
    character(len=19) :: solveu, cncine
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT
!
! ROUTINE DE CALCUL DE RESU = MAT-1(RESU,CNCINE)  NON LINEAIRE
!
! ----------------------------------------------------------------------
!
!
! IN  SOLVEU : SD SOLVEUR
! IN  LMAT   : DESCRIPTEUR DE LA MATR_ASSE
! IN  CNCINE : NOM DU CHARGEMENT CINEMATIQUE
! I/O RESU   : .VALE DU CHAM_NO RESULTAT EN OUT , SMB EN IN
!
!
!
! ----------------------------------------------------------------------
!
    character(len=19) :: matr
    complex(kind=8) :: c16bid
    integer :: iret
    c16bid = dcmplx(0.d0, 0.d0)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    matr = zk24(zi(lmat+1))
!
    call resoud(matr, ' ', solveu, cncine, nbsm,&
                ' ', ' ', 'V', resu, [c16bid],&
                ' ', .true._1, 0, iret)
!
    call jedema()
!
end subroutine
