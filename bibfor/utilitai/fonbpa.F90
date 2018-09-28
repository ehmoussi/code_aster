! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine fonbpa(nomf, vec, typfon, mxpf, nbpf,&
                  nompf)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    integer :: mxpf, nbpf
    character(len=*) :: nomf, vec(*), typfon, nompf(*)
!     NOMBRE DE PARAMETRE D'UNE FONCTION ET NOMS DE CES PARAMETRES
!     ON PASSE VEC, DESCRIPTEUR D'UN OBJET FONCTION (OU NAPPE)
!     ------------------------------------------------------------------
! IN  NOMF  : NOM DE LA FONCTION
! IN  VEC   : VECTEUR DESCRIPTEUR DE L'OBJET FONCTION
! OUT TYPFON: =VEC(1) QUELLE SPECIF ...
!             TYPE DE FONCTION (CONSTANT, LINEAIRE, OU NAPPE)
! IN  MXPF  : NOMBRE MAXIMUM DE PARAMETRE DE LA FONCTION
! OUT NBPF  :NOMBRE DE PARAMETRES
!             0 POUR 'C', 1 POUR 'F',2 POUR 'N',  N POUR 'I'
! OUT NOMPF :NOMS DE CES PARAMETRES
!     ------------------------------------------------------------------
    integer ::  ipa
    integer :: vali(2)
    character(len=24) :: valk
    character(len=19) :: nomfon
    character(len=24), pointer :: nova(:) => null()
!     ------------------------------------------------------------------
    call jemarq()
!
    typfon = vec(1)
!
    if (vec(1)(1:8) .eq. 'CONSTANT') then
        nbpf = 0
        nompf(1) = vec(3)
!
    else if (vec(1)(1:8).eq.'FONCTION') then
        nbpf = 1
        nompf(1) = vec(3)
!
    else if (vec(1)(1:7).eq.'FONCT_C') then
        nbpf = 1
        nompf(1) = vec(3)
!
    else if (vec(1)(1:5).eq.'NAPPE') then
        nbpf = 2
        nompf(1) = vec(3)
        nompf(2) = vec(7)
!
    else if (vec(1)(1:8).eq.'INTERPRE') then
        nomfon = nomf
        call jelira(nomfon//'.NOVA', 'LONUTI', nbpf)
        call jeveuo(nomfon//'.NOVA', 'L', vk24=nova)
        do 12 ipa = 1, nbpf
            nompf(ipa) = nova(ipa)
12      continue
!
    else
        ASSERT(.false.)
    endif
!
    if (nbpf .gt. mxpf) then
        nomfon = nomf
        valk = nomfon
        vali (1) = nbpf
        vali (2) = mxpf
        call utmess('F', 'UTILITAI6_37', sk=valk, ni=2, vali=vali)
    endif
!
    call jedema()
end subroutine
