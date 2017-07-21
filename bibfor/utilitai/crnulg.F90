subroutine crnulg(numddl)
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
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/juveca.h"
#include "asterc/loisem.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
#include "asterc/asmpi_bcast_i.h"
#include "asterc/asmpi_send_i.h"
#include "asterc/asmpi_recv_i.h"
#include "asterc/asmpi_comm.h"
    character(len=14) :: numddl

#ifdef _USE_MPI
#include "mpif.h"
!
    integer :: rang, nbproc, jrefn, jdojoi, nbjoin, iaux, jgraco, numglo, nddll
    integer :: jmasqu, iproc1, iproc2, nbedge, posit, nmatch, icmp, ico2, nbcmp
    integer :: jtmp, dime, idprn1, idprn2, ntot, jordjo, num, ili, nunoel, jcoord
    integer :: nec, l, numpro, jjoine, jjoinr, nbnoee, jaux, numno1, numno2, iec
    integer :: ncmpmx, iad, jcpnec, jencod, jenvoi1, lgenve1, lgenvr1, poscom, nddld
    integer :: nbddll, jnequ, jnugll, nddl, jenco2, deccmp, jcpne2, jnoext
    integer :: jnbddl, decalp, jddlco, posddl, nuddl, inttmp, nbnoer, jrecep1
    integer :: decalm, nbjver, jprddl, jnujoi, cmpteu, lgrcor, jnbjoi, curpos
    integer :: jdeeq, jmlogl, nuno, ieq, numero_noeud, nb_ddl_envoi, nbddl
    integer :: numero_ddl, ibid, ifich, jposdd, nddlg, jenvoi2, jrecep2
    integer :: lgenve2, lgenvr2, jnujoi1, jnujoi2
    integer(kind=4) :: un
    real(kind=8) :: dx, dy, dz
    character(len=24) :: nonulg
!    integer(kind=4) :: iermpi, lint, lint4, lr8, lc8
    integer(kind=4) :: iaux4, num4, numpr4, n4e, n4r
    mpi_int :: mrank, msize, mpicou
!
    character(len=4) :: chnbjo
    character(len=8) :: noma, k8bid, nomgdr
    character(len=24) :: nojoie, nojoir, nomtmp, noma24
!
!    logical :: first
!    save         first,lint,lint4,lr8,lc8
!    data         first /.true./
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
!    if (first) then
!        call MPI_ERRHANDLER_SET(MPI_COMM_WORLD, MPI_ERRORS_RETURN, iermpi)
!        if (loisem() .eq. 8) then
!            lint=MPI_INTEGER8
!        else
!            lint=MPI_INTEGER
!        endif
!        lint4=MPI_INTEGER4
!        lr8 = MPI_DOUBLE_PRECISION
!        lc8 = MPI_DOUBLE_COMPLEX
!        first= .false.
!    endif
!
    call asmpi_comm('GET', mpicou)
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    call wkvect('&&CRNULG.GRAPH_COMM', 'V V I', nbproc*nbproc, jgraco)

!   RECUPERATION DU NOM DU MAILLAGE DANS LE BUT D'OBTENIR LE JOINT
    call jeveuo(numddl//'.NUME.REFN', 'L', jrefn)
    noma = zk24(jrefn)
    nomgdr = zk24(jrefn + 1)
    call jeveuo(noma//'.DOMJOINTS', 'L', jdojoi)
    call jelira(noma//'.DOMJOINTS', 'LONMAX', nbjoin, k8bid)
    call jeveuo(noma//'.NOEX', 'L', jnoext)
    call jeveuo(noma//'.COORDO    .VALE', 'L', jcoord)

!   CREATION DU GRAPH LOCAL
    do iaux = 1, nbjoin
        zi(jgraco + rang*nbproc + zi(jdojoi + iaux - 1)) = 1
    end do
    nbjoin = nbjoin/2

!   NOMBRE DE DDL LOCAUX
    call jeveuo(numddl//'.NUME.NEQU', 'L', jnequ)
    nbddll = zi(jnequ)
    n4e = nbproc
!   ON COMMUNIQUE POUR SAVOIR QUI EST EN RELATION AVEC QUI
    do iaux = 0, nbproc - 1
        iaux4 = iaux
!        call MPI_BCAST(zi(jgraco+iaux*nbproc), n4e, lint, iaux4, MPI_COMM_WORLD,&
!                       iermpi)
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
            if (zi(jgraco + posit) .eq. 1 .and. zi(jtmp + iproc1) .eq. 0 .and. zi(jtmp + iproc2) .eq. 0) then
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
    call jeveuo(noma//'.DIME', 'L', dime)
    call jeveuo(numddl//'.NUME.DEEQ', 'L', jdeeq)

    call jeveuo(jexnom('&CATA.GD.NOMCMP', nomgdr), 'L', iad)
    call jelira(jexnom('&CATA.GD.NOMCMP', nomgdr), 'LONMAX', ncmpmx, k8bid)
    call wkvect('&&CRNULG.CMP', 'V V I', ncmpmx, jcpnec)
    call wkvect('&&CRNULG.CMP2', 'V V I', ncmpmx, jcpne2)

!   !!! VERIFIER QU'IL N'Y A PAS DE MACRO-ELTS
!   CALCUL DU NOMBRE D'ENTIERS CODES A PARTIR DE LONMAX
    nec = ntot/zi(dime) - 2
    call wkvect('&&CRNULG.NEC', 'V V I', nec, jencod)
    call wkvect('&&CRNULG.NEC2', 'V V I', nec, jenco2)

!   Creation de la numerotation globale
    call wkvect(numddl//'.NUME.NULG', 'G V I', nbddll, jnugll)
    call wkvect(numddl//'.NUME.PDDL', 'G V I', nbddll, jposdd)
    do iaux = 0, nbddll - 1
        zi(jnugll + iaux) = -1
        zi(jposdd + iaux) = -1
    end do
    numglo = 0
    ifich = 16 + rang
    do iaux = 0, nbddll - 1
        numero_noeud = zi(jdeeq + iaux*2)
        numero_ddl = zi(jdeeq + iaux*2 + 1)
        if ( zi(jnoext + numero_noeud - 1).eq.rang ) then
            zi(jnugll + iaux) = numglo
            zi(jposdd + iaux) = rang
            !dx = 10.*zr(jcoord + (numero_noeud - 1)*3)
            !dy = 10.*zr(jcoord + (numero_noeud - 1)*3 + 1)
            !dz = 10.*zr(jcoord + (numero_noeud - 1)*3 + 2)
            !ibid = nint(dx) + 11*nint(dy) + 121*nint(dz)
            !write(ifich, *) ibid, numero_noeud
            !write(ifich, *) ibid, numero_noeud, numero_ddl
            numglo = numglo + 1
        endif
    end do
!
    call wkvect('&&CRNULG.NBDDLL', 'V V I', nbproc, jnbddl)
    zi(jnbddl + rang) = numglo
!
!   ON CHERCHE LE NOMBRE TOTAL DE DDL AINSI QUE LE DECALAGE
!   DE NUMEROTATION A APPLIQUER POUR CHAQUE PROC
    un = 1
    do iaux = 0, nbproc - 1
        iaux4 = iaux
!        call MPI_BCAST(zi(jnbddl + iaux), 1, lint, iaux4, MPI_COMM_WORLD,&
!                       iermpi)
        call asmpi_bcast_i(zi(jnbddl + iaux), un, iaux4, mpicou)
        if (iaux .ne. 0) then
            zi(jnbddl + iaux) = zi(jnbddl + iaux) + zi(jnbddl + iaux - 1)
        endif
    end do
    zi(jnequ + 1) = zi(jnbddl + nbproc - 1)
    do iaux = nbproc - 1, 1, -1
        zi(jnbddl + iaux) = zi(jnbddl + iaux - 1)
    end do
    zi(jnbddl) = 0

!   Decalage de la numerotation
    do iaux = 0, nbddll - 1
        if ( zi(jnugll + iaux) .ne. -1 ) then
            zi(jnugll + iaux) = zi(jnugll + iaux) + zi(jnbddl + rang)
        endif
    end do
!
    write(6,*)'Je suppose qu un noeud possede par un proc aura sur ce proc l union'
    write(6,*)'des cmp que ce noeud porte sur tous les domaines'
    write(6,*)'Je suppose que les noeuds sont dans le meme ordre des deux cotes du raccord'
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
!            call MPI_SEND(zi(jenvoi1), n4r, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, iermpi)
!            call MPI_RECV(zi(jrecep1), n4e, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, MPI_STATUS_IGNORE, iermpi)
            call asmpi_send_i(zi(jenvoi1), n4r, numpr4, num4, mpicou)
            call asmpi_recv_i(zi(jrecep1), n4e, numpr4, num4, mpicou)
        else if (rang.gt.numpro) then
!            call MPI_RECV(zi(jrecep1), n4e, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, MPI_STATUS_IGNORE, iermpi)
!            call MPI_SEND(zi(jenvoi1), n4r, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, iermpi)
            call asmpi_recv_i(zi(jrecep1), n4e, numpr4, num4, mpicou)
            call asmpi_send_i(zi(jenvoi1), n4r, numpr4, num4, mpicou)
        else
            ASSERT(.false.)
        endif
        call wkvect('&&CRNULG.NUM_DDL_GLOB_E', 'V V I', zi(jrecep1), jenvoi2)
        call wkvect('&&CRNULG.NUM_DDL_GLOB_R', 'V V I', zi(jenvoi1), jrecep2)
        call codent(iaux, 'G', chnbjo)
        call wkvect(numddl//'.NUME.E'//chnbjo(1:3), 'G V I', zi(jrecep1), jnujoi1)
!
        nbddl = 0
        do jaux = 1, nbnoee
            poscom = (jaux - 1)*(1 + nec) + 1
            numno1 = zi(jrecep1 + poscom)
!
            nddl = zzprno(1, numno1, 1)
            nddlg = zi(jnugll + nddl - 1)
! nsellenet 2013-09-27
!            ASSERT(numno1 .eq. zi(jjoine + 2*(jaux - 1)))
! nsellenet 2013-09-27
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
!            call MPI_SEND(zi(jenvoi2), n4e, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, iermpi)
!            call MPI_RECV(zi(jrecep2), n4r, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, MPI_STATUS_IGNORE, iermpi)
            call asmpi_send_i(zi(jenvoi2), n4e, numpr4, num4, mpicou)
            call asmpi_recv_i(zi(jrecep2), n4r, numpr4, num4, mpicou)
        else if (rang.gt.numpro) then
!            call MPI_RECV(zi(jrecep2), n4r, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, MPI_STATUS_IGNORE, iermpi)
!            call MPI_SEND(zi(jenvoi2), n4e, lint, numpr4, num4,&
!                          MPI_COMM_WORLD, iermpi)
            call asmpi_recv_i(zi(jrecep2), n4r, numpr4, num4, mpicou)
            call asmpi_send_i(zi(jenvoi2), n4e, numpr4, num4, mpicou)
        else
            ASSERT(.false.)
        endif
        call wkvect(numddl//'.NUME.R'//chnbjo(1:3), 'G V I', nb_ddl_envoi, jnujoi2)
!
        curpos = 0
        do jaux = 1, nbnoer
            numno1 = zi(jjoinr + 2*(jaux - 1))
            nddll = zzprno(1, numno1, 1)
            nbcmp = zzprno(1, numno1, 2)
            do icmp = 0, nbcmp - 1
! nsellenet 2013-09-27
!                ASSERT(zi(jnugll - 1 + nddll + icmp) .eq. -1)
! nsellenet 2013-09-27
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
!
! nsellenet 2013-09-27
!    do iaux = 0, nbddll - 1
!        ASSERT(zi(jnugll + iaux) .ne. -1)
!    end do
! nsellenet 2013-09-27
!
    call jedetc('V', '&&CRNULG', 1)
!
    call jedema()
#endif
!
end subroutine
