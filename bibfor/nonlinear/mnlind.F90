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

subroutine mnlind(n, deb, cle, vect, ind)
    implicit none
#include "asterf_types.h"
!
!
!     MODE_NON_LINE -- ROUTINE UTILITAIRE
!     -    -                -            -   -
! ----------------------------------------------------------------------
!
! RENVOIE L'INDICE OU SE TROUVE L'ENTIER RECHERCHER DANS UNE LISTE
! ----------------------------------------------------------------------
! IN      N      : I    : TAILLE DU VECTEUR
! IN      DEB    : I    : INDICE DE DEBUT DU VECTEUR NON TRONQUEE
! IN      CLE    : R    : CLE QUE L'ON RECHERCHE
! IN      VECT   : R8(N): LISTE D'INDICE
! IN      IND    : I    : INDICE OU SE TROUVE LA CLEF
! ----------------------------------------------------------------------
!
! ----------------------------------------------------------------------
! --- DECLARATION DES ARGUMENTS DE LA ROUTINE
! ----------------------------------------------------------------------
    integer :: n, deb, ind
    real(kind=8) :: cle, vect(n)
! ----------------------------------------------------------------------
! --- DECLARATION DES VARIABLES LOCALES
! ----------------------------------------------------------------------
    integer :: indt
    aster_logical :: lstp
!
    if (n .lt. 0) then
        ind=-999
    else
        lstp=.true.
        indt=1
 10     continue
        if (lstp) then
            if (abs(cle-vect(indt)) .lt. 1.d-8) then
                lstp=.false.
                ind=deb+indt
            else
                indt=indt+1
                if (indt .gt. n) then
                    lstp=.false.
                    ind=-999
                endif
            endif
            goto 10
        endif
    endif
!
end subroutine
