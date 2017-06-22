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

subroutine exchnn(descn, numn, tcmp, nbc, tvale,&
                  tnueq, b, valcmp, taber)
    implicit none
!
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/iposdg.h"
    integer :: descn(*), tcmp(*), nbc, taber(*), numn, tnueq(*)
    real(kind=8) :: tvale(*), valcmp(*)
    aster_logical :: b
!
!**********************************************************************
!
!     OPERATION REALISEE
!     ------------------
!
!       EXTRACTION DES VALEURS D' UN ENSEMBLE DE COMPOSANTES SUR UN
!       NOEUDS DANS UN CHAMP_NO
!
!     ARGUMENTS EN ENTREE
!     -------------------
!
!       DESCN : PARTIE DU PRNO ASSOCIE AU NOEUD TRAITE
!
!                  (1) --> ADRESSE DANS TVALE DE LA PARTIE
!                          ASSOCIEE AU NOEUD
!
!                  (2) --> NBR DE CMP SUR CE NOEUD
!
!                  (3),(4),.. --> LES ENTIERS CODES
!
!       NUMN  : NUMERO DU NOEUD A TRAITER
!               QUAND LE CHAMP EST A REPRESENTATION NON CONSTANTE
!               CET INFORMATION EST REDONDANTE AVEC DESCN, DANS CE
!               CAS NUMN VAUT ZERO
!
!       TCMP  : TABLE DES NUMERO DE COMPOSANTES MISE EN JEU
!
!       NBC   : NBR DE COMPOSANTES MISES EN JEU
!
!       TVALE : TABLE DES VALEURS DES CMP DE TOUT LE CHAMP_NO
!
!       TNUEQ : TABLE D'INDIRECTION (JACOT) 
!
!       B     : .TRUE. LE CHAMP EST PROF_CHNO (FALSE SINON).
!
!     ARGUMENTS EN SORTIE
!     -------------------
!
!       VALCMP : TABLE DES VALEURS DES CMP MISE EN JEU SUR LE NOEUD
!
!**********************************************************************
!
!
    integer :: adr, i, poscmp, nbcn
    integer :: iiad
!-----------------------------------------------------------------------
    adr = descn(1)
    nbcn = -descn(2)
!
    if (numn .gt. 0) then
        adr = 1 + nbcn* (numn-1)
    endif
!
    do i = 1,nbc,1
        poscmp = iposdg(descn(3),tcmp(i))
        if (poscmp .gt. 0) then
            if (b) then
                iiad = tnueq(adr+poscmp-1)
            else
                iiad = adr + poscmp - 1
            endif
            valcmp(i) = tvale(iiad)
            taber(i) = 1
        else
            valcmp(i) = r8vide()
            taber(i) = 0
        endif
    end do
!
end subroutine
