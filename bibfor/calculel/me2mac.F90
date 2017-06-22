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

subroutine me2mac(modele, nchar, lchar, mate, vecel)
    implicit none
!
!
!     ARGUMENTS:
!     ----------
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/codent.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/megeom.h"
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
!
    character(len=8) :: modele, lchar(*)
    character(len=19) :: vecel
    character(len=24) :: mate
    integer :: nchar
! ----------------------------------------------------------------------
!     BUT:
!     CALCUL DE TOUS LES SECONDS MEMBRES ELEMENTAIRES PROVENANT DES
!     CHARGES_ACOUSTIQUES
!
!     ENTREES:
!
!     LES NOMS QUI SUIVENT SONT LES PREFIXES UTILISATEUR K8:
!        MODELE : NOM DU MODELE
!        NCHAR  : NOMBRE DE CHARGES
!        LCHAR  : LISTE DES CHARGES
!        MATE   : CARTE DE MATERIAU CODE
!                 SI VECEL EXISTE DEJA, ON LE DETRUIT.
!
!     SORTIES:
!     SONT TRAITES ACTUELLEMENT LES CHAMPS:
!        LCHAR(ICHA)//'.CHAC.CIMPO     ' : PRESSION    IMPOSEE
!        LCHAR(ICHA)//'.CHAC.VITFA     ' : VITESSE NORMALE FACE
!
! ----------------------------------------------------------------------
!
!     FONCTIONS EXTERNES:
!     -------------------
!
!     VARIABLES LOCALES:
!     ------------------
    aster_logical :: lfonc
    character(len=8) :: lpain(5), lpaout(1), k8bid
    character(len=16) :: option
    character(len=24) :: chgeom, lchin(5), lchout(1)
    character(len=24) :: ligrmo, ligrch
!
!-----------------------------------------------------------------------
    integer :: icha, ilires, iret
    character(len=8), pointer :: nomo(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
!
    call megeom(modele, chgeom)
!
    call jeexin(vecel//'.RERR', iret)
    if (iret .gt. 0) then
        call jedetr(vecel//'.RERR')
        call jedetr(vecel//'.RELR')
    endif
    call memare('G', vecel, modele, mate, ' ',&
                'CHAR_ACOU')
!
    lpaout(1) = 'PVECTTC'
    lchout(1) = vecel(1:8)//'.VE000'
    ilires = 0
!
!     BOUCLE SUR LES CHARGES POUR CALCULER :
!        ( CHAR_ACOU_VNOR_F , ISO_FACE ) SUR LE MODELE
!         ( ACOU_DDLI_F    , CAL_TI   )  SUR LE LIGREL(CHARGE)
!
!
    if (nchar .ne. 0) then
        lpain(1) = 'PGEOMER'
        lchin(1) = chgeom
        lpain(2) = 'PMATERC'
        lchin(2) = mate
        if (modele .ne. '        ') then
            ligrmo = modele//'.MODELE'
        else
            call jeveuo(lchar(1)//'.CHAC      .NOMO', 'L', vk8=nomo)
            ligrmo = nomo(1)//'.MODELE'
        endif
        do icha = 1, nchar
            call dismoi('TYPE_CHARGE', lchar(icha), 'CHARGE', repk=k8bid)
            if (k8bid(5:7) .eq. '_FO') then
                lfonc = .true.
            else
                lfonc = .false.
            endif
!
            ligrch = lchar(icha)//'.CHAC.LIGRE      '
!
!           --  ( CHAR_ACOU_VNOR_F , ISO_FACE ) SUR LE MODELE
!
            call exisd('CHAMP_GD', ligrch(1:13)//'.VITFA', iret)
            if (iret .ne. 0) then
                if (lfonc) then
                    option = 'CHAR_ACOU_VNOR_F'
                    lpain(3) = 'PVITENF'
                else
                    option = 'CHAR_ACOU_VNOR_C'
                    lpain(3) = 'PVITENC'
                endif
                lchin(3) = ligrch(1:13)//'.VITFA     '
                ilires = ilires + 1
                call codent(ilires, 'D0', lchout(1) (12:14))
                call calcul('S', option, ligrmo, 3, lchin,&
                            lpain, 1, lchout, lpaout, 'G',&
                            'OUI')
                call reajre(vecel, lchout(1), 'G')
            endif
!           --   ( ACOU_DDLI_F    , CAL_TI   )  SUR LE LIGREL(CHARGE)
            call exisd('CHAMP_GD', ligrch(1:13)//'.CIMPO', iret)
            if (iret .ne. 0) then
                if (lfonc) then
                    option = 'ACOU_DDLI_F'
                    lpain(3) = 'PDDLIMF'
                else
                    option = 'ACOU_DDLI_C'
                    lpain(3) = 'PDDLIMC'
                endif
                lchin(3) = ligrch(1:13)//'.CIMPO     '
                ilires = ilires + 1
                call codent(ilires, 'D0', lchout(1) (12:14))
                call calcul('S', option, ligrch, 3, lchin,&
                            lpain, 1, lchout, lpaout, 'G',&
                            'OUI')
                call reajre(vecel, lchout(1), 'G')
            endif
        end do
    endif
!
    call jedema()
end subroutine
