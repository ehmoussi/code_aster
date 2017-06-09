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

subroutine irgnal(ifi, nbordr, coord, connex, point,&
                  nocmp, nbcmp, numel, nobj, nbel,&
                  cnsc, cnsl, cnsv, partie, jtype,&
                  cnsd)
! aslint: disable=W1306
    implicit none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
!
    integer :: numel, nbel, ifi, nbordr, nbcmp
    integer :: connex(*), point(*), cnsc(*), cnsl(*), cnsv(*), cnsd(*), jtype
    real(kind=8) :: coord(*)
    character(len=*) :: nobj, partie
    character(len=8) :: nocmp(nbcmp)
!
!     IMPRESSION D'UN CHAM_NO AU FORMAT GMSH :
!     NUMEL   : NUMERO DE L'ELEMENT DANS TYPE_MAILLE__.CATA
!     NBEL    : NBRE D'ELEMENTS DE CE TYPE
!     CHAMP   : VECTORIEL SI NBCMP=3
!               SCALAIRE  SI NBCMP=1
!     NOCMP   : NOMS DES NBCMP COMPOSANTES
!
!     REMPLACE IRGN.1 ET 2 (OU .=PSTQEYRH)
!     ------------------------------------------------------------------
!
    integer :: iel, ima, ipoin, listno(99), j, jcnsc, jcnsl, jcnsv, jcnsd, ncmp
    integer :: k, jel, ior, inoe, nbno, l, jno
    real(kind=8) :: val(nbcmp)
!     ------------------------------------------------------------------
!
    call jemarq()
!
! --- VERIF QU'ON N'EST PAS HORS SCOPE D'UTILISATION
!     (CHAMP SCALAIRE OU VECTEUR)
    if (nbcmp .ne. 1 .and. nbcmp .ne. 3) then
        call utmess('F', 'PREPOST2_61')
    endif
!
    call jeveuo(nobj, 'L', jel)
    call jeveuo(jexnum('&CATA.TM.NBNO', numel), 'L', jno)
    nbno=zi(jno)
!
    if (nbno .gt. 99) then
        call utmess('F', 'PREPOST2_62')
    endif
!
!     BOUCLE SUR LES ELEMENTS
    do 10 iel = 1, nbel
        ima = zi(jel-1+iel)
        ipoin = point(ima)
!
        do 100 j = 1, nbno
            listno(j) = connex(ipoin-1+j)
100      continue
!
!        COORDONNEES DES NOEUDS
        do 110 j = 1, 3
            write(ifi,1099) (coord(3*(listno(inoe)-1)+j),inoe=1,nbno)
110      continue
!
!        POUR CHAQUE INSTANT...
        do 120 ior = 1, nbordr
            jcnsc = cnsc(ior)
            jcnsl = cnsl(ior)
            jcnsv = cnsv(ior)
            jcnsd = cnsd(ior)
            ncmp = zi(jcnsd-1+2)
            if (zk8(jtype-1+ior) .eq. 'R') then
!           ...EN CHAQUE NOEUD...
                do 1210 inoe = 1, nbno
!
                    do 1215 l = 1, nbcmp
                        val(l) = 0.d0
1215                  continue
!
!              ...ON CHERCHE LES COMPOSANTES A ECRIRE...
                    do 1220 k = 1, ncmp
!
                        do 1230 l = 1, nbcmp
                            if (zk8(jcnsc-1+k) .eq. nocmp(l)) then
                                if (zl(jcnsl-1+(listno(inoe)-1)*ncmp+ k)) then
                                    val(l) = zr( jcnsv-1+(listno(inoe)- 1)*ncmp+k)
                                    if (abs(val(l)) .le. 1.d-99) val(l)= 0.d0
                                endif
                            endif
1230                      continue
!
1220                  continue
!
!              ...ET ON IMPRIME LES VALEURS DES COMPOSANTES DE NOCMP
                    write(ifi,1099) (val(l),l=1,nbcmp)
!
1210              continue
            else if (zk8(jtype-1+ior) .eq. 'C') then
                do 2210 inoe = 1, nbno
!
                    do 2215 l = 1, nbcmp
                        val(l) = 0.d0
2215                  continue
!
!              ...ON CHERCHE LES COMPOSANTES A ECRIRE...
                    do 2220 k = 1, ncmp
!
                        do 2230 l = 1, nbcmp
                            if (zk8(jcnsc-1+k) .eq. nocmp(l)) then
                                if (zl(jcnsl-1+(listno(inoe)-1)*ncmp+ k)) then
                                    if (partie .eq. 'REEL') then
                                        val(l) = dble( zc( jcnsv-1+ (listno(inoe)-1 )*ncmp+k ) )
                                    else if (partie.eq.'IMAG') then
                                        val(l) = dimag( zc( jcnsv-1+ (listno(inoe)-1 )*ncmp+k ) )
                                    else
                                        call utmess('F', 'PREPOST2_63')
                                    endif
                                    if (abs(val(l)) .le. 1.d-99) val(l)= 0.d0
                                endif
                            endif
2230                      continue
!
2220                  continue
!
!              ...ET ON IMPRIME LES VALEURS DES COMPOSANTES DE NOCMP
                    write(ifi,1099) (val(l),l=1,nbcmp)
!
2210              continue
!
            endif
120      continue
!
10  end do
!
    call jelibe(nobj)
    call jedema()
!
    1099 format(1p,4(e15.7e3,1x))
!
end subroutine
