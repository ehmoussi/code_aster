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

subroutine veimpd(modele, mate, vitini, sddyna, vecelz)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/calcul.h"
#include "asterfort/corich.h"
#include "asterfort/dbgcal.h"
#include "asterfort/infdbg.h"
#include "asterfort/inical.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynkk.h"
#include "asterfort/reajre.h"
    character(len=*) :: vecelz
    character(len=24) :: modele, mate
    character(len=19) :: vitini
    character(len=19) :: sddyna
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! CALCUL DES VECTEURS ELEMENTAIRES DES IMPEDANCES DE SOL
!
! ----------------------------------------------------------------------
!
!
! IN  MODELE : NOM DU MODELE
! IN  MATE   : CHAMP DE MATERIAU
! IN  VITINI : VITESSE INITIALE
! IN  SDDYNA : SD DYNAMIQUE
! OUT VECELE : VECTEURS ELEMENTAIRES IMPEDANCES DE SOL
!
!
!
!
!
    integer :: nbout, nbin
    parameter    (nbout=1, nbin=4)
    character(len=8) :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchout(nbout), lchin(nbin)
!
    integer :: ibid
    character(len=19) :: vecele
    character(len=16) :: option
    character(len=24) :: chgeom, ligrmo
    character(len=19) :: vitent
    aster_logical :: debug
    integer :: ifmdbg, nivdbg
    character(len=8), pointer :: lgrf(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('PRE_CALCUL', ifmdbg, nivdbg)
!
! --- INITIALISATIONS
!
    vecele = vecelz
    ligrmo = modele(1:8)//'.MODELE'
    call ndynkk(sddyna, 'VITENT', vitent)
    call jeveuo(ligrmo(1:19)//'.LGRF', 'L', vk8=lgrf)
    chgeom = lgrf(1)//'.COORDO'
    option = 'IMPE_ABSO'
    if (nivdbg .ge. 2) then
        debug = .true.
    else
        debug = .false.
    endif
!
! --- INITIALISATION DES CHAMPS POUR CALCUL
!
    call inical(nbin, lpain, lchin, nbout, lpaout,&
                lchout)
!
! --- CHAMPS D'ENTREE
!
    lpain(1) = 'PGEOMER'
    lchin(1) = chgeom(1:19)
    lpain(2) = 'PMATERC'
    lchin(2) = mate(1:19)
    lpain(3) = 'PVITPLU'
    lchin(3) = vitini(1:19)
    lpain(4) = 'PVITENT'
    lchin(4) = vitent
!
! --- CHAMPS DE SORTIE
!
    lpaout(1) = 'PVECTUR'
    lchout(1) = vecele
!
! --- ALLOCATION DU VECT_ELEM RESULTAT :
!
    call jedetr(vecele//'.RELR')
!
! --- CALCUL
!
    call corich('E', lchout(1), -1, ibid)
    call calcul('S', option, ligrmo, nbin, lchin,&
                lpain, nbout, lchout, lpaout, 'V',&
                'OUI')
!
    if (debug) then
        call dbgcal(option, ifmdbg, nbin, lpain, lchin,&
                    nbout, lpaout, lchout)
    endif
!
    call reajre(vecele, lchout(1), 'V')
!
    call jedema()
end subroutine
