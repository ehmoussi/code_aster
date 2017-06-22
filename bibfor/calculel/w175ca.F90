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

subroutine w175ca(modele, carele, chfer1, chefge, chfer2)
    implicit none
#include "asterfort/calcul.h"
#include "asterfort/exlim3.h"
#include "asterfort/mecara.h"
    character(len=8) :: modele, carele
    character(len=19) :: chfer1, chfer2, chefge
!
! ----------------------------------------------------------------------
!     CALCUL DE L'OPTION FERRAILLAGE
!
! IN  MODELE  : NOM DU MODELE
! IN  CARELE  : CARACTERISTIQUES COQUES
! IN  CHFER1  : CHAMP DE FER1_R
! IN  CHEFGE  : CHAMP DE EFGE_ELNO
! OUT CHFER2  : RESULTAT DU CALCUL DE FERRAILLAGE
!
    character(len=8) :: lpain(5), lpaout(1)
    character(len=16) :: option
    character(len=19) :: chcara(18)
    character(len=19) :: lchin(15), lchout(1), ligrel
!
    call exlim3('AFFE', 'G', modele, ligrel)
    option = 'FERRAILLAGE'
!
    call mecara(carele, chcara)
!
    lpain(1) = 'PCACOQU'
    lchin(1) = chcara(7)
    lpain(2) = 'PFERRA1'
    lchin(2) = chfer1
    lpain(3) = 'PEFFORR'
    lchin(3) = chefge
!
!
    lpaout(1) = 'PFERRA2'
    lchout(1) = chfer2
!
    call calcul('S', option, ligrel, 3, lchin,&
                lpain, 1, lchout, lpaout, 'G',&
                'OUI')
!
end subroutine
