! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine crnlgc(numddl)
    implicit none
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/isdeco.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetc.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/juveca.h"
#include "asterfort/utimsd.h"
#include "asterc/loisem.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
#include "asterc/asmpi_bcast_i.h"
#include "asterc/asmpi_send_i.h"
#include "asterc/asmpi_recv_i.h"
#include "asterc/asmpi_comm.h"
    character(len=14) :: numddl

#ifdef _USE_MPI
!
    integer :: rang, nbproc, jrefn, jdojoi, nbjoin, iaux, jgraco, nddll
    integer :: jmasqu, iproc1, iproc2, nbedge, posit, nmatch, icmp, ico2, nbcmp
    integer :: jtmp, dime, idprn1, idprn2, ntot, jordjo, num, ili, nunoel
    integer :: nec, l, numpro, jjoine, jjoinr, nbnoee, jaux, numno1, numno2, iec
    integer :: ncmpmx, iad, jcpnec, jencod, jenvoi1, lgenve1, lgenvr1, poscom, nddld
    integer :: nbddll, jnequ, jnugll, nddl, jenco2, deccmp, jcpne2
    integer :: jnbddl, decalp, jddlco, posddl, nuddl, inttmp, nbnoer, jrecep1
    integer :: decalm, nbjver, jprddl, jnujoi, cmpteu, lgrcor, jnbjoi, curpos
    integer :: jdeeq, jmlogl, nuno, ieq, numero_noeud, nb_ddl_envoi, nbddl
    integer :: ibid, jposdd, nddlg, jenvoi2, jrecep2, jjoin, ijoin, numnoe
    integer :: lgenve2, lgenvr2, jnujoi1, jnujoi2, iret, iret1, iret2, nlili
    integer(kind=4) :: un
    real(kind=8) :: dx, dy, dz
    integer(kind=4) :: iaux4, num4, numpr4, n4e, n4r
    mpi_int :: mrank, msize, mpicou
!
    character(len=4) :: chnbjo
    character(len=8) :: noma, k8bid, nomgdr
    character(len=19) :: nomlig
    character(len=24) :: nojoie, nojoir, nomtmp, noma24, nonulg, join
!
!----------------------------------------------------------------------
    integer :: zzprno
!
!---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS PRNO DES S.D. LIGREL
!     REPERTORIEES DANS LE CHAMP LILI DE NUME_DDL ET A LEURS ADRESSES
!     ZZPRNO(ILI,NUNOEL,1) = NUMERO DE L'EQUATION ASSOCIEES AU 1ER DDL
!                            DU NOEUD NUNOEL DANS LA NUMEROTATION LOCALE
!                            AU LIGREL ILI DE .LILI
!     ZZPRNO(ILI,NUNOEL,2) = NOMBRE DE DDL PORTES PAR LE NOEUD NUNOEL
!     ZZPRNO(ILI,NUNOEL,2+1) = 1ER CODE
!     ZZPRNO(ILI,NUNOEL,2+NEC) = NEC IEME CODE
!
    zzprno(ili,nunoel,l) = zi(idprn1-1+zi(idprn2+ili-1)+ (nunoel-1)* (nec+2)+l-1)
!
    call jemarq()
!
    call asmpi_comm('GET', mpicou)
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    ASSERT(nbproc.lt.9999)

!   RECUPERATION DU NOM DU MAILLAGE DANS LE BUT D'OBTENIR LE JOINT
    call jeveuo(numddl//'.NUME.REFN', 'L', jrefn)
    noma = zk24(jrefn)
    nomgdr = zk24(jrefn + 1)

    call jeveuo(numddl//'.NUME.NULG', 'E', jnugll)
    call jeveuo(numddl//'.NUME.PDDL', 'E', jposdd)

    call wkvect('&&CRNULG.GRAPH_COMM', 'V V I', nbproc*nbproc, jgraco)
!
    nbjoin = 0
    jdojoi = 0
    call jeexin(noma//'.DOMJOINTS', iret)
    if(iret > 0) then
        call jeveuo(noma//'.DOMJOINTS', 'L', jdojoi)
        call jelira(noma//'.DOMJOINTS', 'LONMAX', nbjoin, k8bid)
    !   CREATION DU GRAPH LOCAL
        do iaux = 1, nbjoin
            zi(jgraco + rang*nbproc + zi(jdojoi + iaux - 1)) = 1
        end do
        nbjoin = nbjoin/2
    endif

!   NOMBRE DE DDL LOCAUX
    call jeveuo(numddl//'.NUME.NEQU', 'L', jnequ)
    nbddll = zi(jnequ)
    n4e = nbproc
!   ON COMMUNIQUE POUR SAVOIR QUI EST EN RELATION AVEC QUI
    do iaux = 0, nbproc - 1
        iaux4 = iaux
        call asmpi_bcast_i(zi(jgraco+iaux*nbproc), n4e, iaux4, mpicou)
    end do

    nbedge = 0
    do iaux = 1, nbproc*nbproc
       if (zi(jgraco+iaux-1) .eq. 1) nbedge = nbedge+1
    end do
    nbedge = nbedge/2

!   RECHERCHE DES COUPLAGES MAXIMAUX
    call wkvect('&&CRNULG.MASQUE', 'V V I', nbproc*nbproc, jmasqu)
    call wkvect('&&CRNULG.TMP', 'V V I', nbproc, jtmp)
    nmatch = 1
60  continue

    do iproc1 = 0, nbproc - 1
        do iproc2 = 0, nbproc - 1
            posit = iproc1*nbproc + iproc2
            if (zi(jgraco + posit) .eq. 1 .and. zi(jtmp + iproc1) .eq. 0 &
                .and. zi(jtmp + iproc2) .eq. 0) then
                zi(jgraco + posit) = 0
                zi(jmasqu + posit) = nmatch
                posit = iproc2*nbproc + iproc1
                zi(jgraco + posit) = 0
                zi(jmasqu + posit) = nmatch
                nbedge = nbedge-1
                zi(jtmp + iproc1) = 1
                zi(jtmp + iproc2) = 1
            endif
        end do
    end do

    nmatch = nmatch + 1
    do iaux = 0, nbproc - 1
        zi(jtmp + iaux) = 0
    end do
    if (nbedge .gt. 0) goto 60

    nmatch = nmatch - 1
    call wkvect('&&CRNULG.ORDJOI', 'V V I', nmatch, jordjo)
    do iaux = 0, nmatch - 1
        zi(jordjo + iaux) = -1
    end do

    nbjver = 0
    do iaux = 0, nbproc - 1
       num = zi(jmasqu + rang*nbproc + iaux)
       ASSERT(num .le. nmatch)
       if (num .ne. 0) then
           zi(jordjo + num - 1) = iaux
           nbjver = nbjver + 1
       endif
    end do
    ASSERT(nbjver .eq. nbjoin)
    call wkvect(numddl//'.NUME.NBJO', 'G V I', 1 + nmatch, jnbjoi)
    zi(jnbjoi) = nmatch

!     !!!! IL PEUT ETRE INTERESSANT DE STOCKER CES INFOS
!     !!!! EN CAS DE CONSTRUCTION MULTIPLE DE NUMEDDL
!
!   RECHERCHE DES ADRESSES DU .PRNO DE .NUME
    call jeveuo(numddl//'.NUME.PRNO', 'E', idprn1)
    call jeveuo(jexatr(numddl//'.NUME.PRNO', 'LONCUM'), 'L', idprn2)
    call jelira(jexnum(numddl//'.NUME.PRNO', 1), 'LONMAX', ntot, k8bid)
    call jeveuo(numddl//'.NUME.DEEQ', 'L', jdeeq)

    call jeveuo(noma//'.DIME', 'L', dime)

!   !!! VERIFIER QU'IL N'Y A PAS DE MACRO-ELTS
!   CALCUL DU NOMBRE D'ENTIERS CODES A PARTIR DE LONMAX
    nec = ntot/zi(dime) - 2
    call wkvect('&&CRNULG.NEC', 'V V I', nec, jencod)
    call wkvect('&&CRNULG.NEC2', 'V V I', nec, jenco2)

    call jeveuo(jexnom('&CATA.GD.NOMCMP', nomgdr), 'L', iad)
    call jelira(jexnom('&CATA.GD.NOMCMP', nomgdr), 'LONMAX', ncmpmx, k8bid)
    call wkvect('&&CRNULG.CMP', 'V V I', ncmpmx, jcpnec)
    call wkvect('&&CRNULG.CMP2', 'V V I', ncmpmx, jcpne2)
!
!   Il faut maintenant communiquer les numeros partages
!   NOTE : On pourrait sans doute se passer d'une communication puisque celui qui recoit
!          sait ce qu'il attend et celui qui envoit pourrait tout envoyer
    do iaux = 0, nmatch - 1
!
!       RECHERCHE DU JOINT
        numpro = zi(jordjo + iaux)
        zi(jnbjoi + iaux + 1) = numpro
        if (numpro .ne. -1) then
        num = zi(jmasqu + rang*nbproc + numpro)
        call codent(numpro, 'G', chnbjo)
        nojoie = noma//'.E'//chnbjo
        nojoir = noma//'.R'//chnbjo
        call jeveuo(nojoie, 'L', jjoine)
        call jelira(nojoie, 'LONMAX', nbnoee, k8bid)
        call jeveuo(nojoir, 'L', jjoinr)
        call jelira(nojoir, 'LONMAX', nbnoer, k8bid)
        nbnoee = nbnoee/2
        nbnoer = nbnoer/2
!
!       DES DEUX COTES LES NOEUDS NE SONT PAS DANS LE MEME ORDRE ?
        num4 = num
        numpr4 = numpro
        lgenve1 = nbnoee*(1 + nec) + 1
        lgenvr1 = nbnoer*(1 + nec) + 1
        call wkvect('&&CRNULG.NOEUD_NEC_E1', 'V V I', lgenvr1, jenvoi1)
        call wkvect('&&CRNULG.NOEUD_NEC_R1', 'V V I', lgenve1, jrecep1)
!
        lgenve2 = nbnoee*(1 + nec) + 1
        lgenvr2 = nbnoer*(1 + nec) + 1
!
!       On commence par envoyer, le but final est de recevoir les numeros de ddl
!       On boucle donc sur les noeuds a recevoir
        nb_ddl_envoi = 0
        do jaux = 1, nbnoer
            poscom = (jaux - 1)*(1 + nec) + 1
            numno1 = zi(jjoinr + 2*(jaux - 1))
            numno2 = zi(jjoinr + 2*jaux - 1)
            zi(jenvoi1 + poscom) = numno2
            do iec = 1, nec
                zi(jenvoi1 + poscom + iec) = zzprno(1, numno1, 2 + iec)
            end do
            nb_ddl_envoi = nb_ddl_envoi + zzprno(1, numno1, 2)
        end do
        zi(jenvoi1) = nb_ddl_envoi
        n4r = lgenvr1
        n4e = lgenve1
        if (rang .lt. numpro) then
            call asmpi_send_i(zi(jenvoi1), n4r, numpr4, num4, mpicou)
            call asmpi_recv_i(zi(jrecep1), n4e, numpr4, num4, mpicou)
        else if (rang.gt.numpro) then
            call asmpi_recv_i(zi(jrecep1), n4e, numpr4, num4, mpicou)
            call asmpi_send_i(zi(jenvoi1), n4r, numpr4, num4, mpicou)
        else
            ASSERT(.false.)
        endif
        call wkvect('&&CRNULG.NUM_DDL_GLOB_E', 'V V I', zi(jrecep1), jenvoi2)
        call wkvect('&&CRNULG.NUM_DDL_GLOB_R', 'V V I', zi(jenvoi1), jrecep2)
        call codent(iaux, 'G', chnbjo)
        call wkvect(numddl//'.NUMEE'//chnbjo, 'G V I', zi(jrecep1), jnujoi1)
!
        nbddl = 0
        do jaux = 1, nbnoee
            poscom = (jaux - 1)*(1 + nec) + 1
            numno1 = zi(jrecep1 + poscom)
!
            nddl = zzprno(1, numno1, 1)
            nddlg = zi(jnugll + nddl - 1)
!
!           Recherche des composantes demandees
            do iec = 1, nec
                zi(jencod + iec - 1) = zzprno(1, numno1, 2 + iec)
                zi(jenco2 + iec - 1) = zi(jrecep1 + poscom + iec)
            end do
            call isdeco(zi(jencod), zi(jcpnec), ncmpmx)
            call isdeco(zi(jenco2), zi(jcpne2), ncmpmx)
            ico2 = 0
            do icmp = 1, ncmpmx
                if ( zi(jcpnec + icmp - 1) .eq. 1 ) then
                    if ( zi(jcpne2 + icmp - 1) .eq. 1 ) then
                        zi(jenvoi2 + nbddl) = nddlg + ico2
                        zi(jnujoi1 + nbddl) = nddl + ico2
                    endif
                    ico2 = ico2 + 1
                    nbddl = nbddl + 1
                endif
            enddo
        enddo
        ASSERT(zi(jrecep1) .eq. nbddl)
        n4e = nbddl
        n4r = nb_ddl_envoi
        if (rang .lt. numpro) then
            call asmpi_send_i(zi(jenvoi2), n4e, numpr4, num4, mpicou)
            call asmpi_recv_i(zi(jrecep2), n4r, numpr4, num4, mpicou)
        else if (rang.gt.numpro) then
            call asmpi_recv_i(zi(jrecep2), n4r, numpr4, num4, mpicou)
            call asmpi_send_i(zi(jenvoi2), n4e, numpr4, num4, mpicou)
        else
            ASSERT(.false.)
        endif
        call wkvect(numddl//'.NUMER'//chnbjo, 'G V I', nb_ddl_envoi, jnujoi2)
!
        curpos = 0
        do jaux = 1, nbnoer
            numno1 = zi(jjoinr + 2*(jaux - 1))
            nddll = zzprno(1, numno1, 1)
            nbcmp = zzprno(1, numno1, 2)
            do icmp = 0, nbcmp - 1
                zi(jnugll - 1 + nddll + icmp) = zi(jrecep2 + curpos)
                zi(jposdd - 1 + nddll + icmp) = numpro
                zi(jnujoi2 + curpos) = nddll + icmp
                curpos = curpos + 1
            enddo
        enddo
        ASSERT(curpos .eq. nb_ddl_envoi)
!
        call jedetr('&&CRNULG.NOEUD_NEC_E1')
        call jedetr('&&CRNULG.NOEUD_NEC_R1')
        call jedetr('&&CRNULG.NUM_DDL_GLOB_E')
        call jedetr('&&CRNULG.NUM_DDL_GLOB_R')
        endif
    end do

    call jelira(numddl//'.NUME.PRNO', 'NMAXOC', nlili, k8bid)
    do ili = 2, nlili
        call jeexin(jexnum(numddl//'.NUME.PRNO', ili), iret)
        if( iret.ne.0 ) then
            call jenuno(jexnum(numddl//'.NUME.LILI', ili), nomlig)
            join = nomlig//".NBJO"
            call jeexin(join, iret)
            if( iret.eq.0 ) cycle
            call jeveuo(join, 'L', jjoin)
            call jelira(join, 'LONMAX', nbjoin)
            do ijoin = 1, nbjoin
                numpro = zi(jjoin+ijoin-1)
                if( numpro.ne.-1 ) then
                    numpr4 = numpro
                    num4 = ijoin
                    call codent(numpro, 'G', chnbjo)
                    nojoie = nomlig//'.E'//chnbjo
                    nojoir = nomlig//'.R'//chnbjo

                    call jeexin(nojoie, iret1)
                    if( iret1.ne.0 ) then
                        call jeveuo(nojoie, 'L', jjoine)
                        call jelira(nojoie, 'LONMAX', nbnoee, k8bid)
                        call wkvect('&&CRNUGL.NUM_DDL_GLOB_E', 'V V I', nbnoee, jnujoi1)
                        do jaux = 1, nbnoee
                            numnoe = -zi(jjoine+jaux-1)
                            ASSERT(zzprno(ili, numnoe, 2).eq.1)
                            nddll = zzprno(ili, numnoe, 1)
                            zi(jnujoi1+jaux-1) = zi(jnugll - 1 + nddll)
                        enddo
                        n4e = nbnoee
                    endif

                    call jeexin(nojoir, iret2)
                    if( iret2.ne.0 ) then
                        call jeveuo(nojoir, 'L', jjoinr)
                        call jelira(nojoir, 'LONMAX', nbnoer, k8bid)
                        call wkvect('&&CRNUGL.NUM_DDL_GLOB_R', 'V V I', nbnoer, jnujoi2)
                    endif

                    if (rang .lt. numpro) then
                        if( iret1.ne.0 ) then
                            call asmpi_send_i(zi(jnujoi1), n4e, numpr4, num4, mpicou)
                        endif
                        if( iret2.ne.0 ) then
                            call asmpi_recv_i(zi(jnujoi2), n4r, numpr4, num4, mpicou)
                        endif
                    else if (rang.gt.numpro) then
                        if( iret2.ne.0 ) then
                            call asmpi_recv_i(zi(jnujoi2), n4r, numpr4, num4, mpicou)
                        endif
                        if( iret1.ne.0 ) then
                            call asmpi_send_i(zi(jnujoi1), n4e, numpr4, num4, mpicou)
                        endif
                    endif

                    if( iret2.ne.0 ) then
                        do jaux = 1, nbnoer
                            numnoe = -zi(jjoinr+jaux-1)
                            ASSERT(zzprno(ili, numnoe, 2).eq.1)
                            nddll = zzprno(ili, numnoe, 1)
                            zi(jnugll - 1 + nddll) = zi(jnujoi2+jaux-1)
                            zi(jposdd - 1 + nddll) = numpro
                        enddo
                    endif
                    call jedetr('&&CRNUGL.NUM_DDL_GLOB_E')
                    call jedetr('&&CRNUGL.NUM_DDL_GLOB_R')
                endif
            enddo
        endif
    enddo
!
    call jedetc('V', '&&CRNULG', 1)
!
    call jedema()
#endif
!
end subroutine
