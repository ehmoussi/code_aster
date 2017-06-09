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

subroutine craglc(long, ligrch)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/agligr.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/jecrec.h"
#include "asterfort/jedema.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
!
!
    integer, intent(in) :: long
    character(len=19), intent(in) :: ligrch
!
! ---------------------------------------------------------------------
!     CREATION OU EXTENSION DU LIGREL DE CHARGE LIGRCH
!     D'UN NOMBRE DE TERMES EGAL A LONG
!
!     LONG DOIT ETRE > 0
!
!----------------------------------------------------------------------
!  LONG          - IN   - I    - : NOMBRE DE GRELS A RAJOUTER A LIGRCH-
!----------------------------------------------------------------------
!  LIGRCH        - IN   - K19  - : NOM DU LIGREL DE CHARGE
!                - JXVAR-      -
!----------------------------------------------------------------------
!
!
! --------- VARIABLES LOCALES ------------------------------------------
    character(len=8) :: mod
! --------- FIN  DECLARATIONS  VARIABLES LOCALES ----------------------
!
!-----------------------------------------------------------------------
    integer :: idlgns, idnbno, iret, lonema
    integer :: longma, longut, lonlig, lont, nbeldi, nbelma, nbelut
    integer :: nbmata, nbnomx
!-----------------------------------------------------------------------
    call jemarq()
    ASSERT(long.gt.0)
!
! --- ON CREE LIGREL DE CHARGE S'IL N'EXISTE PAS ---
!
    call jeexin(ligrch//'.LIEL', iret)
    if (iret .eq. 0) then
!
!  appeler char_lrea_ligf
        call jecrec(ligrch//'.LIEL', 'G V I', 'NU', 'CONTIG', 'VARIABLE',&
                    long)
        lonlig = 2*long
        call jeecra(ligrch//'.LIEL', 'LONT', lonlig)
!
        call jecrec(ligrch//'.NEMA', 'G V I', 'NU', 'CONTIG', 'VARIABLE',&
                    long)
        lonema = 4*long
        call jeecra(ligrch//'.NEMA', 'LONT', lonema)
!
        call wkvect(ligrch//'.LGNS', 'G V I', 2*lonema, idlgns)
!
! --- MODELE ASSOCIE AU LIGREL DE CHARGE ---
!
        call dismoi('NOM_MODELE', ligrch(1:8), 'CHARGE', repk=mod)
!
! --- MAILLAGE ASSOCIE AU MODELE ---
!
        call jedupo(mod//'.MODELE    .LGRF', 'G', ligrch//'.LGRF', .false._1)
!
        call wkvect(ligrch//'.NBNO', 'G V I', 1, idnbno)
        zi(idnbno) = 0
    endif
!
! --- NOMBRE MAX D'ELEMENTS DE LA COLLECTION LIGRCH ---
!
    call jelira(ligrch//'.NEMA', 'NMAXOC', nbelma)
!
! --- NOMBRE DE MAILLES TARDIVES DU LIGREL DE CHARGE ---
!
    call dismoi('NB_MA_SUP', ligrch, 'LIGREL', repi=nbmata)
!
! --- NOMBRE D'ELEMENTS DEJA AFFECTES DE LA COLLECTION LIGRCH ---
!
    call jelira(ligrch//'.NEMA', 'NUTIOC', nbelut)
!
! --- NOMBRE D'ELEMENTS DISPONIBLES DE LA COLLECTION LIGRCH ---
!
    nbeldi = nbelma - nbelut
!
! --- LONGUEUR TOTALE DE LA COLLECTION LIGRCH ---
!
    call jelira(ligrch//'.NEMA', 'LONT', lont)
!
! --- NOUVEAU NOMBRE D'OBJETS DE LA COLLECTION LIGRCH ---
!
    longut = nbelut + long
!
! --- MAJORANT DE LA NOUVELLE LONGUEUR DE LA COLLECTION LIGRCH.NEMA ---
!
    call dismoi('NB_NO_MAX', '&', 'CATALOGUE', repi=nbnomx)
    longma = (nbnomx+1)*longut
!
! --- VERIFICATION DE L'ADEQUATION DE LA TAILLE DU LIGREL DE ---
! --- CHARGE A SON AFFECTATION PAR LES MAILLES TARDIVES DUES ---
! --- AUX RELATIONS LINEAIRES                                ---
!
    if (long .gt. nbeldi .or. longma .gt. lont) then
!
! ---       LA TAILLE DU LIGREL DE CHARGE EST INSUFFISANTE  ---
! ---       ON LA REDIMENSIONNE DE MANIERE ADEQUATE         ---
        call agligr(longut, ligrch)
    endif
!
    call jedema()
end subroutine
