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

subroutine fonno1(noma, cnxinv, ndim, na, nb,&
                  nbmac, macofo)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
!
    integer :: na, nb, ndim, nbmac
    character(len=8) :: noma
    character(len=19) :: macofo, cnxinv
!
!       RECUPERATION DES NUMEROS DES MAILLES CONNECTEES AU
!       SEGMENT DU FOND -> REMPLISSAGE DU VECTEUR &&FONNOR.MACOFOND
!       ----------------------------------------------------------------
!    ENTREES
!       NOMA   : NOM DU MAILLAGE
!       CNXINV : CONNECTIVITE INVERSE
!       NDIM   : DIMENSION DU MODELE
!       NA     : NUMERO DU NOEUD SOMMET COURANT
!       NB     : NUMERO DU NOEUD SOMMET SUIVANT
!    SORTIE
!       MACOFO : VECTEUR DES MAILLES (PRINCIPALES) CONNECTEES AU SEGMENT
!                DU FOND DE FISSURE COURANT
!       NBMAC  : NOMBRE DE MAILLES REMPLIES DANS MACOFO
!
!
    integer :: jdrvlc, iatyma, jmaco, iamase, jcncin, ityp
    integer :: nbmaca, adra, comp1, ima, numac, ino1, ndime, nn
    character(len=8) :: type
!     -----------------------------------------------------------------
!
    call jemarq()
!
!     RECUPERATION DE LA CONNECTIVITE INVERSE
    call jeveuo(jexatr(cnxinv, 'LONCUM'), 'L', jdrvlc)
    call jeveuo(jexnum(cnxinv, 1), 'L', jcncin)
!
!
!     RECUPERATION DE L'ADRESSE DES TYPFON DE MAILLES
    call jeveuo(noma//'.TYPMAIL', 'L', iatyma)
!
!     MAILLES CONNECTEES A NA
    adra = zi(jdrvlc-1 + na)
    nbmaca = zi(jdrvlc-1 + na+1) - zi(jdrvlc-1 + na)
!
!     ALLOCATION DU VECTEUR DES MAILLES CONNECTEES AU SEGMENT DU FOND
    call wkvect(macofo, 'V V I', nbmaca, jmaco)
!
    comp1=0
    do ima = 1, nbmaca
!       NUMERO DE LA MAILLE
        numac = zi(jcncin-1 + adra+ima-1)
        ityp = iatyma-1+numac
        call jenuno(jexnum('&CATA.TM.NOMTM', zi(ityp)), type)
        call dismoi('DIM_TOPO', type, 'TYPE_MAILLE', repi=ndime)
!       ON ZAPPE LES MAILLES DE BORDS
        if (ndime .ne. ndim) goto 10
!
        if (ndim .eq. 2) then
            comp1=comp1+1
            zi(jmaco-1+comp1)=numac
        else if (ndim.eq.3) then
!         EN 3D ON DOIT AVOIR AUSSI LE NOEUD NB
            call jeveuo(jexnum(noma//'.CONNEX', numac), 'L', iamase)
            call dismoi('NBNO_TYPMAIL', type, 'TYPE_MAILLE', repi=nn)
            do ino1 = 1, nn
                if (zi(iamase-1 + ino1) .eq. nb) then
                    comp1=comp1+1
                    zi(jmaco-1+comp1)=numac
                endif
            end do
        endif
 10     continue
    end do
!
!     NB MAILLES CONNECTEES AU SEGMENT
    nbmac = comp1
    call jedema()
end subroutine
