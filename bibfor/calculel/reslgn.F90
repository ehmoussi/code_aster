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

subroutine reslgn(ligrel, option, erree, erren)
    implicit none
#include "asterfort/calcul.h"
    character(len=*) :: ligrel, erree, erren
!
!     BUT:   CALCUL DE L'OPTION : 'ERME_ELNO' ET 'QIRE_ELNO'
!     ----
!
! IN  : LIGREL : NOM DU LIGREL
! IN  : ERREE  : NOM DU CHAM_ELEM ERREUR PAR ELEMENT
! OUT : ERREN  : NOM DU CHAM_ELEM_ERREUR PRODUIT AUX NOEUDS
!
! ......................................................................
!
    character(len=8) :: lpain(1), lpaout(1)
    character(len=16) :: option
    character(len=24) :: lchin(1), lchout(1)
!
    lpain(1) = 'PERREUR'
    lchin(1) = erree
!
    lpaout(1) = 'PERRENO'
    lchout(1) = erren
!
    call calcul('S', option, ligrel, 1, lchin,&
                lpain, 1, lchout, lpaout, 'G',&
                'OUI')
!
end subroutine
