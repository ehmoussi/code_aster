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

subroutine moinip(nch, ncoef, iich, iisuiv, ilig,&
                  ilig2)
! aslint: disable=W1304
    implicit none
    integer :: iich(*), iisuiv(*), ilig(*)
    integer :: nch, ncoef, ii2, j, ii1
    integer(kind=4) :: ilig2(1)
!     DESIMBRICATION DES CHAINES DE LA STRUCTURE (IICH, IISUIV,ILIG) :
!     ------------------------------------------------------------------
! IN  NCH       DIMENSION DU TABLEAU IICH = NOMBRE DE CHAINES
! OUT NCOEF     LONGUEUR DE ILIG
! VAR IICH(K)   CF CI-DESSOUS
! VAR IISUIV(K) CF CI-DESSOUS
!       EN ENTREE IICH(J) EST L'ADRESSE DANS ILIG DU DEBUT DE
!                  LA CHAINE J . ILIG(IISUIV(K)) EST L'ELEMENT SUIVANT
!                  ILIG(K) DANS LA CHAINE A LAQUELLE ILS APPARTIENNENT.
!                  SI IICH(J) <= 0 LA CHAINE J EST VIDE .
!                  SI IISUIV(K) < 0 -IISUIV(K) EST LE NUMERO DE LA
!                  CHAINE A LAQUELLE APPARTIENT ILIG(K).
!       EN SORTIE IICH(J) EST L'ADRESSE DANS ILIG DE LA FIN DE
!                  LA CHAINE J ET POUR QUE ILIG(K) APPARTIENNE A LA
!                  CHAINE J IL FAUT ET IL SUFFIT QUE
!                  IICH(J-1) < K < IICH(J) + 1 .
! VAR ILIG(.)   TABLE DES ELEMENTS CHAINES
!     ------------------------------------------------------------------
    ii2 = 1
    do 120 j = 1, nch
        ii1 = iich(j)
        if (ii1 .le. 0) then
!            PREMIER MAILLON DE LA CHAINE VIDE
            iich(j) = ii2 - 1
        else
!            CHAINE NON VIDE    PREMIER MAILLON
            ilig2(ii2) = ilig(ii1)
            ii2 = ii2 + 1
            ii1 = iisuiv(ii1)
!
!             MAILLONS SUIVANTS DE LA CHAINE
!             TANT QUE II1 > 0 FAIRE :
110          continue
            if (ii1 .le. 0) then
!                 FIN DE LA CHAINE J
                iich(j) = ii2 - 1
                goto 120
            else
                ilig2(ii2) = ilig(ii1)
                ii2 = ii2 + 1
                ii1 = iisuiv(ii1)
                goto 110
            endif
        endif
!
120  end do
    ncoef = iich(nch)
end subroutine
