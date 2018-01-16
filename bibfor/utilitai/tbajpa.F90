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

subroutine tbajpa(nomta, nbpar, nompar, typpar)
    implicit none
#include "jeveux.h"
#include "asterfort/codent.h"
#include "asterfort/jecreo.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/utmess.h"
#include "asterfort/trabck.h"
    integer :: nbpar
    character(len=*) :: nomta, nompar(*), typpar(*)
!      AJOUTER DES PARAMETRES A UNE TABLE.
! ----------------------------------------------------------------------
! IN  : NOMTA  : NOM DE LA STRUCTURE "TABLE".
! IN  : NBPAR  : NOMBRE DE PARAMETRES.
! IN  : NOMPAR : NOMS DES PARAMETRES.
! IN  : TYPPAR : TYPES DES PARAMETRES.
! ----------------------------------------------------------------------
    integer :: iret, nbpara, nblign,   nbpm, nbpu, nbligu
    integer :: ndim, jtblp, i, j, k, ideb, jnjv, nbpar1
    character(len=1) :: base
    character(len=3) :: type
    character(len=4) :: knume
    character(len=19) :: nomtab
    character(len=24) :: nomjv, inpar, jnpar
    character(len=8), pointer :: tbba(:) => null()
    integer, pointer :: tbnp(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
!
    nomtab = ' '
    nomtab = nomta
    call jeexin(nomtab//'.TBBA', iret)
    if (iret .eq. 0) then
        call utmess('F', 'UTILITAI4_64')
    endif
    if (nomtab(18:19) .ne. '  ') then
        call utmess('F', 'UTILITAI4_68')
    endif
!
    call jeveuo(nomtab//'.TBBA', 'L', vk8=tbba)
    base = tbba(1)(1:1)
!
    call jeveuo(nomtab//'.TBNP', 'E', vi=tbnp)
    nbpara = tbnp(1)
    nbligu = tbnp(2)
    nblign = max (nbligu , 10 )
!
! ----------------------------------------------------------------------
!
!                   --- ON INITIALISE LA TABLE ---
!
    if (nbpara .eq. 0) then
!
        tbnp(1) = nbpar
        ndim = 4 * nbpar
!
        call jecreo(nomtab//'.TBLP', base//' V K24')
        call jeecra(nomtab//'.TBLP', 'LONMAX', ndim)
        call jeecra(nomtab//'.TBLP', 'LONUTI', ndim)
        call jeveuo(nomtab//'.TBLP', 'E', jtblp)
!
        do 10 i = 1, nbpar
            zk24(jtblp+4*(i-1) ) = nompar(i)
            zk24(jtblp+4*(i-1)+1) = typpar(i)
            call codent(i, 'D0', knume)
            nomjv = nomtab//'.'//knume
            type = '   '
            type = typpar(i)
            call jecreo(nomjv, base//' V '//type)
            call jeecra(nomjv, 'LONMAX', nblign)
            call jeecra(nomjv, 'LONUTI', 0)
            call jeveuo(nomjv, 'E', iret)
            zk24(jtblp+4*(i-1)+2) = nomjv
            nomjv = nomtab(1:17)//'LG.'//knume
            call jecreo(nomjv, base//' V I')
            call jeecra(nomjv, 'LONMAX', nblign)
            call jeecra(nomjv, 'LONUTI', 0)
            call jeveuo(nomjv, 'E', jnjv)
            do 12 j = 1, nblign
                zi(jnjv+j-1) = 0
12          continue
            zk24(jtblp+4*(i-1)+3) = nomjv
10      continue
!
! ----------------------------------------------------------------------
!
!               --- ON AJOUTE DES PARAMETRES A LA TABLE ---
!
    else
!
        call jelira(nomtab//'.TBLP', 'LONMAX', nbpm)
        call jelira(nomtab//'.TBLP', 'LONUTI', nbpu)
        call jeveuo(nomtab//'.TBLP', 'L', jtblp)
!
!        IL FAUT INITIALISER LES COLONNES AU LONMAX ET NON PAS A NBLIGN
!        QUI EST LE NOMBRE DE LIGNES EVENTUELLEMENT REMPLI
!        ON RECUPERE LE PREMIER PARAMETRE DE LA TABLE
!
        j = 1
        call codent(j, 'D0', knume)
        nomjv = nomtab(1:17)//'LG.'//knume
        call jelira(nomjv, 'LONMAX', nblign)
!
!       -- on n'ajoute que les parametres qui n'existent pas :
        nbpar1 = 0
        do 20 i = 1, nbpar
            inpar = nompar(i)
            do 22 j = 1, nbpara
                jnpar = zk24(jtblp+4*(j-1))
                if (inpar .eq. jnpar) goto 20
22          continue
            nbpar1 = nbpar1 + 1
20      continue
        if (nbpar1 .eq. 0) goto 9999
!
        ideb = nbpara
        nbpara = nbpara + nbpar1
        tbnp(1) = nbpara
        ndim = 4*nbpara
!
        if (ndim .gt. nbpm) then
            call juveca(nomtab//'.TBLP', ndim)
        endif
        call jeecra(nomtab//'.TBLP', 'LONUTI', ndim)
        call jeveuo(nomtab//'.TBLP', 'E', jtblp)
        do 30 i = 1, nbpar
            inpar = nompar(i)
            do 32 j = 1, nbpara
                jnpar = zk24(jtblp+4*(j-1))
                if (inpar .eq. jnpar) goto 30
32          continue
            ideb = ideb + 1
            j = ideb
            zk24(jtblp+4*(j-1) ) = nompar(i)
            zk24(jtblp+4*(j-1)+1) = typpar(i)
            call codent(j, 'D0', knume)
            nomjv = nomtab//'.'//knume
            type = '   '
            type = typpar(i)
            call jecreo(nomjv, base//' V '//type)
            call jeecra(nomjv, 'LONMAX', nblign)
            call jeecra(nomjv, 'LONUTI', nbligu)
            call jeveuo(nomjv, 'E', iret)
            zk24(jtblp+4*(j-1)+2) = nomjv
            nomjv = nomtab(1:17)//'LG.'//knume
            call jecreo(nomjv, base//' V I')
            call jeecra(nomjv, 'LONMAX', nblign)
            call jeecra(nomjv, 'LONUTI', nbligu)
            call jeveuo(nomjv, 'E', jnjv)
            do 34 k = 1, nblign
                zi(jnjv+k-1) = 0
34          continue
            zk24(jtblp+4*(j-1)+3) = nomjv
30      continue
!
    endif
9999  continue
!
    call jedema()
end subroutine
