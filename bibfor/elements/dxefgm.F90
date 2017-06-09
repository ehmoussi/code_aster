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

subroutine dxefgm(nomte, option, xyzl, pgl, depl,&
                  effg)
    implicit none
#include "asterfort/dkqedg.h"
#include "asterfort/dktedg.h"
#include "asterfort/dsqedg.h"
#include "asterfort/dstedg.h"
#include "asterfort/q4gedg.h"
#include "asterfort/t3gedg.h"
#include "asterfort/utmess.h"
    real(kind=8) :: xyzl(3, 1), pgl(3, 1), depl(1), effg(1)
    character(len=16) :: nomte, option
! --- EFFORTS GENERALISES D'ORIGINE MECANIQUE AUX POINTS DE CALCUL
! --- POUR LES ELEMENTS COQUES A FACETTES PLANES :
! --- DST, DKT, DSQ, DKQ, Q4G
!     ------------------------------------------------------------------
!     IN  NOMTE        : NOM DU TYPE D'ELEMENT
!     IN  OPTION       : NOM DE L'OPTION
!     IN  XYZL(3,NNO)  : COORDONNEES DES CONNECTIVITES DE L'ELEMENT
!                        DANS LE REPERE LOCAL DE L'ELEMENT
!     IN  PGL(3,3)     : MATRICE DE PASSAGE DU REPERE GLOBAL AU REPERE
!                        LOCAL
!     IN  DEPL(1)      : VECTEUR DES DEPLACEMENTS AUX NOEUDS
!     OUT EFFG(1)      : EFFORTS  GENERALISES D'ORIGINE MECANIQUE
!                        AUX POINTS DE CALCUL
!     ------------------------------------------------------------------
    integer :: multic
!     ------------------------------------------------------------------
!
    if (nomte .eq. 'MEDKTR3 ' .or. nomte .eq. 'MEDKTG3 ') then
        call dktedg(xyzl, option, pgl, depl, effg,&
                    multic)
!
    else if (nomte.eq.'MEDSTR3 ') then
        call dstedg(xyzl, option, pgl, depl, effg)
!
    else if (nomte.eq.'MEDKQU4 '.or. nomte.eq.'MEDKQG4 ') then
        call dkqedg(xyzl, option, pgl, depl, effg)
!
    else if (nomte.eq.'MEDSQU4 ') then
        call dsqedg(xyzl, option, pgl, depl, effg)
!
    else if (nomte.eq.'MEQ4QU4 '.or. nomte.eq.'MEQ4GG4') then
        call q4gedg(xyzl, option, pgl, depl, effg)
!
    else if (nomte.eq.'MET3TR3 '.or. nomte.eq.'MET3GG3') then
        call t3gedg(xyzl, option, pgl, depl, effg)
!
    else
        call utmess('F', 'ELEMENTS_14', sk=nomte)
    endif
!
end subroutine
