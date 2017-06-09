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

subroutine rvaffm(mcf, iocc, sdlieu, sdeval, sdmoy,&
                  oper, quant, option, rep, nomtab,&
                  xnovar, ncheff, i1, isd)
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
#include "asterfort/rvtamo.h"
    integer :: i1, iocc, isd
    character(len=16) :: ncheff, oper
    character(len=19) :: sdeval
    character(len=24) :: sdlieu, sdmoy, xnovar
    character(len=*) :: mcf, rep, option, nomtab, quant
!     AFFICHAGE MOYENNE
!     ------------------------------------------------------------------
! IN  SDLIEU : K : SD DU LIEU TRAITEE
! IN  SDEVAL : K : SD DE L' EVALUATION DE LA QUANTITE SUR CE LIEU
! IN  SDMOY  : K : SD DES MOYENNES
! IN  OPER   : K : TYPE D'OPERATION: 'MOYENNE'
! IN  QUANT  : K : NOM DE LA QUANTITE TRAITEE
! IN  OPTION : K : NOM DE L' OPTION   TRAITEE
!     ------------------------------------------------------------------
    integer :: anocp, nbcp, ioc, aabsc, nbpt, nboc, asdmo
    integer :: i, ifm, anomnd, nbco, nbsp, k, niv
    real(kind=8) ::  s1, s2
    character(len=4) :: docul
    character(len=24) :: nabsc, nnocp
!======================================================================
!
    call jemarq()
    call infniv(ifm, niv)
    if (niv .gt. 1) call rvinfa(ifm, mcf, iocc, quant, option,&
                                oper, rep(1:1))
    nnocp = sdeval//'.NOCP'
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
    do ioc = 1, nboc, 1
        call jelira(jexnum(nabsc , ioc), 'LONMAX', nbpt)
        call jeveuo(jexnum(nabsc , ioc), 'L', aabsc)
        call jeveuo(jexnum(sdmoy , ioc), 'L', asdmo)
        s1 = zr(aabsc + 1-1)
        s2 = zr(aabsc + nbpt-1)
        if (niv .gt. 1) then
            if (docul .eq. 'LSTN') then
                write(ifm,*)'CHEMIN RELIANT LES NOEUDS :'
                do i = 1,nbpt/8, 1
                    write(ifm,'(8(1X,A8))')(zk8(anomnd+(i-1)*8+k-1),k=&
                        1,8,1)
                enddo
                write(ifm,*)'   '
                write(ifm,*)(zk8(anomnd+k-1)//' ',k=8*(nbpt/8)+1,nbpt,&
                    1)
            endif
            write(ifm,*)' '
        endif
        call rvtamo(zr(asdmo), zk8(anocp), nbcp, nbco, nbsp,&
                    nomtab, iocc, xnovar, ncheff, i1)
    enddo
!
    call jedema()
end subroutine
