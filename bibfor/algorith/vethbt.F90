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

subroutine vethbt(modele, charge, infcha, carele, mate,&
                  chtni, vebtla)
    implicit none
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/gcncon.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/memare.h"
#include "asterfort/wkvect.h"
    character(len=24) :: modele, charge, infcha, carele, mate, chtni, vebtla
! ----------------------------------------------------------------------
! CALCUL DES TERMES DE DIRICHLET EN THERMIQUE NON LINEAIRE
!
! IN  MODELE  : NOM DU MODELE
! IN  CHARGE  : LISTE DES CHARGES
! IN  INFCHA  : INFORMATIONS SUR LES CHARGEMENTS
! IN  CARELE  : CHAMP DE CARA_ELEM
! IN  MATE    : MATERIAU CODE
! IN  CHTNI   : IEME ITEREE DU CHAMP DE TEMPERATURE
! OUT VEBTLA  : VECTEURS ELEMENTAIRES PROVENANT DE BT LAMBDA
!
!
!
    character(len=8) :: nomcha, lpain(2), lpaout(1), newnom
    character(len=16) :: option
    character(len=19) :: vecel
    character(len=24) :: lchin(2), lchout(1), ligrch
    integer :: iret, nchar, icha, jchar, jinf
!-----------------------------------------------------------------------
    integer :: ibid, jdir, ndir
!-----------------------------------------------------------------------
    call jemarq()
    call jeexin(charge, iret)
    if (iret .ne. 0) then
        call jelira(charge, 'LONMAX', nchar)
        call jeveuo(charge, 'L', jchar)
    else
        nchar = 0
    endif
!
    call jeexin(vebtla, iret)
    vecel = '&&VETBTL           '
    if (iret .eq. 0) then
        vebtla = vecel//'.RELR'
        call memare('V', vecel, modele(1:8), mate, carele,&
                    'CHAR_THER')
        call wkvect(vebtla, 'V V K24', nchar, jdir)
    else
        call jeveuo(vebtla, 'E', jdir)
    endif
    call jeecra(vebtla, 'LONUTI', 0)
!
    if (nchar .gt. 0) then
        call jeveuo(infcha, 'L', jinf)
        ndir = 0
        do 10 icha = 1, nchar
!
! ------- CALCUL DES TERMES DE DIRICHLET SOUS-OPTION BT LAMBDA
!
            option = 'THER_BTLA_R'
            if (zi(jinf+icha) .gt. 0) then
                nomcha = zk24(jchar+icha-1) (1:8)
                ligrch = nomcha//'.CHTH.LIGRE'
                lpain(1) = 'PDDLMUR'
                lchin(1) = nomcha//'.CHTH.CMULT'
                lpain(2) = 'PLAGRAR'
                lchin(2) = chtni
                lpaout(1) = 'PVECTTR'
                lchout(1) = '&&VETHBT.???????'
                call gcncon('.', newnom)
                lchout(1) (10:16) = newnom(2:8)
                call corich('E', lchout(1), -1, ibid)
                call calcul('S', option, ligrch, 2, lchin,&
                            lpain, 1, lchout, lpaout, 'V',&
                            'OUI')
                ndir = ndir + 1
                zk24(jdir+ndir-1) = lchout(1)
            endif
!
10      continue
        call jeecra(vebtla, 'LONUTI', ndir)
!
    endif
! FIN ------------------------------------------------------------------
    call jedema()
end subroutine
