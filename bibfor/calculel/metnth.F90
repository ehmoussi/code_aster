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

subroutine metnth(modele, lchar, cara, mate, time,&
                  chtni, metrnl)
!
!
!
!     ARGUMENTS:
!     ----------
    implicit none
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mecact.h"
#include "asterfort/mecara.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
#include "asterfort/utmess.h"
    character(len=*) :: lchar, mate
    character(len=24) :: modele, cara, metrnl, time, chtni
! ----------------------------------------------------------------------
!
!     CALCUL DES MATRICES ELEMENTAIRES DE CONVECTION NATURELLE
!
!     ENTREES:
!
!     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
!        MODELE : NOM DU MODELE
!        LCHAR  : OBJET CONTENANT LA LISTE DES CHARGES
!        MATE   : CHAMP DE MATERIAUX
!        CARA   : CHAMP DE CARAC_ELEM
!        TIME   : CHAMPS DE TEMPSR
!        CHTNI  : IEME ITEREE DU CHAMP DE TEMPERATURE
!        METRNL : NOM DU MATR_ELEM (N RESUELEM) PRODUIT
!
!     SORTIES:
!        METRNL  : EST REMPLI.
!
! ----------------------------------------------------------------------
!
!     VARIABLES LOCALES:
!     ------------------
!
!
    character(len=8) :: nomcha, lpain(7), lpaout(1)
    character(len=8) :: vitess, decent
    character(len=16) :: option
    character(len=24) :: lchin(7), lchout(1), chgeom, chcara(18)
    character(len=24) :: chvite, ligrmo, carte, convch, carele
    integer :: iret, ilires
    integer :: nchar, jchar
!
! DEB-------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: ichar, iconv, jvites
!-----------------------------------------------------------------------
    call jemarq()
!     -- ON VERIFIE LA PRESENCE PARFOIS NECESSAIRE DE CARA_ELEM
    if (modele(1:1) .eq. ' ') then
        call utmess('F', 'CALCULEL3_50')
    endif
!
    call jeexin(lchar, iret)
    if (iret .ne. 0) then
        call jelira(lchar, 'LONMAX', nchar)
        call jeveuo(lchar, 'L', jchar)
    else
        nchar = 0
    endif
!
    call megeom(modele, chgeom)
    call mecara(cara, chcara)
!
    call jeexin(metrnl, iret)
    if (iret .eq. 0) then
        metrnl = '&&METNTH           .RELR'
        call memare('V', metrnl, modele(1:8), mate, carele,&
                    'RIGI_THER_CONV_T')
    else
        call jedetr(metrnl)
    endif
!
    chvite = '????'
!
    iconv = 0
!
    lpaout(1) = 'PMATTTR'
    lchout(1) = metrnl(1:8)//'.ME000'
    do ichar = 1, nchar
        nomcha = zk24(jchar+ichar-1) (1:8)
        convch = nomcha//'.CHTH'//'.CONVE'//'.VALE'
        call jeexin(convch, iret)
        if (iret .gt. 0) then
            iconv = iconv + 1
            if (iconv .gt. 1) then
                call utmess('F', 'CALCULEL3_72')
            endif
!
            decent = 'OUI'
            option = 'RIGI_THER_CONV'
            if (decent .eq. 'OUI') option = 'RIGI_THER_CONV_T'
            call memare('V', metrnl, modele(1:8), mate, cara,&
                        option)
!
            call jeveuo(convch, 'L', jvites)
            vitess = zk8(jvites)
            chvite = vitess
            carte = '&&METNTH'//'.CONVECT.DECENT'
            call mecact('V', carte, 'MODELE', modele(1:8)//'.MODELE', 'NEUT_K24',&
                        ncmp=1, nomcmp='Z1', sk=decent)
            lpain(1) = 'PGEOMER'
            lchin(1) = chgeom
            lpain(2) = 'PMATERC'
            lchin(2) = mate
            lpain(3) = 'PCACOQU'
            lchin(3) = chcara(7)
            lpain(4) = 'PTEMPSR'
            lchin(4) = time
            lpain(5) = 'PVITESR'
            lchin(5) = chvite
            lpain(7) = 'PNEUK24'
            lchin(7) = carte
            lpain(6) = 'PTEMPEI'
            lchin(6) = chtni
!
!
            ligrmo = modele(1:8)//'.MODELE'
            ilires = 0
            ilires = ilires + 1
            call codent(ilires, 'D0', lchout(1) (12:14))
            call calcul('S', option, ligrmo, 7, lchin,&
                        lpain, 1, lchout, lpaout, 'V',&
                        'OUI')
            call reajre(metrnl, lchout(1), 'V')
!
        endif
    end do
!
    call jedema()
!
end subroutine
