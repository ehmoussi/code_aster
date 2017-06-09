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

subroutine rvaffs(mcf, iocc, sdlieu, sdeval, sdmoy,&
                  quant, option, rep, nomtab, ncheff,&
                  i1, isd)
    implicit   none
#include "jeveux.h"
!
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/rvinfa.h"
#include "asterfort/rvtaso.h"
    integer :: iocc, i1, isd
    character(len=16) :: ncheff
    character(len=19) :: sdeval, nomtab
    character(len=24) :: sdlieu, sdmoy
    character(len=*) :: mcf, rep, option, quant
!     AFFICHAGE SOMME
!     ------------------------------------------------------------------
! IN  SDLIEU : K : SD DU LIEU TRAITEE
! IN  SDEVAL : K : SD DE L' EVALUATION DE LA QUANTITE SUR CE LIEU
! IN  SDMOY  : K : SD DES SOMMES
! IN  QUANT  : K : NOM DE LA QUANTITE TRAITEE
! IN  OPTION : K : NOM DE L' OPTION   TRAITEE
! IN  TEST   : R : TABLE DES VALEURS TEST
! IN  MAXTST : R : DIMENSION DE LA TABLE TEST
! IN  PTEST  : I : POINTEUR SUR LA SOUS TABLE DE TEST A TRAITRER
!            :   : PTEST = 0 <=> AFFICHAGE DE MOYENNE
! IN  PREC   : R : PRECISION DU TEST
! IN  CRIT   : K8: CRITERE   DU TEST
!     ------------------------------------------------------------------
    integer :: anocp, nbcp, ioc, aabsc, nbpt, nboc, asdmo, niv
    integer :: i, ifm, anomnd, nbco, nbsp, k
    real(kind=8) ::  s1, s2
    character(len=4) :: docul
    character(len=16) :: oper
    character(len=24) :: nabsc, nnocp
!
!==================== CORPS DE LA ROUTINE =============================
!
    call jemarq()
    call infniv(ifm, niv)
    oper = 'SOMME'
    if (niv .gt. 1) call rvinfa(ifm, mcf, iocc, quant, option,&
                                oper, rep(1:1))
    nnocp = sdmoy(1:19)//'.NOCP'
    nabsc = sdlieu(1:19)//'.ABSC'
    call jelira(sdlieu(1:19)//'.REFE', 'DOCU', cval=docul)
    call jeveuo(sdlieu(1:19)//'.DESC', 'L', anomnd)
    call jelira(nabsc, 'NMAXOC', nboc)
    call jelira(nnocp, 'LONMAX', nbcp)
    call jeveuo(nnocp, 'L', anocp)
    call jeveuo(sdeval//'.PNCO', 'L', i)
    nbco = zi(i)
    call jeveuo(sdeval//'.PNSP', 'L', i)
    nbsp = zi(i)
    do 100, ioc = 1, nboc, 1
    call jelira(jexnum(nabsc , ioc), 'LONMAX', nbpt)
    call jeveuo(jexnum(nabsc , ioc), 'L', aabsc)
    call jeveuo(jexnum(sdmoy(1:19)//'.VALE', ioc), 'L', asdmo)
    s1 = zr(aabsc + 1-1)
    s2 = zr(aabsc + nbpt-1)
    if (niv .gt. 1) then
        if (docul .eq. 'LSTN') then
            write(ifm,*)'CHEMIN RELIANT LES NOEUDS :'
            do 200, i = 1,nbpt/8, 1
            write(ifm,'(8(1X,A8))')(zk8(anomnd+(i-1)*8+k-1),k=&
                    1,8,1)
200          continue
            write(ifm,*)'   '
            write(ifm,*)(zk8(anomnd+k-1)//' ',k=8*(nbpt/8)+1,nbpt,&
                1)
        endif
        write(ifm,*)' '
    endif
    call rvtaso(zr(asdmo), zk8(anocp), nbcp, nbco, nbsp,&
                nomtab, iocc, ncheff, i1)
    100 end do
!
    call jedema()
end subroutine
