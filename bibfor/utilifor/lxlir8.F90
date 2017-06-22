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

subroutine lxlir8(chaine, rval, ier)
    implicit none
#include "asterfort/lxscan.h"
    character(len=*) :: chaine
    real(kind=8) :: rval
    integer :: ier
!     DECODAGE D'UN REEL ECRIT EN CHAINE DE CARACTERES
!     ------------------------------------------------------------------
! IN  CHAINE : CH*(*) : CHAINE DE CARACTERES CONTENANT L'ENTIER
! OUT IVAL   : R8     : REEL DECODE
! OUT IER    : IS     : CODE RETOUR
!              = 0  PAS D'ERREUR ON A BIEN LU UN ENTIER (IVAL)
!              = 1  ON A LU AUTRE CHOSE QU'UN ENTIER
!     ------------------------------------------------------------------
!     ROUTINE(S) UTILISEE(S) :
!         LXSCAN
!     ROUTINE(S) FORTRAN     :
!         -
!     ------------------------------------------------------------------
! FIN LXLIR8
!     ------------------------------------------------------------------
    character(len=80) :: cval
    integer :: ival
!
!-----------------------------------------------------------------------
    integer :: iclass, icol
!-----------------------------------------------------------------------
    ier = 0
    icol = 1
    call lxscan(chaine, icol, iclass, ival, rval,&
                cval)
!     ------------------------------------------------------------------
!                          ICLASS      CODE DE CE QUE L'ON A TROUVE
!           -- TYPE -----    ---- INFORMATION --------------------------
!          -1 FIN DE LIGNE   (RIEN A LIRE)
!           0 ERREUR         CVAL DE TYPE CHARACTER*(*) DE LONGUEUR IVAL
!           1 ENTIER         IVAL DE TYPE INTEGER
!           2 REEL           RVAL DE TYPE REAL*8
!           3 IDENTIFICATEUR CVAL DE TYPE CHARACTER*(*) DE LONGUEUR IVAL
!           4 TEXTE          CVAL DE TYPE CHARACTER*(*) DE LONGUEUR IVAL
!           5 SEPARATEUR     CVAL DE TYPE CHARACTER*(*) DE LONGUEUR 1
!     ------------------------------------------------------------------
    if (iclass .ne. 2) ier = 1
end subroutine
