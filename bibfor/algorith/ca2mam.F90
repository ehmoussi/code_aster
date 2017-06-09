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

subroutine ca2mam(moint, incr, ligrmo, lchin, lpain,&
                  lpaout, num, made)
    implicit none
!
! ROUTINE CALCULANT LES MATRICES DES DERIVEES
! DE FONCTIONS DE FORME SUR LE MODELE INTERFACE
!
! IN : MOINT : MODELE INTERFACE
! IN : MATE : MATERIAU CODE
! IN : LIGRMO : LIGREL DU MODELE
! IN: LCHIN,LPAIN,LPAOUT : PARAMETRES DU CALCUL ELEMENTAIRE
! IN : NUM : NUMEROTATION DES DDLS THERMIQUES D INTERFACE
!
! OUT : MADE : MATRICE DES DERIVEES
!
!---------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterfort/assmam.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/memare.h"
#include "asterfort/numddl.h"
#include "asterfort/promor.h"
#include "asterfort/wkvect.h"
    character(len=*) :: moint
    character(len=3) :: incr
    character(len=8) :: lpain(2), lpaout(1)
    character(len=14) :: num
    character(len=16) :: option
    character(len=19) :: matel, nu19
    character(len=24) :: lchout(1), lchin(2), ligrmo
    character(len=24) :: made, madeel
!
! ----- CREATION DE LA MATR_ELEM DES DERIVEES DES DN(I)*DN(J)
!--------------SUR LE MODELE THERMIQUE------------------------------
!--------------------D'INTERFACE -----------------------------------
!
!-----------------------------------------------------------------------
    integer :: jlva
!-----------------------------------------------------------------------
    call jemarq()
    option = 'AMOR_AJOU'
    lpaout(1) = 'PMATTTR'
    matel = '&&B'//incr(1:3)
    madeel = matel//'.RELR'
    call memare('V', matel, moint(1:8), ' ', ' ',&
                'AMOR_AJOU ')
    call wkvect(madeel, 'V V K24', 1, jlva)
!
    lchout(1) = matel(1:8)//'.ME000'
    call codent(1, 'D0', lchout(1) (12:14))
    call calcul('S', option, ligrmo, 2, lchin,&
                lpain, 1, lchout, lpaout, 'V',&
                'OUI')
    zk24(jlva) = lchout(1)
    call jeecra(madeel, 'LONUTI', 1)
!
!
!-------------------- NUMEROTATION ----------------------------------
!
    num = 'NUM'//incr
    call numddl(num, 'VV', 1, matel)
    call promor(num, 'V')
!
!---------------ASSEMBLAGE DES MATRICES  DES DN(I)DN(J)--------------
!
    made = 'MA'//incr
!
    call assmam('V', made, 1, matel, [1.d0],&
                num, 'ZERO', 1)
!
!
    nu19=num
!
! --- MENAGE
!
    call jedetr(nu19//'.ADLI')
    call jedetr(nu19//'.ADNE')
    call detrsd('MATR_ELEM', matel)
    call detrsd('CHAMP_GD', lchout(1))
!
    call jedema()
end subroutine
