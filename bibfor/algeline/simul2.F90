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

subroutine simul2(resu, nomcmd, masse, modsta, nbdir,&
                  dir, nomnoe, nbno)
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelibe.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
#include "asterfort/mtdscr.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsorac.h"
#include "asterfort/rsvpar.h"
#include "asterfort/typddl.h"
#include "asterfort/utmess.h"
#include "asterfort/vtcrem.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
    integer :: nbdir, nbno
    real(kind=8) :: dir(*)
    character(len=*) :: resu, nomcmd, masse, modsta, nomnoe(*)
    character(len=19) :: mass2
!
!     OPERATEUR :   CALC_CHAR_SEISME
!
!     CREE LE VECTEUR SECOND MEMBRE DANS LE CAS D'UN CALCUL SISMIQUE
!     STRUCTURE : MULTI-APPUI
!
!     ------------------------------------------------------------------
!
    integer :: lmat, neq, ibid, iordr(1), ier
    real(kind=8) :: r8b, epsi
    character(len=8) :: cmp(6), crit
    character(len=24) :: valk(3)
    character(len=14) :: nume
    character(len=16) :: acces
    character(len=19) :: resu2, chamno
    complex(kind=8) :: c16b
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, id, idchm, iddl
    integer :: in, iret, nba, nbb, nbl, nbliai, nbtrou
!
    real(kind=8) :: xd
    real(kind=8), pointer :: vecteur(:) => null()
    real(kind=8), pointer :: mst(:) => null()
!-----------------------------------------------------------------------
    data cmp / 'DX' , 'DY' , 'DZ' , 'DRX' , 'DRY' , 'DRZ' /
!     ------------------------------------------------------------------
    call jemarq()
    resu2 = resu
    epsi = r8prem()
    ier = 0
!
    call mtdscr(masse)
    mass2=masse
    call jeveuo(mass2//'.&INT', 'E', lmat)
    call dismoi('NB_EQUA', masse, 'MATR_ASSE', repi=neq)
    call dismoi('NOM_NUME_DDL', masse, 'MATR_ASSE', repk=nume)
    AS_ALLOCATE(vr=vecteur, size=neq)
!
!     --- CREATION DU CHAM_NO RESULTAT ---
!
    call vtcrem(resu2, masse, 'G', 'R')
    call jeveuo(resu2//'.VALE', 'E', idchm)
!
!     --- ON BOUCLE SUR LES NOEUDS ---
!
    do id = 1, nbdir
        xd = dir(id)
        if (abs(xd) .gt. epsi) then
            do in = 1, nbno
                acces(1:8 ) = nomnoe(in)
                acces(9:16) = cmp(id)
!
!              --- ON RECUPERE LE MODE STATIQUE ASSOCIE AU NOEUD ---
                call rsorac(modsta, 'NOEUD_CMP', ibid, r8b, acces,&
                            c16b, epsi, crit, iordr, 1,&
                            nbtrou)
                if (nbtrou .ne. 1) then
                    ier = ier + 1
                    valk (1) = acces(1:8)
                    valk (2) = acces(9:16)
                    call utmess('E', 'ALGELINE5_41', nk=2, valk=valk)
                    goto 20
                endif
                call rsvpar(modsta, iordr(1), 'TYPE_DEFO', ibid, r8b,&
                            'DEPL_IMPO', iret)
                if (iret .ne. 100) then
                    ier = ier + 1
                    valk (1) = 'MODE_MECA'
                    valk (2) = acces(1:8)
                    valk (3) = acces(9:16)
                    call utmess('E', 'ALGELINE5_42', nk=3, valk=valk)
                    goto 20
                endif
                call rsexch(' ', modsta, 'DEPL', iordr(1), chamno,&
                            iret)
                if (iret .ne. 0) then
                    ier = ier + 1
                    valk (1) = chamno
                    valk (2) = acces(1:8)
                    valk (3) = acces(9:16)
                    call utmess('E', 'ALGELINE5_43', nk=3, valk=valk)
                    goto 20
                else
                    call jeveuo(chamno//'.VALE', 'L', vr=mst)
!
!                 --- ON EFFECTUE LE PRODUIT  MASSE * CHAM_NO ---
                    do i = 0, neq-1
                        vecteur(1+i) = -xd * mst(1+i)
                    end do
                    call jelibe(chamno//'.VALE')
                    call mrmult('CUMU', lmat, vecteur, zr(idchm), 1,&
                                .true._1)
                endif
 20             continue
            end do
        endif
    end do
    if (ier .ne. 0) then
        call utmess('F', 'ALGELINE5_40')
    endif
!
    call wkvect('&&SIMUL2.DDL.BLOQUE', 'V V I', neq, iddl)
    call typddl('BLOQ', nume, neq, zi(iddl), nba,&
                nbb, nbl, nbliai)
!
    do in = 0, neq-1
        zr(idchm+in) = ( 1 - zi(iddl+in) ) * zr(idchm+in)
    end do
!
! --- MENAGE
    call jelibe(resu2//'.VALE')
    AS_DEALLOCATE(vr=vecteur)
    call jedetr('&&SIMUL2.DDL.BLOQUE')
!
    call jedema()
end subroutine
