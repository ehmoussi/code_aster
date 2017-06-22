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

subroutine vtcrea(champ, crefe, base, typc, neq)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/sdchgd.h"
#include "asterfort/wkvect.h"
    character(len=*) :: champ, base, typc
    character(len=24) :: crefe(*)
!     CREATION D'UNE STRUCTURE CHAM_NO A PARTIR D'UN MODELE : CREFE
!     LE CHAM_NO MODELE NE DOIT PAS ETRE A REPRESENTATION CONSTANTE.
!     ------------------------------------------------------------------
!     IN  CHAMP  : K19 : NOM DU CHAM_NO A CREER
!     IN  CREFE  : K24 : CONTENU DE L'OBJET .REFE D'UN CHAM_NO MODELE
!                (1) :  K8  : MODELE
!                (2) :  K19 : PROF_CHNO
! IN  BASE   : CH1 : NOM DE LA BASE SUR LAQUELLE LE CHAM_NO DOIT ETRE
!                    CREER
!     IN  TYPC   :     : TYPE DES VALEURS DU CHAM_NO A CREER
!              'R'  ==> COEFFICIENTS REELS
!              'C'  ==> COEFFICIENTS COMPLEXES
!              'K8' ==> COEFFICIENTS CARACTERE*8
!     REMARQUE:  AUCUN CONTROLE SUR LE "TYPC" QUE L'ON PASSE TEL QUEL
!                A JEVEUX
!     ------------------------------------------------------------------
!     PRECAUTIONS D'EMPLOI :
!       1) LE CHAM_NO "CHAMP" NE DOIT PAS EXISTER
!       2) LES COEFFICIENTS DU CHAM_NO "CHAMP" NE SONT PAS AFFECTES
!                 (I.E.  LE .VALE EST VIERGE)
!     ------------------------------------------------------------------
!
!
!     ------------------------------------------------------------------
    integer :: lchamp
    character(len=1) :: classe
    character(len=1) :: type
    character(len=14) :: nu
    character(len=24) :: vale, refe, desc
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, ibid, neq, nugdsi
!-----------------------------------------------------------------------
    data vale/'                   .VALE'/
    data refe/'                   .REFE'/
    data desc/'                   .DESC'/
!     DEB --------------------------------------------------------------
    call jemarq()
    classe = base(1:1)
    if (typc(1:1) .eq. 'K') then
        type = 'F'
    else
        type = typc(1:1)
    endif
!
!     --- RECOPIE DE L'OBJET .REFE MODELE :
    refe(1:19) = champ
    call wkvect(refe, classe//' V K24', 4, lchamp)
    do i = 1, 2
        zk24(lchamp-1+i) = crefe(i)
    end do
!
!     -- CREATION DE L'OBJET .DESC :
    desc(1:19) = champ
    call wkvect(desc, classe//' V I', 2, lchamp)
    call jeecra(desc, 'DOCU', ibid, 'CHNO')
    nu= crefe(2)(1:14)
    call dismoi('NUM_GD_SI', nu, 'NUME_DDL', repi=nugdsi)
    zi(lchamp-1+1)=nugdsi
    zi(lchamp-1+2) = 1
!
!     -- CREATION DE L'OBJET .VALE :
    vale(1:19) = champ
    call wkvect(vale, classe//' V '//type, neq, lchamp)
!
!     -- CHANGER LE TYPE SCALAIRE DE LA GRANDEUR ---
    call sdchgd(champ, type)
    call jedema()
end subroutine
