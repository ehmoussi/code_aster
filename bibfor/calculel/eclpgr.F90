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

subroutine eclpgr()
    implicit none
! person_in_charge: j-pierre.lefebvre at edf.fr
!   - TRAITEMENT DU MOT CLE CREA_RESU/ECLA_PG
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/gettco.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/celfpg.h"
#include "asterfort/dismoi.h"
#include "asterfort/eclpgc.h"
#include "asterfort/exlima.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/gnomsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rscrsd.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/rsutnu.h"
#include "asterfort/utmess.h"
    character(len=24) :: noojb
!
! ---------------------------------------------------------------------
    real(kind=8) :: prec
    integer :: ibid, iret, i, iains1, iains2
    integer :: nbsy, np, nc, isy
    integer :: nbordr, iordr
    integer :: mxsy, iret2, nbproc
    parameter(mxsy=15)
    character(len=8) :: mo1, ma1, ma2, kbid, resu, evo1, crit
    character(len=16) :: typres, nomcmd, nomsy1, nomsy2, licham(mxsy)
    character(len=16) :: typre2
    character(len=19) :: ligrel, ch1, ch2, prchno
    character(len=24) :: nomfpg, valk(2)
    integer, pointer :: nume_ordre(:) => null()
    mpi_int :: msize
! DEB -----------------------------------------------------------------
!
    call jemarq()
!
!
    call getres(resu, typre2, nomcmd)
    call getvid('ECLA_PG', 'RESU_INIT', iocc=1, scal=evo1, nbret=ibid)
    call gettco(evo1, typres)
    if (typres .ne. typre2) then
        call utmess('F', 'CALCULEL2_37')
    endif
!
    call getvid('ECLA_PG', 'MAILLAGE', iocc=1, scal=ma2, nbret=ibid)
    call getvid('ECLA_PG', 'MODELE_INIT', iocc=1, scal=mo1, nbret=ibid)
    call getvtx('ECLA_PG', 'NOM_CHAM', iocc=1, nbval=mxsy, vect=licham,&
                nbret=nbsy)
!
    call asmpi_info(size=msize)
    nbproc = to_aster_int(msize)
    if ( nbproc.gt.1 ) then
        call utmess('F', 'CALCULEL2_59')
    endif
!
    call dismoi('NOM_MAILLA', mo1, 'MODELE', repk=ma1)
!
    call exlima('ECLA_PG', 1, 'V', mo1, ligrel)
!
    nomfpg='&&ECLPGR.NOMFPG'
!
!     -- CREATION DE LA SD RESULTAT : RESU
!     ------------------------------------
    call getvr8('ECLA_PG', 'PRECISION', iocc=1, scal=prec, nbret=np)
    call getvtx('ECLA_PG', 'CRITERE', iocc=1, scal=crit, nbret=nc)
    call rsutnu(evo1, 'ECLA_PG', 1, '&&ECLPGR.NUME_ORDRE', nbordr,&
                prec, crit, iret)
    if (nbordr .eq. 0) then
        call utmess('F', 'CALCULEL2_38')
    endif
    call jeveuo('&&ECLPGR.NUME_ORDRE', 'L', vi=nume_ordre)
!
    if (resu .ne. evo1) call rscrsd('G', resu, typres, nbordr)
!
!
!     -- ON CALCULE LES CHAM_NO RESULTATS :
!     --------------------------------------
    do isy = 1, nbsy
!
!       -- ON SUPPOSE QUE TOUS LES INSTANTS ONT LE MEME PROFIL :
!          PRCHNO
        noojb='12345678.00000.NUME.PRNO'
        call gnomsd(' ', noojb, 10, 14)
        prchno=noojb(1:19)
!
        nomsy1=licham(isy)
        if (nomsy1(6:9) .ne. 'ELGA') then
            call utmess('F', 'CALCULEL2_41')
        endif
        nomsy2 = nomsy1
!
        do i = 1, nbordr
            iordr=nume_ordre(i)
            call rsexch(' ', evo1, nomsy1, iordr, ch1,&
                        iret)
            if (iret .gt. 0) goto 10
!
            call rsexch(' ', resu, nomsy2, iordr, ch2,&
                        iret)
!
!         -- ON NE CALCULE NOMFPG QUE POUR LE 1ER NUME_ORDRE :
!         -- ON VERIFIE QUE LES CHAMPS ONT TOUS LA MEME FAMILLE DE
!            DE POINTS DE GAUSS
            if (i .eq. 1) then
                call celfpg(ch1, nomfpg, iret2)
                if (iret2 .eq. 1) then
                    valk(1)=mo1
                    valk(2)=licham(1)
                    call utmess('I', 'CALCULEL2_33', nk=2, valk=valk)
                endif
            endif
!
            call eclpgc(ch1, ch2, ligrel, ma2, prchno,&
                        nomfpg)
            call rsnoch(resu, nomsy2, iordr)
 10         continue
        end do
        call jedetr(nomfpg)
    end do
!
!
!       -- ON RECOPIE LE PARAMETRE "INST" :
!       -----------------------------------
    do i = 1, nbordr
        iordr=nume_ordre(i)
        call rsadpa(evo1, 'L', 1, 'INST', iordr,&
                    0, sjv=iains1, styp=kbid)
        call rsadpa(resu, 'E', 1, 'INST', iordr,&
                    0, sjv=iains2, styp=kbid)
        zr(iains2)=zr(iains1)
    end do
!
!
! --- MENAGE
!
    call jedetr('&&ECLPGR.NUME_ORDRE')
!
    call jedema()
end subroutine
