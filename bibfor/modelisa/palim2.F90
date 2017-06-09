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

subroutine palim2(mcfact, iocc, nomaz, nomvei, nomvek,&
                  iadr)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/i2rdl2.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenonu.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/lxlgut.h"
#include "asterfort/reliem.h"
#include "asterfort/utmess.h"
!
    integer :: iocc, iadr
    character(len=*) :: mcfact, nomaz, nomvei, nomvek
!
! IN   NOMAZ  : NOM DU MAILLAGE
! OUT  NOML   : NOM DE L'OBJET JEVEUX CREE SUR LA VOLATILE
! OUT  NBMAIL : NOMBRE DE MAILLES RECUPEREES
!     ------------------------------------------------------------------
!
    integer :: n1, ier, kotyp, im, numa, ityp, nume, iatyma, lgp, lgm
    integer :: ilist, klist, nbmc, nbma, jnoma
    parameter     ( nbmc = 3 )
    aster_logical :: lnume, lmail
    integer :: lopt, lnom
    character(len=8) :: noma, option, oldtyp, prfm, nommai, knume
    character(len=16) :: tymocl(nbmc), motcle(nbmc)
    character(len=24) :: nomama, nomaty, nomjv
    character(len=24) :: valk(2)
!     ------------------------------------------------------------------
!
    call jemarq()
!
    noma = nomaz
    nomama = noma//'.NOMMAI'
    nomaty = noma//'.TYPMAIL'
!
    lopt = getexm ( mcfact, 'OPTION' )
    lnom = getexm ( mcfact, 'PREF_MAILLE' )
    call jeveuo(nomvei, 'E', ilist)
    call jeveuo(nomvek, 'E', klist)
    ier = 0
!
    if (lopt .eq. 1) then
        call getvtx(mcfact, 'OPTION', iocc=iocc, scal=option, nbret=n1)
        if (option .eq. 'TRIA6_7') then
            oldtyp = 'TRIA6'
        else if (option .eq. 'QUAD8_9') then
            oldtyp = 'QUAD8'
        else if (option .eq. 'SEG3_4') then
            oldtyp = 'SEG3'
        endif
        call jenonu(jexnom('&CATA.TM.NOMTM', oldtyp), kotyp)
    endif
!
    lmail = .false.
    lnume = .false.
    if (lnom .eq. 1) then
        call getvtx(mcfact, 'PREF_MAILLE', iocc=iocc, nbval=0, nbret=n1)
        if (n1 .ne. 0) then
            call getvtx(mcfact, 'PREF_MAILLE', iocc=iocc, scal=prfm, nbret=n1)
            lgp = lxlgut(prfm)
            lmail = .true.
        else
            lgp = 0
            prfm = ' '
        endif
        call getvis(mcfact, 'PREF_NUME', iocc=iocc, nbval=0, nbret=n1)
        if (n1 .ne. 0) then
            lnume = .true.
            call getvis(mcfact, 'PREF_NUME', iocc=iocc, scal=nume, nbret=n1)
        endif
    endif
!
    motcle(1) = 'TOUT'
    tymocl(1) = 'TOUT'
    motcle(2) = 'GROUP_MA'
    tymocl(2) = 'GROUP_MA'
    motcle(3) = 'MAILLE'
    tymocl(3) = 'MAILLE'
!
    nomjv = '&&OP0167.LISTE_MA'
    call reliem(' ', noma, 'NO_MAILLE', mcfact, iocc,&
                nbmc, motcle, tymocl, nomjv, nbma)
    call jeveuo(nomjv, 'L', jnoma)
!
    do 30 im = 0, nbma-1
        nommai = zk8(jnoma+im)
        call jenonu(jexnom(nomama, nommai), numa)
        if (numa .eq. 0) then
            ier = ier + 1
            valk(1) = nommai
            valk(2) = noma
            call utmess('E', 'MODELISA6_10', nk=2, valk=valk)
        else
            if (lmail) then
                if (lnume) then
                    call codent(nume, 'G', knume)
                    nume = nume + 1
                    lgm = lxlgut(knume)
                    if (lgm+lgp .gt. 8) then
                        call utmess('F', 'MODELISA6_11')
                    endif
                    nommai = prfm(1:lgp)//knume
                else
                    lgm = lxlgut(nommai)
                    if (lgm+lgp .gt. 8) then
                        call utmess('F', 'MODELISA6_12')
                    endif
                    nommai = prfm(1:lgp)//nommai
                endif
            endif
            if (lopt .eq. 1) then
                call jeveuo(nomaty, 'L', iatyma)
                ityp=iatyma-1+numa
                if (zi(ityp) .eq. kotyp) then
                    call i2rdl2(numa, zi(ilist), nommai, zk8(klist), iadr)
                endif
            else
                call i2rdl2(numa, zi(ilist), nommai, zk8(klist), iadr)
            endif
        endif
 30 end do
    call jedetr(nomjv)
!
    if (ier .ne. 0) then
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
