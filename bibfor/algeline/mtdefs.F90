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

subroutine mtdefs(matout, matin, base, typc)
    implicit none
#include "jeveux.h"
!
#include "asterfort/jecrec.h"
#include "asterfort/jecreo.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=*) :: matout, matin, base, typc
!     DEFINITION DE LA STRUCTURE D'UNE MATRICE "MATOUT"
!       QUI S'APPUIE SUR LA MEME NUMEROTATION QUE "MATIN",
!       QUI A LA MEME STRUCTURE (PROFIL PAR BLOC/MORSE) QUE "MATIN"
!     LA MATRICE "MATOUT" EST CREEE SUR LA BASE "BASE".
!     LA MATRICE "MATOUT" EST A COEFFICIENTS "TYPE".
!     ------------------------------------------------------------------
! IN  MATOUT : CH19: NOM DE LA MATRICE A CREER
! IN  MATIN  : CH19: NOM DE LA MATRICE MODELE
! IN  BASE   : CH1 : NOM DE LA BASE SUR LAQUELLE LA MATRICE DOIT ETRE
!                    CREER
! IN  TYPC   : CH1 : TYPE DES VALEURS DE LA MATRICE A CREER
!              'R'  ==> COEFFICIENTS REELS
!              'C'  ==> COEFFICIENTS COMPLEXES
!              ' '  ==> COEFFICIENTS DU TYPE DE LA MATRICE MATIN
!     ------------------------------------------------------------------
!     PRECAUTIONS D'EMPLOI :
!       1) LA MATRICE "MATOUT" NE DOIT PAS EXISTER
!       2) LES COEFFICIENTS DE LA MATRICE "MATOUT" NE SONT PAS AFFECTES
!       3) LA MATRICE MATOUT EST DANS L'ETAT 'ASSE'
!     ------------------------------------------------------------------
!
!
!     ------------------------------------------------------------------
    integer :: nbval, ival, jrefao, jrefai
    character(len=1) :: classe, type
    character(len=19) :: nomout, nomin
    character(len=24) :: valm, refa, lime
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: ibloc, iret, jvalm, lgbloc, nbbloc
!-----------------------------------------------------------------------
    call jemarq()
    classe = base(1:1)
!
    nomin = matin
    nomout = matout
!
!     -- OBJET .REFA :
!     ----------------------------
    refa = nomin//'.REFA'
    call jelira(refa, 'LONMAX', nbval)
    call jeveuo(refa, 'L', jrefai)
    refa = nomout//'.REFA'
    call jecreo(refa, classe//' V K24')
    call jeecra(refa, 'LONMAX', nbval)
    call jeveuo(refa, 'E', jrefao)
    do 10 ival = 0, nbval-1
        zk24(jrefao+ival) = zk24(jrefai+ival)
10  end do
    zk24(jrefao-1+8) = 'ASSE'
!
!
!
!     -- RECOPIE DU .LIME:
!     --------------------------
    lime = nomin//'.LIME'
    call jeexin(lime, iret)
    if (iret .gt. 0) then
        call jelira(lime, 'LONMAX', nbval)
        call jeveuo(lime, 'L', jrefai)
!
        lime = nomout//'.LIME'
        call jecreo(lime, classe//' V K24')
        call jeecra(lime, 'LONMAX', nbval)
        call jeveuo(lime, 'E', jrefao)
        do 15 ival = 0, nbval-1
            zk24(jrefao+ival) = zk24(jrefai+ival)
15      continue
    endif
!
!
!     -- CREATION DE LA COLLECTION .VALM :
!     --------------------------------------------------------------
    valm = nomin//'.VALM'
    type = typc(1:1)
    if (type .eq. ' ') call jelira(valm, 'TYPE', cval=type)
    call jelira(valm, 'NMAXOC', nbbloc)
    call jelira(jexnum(valm, 1), 'LONMAX', lgbloc)
    valm = nomout//'.VALM'
    call jecrec(valm, classe//' V '//type, 'NU', 'DISPERSE', 'CONSTANT',&
                nbbloc)
    call jeecra(valm, 'LONMAX', lgbloc)
    do 20 ibloc = 1, nbbloc
        call jecroc(jexnum(valm, ibloc))
!        -- IL FAUT FAIRE UN JEVEUO/'E' POUR QUE L'OBJET EXISTE VRAIMENT
        call jeveuo(jexnum(valm, ibloc), 'E', jvalm)
20  end do
!
!
    call jedema()
end subroutine
