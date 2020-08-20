!--------------------------------------------------------------------
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
subroutine pcptcc(option, ldist, dbg_ob, dbgv_ob, lcpu, ltest, rang, nbproc, mpicou,&
                  nbordr, nbpas, vldist, vcham, lisori, nbordi, lisord,&
                  modele, sd_partition, lsdpar,&
                  i, ipas, ideb, ifin, irelat,&
                  chamno, lonnew, lonch, ktyp, vcnoch, noch, nochc)
implicit none
!
#include "jeveux.h"
#include "blas/dcopy.h"
#include "blas/zcopy.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_barrier.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/infniv.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeimpo.h"
#include "asterfort/jelibe.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeexin.h"
#include "asterfort/getvtx.h"
#include "asterfort/utimsd.h"
#include "asterfort/utmess.h"
#include "asterfort/vecinc.h"
#include "asterfort/vecini.h"
#include "asterfort/vecink.h"
#include "asterfort/vecint.h"
#include "asterfort/wkvect.h"
    integer           :: option, nbordr, i, ipas, lonnew, lonch
    character(len=1)  :: ktyp
    character(len=19)  :: lisord
    character(len=24)  :: vldist, vcham, lisori, modele, chamno, vcnoch
    aster_logical      :: ldist, dbg_ob, lsdpar
    aster_logical      :: dbgv_ob, lcpu, ltest
    integer            :: rang, nbpas, nbproc, ideb, ifin, irelat
    integer            :: nbordi
    mpi_int            :: mpicou
    character(len=8)   :: sd_partition
    real(kind=8), pointer :: noch(:)
    complex(kind=8), pointer :: nochc(:)
! ---------------------------------------------------------------------
!
!  PREPARATION DU CONTEXTE DU PARALLELISME EN TEMPS POUR CALC_CHAMP
!  P______________C___________P_______________T__________C____C____
! ----------------------------------------------------------------------
    mpi_int :: mpicow, mrang, mnbproc
    integer :: ifm, niv, iret, jldist, iaux1, k, jvcham, jordi, compt, jordr, jparti, p
    integer :: lonmax, lonmin, jcnoch, jval
    real(kind=8) :: rzero
    complex(kind=8) :: czero
    character(len=6)  :: k6
    character(len=16) :: kmpi
    character(len=24) :: kblanc, k24b
!
    if(((option.ge.1).and.(option.le.8)).or.(option.eq.101).or.(option.eq.301)&
             .or.(option.eq.102)) then
! Option prévue
    else
      ASSERT(.False.)
    endif
    call infniv(ifm, niv)
    rzero=0.d0
    czero=dcmplx(0.D0,0.D0)
!
! OPTION=1
! INITIALISATION CONTEXTE PARALLELISME EN TEMPS
! INPUT: nbordr, lisord (avec option=1)
! OUTPUT: ldist, dbg_ob, dbgv_ob, lcpu, ltest, rang, nbproc, nbpas, nbordi (avec option=1),&
!         mpicou, vldist, vcham, lisori (avec option=1)
    if ((option.eq.1).or.(option.eq.101)) then
!
! INITIALISATIONS
      kblanc=' '
      rang=-9999
      nbproc=-9999
      nbpas=-9999
      nbordi=-9999
      mpicou=-9999
! ACTIVATION DU PARALLELISME DISTRIBUE
      ldist=.False.
! ACTIVATION DU MODE DEBUG ASSOCIE
      dbg_ob=.False.
! ACTIVATION DU MODE DEBUG TRES VERBOSE: IMPRESSION CHAM_NOS GENERES.
      dbgv_ob=.False.
! ACTIVATION DU PROFILING
      lcpu=.False.
! ACTIVATION DU TEST CANONIQUE: CHAMNO.VALE = VECTEUR DE VALEUR IORDR OU (0,IORDR)
! ON VERIFIE AINSI LA BONNE DISTRIBUTION MPI: LICITE QUE SI LDIST=.TRUE.
      ltest=.False.
!
! PARAMETRAGE DES LOGICALS OUTPUT
      if (niv.eq.1) then
        dbg_ob=.False.
        dbgv_ob=.False.
        lcpu=.False.
      else if (niv.eq.2) then
        dbg_ob=.True.
        dbgv_ob=.False.
        lcpu=.False.
      else if (niv.ge.3) then
        dbg_ob=.True.
        dbgv_ob=.True.
        lcpu=.True.
      endif
!
! ACCELERATION MPI (EFFECTIVE QUE SI MPI_NBPROC>1 ET NBPAS>1)
      call getvtx(' ', 'PARALLELISME_TEMPS', scal=kmpi, nbret=iret)
      ASSERT(iret.ge.0)
      if (kmpi(1:3).eq.'OUI') then
        ldist=.true.
      else if (kmpi(1:3).eq.'NON') then
        ldist=.false.
      else
! valeur aberrante
        ASSERT(.false.)
      endif
!
! CONTEXTE MPI
      call asmpi_comm('GET_WORLD', mpicow)
      call asmpi_comm('GET', mpicou)
      if (mpicow.ne.mpicou) then
        ASSERT(.False.)
      endif
      call asmpi_info(mpicow, mrang, mnbproc)
      rang = to_aster_int(mrang)
      ASSERT(rang.ge.0)
      nbproc = to_aster_int(mnbproc)
      ASSERT(nbproc.ge.1)
! DETERMINATION DU NBRE DE PAS PARALLELES MPI: NBPAS
      nbpas=nbordr/nbproc
      ASSERT(nbpas.ge.0)
      if (dbg_ob) then
        write(ifm,*)'< ',rang,'pcptcc> valeur kmpi/ldist/dbgv_ob/lcpu=',kmpi,ldist,dbgv_ob,lcpu
        write(ifm,*)'< ',rang,'pcptcc> nbordr/nbproc/nbpas= ',nbordr,nbproc,nbpas
      endif
      if ((ldist).and.((nbpas.lt.1).or.(nbproc.eq.1))) then
        ldist=.False.
        call utmess('A', 'PREPOST_15')
      endif
!
! VECTEUR PILOTANT LA DISTRIBUTION DES IORDR SUIVANT PAR NBPAS PAQUETS DE NBPROC PROCESSUS MPI
! AU PAQUET IPAS, CHAQUE MPI TRAITE SON PAS DE TEMPS DEDIE (IPAS-1)*NBPROC+(RANG+1)
! (RANG COMMENCE A 0, COMMUNICATIONS MPI SUR AU SEIN DE CES PAQUETS A PREVOIR)
! TOUS LES PROCESSUS MPI FONT LE RELIQUAT > NBPAS*NBPROC (PAS DE COM MPI A PREVOIR)
      vldist='&&PCPTCC.VLDIST'
      call wkvect(vldist,'V V I',nbordr,jldist)
      if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> creation objet=',vldist
      call vecint(nbordr,rang,zi(jldist))
      if (ldist) then
        iaux1=0
        do k=1,nbpas*nbproc
          if (iaux1.gt.(nbproc-1)) iaux1=0
          zi(jldist+k-1)=iaux1
          iaux1=iaux1+1          
        enddo
      endif
      if (dbgv_ob) call jeimpo(ifm,vldist,'vldist')
!
! VECTEUR STOCKANT LES NOMS DES NBPROC CHAMNOS SIMULTANES POUR VTCREB SUIVANT
      if (ldist) then
        vcham='&&PCPTCC.VCHAM'
        call wkvect(vcham,'V V K24',nbproc,jvcham)
        if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> creation objet=',vcham
        call vecink(nbproc,kblanc,zk24(jvcham))
      endif
!
! CONSTITUTION DE LA LISTE D'INSTANTS DEDIES AU PROCESSUS MPI COURANT, POUR TOUS LE
! TRANSITOIRE (DONC SUR TOUS LES NPAS PAQUETS): UTILE POUR CALCUL SUR TOUS LE TRANSITOIRE
! (CF. CALCOP(SIEF_ELGA)) : LISORI. SA TAILLE EST NBORDI.
      if ((ldist).and.(option.eq.1)) then
! NOM DE LA LISTE D'INSTANTS LOCAUX AU PROCESSUS MPI COURANT
        lisori = '&&PCPTCC.NUME_ORDRE'
        call jeveuo(lisord, 'L', jordr)
        nbordi=nbpas+(nbordr-(nbpas*nbproc))
        ASSERT(nbordi.ge.1)
        call wkvect(lisori,'V V I',nbordi,jordi)
        if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> creation objet=',lisori
        compt=0
        do k=1,nbordr
          if (zi(jldist+k-1).eq.rang) then
            compt=compt+1
            zi(jordi+compt-1)=zi(jordr+k-1)
          endif
        enddo
        if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> nbordi= ',nbordi
        ASSERT(compt.eq.nbordi)
        if (dbgv_ob) call jeimpo(ifm,lisori,'lisori')     
      endif
      if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> Fin de création du contexte parallélisme en temps '
!
    else if (option.eq.102) then
! OPTION=102 INITIALISATIONS POUR CALCOP AVEC APPELS RECURSIF
! INPUT: nbordr
! OUTPUT: ldist, dbg_ob, dbgv_ob, lcpu, ltest, rang, nbproc, nbpas, mpicou, vldist, vcham
      ldist=.False.
      dbg_ob=.False.
      dbgv_ob=.False.
      lcpu=.False.
      ltest=.False.
! CONTEXTE MPI
      call asmpi_comm('GET_WORLD', mpicow)
      call asmpi_comm('GET', mpicou)
      if (mpicow.ne.mpicou) then
        ASSERT(.False.)
      endif
      call asmpi_info(mpicow, mrang, mnbproc)
      rang = to_aster_int(mrang)
      ASSERT(rang.ge.0)
      nbproc = to_aster_int(mnbproc)
      ASSERT(nbproc.ge.1)
      nbpas=0
      vldist='&&PCPTCC2.VLDIST'
      if (nbordr.ge.1) then
        iret=nbordr
      else
        iret=1
      endif
      call wkvect(vldist,'V V I',iret,jldist)
      call vecint(iret,rang,zi(jldist))
      vcham='&&PCPTCC2.VCHAM' 
    else if (option.eq.2) then
! OPTION=2
! DEBRANCHE LE PARALLELISME EN ESPACE
! INPUT: ldist, modele, dbg_ob, rang
! OUTPUT: sd_partition, lsdpar
      sd_partition=' '
      lsdpar=.False.
      ASSERT(rang.ge.0)
      call jeexin(modele(1:8)//'.PARTIT',iret)
      if (iret.ne.0) then
        call jeveuo(modele(1:8)//'.PARTIT', 'E', jparti)
        sd_partition=zk8(jparti)
! AFIN DE SIGNIFIER L'ACTIVATION DU PARALLELISME EN ESPACE
        if (sd_partition.ne.' ') lsdpar=.True.
! AFIN DE STOPPER PONCTUELLEMENT LE PARALLELISME EN ESPACE
        if (lsdpar.and.ldist) zk8(jparti)=' '
      endif
      if (dbg_ob) write(ifm,*)&
          '< ',rang,'pcptcc> lsdpar/sd_partition_init= ',lsdpar,sd_partition
!
    else if ((option.eq.3).or.(option.eq.301)) then
! OPTION=3
! REBRANCHE LE PARALLELISME EN ESPACE ET DETRUIT OBJETS JEVEUX DU CONTEXTE PARALLELISME TEMPS
! INPUT: ldist, modele, sd_partition, rang, lsdpar, dbg_ob, vcham, lisori (avec option=3),&
!        vcnoch, vldist
! NETTOYAGE POUR PARALLELISME EN TEMPS
      if (ldist) then
        ASSERT(rang.ge.0)
        call jedetr(vcham)
        if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> destruction objet=',vcham
        if (option.eq.3) then
          call jedetr(lisori)
          if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> destruction objet=',lisori
        endif
        call jedetr(vcnoch)
        if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> destruction objet=',vcnoch
      endif
      call jedetr(vldist)
      if (dbg_ob) then
        write(ifm,*)'< ',rang,'pcptcc> destruction objet=', vldist
        write(ifm,*)'< ',rang,'pcptcc> Fin de destruction du contexte parallélisme en temps'
      endif
      if (ldist) then
        if (lsdpar) then
          call jeveuo(modele(1:8)//'.PARTIT', 'E', jparti)
          zk8(jparti)=sd_partition
        endif
        if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> lsdpar/sd_partition_fin= ',lsdpar,sd_partition
      endif
    else if (option.eq.4) then
! OPTION=4
! CONSTRUCTION DES INDICES POUR GERER LE PARALLELISME EN TEMPS
! INPUT: i, ldist, ipas, nbpas, nbproc, dbg_ob, rang
! OUTPUT: ideb, ifin, irelat
      ASSERT(i.ge.1)
      ASSERT(ipas.ge.0)
      ASSERT(nbpas.ge.0)
      ASSERT(nbproc.ge.1)
      ASSERT(rang.ge.0)
      ideb=i
      ifin=i
      irelat=1
      if ((ldist).and.(ipas.le.nbpas)) then
! TRAITEMENT SIMULTANE DES INDICES ENTRE IDEB ET IFIN
        ideb=(ipas-1)*nbproc+1
        ifin=ideb+nbproc-1
! INDICE RELATIF DANS CE PAQUET
        irelat=i-ideb+1
      endif
      if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> i/ideb/ifin/irelat= ',i,ideb,ifin,irelat
      ASSERT(ideb.ge.1)
      ASSERT(ifin.ge.1)
      ASSERT(irelat.ge.1)
      ASSERT(ideb.le.ifin)
    else if (option.eq.5) then
! OPTION A EFFACER A TERME
      ASSERT(.False.)
! OPTION=5
! REMPLISSAGE LISTE DES CHAM_NOS A CREER SIMULTANEMENT
! INPUT: ldist, ideb, ifin, chamno, vcham, dbg_ob, rang
      if ((ldist).and.(ideb.ne.ifin)) then
        ASSERT(rang.ge.0)
        ASSERT(ideb.ge.1)
        ASSERT(ifin.ge.1)
        ASSERT(ideb.le.ifin)
        call jeveuo(vcham,'E',jvcham)
        p=1
        do k=ideb,ifin
          k24b=' '
          k24b=chamno
          k6=' '
          call codent(k-1, 'D0', k6)
          k24b(1:24)=chamno(1:13)//k6(1:6)
          zk24(jvcham+p-1)=k24b
          if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> p/k/chamno=',p,k,k24b
          p=p+1
        enddo
      endif
!
    else if (option.eq.6) then
! OPTION=6
! GARDE-FOU LONGUEUR DES CHAM_NOS IDENTIQUES
! INPUT: ldist, lonnew, dbg_ob, rang, lonch, ipas
      if (ldist) then
        ASSERT(rang.ge.0)
        ASSERT(lonnew.ge.1)
        ASSERT(ipas.ge.0)
        if (ipas.gt.1) then
          ASSERT(lonch.ge.1)
        endif
        lonmax=lonnew
        lonmin=lonnew
        call asmpi_comm_vect('MPI_MAX', 'I', sci=lonmax)
        call asmpi_comm_vect('MPI_MIN', 'I', sci=lonmin)
        if (dbg_ob) then
          write(ifm,*)'< ',rang,'pcptcc> lonch_avant/lonch_apres=',lonch,lonnew
          write(ifm,*)'< ',rang,'pcptcc> lonch_min/lonch_max=',lonmin,lonmax
        endif
        ASSERT(lonmax.ge.1)
        ASSERT(lonmin.ge.1)
        ASSERT(lonmax.ge.lonnew)
        ASSERT(lonmin.le.lonnew)
        ASSERT(lonmin.le.lonmax)
        if ((lonmax.ne.lonmin).or.((ipas.gt.1).and.(lonnew.ne.lonch)))&
          call utmess('F', 'PREPOST_17')
      endif
!
    else if (option.eq.7) then
! OPTION=7
! INPUT: ldist, ideb, ifin, dbg_ob, rang, lonch, ktyp, ipas, nbproc, irelat,
!        mpicou, vcham
! OUTPUT: vcnoch
! NOM DU BUFFER MATRICIEL DE COMMUNICATION DES CHAMNO.VALE
      vcnoch='&&PCPTCC.VCNOCH'
      if ((ldist).and.(ideb.ne.ifin)) then
        ASSERT(rang.ge.0)
        ASSERT(ideb.ge.1)
        ASSERT(ifin.ge.1)
        ASSERT(ideb.le.ifin)
        ASSERT(lonch.ge.1)
        ASSERT(nbproc.ge.1)
! BUFFER MATRICIEL DE COMMUNICATION DES CHAMNO.VALE
! ON LE CREE AU PREMIER PAS, ON L'INITIALISE A CHAQUE FOIS
! POUR L'INSTANT, ON SUPPOSE TOUS LES CHAM_NOS DE LONGUEUR IDENTIQUE
        if (dbg_ob) write(ifm,*)'< ',rang,'ccfnrn> lonch=',lonch
        if (ktyp.eq.'R') then
          if (ipas.eq.1) then
            call wkvect(vcnoch,'V V R',lonch*nbproc,jcnoch)
            if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> creation objet=',vcnoch
          else
            call jeveuo(vcnoch,'E',jcnoch)
          endif
          call vecini(lonch*nbproc,rzero,zr(jcnoch))
        else if (ktyp.eq.'C') then
          if (ipas.eq.1) then
            call wkvect(vcnoch,'V V C',lonch*nbproc,jcnoch)
            if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> creation objet=',vcnoch
          else
            call jeveuo(vcnoch,'E',jcnoch)
          endif
          call vecinc(lonch*nbproc,czero,zc(jcnoch))
        else
          ASSERT(.False.)
        endif
! ON RECOPIE LE .VALE DU CHAM_NO CALCULE PAR LE PROCESSUS MPI COURANT DS LE BUFFER
! ON COMMUNIQUE LE BUFFER ET ON REMPLI LES CHAM_NOS.VALE
! ON LIBERE ENSUITE TOUS LES OBJETS JV LIES A CES CHAM_NOS
! RQ: ASMPI_BARRIER AU CAS OU.
        call jeveuo(vcham,'E',jvcham)
        if (ktyp.eq.'R') then
          call dcopy(lonch,noch,1,zr(jcnoch+(irelat-1)*lonch),1)
          call asmpi_barrier(mpicou)
          call asmpi_comm_vect('MPI_SUM','R',nbval=lonch*nbproc,vr=zr(jcnoch))
          if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> ALLREDUCE réel longueur=',lonch*nbproc
          call asmpi_barrier(mpicou)
          p=1
          do k=ideb,ifin
            k24b=zk24(jvcham+p-1)
            call jeveuo(k24b(1:19)//'.VALE', 'E', jval)
            call dcopy(lonch,zr(jcnoch+(p-1)*lonch),1,zr(jval),1)
            call jelibe(k24b(1:19)//'.VALE')
            call jelibe(k24b(1:19)//'.REFE')
            call jelibe(k24b(1:19)//'.DESC')
            p=p+1
          enddo
        else
          call zcopy(lonch,nochc,1,zc(jcnoch+(irelat-1)*lonch),1)
          call asmpi_barrier(mpicou)
          call asmpi_comm_vect('MPI_SUM','C',nbval=lonch*nbproc,vc=zc(jcnoch))
          if (dbg_ob) write(ifm,*)'< ',rang,'pcptcc> ALLREDUCE complexe longueur=',lonch*nbproc
          call asmpi_barrier(mpicou)
          p=1
          do k=ideb,ifin
            k24b=zk24(jvcham+p-1)
            call jeveuo(k24b(1:19)//'.VALE', 'E', jval)
            call zcopy(lonch,zc(jcnoch+(p-1)*lonch),1,zc(jval),1)
            call jelibe(k24b(1:19)//'.VALE')
            call jelibe(k24b(1:19)//'.REFE')
            call jelibe(k24b(1:19)//'.DESC')
            p=p+1
          enddo
        endif
      endif
!
    else if (option.eq.8) then
! OPTION=8
! INPUT: dbgv_ob, ldist, ideb, ifin, vcham, ideb, ifin, chamno
      if (dbgv_ob) then
! EN SIMULTANE
        if ((ldist).and.(ideb.ne.ifin)) then
          ASSERT(ideb.ge.1)
          ASSERT(ifin.ge.1)
          ASSERT(ideb.le.ifin)
          call jeveuo(vcham,'L',jvcham)
          p=1
          do k=ideb,ifin
            k24b=zk24(jvcham+p-1)
! TRES VERBOSE: A RESERVER AUX PETITS CAS
!            call jeimpo(ifm,k24b(1:19)//'.DESC','ccfnrn fin')
!            call jeimpo(ifm,k24b(1:19)//'.REFE','ccfnrn fin')
!            call jeveuo(k24b(1:19)//'.VALE', 'L', jval)
!            do i=1,10
!              write(ifm,*)i,zr(jval+i-1)
!            enddo
!            call jeimpo(ifm,k24b(1:19)//'.VALE','ccfnrn fin')
            call utimsd(ifm, -1, .False._1, .False._1, k24b(1:19),1, 'G', perm='NON')
            p=p+1
          enddo
        else
! EN SIMPLE
!          call jeimpo(ifm,chamno(1:19)//'.DESC','ccfnrn fin')
!          call jeimpo(ifm,chamno(1:19)//'.REFE','ccfnrn fin')
!          call jeimpo(ifm,chamno(1:19)//'.VALE','ccfnrn fin')
!          call jeveuo(chamno(1:19)//'.VALE', 'L', jval)
!            do i=1,10
!              write(ifm,*)i,zr(jval+i-1)
!            enddo
          call utimsd(ifm, -1, .False._1, .False._1, chamno(1:19),1, 'G', perm='NON')
        endif
      endif
!
    else
! MAUVAISE VALEUR D'OPTION
      ASSERT(.False.)
    endif
end subroutine
